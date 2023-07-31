//
//  JsonReaderService.swift
//  MovieDatabaseApp
//
//  Created by Ashish Jain on 28/07/23.
//

import Foundation
import UIKit

class JsonReaderService {
    
    func readJsonFile() throws -> [MovieModel]{
        
        do {
            if let filePath = Bundle.main.path(forResource: "movies", ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                let decoded = try JSONDecoder().decode([MovieModel].self, from: data)
                return decoded
            }
        } catch {
            throw error
        }
        return []
    }
}
