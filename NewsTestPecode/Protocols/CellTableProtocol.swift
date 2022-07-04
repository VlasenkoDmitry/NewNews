//
//  CellTableProtocol.swift
//  NewsTestPecode
//
//  Created by Ap on 4.07.22.
//

import Foundation

protocol CellTableProtocol {
    func getImage() -> Data?
    func getImageLink() -> String
    func getAuthor() -> String
    func getTitle() -> String
    func getDescript() -> String
    func getLink() -> String
    func setImage(image: Data?)
}

