//
//  Order.swift
//  Ordering(MVVM)
//
//  Created by SeonHo Cha on 2022/11/15.
//

import Foundation


enum CoffeeType: String, Codable {
    case Cappuccino
    case Latte
    case Espresso
    case Americano
    
}

enum CoffeeSize: String, Codable {
    case Small
    case Medium
    case Large
}

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
}
