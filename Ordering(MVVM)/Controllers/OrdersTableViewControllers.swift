//
//  OrdersTableViewControllers.swift
//  Ordering(MVVM)
//
//  Created by SeonHo Cha on 2022/11/14.
//

import Foundation
import UIKit

//3rd 가져온 데이터를 viewcontroller에 쏴줘야지
class OrdersTableViewController: UITableViewController, AddCoffeeOrderDelegate {
    
    //5th orderlistVM ([VM]) 초기화
    var orderListViewModel = OrderListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateOrders() // 주문을 덪붙이다
    }
    
        //MARK: - Delegate Function of AddCoffeeOrderDelegate
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    // save버튼 누르면 컨트롤러 dismiss하고 리스트 보여주기 ***********************************************************
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        let orderVM = OrderViewModel(order: order)
        self.orderListViewModel.orderViewModel.append(orderVM)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.orderViewModel.count - 1, section: 0)], with: .automatic)
    }
    
    
    private func populateOrders() {
//// 모델에 보낼때 받을 때 한번에 하려고 order.all에 있음
//        guard let coffeeOrdersURL = URL(string: "https://warp-wiry-rugby.glitch.me/orders")  else {
//            fatalError("URL was incorrect")
//        }
//
//        let resource = Resource<[Order]>(url: coffeeOrdersURL) // webservice의 Resource struct 어떤 종류의 Resource인지, 어떤 종류의 result를 기대하는지 정의
        
        Webservice().load(resource: Order.all) { [weak self] result in // result는 서버에서 Webservice로 가져온 모든 data인데 result는 webservice에서 두가지 타입을 가지고 있음 성공: Result<Order> /실패: Failure, DisPatchMainQueue는 Webservice에서 하는 게 아니고 뷰컨에서 호출할 때 실행 된다.
            switch result {
            case .success(let orders): // .success라면 기대하던 order를 받을 수 있을 것이기 때문에 .success 시 바로 order 객체 생성
//                print(orders) // 함 봐봐 result로 뭐가 떨어지나 // 이 결과를 VM에 물려줘야돼..^^************************************
                
                self?.orderListViewModel.orderViewModel = orders.map(OrderViewModel.init) //** map 배우고 오자. order을 map으로 OrderViewModel에 물려주고 orderViewModel에 할당
                
                print(orders.map(OrderViewModel.init))
//                print(self?.orderListViewModel.orderViewModel)
                
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // tableView Delegate안쓰고 tableView 구현
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.orderViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.orderListViewModel.orderViewModel(at: indexPath.row)
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        
        
        return cell
    }
    
    //11th protocol delegate 내가 한다고 선언
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let addCoffeeOrderVC = navC.viewControllers.first as? AddOrderViewController else {
            fatalError("Error performing segue")
        }
        addCoffeeOrderVC.delegate = self
    }
}
