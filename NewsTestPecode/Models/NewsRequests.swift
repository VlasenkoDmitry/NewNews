import Foundation

class NewsRequests {
    private var numberAllNewsOnRequest = 0
    private var newNews: [DataCellTable] = []
    
    func saveNumberAllNewsOnRequest(number: Int) {
        self.numberAllNewsOnRequest = number
    }
    
    func saveNews(news: [DataCellTable]) {
        self.newNews = news
    }
    
    func getNumberAllNewsOnRequest() -> Int {
        return numberAllNewsOnRequest
    }
    
    func getNews() -> [DataCellTable] {
        return newNews
    }
}
