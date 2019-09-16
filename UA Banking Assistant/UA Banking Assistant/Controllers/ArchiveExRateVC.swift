//
//  ArchiveExRateVC.swift
//  UA Banking Assistant
//
//  Created by admin on 9/8/19.
//  Copyright © 2019 Viacheslav Savitsky. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class ArchiveExRateVC: UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var heightInfoConstraint: NSLayoutConstraint!
    
    var archiveExRate: [ArchiveExRateModel] = []
    var archiveExRateMappable: [ExchangeRateMappable] = []
    let transition = SlideInTransition()
    
    var dateText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dateTextField.delegate = self
        
        tableView.register(UINib(nibName: "ArchiveExRateCell", bundle: nil), forCellReuseIdentifier: "ArchiveExRateCell")
        
        tableView.reloadData()
    }
    
    func getData() {
        var parameters: [String: Any] = [:]
        parameters["date"] = dateText
        
        Alamofire.request("https://api.privatbank.ua/p24api/exchange_rates?json", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            let rate = Mapper<ArchiveExRateMappable>().map(JSONObject: response.result.value)
            if let exchangeRate = rate?.exchangeRate {
               
                self.archiveExRateMappable = exchangeRate
                for rate in self.archiveExRateMappable {
                    let exRate = ArchiveExRateModel()
                    exRate.baseCurrency = rate.baseCurrency
                    exRate.currency = rate.currency
                    exRate.saleRate = rate.saleRate
                    exRate.purchaseRate = rate.purchaseRate
                    self.archiveExRate.append(exRate)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func didTapMenuButton(_ sender: Any) {
        guard let menuVC = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuVC.didTapMenuType = { menuType in
            self.transitionToNewContent(menuType)
        }
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.transitioningDelegate = self
        present(menuVC, animated: true)
    }
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        heightInfoConstraint.priority = UILayoutPriority(rawValue: 700)
        dateText = dateTextField.text ?? ""
        getData()
        tableView.reloadData()
    }
    
    func transitionToNewContent(_ menuType: MenuType) {
        let title = String(describing: menuType).capitalized
        self.title = title
        
        var withIdentifier = ""
        
        switch menuType {
        case .exchangeRate:
            withIdentifier = "ExchangeRateVC"
        case .archiveOfTheExchangeRate:
            withIdentifier = "ArchiveExRateVC"
        case .exchangeRateOfBanksOfUkraine:
            withIdentifier = ""
        case .atms:
            withIdentifier = ""
        case .branches:
            withIdentifier = ""
        case .selfServiceTerminals:
            withIdentifier = ""
        default:
            break
        }
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: withIdentifier) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ArchiveExRateVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archiveExRate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveExRateCell", for: indexPath) as! ArchiveExRateCell
        cell.update(model: archiveExRate[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

extension ArchiveExRateVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == textField {
            if (textField.text?.count == 2) || (textField.text?.count == 5) {
                if !(string == "") {
                    textField.text = (textField.text)! + "."
                }
            }
            return !(textField.text!.count > 9 && (string.count ) > range.length)
        }
        else {
            return true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dateTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        heightInfoConstraint.priority = UILayoutPriority(rawValue: 900)
    }
}

extension ArchiveExRateVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
