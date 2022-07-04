import Foundation
import RealmSwift

protocol RealmBase {
    func realmFile()
    func checkNews(data: DataCellTable) -> Bool
    func addNews(data: DataCellTable)
    func deleteNewsByLink(data: DataCellTable)
    func deleteNewsByTitle(title: String)
    func takeAllTitles () -> [String]
    func cleanBase()
    func getLink(title: String) -> String?
}
