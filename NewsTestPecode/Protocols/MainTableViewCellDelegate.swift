import Foundation

protocol MainTableViewCellDelegate: AnyObject {
    func addNewsToFavourite(index: Int)
    func deleteNewsFromFavourite(index: Int)
}
