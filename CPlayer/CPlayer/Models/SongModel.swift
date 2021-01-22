//
//  SongModel.swift
//  CPlayer
//
//  Created by Cedric Bahirwe on 10/9/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import Foundation

struct Album: Codable {
    var author: String
    var tracks: [Track]
}

struct Track: Codable {
    var index: Int
    var title: String
    
    static let track = Track(index: 0, title: "")
}

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }
}
