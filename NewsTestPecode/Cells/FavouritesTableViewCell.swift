import UIKit

class FavouritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!    
    @IBOutlet weak var imageNewsView: UIImageView!
    
    func configure(title: String, image: Data?) {
        self.title.text = title
        if let imageData = image {
            self.imageNewsView.image = UIImage(data: imageData)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.title.text = nil
        self.imageNewsView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
}
