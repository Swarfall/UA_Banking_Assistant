//
//  MenuViewController.swift
//  UA Banking Assistant
//
//  Created by admin on 9/14/19.
//  Copyright © 2019 Viacheslav Savitsky. All rights reserved.
//

import UIKit

enum MenuType: Int {
    
    case exchangeRate
    case archiveOfTheExchangeRate
    case exchangeRateOfBanksOfUkraine
    case atms
    case branches
    case selfServiceTerminals
}

class MenuViewController: UITableViewController {
    
    var didTapMenuType: ((MenuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) {
            
            switch menuType {
            case .exchangeRate:
                debugPrint("exchangeRate")
            case .exchangeRateOfBanksOfUkraine:
                debugPrint("exchangeRateOfBanksOfUkraine")
            case .atms:
                debugPrint("atms")
            case .branches:
                debugPrint("branches")
            case .selfServiceTerminals:
                debugPrint("selfServiceTerminals")
            default:
                break
            }
            
            debugPrint("Dismissing: \(menuType)")
            self.didTapMenuType?(menuType)
        }
    }
}
