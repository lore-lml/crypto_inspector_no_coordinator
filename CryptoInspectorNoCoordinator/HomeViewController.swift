//
//  HomeViewController.swift
//  CryptoInspectorNoCoordinator
//
//  Created by Lorenzo Limoli on 24/11/21.
//

import UIKit
import MessariAPI

class HomeViewController: UIViewController {

    @IBOutlet weak var watchListTableView: UITableView!
    
    var watchList: [Coin] = []
    var topGainers: [Coin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoinFetcher.shared.fetchCoinInfo(limit: 10){
            self.topGainers = $0
            DispatchQueue.main.async { [weak self] in
                self?.watchListTableView.reloadData()
            }
        }
        
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
            Coin(name: "Solana", ticker: "SOL", price: 201.24, gain24h: 3.10)
        ]
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
        if indexPath.section == 0{
            return retrieveTableViewCell(of: tableView, withCellId: WatchListTableViewCell.cellId, at: indexPath, from: watchList)
        }
        return retrieveTableViewCell(of: tableView, withCellId: TopGainerTableViewCell.cellId, at: indexPath, from: topGainers)
    }
    
    private func retrieveTableViewCell(of tableView: UITableView, withCellId id: String, at indexPath: IndexPath, from data: [Coin]) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        
        guard let c = cell as? CoinTableViewCellProtocol else{
            fatalError("Wrong cell type")
        }
        
        cell.selectionStyle = .none
        c.set(from: data[indexPath.row])
        
        if let topGainerCell = c as? TopGainerTableViewCell, indexPath.row != indexPath.startIndex{
            topGainerCell.addBorder(toSide: .Top, withColor: UIColor(named: "Text")?.cgColor, andThickness: 0.8)
        }

        return c as! UITableViewCell
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
        headerView.backgroundColor = UIColor.background
        
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-20)
        label.text = section == 0 ? "Watch List ❤️‍🔥" : "Top Gainers 🚀"
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.accent
        
        headerView.addSubview(label)
        
        return headerView
    }
}
