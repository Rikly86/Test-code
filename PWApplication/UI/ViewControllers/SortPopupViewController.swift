//
//  SortPopupViewController.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 04/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit

class SortPopupViewController:  ParentViewController{
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    let viewModel = SortPopupViewModel()
    
    // MARK: - Life cicle
    class func controller() -> SortPopupViewController {
        return getController(String(describing: SortPopupViewController.self)) as! SortPopupViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initViewModel()
    }
    
    // MARK: - Private methods
    private func initViewModel(){
        viewModel.delegateForDismiss = self
    }
    
    private func initTableView(){
        tableView?.dataSource = viewModel
        tableView?.delegate = viewModel
    }
}

//MARK: SortPopupViewModelProtocol
extension SortPopupViewController: SortPopupViewModelProtocol{
    func sortBy(_ value: SortPopupViewModel.SortType) {
        dismiss(animated: true, completion: nil)
    }
}




