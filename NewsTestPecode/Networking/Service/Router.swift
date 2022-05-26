import Foundation

class Router {
    func request(from urlRequest: URLRequest, completion: @escaping (Data?, Error?) -> ()) {
        guard let url = urlRequest.url else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            completion(data, error)
        }
        task.resume()
    }
}
