//
//  HistoryViewController.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 26/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController:  ParentViewControllerWithBalance{
    
    //MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    fileprivate let viewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initSearchBar()
        initViewModel()
        initKeyboardNotification()
    }
    
    // MARK: - Private methods
    private func initTableView(){
        tableView?.dataSource = viewModel
        tableView?.delegate = viewModel
    }
    
    private func initViewModel(){
        viewModel.delegateStandart = self
    }
    
    private func initSearchBar(){
        searchBar.delegate = viewModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "History"
        viewModel.getHistory()
    }
    
    // MARK: - Public methods
    override func refreshBalance(){
        if viewModel.isLoadingMessenger() { return }
        viewModel.getBalance()
        viewModel.getHistory()
    }
    
    func sortTapped(){
        guard let sortBtn = tabBarController?.navigationItem.rightBarButtonItems?[1] else{return}
        
        let vc = SortPopupViewController.controller()
        vc.viewModel.delegate = viewModel
        vc.preferredContentSize = CGSize(width: 100,height: 120)
        vc.modalPresentationStyle = .popover
        
        let popover = vc.popoverPresentationController
        popover?.delegate = self
        popover?.barButtonItem = sortBtn
        popover?.permittedArrowDirections = .up
        
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: ViewModelStandartProtocol
extension HistoryViewController: ViewModelStandartProtocol{
    func refreshData() {
        self.tableView.reloadData()
    }
    
    func needShowAlert(_ text: String) {
        self.showAlert(NSLocalizedString("ALERT", comment: ""), messegeText: text)
    }
}

//MARK: UIPopoverPresentationControllerDelegate
extension HistoryViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
