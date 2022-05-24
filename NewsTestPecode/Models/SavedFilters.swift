////
////  SavedFilters.swift
////  NewsTestPecode
////
////  Created by Ap on 19.05.22.
////
//
//import Foundation
//
//class SavedFilters: Codable {
//    
//    var listParameters: [String]
//    var checkList: [String]
//    
//    
//    init(listParameters: [String], checkList: [String]) {
//        self.listParameters = listParameters
//        self.checkList = checkList
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case listParameters, checkList
//    }
//    
//    required public init(from decoder: Decoder) throws {
//        self.listParameters = try container.decode([String].self, forKey: .listParameters)
//        self.checkList = try container.decode([String].self, forKey: .checkList)
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        try container.encode(self.listParameters, forKey: .listParameters)
//        try container.encode(self.checkList, forKey: .checkList)
//    }
//}
//
//extension UserDefaults {
//    
//    func set<T: Encodable>(encodable: T, forKey key: String) {
//        if let data = try? JSONEncoder().encode(encodable) {
//            set(data, forKey: key)
//        }
//    }
//    
//    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
//        if let data = object(forKey: key) as? Data,
//           let value = try? JSONDecoder().decode(type, from: data) {
//            return value
//        }
//        return nil
//    }
//}
//
//
