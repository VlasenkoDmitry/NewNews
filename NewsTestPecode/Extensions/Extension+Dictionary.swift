import Foundation

extension Dictionary {
    func merge(dict: Dictionary<Key,Value>) -> Dictionary<Key,Value> {
        var mutableCopy = self
        for (key, _) in dict {
            if mutableCopy[key] != nil {
                continue
            } else {
                mutableCopy[key] = dict[key]
            }
        }
        return mutableCopy
    }
}
