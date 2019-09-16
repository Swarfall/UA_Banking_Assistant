//
//  MenuViewController.swift
//  UA Banking Assistant
//
//  Created by admin on 9/8/19.
//  Copyright © 2019 Viacheslav Savitsky. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ExchangeRateVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let transition = SlideInTransition()
    var exchangeRate: [ExchangeRateModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ExchangeRateCell",
                                 bundle: nil),
                                 forCellReuseIdentifier: "ExchangeRateCell")
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        
        tableView.reloadData()
        tableView.tableFooterView = UIView()
        
        bannerView.adUnitID = "ca-app-pub-7458509889047730/5390005435"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    func getData() {
        let urlString = "https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=11"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            debugPrint(String(data: data, encoding: .utf8)!)
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    if json.count > 0 {
                        
                        for rate in json {
                            let exRate = ExchangeRateModel()
                            guard let ccy = rate["ccy"] as? String else { return }
                            guard let ccyBase = rate["base_ccy"] as? String else { return }
                            guard let buy = rate["buy"] as? String else { return }
                            guard let sale = rate["sale"] as? String else { return }
                            
                            exRate.ccy = ccy
                            exRate.baseCcy = ccyBase
                            exRate.buy = buy
                            exRate.sale = sale
                            self.exchangeRate.append(exRate)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch let error as NSError {
                debugPrint("Error: \(error.localizedDescription)")
            }
        }
        task.resume()
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

extension ExchangeRateVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchangeRate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeRateCell", for: indexPath) as! ExchangeRateCell
        cell.update(model: exchangeRate[indexPath.row])
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

extension ExchangeRateVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

extension ExchangeRateVC: GADBannerViewDelegate {
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
}
