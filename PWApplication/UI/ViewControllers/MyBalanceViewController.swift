//
//  MyBalanceViewController.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 26/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//


import Foundation
import UIKit

class MyBalanceViewController:  ParentViewControllerWithBalance{
    
    //MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    fileprivate let viewModel = MyBalanceViewModel()
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initSearchBar()
        initViewModel()
        initKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "My Balance"
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let ind = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: ind, animated: false)
        }
    }
    
    // MARK: - Private methods
    private func initTableView(){
        tableView?.dataSource = viewModel
        tableView?.delegate = viewModel
    }
    
    private func initSearchBar(){
        searchBar.delegate = viewModel
    }
    
    private func initViewModel(){
        viewModel.delegateStandart = self
        viewModel.getBalance()
    }
    
    override func refreshBalance(){
        if viewModel.isLoadingMessenger() { return }
        viewModel.getBalance()
    }
}

// MARK: - ViewModelStandartProtocol
extension MyBalanceViewController: ViewModelStandartProtocol{
    func needShowAlert(_ text: String) {
        self.showAlert(NSLocalizedString("Alert", comment: ""), messegeText: text)
    }
    
    func refreshData() {
        self.tableView.reloadData()
    }
}




