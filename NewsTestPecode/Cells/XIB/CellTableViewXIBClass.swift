import UIKit
import SwiftUI

class CellTableViewXIBClass: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descript: UILabel!
    @IBOutlet weak var notesBotton: UIButton!
    
    weak var delegate: XIBToCellDelegate?
    
    static func instanceFromNib(cell: DataCellTable) -> CellTableViewXIBClass {
        let manager = NetworkManager()
        guard let xib = UINib(nibName: "CellTableViewXIBClass", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? CellTableViewXIBClass else { return CellTableViewXIBClass()}
        
        xib.layer.cornerRadius = 15
        xib.author.text = cell.author
        xib.title.text = cell.title
        xib.descript.text = cell.descript
        
        xib.imageView.contentMode = .scaleAspectFill
        manager.downloadImage(link: cell.imageLink, completion: { result in
            if let result = result {
                cell.image = result
                DispatchQueue.main.async {
                    guard let data = cell.image else { return }
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
