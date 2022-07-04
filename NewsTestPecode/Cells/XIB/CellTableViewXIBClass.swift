import UIKit
import SwiftUI

class CellTableViewXIBClass: UIView {
    weak var delegate: XIBToCellDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descript: UILabel!
    @IBOutlet weak var notesBotton: UIButton!
    
    static func instanceFromNib(cell: DataCellTable) -> CellTableViewXIBClass {
        let manager = NetworkManager()
        guard let xib = UINib(nibName: "CellTableViewXIBClass", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? CellTableViewXIBClass else { return CellTableViewXIBClass()}
        
        xib.layer.cornerRadius = 15
        xib.author.text = cell.getAuthor()
        xib.title.text = cell.getTitle()
        xib.descript.text = cell.getDescript()
        
        xib.imageView.contentMode = .scaleAspectFill
        manager.downloadImage(link: cell.getImageLink(), completion: { result in
            if let result = result {
                cell.setImage(image: result)
                DispatchQueue.main.async {
                    guard let data = cell.getImage() else { return }
                    xib.imageView.image = UIImage(data: data)
                }
            } else {
                DispatchQueue.main.async {
                    xib.imageView.image = UIImage(named: "placeholder")
                }
            }
        })
        return xib
    }
}
