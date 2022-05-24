import Foundation
import RealmSwift

class NewsRealmData: Object {
    @objc dynamic var image: Data? = nil
    @objc dynamic var title: String = ""
    @objc dynamic var link: String = ""
}
