import UIKit

class MainTableViewCell: UITableViewCell {
    private var customView = CellTableViewXIBClass()
    weak var delegate: MainTableViewCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func configure(dataNews: DataCellTable, index: Int) {
        customView = CellTableViewXIBClass.instanceFromNib(cell: dataNews)
        customView.notesBotton.setImage(UIImage(systemName: "bookmark.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .selected)
        customView.notesBotton.setImage(UIImage(systemName: "bookmark")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        customView.notesBotton.tag = index
        customView.notesBotton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.addSubview(customView)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            delegate?.addNewsToFavourite(index: sender.tag)
        } else {
            delegate?.deleteNewsFromFavourite(index: sender.tag)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        customView.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        customView.frame = CGRect(x: 16, y: 10, width: self.frame.size.width - 32, height: self.frame.size.height - 20)
    }
    
    func getCustomView() -> CellTableViewXIBClass {
        return customView
    }
}



