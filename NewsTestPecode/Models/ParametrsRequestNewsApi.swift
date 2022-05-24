import Foundation

enum ParametrsRequestNewsApi: String {
    case sources = "sources"
    case search = "q"
    case language = "language"
    case country = "country"
    case category = "category"
}

struct Constants {
    static let pageSize = 10
}
