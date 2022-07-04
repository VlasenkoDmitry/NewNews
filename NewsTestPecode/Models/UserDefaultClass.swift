import Foundation

class UserDefaultClass: UserDefaultProtocol {
    private let defaults = UserDefaults.standard
    
    func setFilters(filters: Filters) {
        for index in filters.getFilters() {
            var arrayList: [String] = []
            var arrayListCheck: [Bool] = []
            for j in 0..<index.getList().count {
                arrayList.append(index.getList()[j])
                arrayListCheck.append(index.getListCheck()[j])
            }
            defaults.set(arrayList, forKey: index.getTitle() + " arrayList")
            defaults.set(arrayListCheck, forKey: index.getTitle() + " arrayListCheck")
        }
    }
    
    func readSavedFilters(titles: [String]) -> Filters {
        let savedFiltersObject = Filters()
        for title in titles {
            guard let arrayList = defaults.object(forKey: title + " arrayList") as? [String] else { continue }
            guard let arrayListCheck = defaults.object(forKey: title + " arrayListCheck") as? [Bool] else { continue }
            let savedFilters = savedFiltersObject.getFilters()
            savedFilters.first(where: { $0.getTitle() == title })?.setList(list: arrayList)
            savedFilters.first(where: { $0.getTitle() == title })?.setListCheck(listCheck: arrayListCheck)
        }
        return savedFiltersObject
    }
    

    
    func clearFilters() {
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        let fileName = Bundle.main.bundleIdentifier!
        let library = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
        let preferences = library.appendingPathComponent("Preferences")
        let userDefaultsPlistURL = preferences.appendingPathComponent(fileName).appendingPathExtension("plist")
        print("Library directory:", userDefaultsPlistURL.path)
        print("Preferences directory:", userDefaultsPlistURL.path)
        print("UserDefaults plist file:", userDefaultsPlistURL.path)
        if FileManager.default.fileExists(atPath: userDefaultsPlistURL.path) {
            print("file found")
        }
    }
}
