//
//  MovieModel.swift
//  MovieDatabaseApp
//
//  Created by Ashish Jain on 28/07/23.
//

import Foundation

struct MovieModel : Codable {
    var Title : String
    var Year : String
    var Rated : String
    var Released : String
    var Runtime : String
    var Genre : String
    var Director : String
    var Writer  : String
    var Actors  : String
    var Plot : String
    var Language : String
    var Country : String
    var Awards  : String
    var Poster  : String
    var Ratings : [RatingModel]
    var Metascore  : String
    var imdbRating : String
    var imdbVotes : String
    var imdbID : String
    var MovieType : String
    var DVD : String?
    var BoxOffice : String?
    var Production : String?
    var Website : String?
    var Response : String?
    
    private enum CodingKeys : String, CodingKey {
        case MovieType = "Type"
        case Title, Year, Rated, Released, Runtime, Genre, Director, Writer, Actors, Plot, Language, Country, Awards, Poster, Ratings, Metascore, imdbRating, imdbVotes, imdbID, DVD, BoxOffice, Production, Website, Response
    }
}
