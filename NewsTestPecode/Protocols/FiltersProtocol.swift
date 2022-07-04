//
//  FiltersProtocol.swift
//  NewsTestPecode
//
//  Created by Ap on 2.07.22.
//

import Foundation

protocol FiltersProtocol {
    func setNewSettingsFilter(addedFilter: Filter)
    func updateFilters(changedFilter: Filter)
    func checkAtLeastOneActiveFilter() -> Bool
    func getParametersFromFilters() -> Parameters
    func updateSourcesFilter(downloadedListSources: [String])
    func fillSourcesFilterSavedData()
    func getFilters() -> [Filter]
}
