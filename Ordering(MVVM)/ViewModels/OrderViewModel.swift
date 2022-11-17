//
//  OrderViewModel.swift
//  Ordering(MVVM)
//
//  Created by SeonHo Cha on 2022/11/17.
//

import Foundation
// 여기 다시 구조체를 배열고 감쌋어.? -> parentviewmodel로 표현을 했네?
class OrderListViewModel {
    var orderViewModel: [OrderViewModel]
    
    init() {
        self.orderViewModel = [OrderViewModel]()
    }
}
extension OrderListViewModel {
    func orderViewModel(at index: Int) -> OrderViewModel {
        return self.orderViewModel[index]
    }
}


struct OrderViewModel {
    let order: Order
}

extension OrderViewModel {
    var name: String{
        return self.order.name
    }
    var email: String {
        return self.order.email
    }
    var type: String {
        return self.order.type.rawValue.capitalized
    }
    var size: String {
        return self.order.size.rawValue.capitalized
    }
}
