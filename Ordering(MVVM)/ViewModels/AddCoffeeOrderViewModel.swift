//
//  AddCoffeeOrderViewModel.swift
//  Ordering(MVVM)
//
//  Created by SeonHo Cha on 2023/02/15.
//

//6th AddCoffeeViewModel작성
import Foundation
import UIKit


struct AddCoffeeOrderViewModel {
    
    // 얘는 보낼 데이터 
    var name: String?
    var email: String?
    
    var selectedType: String?
    var selectedSize: String?
    
    
    // 얘는 내려온 데이터
    var types: [String] { // Model가서 caseIterable 설정
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var sizes: [String] {
        return CoffeeSize.allCases.map { $0.rawValue.capitalized }
    }
}
