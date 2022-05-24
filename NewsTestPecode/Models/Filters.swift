import Foundation

class Filters {
    var filters = [Filter]()
    
    init() {
        for element in 0..<ParametersFilters.titles.count {
            filters.append(Filter(title: ParametersFilters.titles[element],
                                  list: ParametersFilters.lists[element],
                                  listCheck: Array(repeating: false, count: ParametersFilters.lists[element].count)))
        }
    }
    
    func setNewSettingsFilter(addedFilter: Filter) {
        for filter in filters where filter.title == addedFilter.title {
            filter.listCheck = addedFilter.listCheck
        }
    }
    
    func updateFilters(changedFilter: Filter) {
        for filter in filters {
            if filter.title == changedFilter.title, filter.listCheck != changedFilter.listCheck {
                changeIncompatibleFilters(changeble: changedFilter)
            }
        }
        setNewSettingsFilter(addedFilter: changedFilter)
    }
    
    func checkAtLeastOneActiveFilter() -> Bool{
        var mainChecker = Set<Bool>()
        for filter in filters {
            let newChecker = Set(filter.listCheck.map { $0 })
            mainChecker = mainChecker.union(newChecker)
        }
        if mainChecker.contains(true) == false {
            return false
        } else {
            return true
        }
    }
    
    /// We can't mix sources param with the country or category params.
    private func changeIncompatibleFilters(changeble: Filter) {
        switch changeble.title {
        case ParametrsRequestNewsApi.sources.rawValue:
            for filter in filters {
                if filter.title == ParametrsRequestNewsApi.category.rawValue || filter.title == ParametrsRequestNewsApi.country.rawValue {
                    filter.listCheck = Array(repeating: false, count: filter.list.count)
                }
            }
        case ParametrsRequestNewsApi.category.rawValue, ParametrsRequestNewsApi.country.rawValue:
            for filter in filters {
                if filter.title == ParametrsRequestNewsApi.sources.rawValue {
                    filter.listCheck = Array(repeating: false, count: filter.list.count)
                }
            }
        default:
            print("Zero")
        }
    }
    
    /// Casting filters to type Parameters to using it like a part of the request
    /// - Returns: Filters casted to type Parameters like ["sources" : "bbc-news,bild",]
    func filtersToParametrs() -> Parameters {
        var parameters = Parameters()
        for filter in filters {
            var array: [String] = []
            for num in 0..<filter.list.count{
                if filter.listCheck[num] {
                    array.append(filter.list[num])
                }
            }
            if array.count > 0 {
                parameters[filter.title] = array.joined(separator:",")
            }
        }
        return parameters
    }
    
    func updateSoures(downloadedListSources: [String]) {
        print(downloadedListSources)
        
        guard let oldList = filters.first(where: { $0.title == ParametrsRequestNewsApi.sources.rawValue })?.list else { return }
        print(oldList)
        guard let oldCheckList = filters.first(where: { $0.title == ParametrsRequestNewsApi.sources.rawValue })?.listCheck else { return }
        print(oldCheckList)
        var resultList: [String] = []
        var resultCheckList: [Bool] = []
        for source in downloadedListSources {
            if (oldList.contains(source)) {
                resultList.append(source)
                if let index = oldList.firstIndex(of: source) {
                    resultCheckList.append(oldCheckList[index])
                    print(resultCheckList)
                } else {
                    resultCheckList.append(false)
                }
            } else {
                resultList.append(source)
                resultCheckList.append(false)
            }
        }
        filters.first(where: { $0.title == ParametrsRequestNewsApi.sources.rawValue })?.list = resultList
        filters.first(where: { $0.title == ParametrsRequestNewsApi.sources.rawValue })?.listCheck = resultCheckList
    }
    
}
