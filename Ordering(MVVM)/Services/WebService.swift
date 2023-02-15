//
//  WebService.swift
//  Ordering(MVVM)
//
//  Created by SeonHo Cha on 2022/11/14.
//

import Foundation
//1st 포스트 맨으로 예시 key value를 서버에 입력(아잠 강의 14강에 포스트맨 url있음.. post가 서버에 등록 get이 내려받기)
// service먼저 작성-> model작성( 타입공부는 조금 더 지나고,,, 익숙하게만 봐두자)
// service는 서버에서 service를 통해 view모델로 넣어주기 직전까지의 과정 -> result는 서버에서 가져온 모든 데이터를 가지고 있다.
enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

struct Resource<T: Codable> { // data를 fetch할 때 (커피주문 데이터) Codable을 준수해야한다. T는 제네릭 '타입'
    // 얘는 왜 struct????????????????????????????????????????????????????????

    let url: URL
    //************받을 때는 .get이고 body가 nil이여야함
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
    
}
// resource 초기화
extension Resource {
    init(url: URL) {
        self.url = url
    }
}



class Webservice { // 어떤 유형인지 모르기 때문에 Generic을 사용
    // 두 가지 파라미어 T, NetworkError / T는 성공했을 때 result, NetworkError는 실패했을 때 파라미터
    // @escaping은 클로져를 탈출할 것이기 때문에
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        
        // 9th Post requset
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //언래핑
            guard let data = data, error == nil else{
                completion(.failure(.domainError))
                return
            }
            // 언래핑 한 data를 result에 decode
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result {
                DispatchQueue.main.async { // dispatchQueue.main에서 결과를 얻는 이유는 result가 결국 UI로 전달 될 것이기 때문 / UI에서 무엇이든 하려면 main Thread에 전달해야 한다.
                    // 그렇다면 UI에 관련된 API 데이터는 무조건 mainqueue??
                    completion(.success(result))
                }
                // 디코드 언래핑 안된다면
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

