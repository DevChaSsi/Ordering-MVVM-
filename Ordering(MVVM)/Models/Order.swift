//
//  Order.swift
//  Ordering(MVVM)
//
//  Created by SeonHo Cha on 2022/11/15.
//

import Foundation

// 2nd로 model형성


//c
enum CoffeeType: String, Codable, CaseIterable {
    case cappuccino
    case latte
    case espresso
    case americano
    
}
//b
enum CoffeeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

//a
struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
}


// 웹서비스로 보낼 Data 다 여기있어(뷰모델을 사용하여 모델 채우기)

extension Order {
    init?(_ vm: AddCoffeeOrderViewModel) { //****************요따구로 쓰는 방법
        //a. vm에 있는 걸 프로퍼티에 할당하고
        guard let name = vm.name,
              let email = vm.email,
              let selectedType = CoffeeType(rawValue: vm.selectedType!.lowercased()),
              let selectedSize = CoffeeSize(rawValue: vm.selectedSize!.lowercased()) else {
            return nil
        }
        ///b. 프로퍼티에 있는 걸 모델에 갖다 넣어
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
    }
}

//7th 웹서비스로 보낼 준비
extension Order {
    //타입프로퍼티
    static var all: Resource<[Order]> = {
        
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("URL is incorrect")
        }
        return Resource<[Order]>(url: url)
    }()
    
    // static 언제쓰나 -> 타입 메서드
    // 리턴이 resouce형식
    static func create(vm: AddCoffeeOrderViewModel) -> Resource<Order?> {
        
        let order = Order(vm) //************요걸 왜? -> 데이터 다 담긴 게 order에 있어
        
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("URL is incorrect")
        }
        
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error encode order")
        }
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = HttpMethod.post
        resource.body = data
        
        return resource
        
    }
}
//8th post, get일 때 url나누기?

enum HttpMethod: String {
    case get = "Get" //
    case post = "Post"
}
