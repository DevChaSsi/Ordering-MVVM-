//
//  AddOrderViewControllers.swift
//  Ordering(MVVM)
//
//  Created by SeonHo Cha on 2022/11/14.
//

import Foundation
import UIKit

//10th  addviewcontroller에서
protocol AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController) // order에도 전달하고 viewcontroller에서 전달하겠습니다.
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController)
}


class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var delegate: AddCoffeeOrderDelegate?
    
    
    private var vm = AddCoffeeOrderViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    private var coffeeSizesSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    // segmetedControl Only code
    private func setupUI() {
        self.coffeeSizesSegmentedControl = UISegmentedControl(items: self.vm.sizes)
        self.coffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.coffeeSizesSegmentedControl)
        self.coffeeSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
        self.coffeeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        cell.textLabel?.text = self.vm.types[indexPath.row]
        return cell
    }
    
    
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        // 프로토콜 수행은 수행해줄 뷰컨트롤러 OrdersTableVeiwController에 가서
        if let delegate = self.delegate {
            delegate.addCoffeeOrderViewControllerDidClose(controller: self)
        }
    }
    
    //6th ********************
    // save버튼 누르고 vm에 담는데 vm은 받은 데이터, 보낼 데이터 구분돼있다 -> 다음단계는 뷰모델에 있는 걸 모델로 변형해서 웹서비스로 보낼 것.
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let name = self.nameTextField.text
        let email = self.emailTextField.text
        
        let selectedSize = self.coffeeSizesSegmentedControl.titleForSegment(at: self.coffeeSizesSegmentedControl.selectedSegmentIndex)
        
        //index를 따로 저장했어*************************
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("Error in selecting coffee")
        }
        self.vm.name = name
        self.vm.email = email
        
        self.vm.selectedSize = selectedSize
        self.vm.selectedType = self.vm.types[indexPath.row]
        
        
        // 9th 뷰컨에서 타입메서드로???????????? 버튼을 눌렀을 때 값을 넘거야되니까 이게 맞다.
        Webservice().load(resource: Order.create(vm: self.vm)) { result in
            switch result {
            case .success(let order):
                // order은 옵셔널이라 무적권 언래핑,
                if let order = order, let delegate = self.delegate {
                    // order가 언래핑 된 상태로 전달 된 다음 ui에 표시될 것이기 때문에 mainqueue로..
                    DispatchQueue.main.async {
                        // 프로토콜 수행은 수행해줄 뷰컨트롤러 OrdersTableVeiwController에 가서

                        delegate.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
                    }
                }
//                print(order)
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
