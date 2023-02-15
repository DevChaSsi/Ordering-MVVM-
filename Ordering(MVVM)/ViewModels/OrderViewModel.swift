//
//  OrderViewModel.swift
//  Ordering(MVVM)
//
//  Created by SeonHo Cha on 2022/11/17.
//


// 4th VM구현 - 모든 order에 대하여 무엇을 display하고 싶은지를 생각해야돼( 무조건 Model = ViewModel은 아니야)
import Foundation

//c. ****뷰모델 2번 째가 가능한 이유 (기존 VM을 변형?): tableview에 나타낼 order list를 위한 viewModel인데 """"""order에 의해 control 되는 전체 뷰에 데이터를 제공 -> 검색에 유용..""""""

class OrderListViewModel {
    var orderViewModel: [OrderViewModel] // 매칭한 뷰모델 자체를 array[]로 감싸
    
    init() {
        self.orderViewModel = [OrderViewModel]() // 빈배열로 초기화
    }
}

//d. 하나의 order만 display하고 싶을 수도 있어?(지켜보자 어케하는지) -> 얘도 기존 VM을 변형 -> 검색에 유용.. 지켜보자
extension OrderListViewModel {
    func orderViewModel(at index: Int) -> OrderViewModel { //************인덱스를 넣으면 ViewModel을 리턴 오 이 코드 신기하네...
        return self.orderViewModel[index] //*************인덱스를 넣으면 VM을 리턴
        
    }
}

//a 실제 Order(Model) 기반으로 형성 ->  AddOrderView를 위한 VM
struct OrderViewModel {
    let order: Order
}
//b View에 표시할 속성에 대해 생각해야돼
extension OrderViewModel {
    var name: String{
        return self.order.name // 실제 모델의 name을 return
    }
    var email: String {
        return self.order.email // 실제 모델의 email return
    }
    var type: String {
        return self.order.type.rawValue.capitalized // 실제 모델의 type의 찐 값을 return
    }
    var size: String {
        return self.order.size.rawValue.capitalized // 실제 모델의 size의 찐 값을 return
        
    }
}
