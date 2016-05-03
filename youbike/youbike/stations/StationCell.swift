//
//  StationCell.swift
//  youbike
//
//  Created by Ian on 4/28/16.
//  Copyright © 2016 AppWorks School Ian Cheng. All rights reserved.
//

import UIKit

protocol CellDelegation: class {
    func cell(cell: StationCell, viewMap sender: AnyObject?)
}

class StationCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var remainingBikes: UILabel!
    @IBOutlet weak var btnViewMap: UIButton!
    @IBOutlet weak var separateLine: UIView!
    
    weak var delegate: CellDelegation?
    var station: Station = Station()
    
    static let identifier = "StationCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initAction()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initAction() {
        
        self.title.font = UIFont.ybkTextStyle2Font(20)
        self.title.textColor = UIColor.ybkBrownishColor()
        
        self.address.font = UIFont.ybkTextStyle2Font(14)
        self.address.textColor = UIColor.ybkSandBrownColor()
        
        self.btnViewMap.setTitle("看地圖", forState: .Normal)
        self.btnViewMap.setTitleColor(UIColor.ybkDarkSalmonColor(), forState: .Normal)
        self.btnViewMap.layer.cornerRadius = 5
        self.btnViewMap.layer.borderWidth = 1
        self.btnViewMap.layer.borderColor = UIColor.ybkDarkSalmonColor().CGColor
        //        btnViewMap(self, action: #selector(viewMap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.btnViewMap.addTarget(self, action: Selector("viewMap:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.backgroundColor = UIColor.ybkPaleColor()
        self.separateLine.backgroundColor = UIColor.ybkDarkSandColor()
        
        self.bringSubviewToFront(btnViewMap)
        
    }
    
    static func getRemainingBike(remainingBike: Int) -> NSMutableAttributedString {
        
        let prefix = "剩"
        let bikes = String(remainingBike)
        let subfix = "台"
        let remainingBikesString = (prefix + bikes + subfix) as NSString
        
        let font_1 = [ NSForegroundColorAttributeName: UIColor.ybkDarkSalmonColor(), NSFontAttributeName: UIFont.ybkTextStyleFont(80)! ]
        let font_2 = [ NSForegroundColorAttributeName: UIColor.ybkSandBrownColor(), NSFontAttributeName: UIFont.ybkTextStyle2Font(20)! ]
        
        let attributedString = NSMutableAttributedString(string: remainingBikesString as String)
        attributedString.addAttributes(font_2, range: remainingBikesString.rangeOfString(prefix))
        attributedString.addAttributes(font_1, range: remainingBikesString.rangeOfString(bikes))
        attributedString.addAttributes(font_2, range: remainingBikesString.rangeOfString(subfix))
        
        return attributedString
        
    }
    
    func viewMap(sender: UIButton) {
        print("click by cell")
        self.delegate?.cell(self, viewMap: sender)
    }
    
}
