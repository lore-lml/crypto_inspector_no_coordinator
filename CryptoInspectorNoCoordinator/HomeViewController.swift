//
//  HomeViewController.swift
//  CryptoInspectorNoCoordinator
//
//  Created by Lorenzo Limoli on 24/11/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var watchListTableView: UITableView!
    
    var watchList: [Coin] = []
    var topGainers: [Coin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibWatchList = UINib(nibName: WatchListTableViewCell.nibId, bundle: .main)
        let nibTopGainer = UINib(nibName: TopGainerTableViewCell.nibId, bundle: .main)
        watchListTableView.delegate = self
        watchListTableView.dataSource = self
        watchListTableView.register(nibWatchList, forCellReuseIdentifier: WatchListTableViewCell.cellId)
        watchListTableView.register(nibTopGainer, forCellReuseIdentifier: TopGainerTableViewCell.cellId)
        
        watchListTableView.tableHeaderView?.tintColor = UIColor(named: "Text")
        
        watchList = [
            Coin(name: "Bitcoin", ticker: "BTC", price: 53000, gain24h: 2.45),
            Coin(name: "Ethereum", ticker: "ETH", price: 4200, gain24h: -2.45),
            Coin(name: "Terra", ticker: "LUNA", price: 42.12, gain24h: 3.10)
        ]
        
        topGainers = watchList
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell tapped at index: \(indexPath.row)")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? watchList.count:topGainers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WatchListTableViewCell.cellId, for: indexPath)
        guard let c = cell as? WatchListTableViewCell else{
            fatalError("Wrong cell type")
        }
        cell.selectionStyle = .none
        let isWatchList = indexPath.section == 0
        let list = isWatchList ? watchList : topGainers
        c.set(from: list[indexPath.row])
        
        return c
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0: return "Watch List"
        case 1: return "Top Gainers"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
                
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = section == 0 ? "Watch List ❤️" : "Top Gainers 🚀"
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor(named: "Warning")
        
        headerView.addSubview(label)
        
        return headerView
    }
}

extension Coin{
    var icon: UIImage{
        return UIImage(named: self.name.lowercased()) ?? UIImage(systemName: "bitcoinsign.circle.fill")!
    }
    
    var priceString: String{
        return String(format: "$ %.2f", price)
    }
    
    var gain24hString: String{
        let sign = gain24h > 0 ? "+":""
        return "\(sign)\(String(format: "%.2f", gain24h)) %"
    }
}

extension WatchListTableViewCell{
    func set(from coin: Coin){
        name.text = coin.name
        ticker.text = coin.ticker
        price.text = coin.priceString
        gain24h.text = coin.gain24hString
        gain24h.textColor = getColor(for: coin.gain24h)
        icon.image = coin.icon
    }
    
    private func getColor(for gain24h: Double) -> UIColor?{
        return gain24h > 0 ? UIColor(named: "Success") : UIColor(named: "Danger")
    }
}


