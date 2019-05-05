//
//  HistoryTableViewCell.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 26/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit

protocol HistoryTableViewCellProtocol : class {
    func repeatTransaction(_ index:Int)
}

class HistoryTableViewCell : UITableViewCell {
    
    // MARK: - Outlets methods
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    // MARK: - Properties
    var index:Int?
    weak var delegate:HistoryTableViewCellProtocol?
    
    // MARK: - Public methods
    func setData(_ history:HistoryModel,_ index:Int) -> Void {
        nameLbl.text = history.username
        
        if let amount = history.amount{
            let plus:String = amount < 0 ? "" : "+"
            amountLbl.textColor = amount < 0 ? UIColor.init(netHex: 0xE94E39, alpha: 1.0) : UIColor.init(netHex: 0x48A14C, alpha: 1.0)
            amountLbl.text = plus + String(amount)
        }
        if let date = history.dateStr{
            dateLbl.text = String(date)
        }
        if let balance = history.balance{
            balanceLbl.text = String(balance)
        }
        self.index = index
    }
    
    // MARK: - Outlets methods
    @IBAction func repeatTapped(_ sender: Any) {
        if let index = index{
            delegate?.repeatTransaction(index)
        }
    }
}
