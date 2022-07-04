import Foundation

class DataCellTable: CellTableProtocol {

    private var image: Data?
    private var imageLink: String
    private var author: String
    private var title: String
    private var descript: String
    private var link: String
    
    init (image: Data?, imageLink: String, author: String, title: String, descript: String, link: String) {
        self.image = image
        self.imageLink = imageLink
        self.author = author
        self.title = title
        self.descript = descript
        self.link = link
    }
    
    func setImage(image: Data?) {
        self.image = image
    }
    
    func getAuthor() -> String {
        return author
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getDescript() -> String {
        return descript
    }
    
    func getImage() -> Data? {
        return image
    }
    
    func getImageLink() -> String {
        return imageLink
    }
    
    func getLink() -> String {
        return link
    }
    
}


