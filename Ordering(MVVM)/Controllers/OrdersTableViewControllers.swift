//
//  OrdersTableViewControllers.swift
//  Ordering(MVVM)
//
//  Created by SeonHo Cha on 2022/11/14.
//

import Foundation
import UIKit


class OrdersTableViewController: UITableViewController {
    
    var orderListViewModel = OrderListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateOrders()
    }
    
    private func populateOrders() {
        guard let coffeeOrdersURL = URL(string: "https://warp-wiry-rugby.glitch.me/orders")  else {
            fatalError("URL was incorrect")
            return
        }
        
        let resource = Resource<[Order]>(url: coffeeOrdersURL)
        
        Webservice().load(resource: resource) { [weak self] result in
            switch result {
            case .success(let orders):
                self?.orderListViewModel.orderViewModel = orders.map(OrderViewModel.init) //** map 배우고 오자.
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
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
}
