import Foundation

extension String {
    func getUrlRequest() -> URLRequest? {
        guard let url = URL(string: self) else { return nil }
        return URLRequest(url: url)
    }
    
    func capitalizingFirstLetter() -> String {
        return String(self.prefix(1)).capitalized + String(self.dropFirst())
    }
}
