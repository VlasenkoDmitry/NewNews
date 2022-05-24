import Foundation

class Filter {
    init(title: String, list: [String], listCheck: [Bool]) {
        self.title = title
        self.list = list
        self.listCheck = listCheck
    }
    var title: String
    var list: [String]
    var listCheck: [Bool]
}



