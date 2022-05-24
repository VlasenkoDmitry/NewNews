import Foundation

protocol EndPointType {
    var apiKey: String { get }
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var systemParameters: Parameters { get }
}

typealias Parameters = [String: Any]

typealias FavouriteData = ([String], [Data])

