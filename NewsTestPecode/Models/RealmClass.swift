import Foundation
import RealmSwift

class RealmClass: RealmBase {
    var realm = try! Realm()
    
    func realmFile() {
                print(Realm.Configuration.defaultConfiguration.fileURL!)
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        realm = try! Realm(configuration: configuration)
    }
    
    
    func getAllObjectsNewsRealmData() -> [NewsRealmData]? {
        var array: [NewsRealmData] = []
        do {
            try realm.write({
                array = Array(realm.objects(NewsRealmData.self))
            })
        } catch let error {
            print(error)
        }
        return array
    }
    
    func checkNews(data: DataCellTable) -> Bool {
        var result = false
        do {
            try realm.write({
                if let _ = realm.objects(NewsRealmData.self).filter("link = %@", data.link).first {
                    result = true
                }
            })
        } catch let error {
            print(error)
        }
        return result
    }
    
    func addNews(data: DataCellTable){
        do {
            try realm.write({
                realm.add(objectRealm(data: data))
            })
        } catch let error {
            print(error)
        }
    }
    
    func deleteNewsByLink(data: DataCellTable){
        do {
            try realm.write({
                guard let item = realm.objects(NewsRealmData.self).filter("link = %@", data.link).first else {return}
                realm.delete(item)
            })
        } catch let error {
            print(error)
        }
    }
    
    func takeAllTitles () -> [String] {
        var listFavourites = [String]()
        do {
            try realm.write({
                let result = realm.objects(NewsRealmData.self).count
                for news in 0..<result {
                    listFavourites.append(realm.objects(NewsRealmData.self)[news].title)
                }
            })
        } catch let error {
            print(error)
        }
        return listFavourites
    }
    
    func cleanBase(){
        do {
            try realm.write({
                realm.deleteAll()
            })
        } catch let error {
            print(error)
        }
    }
    
    func getLink(title: String) -> String? {
        var result: String?
        do {
            try realm.write({
                guard let item = realm.objects(NewsRealmData.self).filter("title = %@", title).first else {return}
                result = item.link
            })
        }  catch let error {
            print(error)
        }
        return result
    }
    
    func deleteNewsByTitle(title: String) {
        do {
            try realm.write({
                guard let item = realm.objects(NewsRealmData.self).filter("title = %@", title).first else {return}
                realm.delete(item)
            })
        } catch let error {
            print(error)
        }
    }
    
    private func objectRealm(data: DataCellTable) -> NewsRealmData{
        let object = NewsRealmData()
        object.image = data.image
        object.link = data.link
        object.title = data.title
        return object
    }
}
