import Foundation

protocol FavouriteNewsViewControllerDelegate: AnyObject {
    func reloadTableViewNews()
    func openNews(title: String)
}


