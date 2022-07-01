import Foundation

protocol UserDefaultProtocol {
    func setFilters(filters: Filters)
    func readSavedFilters(titles: [String]) -> Filters
    func fillingFiltersSavedData(filters: Filters) -> Filters
    func clearFilters()
}
