import UIKit

class FitlersTableViewCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    func configure(model: SettingsOption) {
        textLabel?.text = model.title.capitalizingFirstLetter()
        textLabel?.textColor = UIColor(named: "newGreen")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
    }
}
