import Foundation

protocol UserDefaultProtocol {
    func setFilters(filters: Filters)
    func readSavedFilters(titles: [String]) -> Filters
    func fillFiltersSavedData(filters: Filters) -> Filters
    func clearFilters()
}
