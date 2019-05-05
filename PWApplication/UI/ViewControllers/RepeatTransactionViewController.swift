//
//  RepeatTransactionViewController.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 03/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//


import Foundation
import UIKit

class RepeatTransactionViewController:  ParentViewControllerWithBalance{
    
    //MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedUserLbl: UILabel!
    
    //MARK: Properties
    let viewModel = RepeatTransacrionViewModel()
    
    // MARK: - Life cicle
    class func controller() -> RepeatTransactionViewController {
        return getController(String(describing: RepeatTransactionViewController.self)) as! RepeatTransactionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initSearchBar()
        initViewModel()
        initRightItem()
        initKeyboardNotification()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Select User"
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let ind = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: ind, animated: false)
        }
    }
    
    // MARK: - Private methods
    private func initRightItem(){
        let nextBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
        
        navigationItem.rightBarButtonItem = nextBtn
    }
    
    private func setData(){
        if let name = viewModel.item?.name{
            selectedUserLbl?.text = name
        }
    }
    
    private func initTableView(){
        tableView?.dataSource = viewModel
        tableView?.delegate = viewModel
    }
    
    private func initSearchBar(){
        searchBar.delegate = viewModel
    }
    
    private func initViewModel(){
        viewModel.delegateStandart = self
        viewModel.delegateCustom = self
        viewModel.getBalance()
    }
    
    //MARK: Public methods
    @objc func nextTapped(){
        viewModel.showEnterTransaction()
    }
    
    override func refreshBalance(){
        viewModel.getBalance()
    }
}

//MARK: ViewModelStandartProtocol
extension RepeatTransactionViewController: ViewModelStandartProtocol{
    func needShowAlert(_ text: String) {
        self.showAlert(NSLocalizedString("Alert", comment: ""), messegeText: text)
    }
    
    func refreshData() {
        self.tableView.reloadData()
    }
}

//MARK: RepeatTransacrionViewModelProtocol
extension RepeatTransactionViewController: RepeatTransacrionViewModelProtocol{
    func selectUser(_ item: UserModel) {
        if let name = viewModel.item?.name{
            selectedUserLbl?.text = name
        }
    }
}




