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
