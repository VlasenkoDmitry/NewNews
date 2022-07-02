import Foundation

class UserDefaultClass: UserDefaultProtocol {
    let defaults = UserDefaults.standard
    
    func setFilters(filters: Filters) {
        for index in filters.filters {
            var arrayList: [String] = []
            var arrayListCheck: [Bool] = []
            for j in 0..<index.list.count {
                arrayList.append(index.list[j])
                arrayListCheck.append(index.listCheck[j])
            }
            defaults.set(arrayList, forKey: index.title + " arrayList")
            defaults.set(arrayListCheck, forKey: index.title + " arrayListCheck")
        }
    }
    
    func readSavedFilters(titles: [String]) -> Filters {
        let savedFilters = Filters()
        for title in titles {
            guard let arrayList = defaults.object(forKey: title + " arrayList") as? [String] else { continue }
            guard let arrayListCheck = defaults.object(forKey: title + " arrayListCheck") as? [Bool] else { continue }
            savedFilters.filters.first(where: { $0.title == title })?.list = arrayList
            savedFilters.filters.first(where: { $0.title == title })?.listCheck = arrayListCheck
        }
        return savedFilters
    }
    
    func fillFiltersSavedData(filters: Filters) -> Filters {
        var filters = filters
        filters = readSavedFilters(titles: ParametersFilters.titles)
        
        /// Check the installed filters. If they are not present, we will add one filter. We should add at least one filter on demand API
        var mainChecker = Set<Bool>()
        for filter in filters.filters {
            let newChecker = Set(filter.listCheck.map { $0 })
            mainChecker = mainChecker.union(newChecker)
        }
        if mainChecker.contains(true) == false {
            filters.filters[0].listCheck[0] = true
        }
        return filters
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
