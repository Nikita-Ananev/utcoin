//
//  Networking.swift
//  utcoin
//
//  Created by Никита Ананьев on 24.11.2022.
//

import Foundation
import UIKit


protocol NetworkData {
    
}
enum RequestResult {
    case sucsses(data: NetworkData)
    case error(error: Error)
}
class Networking {
    var urlSession = URLSession.shared
    let decoder = JSONDecoder()
    
    //MARK: Work with PhoneRequestData
    func sendPhoneRequest( to number: String, then completion: @escaping (RequestResult) -> Void) {
        guard let url = URL(string: "https://utcoin.one/loyality/login_step1?phone=\(number)") else { return }
        
        let task = urlSession.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            
            var result: RequestResult
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard
                let strongSelf = self
            else {
                result = .sucsses(data: PhoneRequsetData(successful: false, errorMessage: "Ошибка данных", explainMessage: "Обратитесь к администратору."))
                return
            }
            
            if error == nil, let parsData = data {
                guard
                    let phoneRequest = try? strongSelf.decoder.decode(PhoneRequsetData.self, from: parsData)
                else {
                    result = .sucsses(data: PhoneRequsetData(successful: false, errorMessage: "Ошибка данных", explainMessage: "Обратитесь к администратору."))
                    return
                }
                result = .sucsses(data: phoneRequest)
            } else {
                result = .error(error: error!)
            }
        })
        task.resume()
    }
    
    
    //MARK: Work with LoginRequestData
    func sendLoginRequest(number: String, password: String, then completion: @escaping (RequestResult) -> Void) {
        guard let url = URL(string: "https://utcoin.one/loyality/login_step2?phone=\(number)&password=\(password)") else { return }
        
        let task = urlSession.dataTask(with: url) {[weak self] data, response, error in
            
            var result: RequestResult
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            guard
                let strongSelf = self
            else {
                result = .sucsses(data: LoginRequestData(successful: false, errorMessage: "Ошибка Ошибка приложения", sessionId: "1111"))
                return
            }
            if error == nil, let parsData = data {
                guard
                    let loginRequest = try? strongSelf.decoder.decode(LoginRequestData.self, from: parsData)
                else {
                    result = .sucsses(data: LoginRequestData(successful: false, errorMessage: "Ошибка данных", sessionId: "111"))
                    return
                }
                result = .sucsses(data: loginRequest)
            } else {
                result = .error(error: error!)
            }
        }
        task.resume()
        
    }
    
    func fetchSearchingData(_ searchText: String, then completion: @escaping (Result<SearchingData, Error>) -> Void) {
        guard let url = URL(string: "https://utcoin.one/loyality/search?search_string=\(searchText)") else {
            return
        }
        
        let task = urlSession.dataTask(with: url) { data, response, error in
            guard
                let data = data
            else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            if let data = try? JSONDecoder().decode(SearchingData.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } else {
                print("bad data")
            }
            
        }
        task.resume()
    }
    func downloadWithUrlSession(url: URL, completion: @escaping ((UIImage) -> Void)) {
        let task = urlSession.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let image = UIImage(data: data) else {
                return
            }
            completion(image)
        }
        task.resume()
    }
    //    func downLoadCollectionViewImages(url: IndexPath, collectionView: UICollectionView) {
    //      URLSession.shared.dataTask(with: urls[indexPath.item]) {
    //        [weak self] data, response, error in
    //
    //        guard let self = self,
    //              let data = data,
    //              let image = UIImage(data: data) else {
    //          return
    //        }
    //
    //        DispatchQueue.main.async {
    //          if let cell = self.collectionView
    //            .cellForItem(at: indexPath) as? PhotoCell {
    //            cell.display(image: image)
    //          }
    //        }
    //      }.resume()
    //    }
}
