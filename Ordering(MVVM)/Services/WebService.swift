//
//  WebService.swift
//  Ordering(MVVM)
//
//  Created by SeonHo Cha on 2022/11/14.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

struct Resource<T: Codable> { // data를 fetch할 때 (커피주문 데이터) Codable을 준수해야한다.

    let url: URL
}

class Webservice { // 어떤 유형인지 모르기 때문에 Generic을 사용
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: resource.url) { data, response, error in
            
            guard let data = data, error == nil else{
                completion(.failure(.domainError))
                return
            }
            
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

