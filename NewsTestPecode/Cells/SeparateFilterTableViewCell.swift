import UIKit

class SeparateFilterTableViewCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.clipsToBounds = true
        textLabel?.numberOfLines = 1
    }
    
    func configure(model: String) {
        textLabel?.text = model
        textLabel?.textColor = UIColor(named: "newGreen")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        self.accessoryType = .none
    }
}
