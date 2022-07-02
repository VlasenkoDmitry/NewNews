import Foundation

enum LoadingError: Error {
    case networkFailure(Error)
    case parseFailure(Error)
    case InvalidUrl
    case UnknownError
}

struct NetworkManager {
    let router = Router()
    
    func getNewsRequest (filters: Filters, page: Int, search: String?, complition: @escaping (NewsRequests?,Error?) -> ()) {
        let news = NewsRequests()
        if let request = APIRequestManager.getRequestNews(filters: filters, page: page, search: search).buildRequest(){
            print(request)
            router.request(from: request) { result, error in
                if let result = result, error == nil {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: result) as? [String: Any] {
                            if let totalResults = json["totalResults"] as? Int {
                                news.numberAllNewsOnRequest = totalResults
                            }
                            if let articles = json["articles"] as? [[String: Any]] {
                                news.newNews = parsingJSONDataCellTable(articles: articles)
                            }
                            complition(news, nil)
                        }
                    } catch {
                        complition(nil, LoadingError.parseFailure(error))
                    }
                }
                if let error = error {
                    complition(nil, LoadingError.networkFailure(error))
                }
            }
        } else {
            complition(nil, LoadingError.InvalidUrl)
        }
    }
    
    func getSourcesListRequest(complition: @escaping ([String]?, Error?) -> ()) {
        if let request = APIRequestManager.makeGetSourcesList.buildRequest() {
            print(request)
            router.request(from: request) { result, error in
                if let result = result, error == nil {
                    var arraySources: [String] = []
                    do {
                        if let json = try JSONSerialization.jsonObject(with: result) as? [String: Any] {
                            if let sources = json["sources"] as? [[String: Any]] {
                                for source in sources {
                                    if let id = source["id"] as? String {
                                        arraySources.append(id)
                                    }
                                }
                                complition(arraySources, nil)
                            }
                        }
                    } catch {
                        complition(nil, LoadingError.parseFailure(error))
                    }
                }
                if let error = error {
                    complition(nil, LoadingError.networkFailure(error))
                }
            }
        } else {
            complition(nil, LoadingError.InvalidUrl)
        }
    }
    
    func downloadImage(link: String, completion: @escaping (Data?) -> ()) {
        if let urlRequest = link.getUrlRequest() {
            router.request(from: urlRequest) { result, error in
                completion(result)
            }
        }
    }
    
    /// Manual parsing
    private func parsingJSONDataCellTable(articles: [[String: Any]]) -> [DataCellTable] {
        var data = [DataCellTable]()
        for article in articles {
            let news = DataCellTable(image: nil, imageLink: "", author: "", title: "", descript: "", link: "")
            if let imageLink = article["urlToImage"] as? String {
                news.imageLink = imageLink
            }
            if let author = article["author"] as? String {
                news.author = author
            }
            if let title = article["title"] as? String {
                news.title = title
            }
            if let description = article["description"] as? String {
                news.descript = description
            }
            if let urlString = article["url"] as? String {
                news.link = urlString
            }
            data.append(news)
        }
        return data
    }
    
}






