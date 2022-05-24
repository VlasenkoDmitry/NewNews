//
//  FitlersTableViewCell.swift
//  NewsTestPecode
//
//  Created by Ap on 10.05.22.
//

import UIKit
import SwiftUI

class FitlersTableViewCell: UITableViewCell {
    
    private var label = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.addSubview(label)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
//        contentView.superview?.backgroundColor = UIColor(named: "newGreen")
        label.numberOfLines = 1
    }
    
    func configure(model: SettingsOption) {
        
        label.text = model.title.capitalizingFirstLetter()
        label.textColor = UIColor(named: "newGreen")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 16, y: 0, width: contentView.frame.size.width - 50, height: contentView.frame.size.height)
    }
}
