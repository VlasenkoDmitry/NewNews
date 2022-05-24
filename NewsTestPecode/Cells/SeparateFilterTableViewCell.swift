import UIKit

class SeparateFilterTableViewCell: UITableViewCell {
    var label = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.addSubview(label)
        contentView.clipsToBounds = true
        label.numberOfLines = 1
    }
    
    func configure(model: String) {
        label.text = model
        label.textColor = UIColor(named: "newGreen")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        self.accessoryType = .none
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 16, y: 0, width: contentView.frame.size.width - 50, height: contentView.frame.size.height)
    }
}
