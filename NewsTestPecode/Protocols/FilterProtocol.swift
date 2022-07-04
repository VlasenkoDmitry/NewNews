//
//  FilterProtocol.swift
//  NewsTestPecode
//
//  Created by Ap on 4.07.22.
//

import Foundation

protocol FilterProtocol {
    func setTitle(title: String)
    func setList(list: [String])
    func setListCheck(listCheck: [Bool])
    func setCheckToIndex(check: Bool, index: Int)
    func getTitle() -> String
    func getList() -> [String]
    func getListCheck() -> [Bool]
}
