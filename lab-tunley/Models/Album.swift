//
//  Album.swift
//  lab-tunley
//
//  Created by Dante Ricketts on 9/16/23.
//

import Foundation
struct AlbumSearchResponse: Decodable{
    let results: [Album]
}
struct Album: Decodable {
    let artworkUrl100: URL
}
