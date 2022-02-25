//
//  Model.swift
//  country-list
//
//  Created by Sunil Targe on 2022/2/26.
//

import Foundation

struct City: Decodable {
    let country: String
    let name: String
    let _id: Int
    let coord: Coord
}

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}
