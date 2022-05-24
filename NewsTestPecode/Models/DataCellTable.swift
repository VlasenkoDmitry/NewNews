import Foundation

class DataCellTable {
    var image: Data?
    var imageLink: String
    var author: String
    var title: String
    var descript: String
    var link: String

    
    init (image: Data?, imageLink: String, author: String, title: String, descript: String, link: String) {
        self.image = image
        self.imageLink = imageLink
        self.author = author
        self.title = title
        self.descript = descript
        self.link = link
    }
}


