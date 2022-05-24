import Foundation

enum URLEncoding {
    case queryString
    case none
    
    func encode(_ request: URLRequest, with parameters: Parameters) -> URLRequest {
        var requestEncode = request
        switch self {
            /// In case we need to pass Query Params to GET
        case .queryString:
            guard let url = requestEncode.url else { return requestEncode }
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
               !parameters.isEmpty {
                urlComponents.queryItems = [URLQueryItem]()
                for (k, v) in parameters {
                    let queryItem = URLQueryItem(name: k, value: "\(v)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                    urlComponents.queryItems?.append(queryItem)
                }
                requestEncode.url = urlComponents.url
            }
        case .none:
            break
        }
        return requestEncode
    }
}
