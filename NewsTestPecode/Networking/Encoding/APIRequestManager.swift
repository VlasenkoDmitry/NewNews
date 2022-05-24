import Foundation

enum APIRequestManager: EndPointType {
    case getRequestNews(filters: Filters, page: Int, search: String?)
    case makeGetSourcesList
    
    var apiKey: String {
        switch self {
        default:
            return "892e2c0ab2824611954198502939a54e"
        }
    }
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        default:
            return "newsapi.org"
        }
    }
    
    var path: String {
        switch self {
        case .getRequestNews:
            return "/v2/top-headlines"
        case .makeGetSourcesList:
            return "/v2/top-headlines/sources"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var systemParameters: Parameters {
        let today = Date().formatSmall()
        let pageSize = String(Constants.pageSize)
        
        switch self {
        case .getRequestNews:
            return ["apiKey": apiKey,
                    "from": today,
                    "pageSize": pageSize]
        case .makeGetSourcesList:
            return ["apiKey":apiKey]
        }
    }
    
    func buildRequest() -> URLRequest? {
        do {
            var urlRequest = try URLComponentsCollect()
            var parameters = Parameters()
            switch self {
            case .getRequestNews(let filters, let page, let search):
                var userParameters = Parameters()
                print(ParametersFilters.titles[0])
                print(ParametersFilters.lists[0][0])
                userParameters = filters.filtersToParametrs()
                userParameters["page"] = page
                if let search = search {
                    userParameters[ParametrsRequestNewsApi.search.rawValue] = search
                }
                parameters = mergParametrs(left: userParameters, right: systemParameters)
                urlRequest = URLEncoding.queryString.encode(urlRequest, with: parameters)
            case .makeGetSourcesList:
                urlRequest = URLEncoding.queryString.encode(urlRequest, with: systemParameters)
            }
            return urlRequest
        } catch LoadingError.InvalidUrl {
            print("Missing url")
            return nil
        } catch {
            print("Unknown error")
            return nil
        }
    }
    
    private func URLComponentsCollect() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseURL
        components.path = path
        guard let url = components.url else { throw LoadingError.InvalidUrl }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
    
    private func mergParametrs<K, V>(left: [K: V], right: [K: V]) -> [K: V] {
        return left.merging(right) { $1 }
    }
}





