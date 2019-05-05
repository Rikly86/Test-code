//
//  UserTableViewCell.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 26/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit

class UserTableViewCell : UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLbl: UILabel!
    
    // MARK: - Public methods
    func setData(_ user:UserModel) -> Void {
        nameLbl.text = user.name
    }
}
