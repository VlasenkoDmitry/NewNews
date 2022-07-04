import Foundation

class Filter: FilterProtocol {
    private var title: String
    private var list: [String]
    private var listCheck: [Bool]
    
    init(title: String, list: [String], listCheck: [Bool]) {
        self.title = title
        self.list = list
        self.listCheck = listCheck
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func setList(list: [String]) {
        self.list = list
    }
    
    func setListCheck(listCheck: [Bool]) {
        self.listCheck = listCheck
    }
    
    func setCheckToIndex(check: Bool, index: Int) {
        self.listCheck[index] = check
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getList() -> [String] {
        return list
    }
    
    func getListCheck() -> [Bool] {
        return listCheck
    }

}



