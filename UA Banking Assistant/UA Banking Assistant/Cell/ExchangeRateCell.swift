//
//  ExchangeRateCell.swift
//  UA Banking Assistant
//
//  Created by admin on 9/8/19.
//  Copyright © 2019 Viacheslav Savitsky. All rights reserved.
//

import UIKit

class ExchangeRateCell: UITableViewCell {

    @IBOutlet weak var ccyLabel: UILabel!
    @IBOutlet weak var baseCcyLabel: UILabel!
    @IBOutlet weak var buyLabel: UILabel!
    @IBOutlet weak var saleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(model: ExchangeRateModel) {
        
        ccyLabel.text = model.ccy
        baseCcyLabel.text = model.baseCcy
        buyLabel.text = model.buy
        saleLabel.text = model.buy
    }
    
}
