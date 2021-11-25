//
//  TopGainerTableViewCell.swift
//  CryptoInspectorNoCoordinator
//
//  Created by Lorenzo Limoli on 25/11/21.
//

import UIKit

class TopGainerTableViewCell: UITableViewCell, CoinTableViewCellProtocol {

    static let nibId: String = "TopGainerTableViewCell"
    static let cellId: String = "topGainerCell"
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var gain24h: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var alert: UIImageView!
    var borders: [CALayer?] = [nil, nil, nil, nil]
}

extension TopGainerTableViewCell {
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
        
        var order: Int{
            switch self {
            case .Left:
                return 0
            case .Right:
                return 1
            case .Top:
                return 2
            case .Bottom:
                return 3
            }
        }
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor?, andThickness thickness: CGFloat) {
        
        let alreadyExist = borders[side.order] != nil
        if alreadyExist{
            return
        }
        let border = alreadyExist ? borders[side.order]! : CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left:
            border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX + 10, y: frame.minY+1, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX + 10, y: frame.maxY-1, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
        borders[side.order] = border
    }
    
    func setBorder(of side: ViewSide, withVisibility value: Bool){
        borders[side.order]?.isHidden = value
    }
}
