//
//  SortTableViewCell.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 05/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class SortTableViewCell : UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLbl: UILabel!
    
    // MARK: - Public methods
    func setData(_ name:String) -> Void {
        nameLbl.text = name
    }
}
