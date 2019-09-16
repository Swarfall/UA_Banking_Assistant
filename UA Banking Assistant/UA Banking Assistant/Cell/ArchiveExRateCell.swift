//
//  ArchiveExRateCell.swift
//  UA Banking Assistant
//
//  Created by admin on 9/8/19.
//  Copyright © 2019 Viacheslav Savitsky. All rights reserved.
//

import UIKit

class ArchiveExRateCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var purchaseRate: UILabel!
    @IBOutlet weak var saleRate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(model: ArchiveExRateModel) {
        
        guard let purcRate = model.purchaseRate else { return }
        guard let salesRate = model.saleRate else { return }
        
        currencyLabel.text = model.currency
        baseCurrencyLabel.text = model.baseCurrency
        purchaseRate.text = "\(purcRate)"
        saleRate.text = "\(salesRate)"
    }
    
}
