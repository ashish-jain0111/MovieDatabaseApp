//
//  HomeViewModel.swift
//  MovieDatabaseApp
//
//  Created by Ashish Jain on 29/07/23.
//

import Foundation

struct MovieCategory {
    var value : String
    var movies : [MovieModel] = []
    var isMovieListVisible : Bool = false
}

struct MovieSection {
    var sectionName : String
    var categories : [MovieCategory] = []
    var isCategoryListVisible : Bool = false
}

enum RowType {
    case categoryType
    case movieType
}

class HomeViewModel {
    
    var searchedMovieSections : Box<[MovieSection]> = Box([])
    var movieModels : [MovieModel]?
    
    private let sections = ["Year","Genre","Director","Actors", "All Movies"]
    init() {
        loadMovies()
    }
    
    func loadMovies() {
        if movieModels == nil {
            movieModels = getMoviesJson()
        }
        loadSearchList(movieModels: movieModels)
    }
    
    func loadSearchList(movieModels: [MovieModel]?){
        searchedMovieSections.value = []
        if let movieModels = movieModels {
            if movieModels.count > 0 {
                for section in sections {
                    if section == "All Movies" {
                        var allMovieSection = MovieSection(sectionName: section)
                        allMovieSection.categories.append(MovieCategory(value: ""))
                        allMovieSection.categories[0].isMovieListVisible = true
                        searchedMovieSections.value.append(allMovieSection)
                    }
                    else {
                        searchedMovieSections.value.append(MovieSection(sectionName: section))
                    }
                    
                }
                for movie in movieModels {
                    
                    // Adding movie year wise
                    var yearCategory = searchedMovieSections.value[0].categories.filter({$0.value == movie.Year}).first
                    if yearCategory != nil {
                        yearCategory!.movies.append(movie)
                    }
                    else {
                        yearCategory = MovieCategory(value: movie.Year)
                        yearCategory!.movies.append(movie)
                        searchedMovieSections.value[0].categories.append(yearCategory!)
                    }
                    
                    //Adding movie genre wise
                    var genreCategory = searchedMovieSections.value[1].categories.filter({movie.Genre.contains($0.value)}).first
                    if genreCategory != nil {
                        genreCategory!.movies.append(movie)
                    }
                    else {
                        let genres = movie.Genre.split(separator: ",", omittingEmptySubsequences: true)
                        for genre in genres {
                            genreCategory = MovieCategory(value: String(genre).trimmingCharacters(in: .whitespacesAndNewlines))
                            genreCategory!.movies.append(movie)
                            searchedMovieSections.value[1].categories.append(genreCategory!)
                        }
                    }
                    
                    //Adding movie director wise
                    var directorCategory = searchedMovieSections.value[2].categories.filter({movie.Director.contains($0.value)}).first
                    if directorCategory != nil {
                        directorCategory!.movies.append(movie)
                    }
                    else {
                        let directors = movie.Director.split(separator: ",", omittingEmptySubsequences: true)
                        for director in directors {
                            directorCategory = MovieCategory(value: String(director).trimmingCharacters(in: .whitespacesAndNewlines))
                            directorCategory!.movies.append(movie)
                            searchedMovieSections.value[2].categories.append(directorCategory!)
                        }
                    }
                    
                    //Adding movie actor wise
                    var actorCategory = searchedMovieSections.value[3].categories.filter({movie.Actors.contains($0.value)}).first
                    if actorCategory != nil {
                        actorCategory!.movies.append(movie)
                    }
                    else {
                        let actors = movie.Actors.split(separator: ",", omittingEmptySubsequences: true)
                        for actor in actors {
                            actorCategory = MovieCategory(value: String(actor).trimmingCharacters(in: .whitespacesAndNewlines))
                            actorCategory!.movies.append(movie)
                            searchedMovieSections.value[3].categories.append(actorCategory!)
                        }
                    }
                    
                    //Adding movie to all movie
                    searchedMovieSections.value[4].categories[0].movies.append(movie)
                }
            }
        }
    }
    
    func getMoviesJson() -> [MovieModel] {
        let jsonReaderService = JsonReaderService()
        do {
            return try jsonReaderService.readJsonFile()
        }catch {
            print("Error : \(error.localizedDescription)")
            return []
        }
    }
    
    func toggleCategoryListVisibleForSection(section : Int){
        searchedMovieSections.value[section].isCategoryListVisible = !searchedMovieSections.value[section].isCategoryListVisible
    }
    
    func toggleMovieListVisible(section : Int, row : Int){
        var categoryIndex = -1
        var rowNumber = -1
        let movieSection = searchedMovieSections.value[section]
        for category in movieSection.categories {
            categoryIndex += 1
            rowNumber += 1
            if rowNumber == row {
                break
            }
            if category.isMovieListVisible {
                for _ in category.movies {
                    rowNumber += 1
                    if rowNumber == row {
                        break
                    }
                }
            }
        }
        searchedMovieSections.value[section].categories[categoryIndex].isMovieListVisible = !searchedMovieSections.value[section].categories[categoryIndex].isMovieListVisible
    }
    
    func filterMovies(searchText: String?){
        guard let movieModels = movieModels else {
            return
        }
        
        guard let searchText = searchText else{
            loadSearchList(movieModels: movieModels)
            return
        }
        
        if searchText == "" {
            loadSearchList(movieModels: movieModels)
            return
        }
        var filterMovieModels : [MovieModel] = []
        for movieModel in movieModels {
            if movieModel.Title.contains(searchText) {
                filterMovieModels.append(movieModel)
                continue
            }
            if movieModel.Genre.contains(searchText) {
                filterMovieModels.append(movieModel)
                continue
            }
            if movieModel.Actors.contains(searchText) {
                filterMovieModels.append(movieModel)
                continue
            }
            if movieModel.Director.contains(searchText) {
                filterMovieModels.append(movieModel)
                continue
            }
        }
        searchedMovieSections.value = []
        if filterMovieModels.count > 0 {
            var filteredMoviesSection = MovieSection(sectionName: "")
            filteredMoviesSection.isCategoryListVisible = true
            filteredMoviesSection.categories.append(MovieCategory(value: ""))
            filteredMoviesSection.categories[0].isMovieListVisible = true
            searchedMovieSections.value.append(filteredMoviesSection)
            for movie in filterMovieModels {
                searchedMovieSections.value[0].categories[0].movies.append(movie)
            }
        }
        
    }
    
    func getHeightForSection(section: Int) -> CGFloat{
        if searchedMovieSections.value[section].sectionName == "" {
            return 0
        }
        return 50
    }
    
    func getHeightForCategoryInSection(section: Int, category: Int) -> CGFloat{
        if searchedMovieSections.value[section].sectionName == "All Movies" || searchedMovieSections.value[section].sectionName == "" {
            switch getRowType(section: section, row: category){
            case .categoryType:
                return 0
            case .movieType:
                return 125
            }
        }
        switch getRowType(section: section, row: category){
        case .categoryType:
            return 40
        case .movieType:
            return 125
        }
    }
    
    func getRowsInSection(section: Int) -> Int{
        var numberOfRows = 0
        if searchedMovieSections.value[section].isCategoryListVisible {
            numberOfRows = searchedMovieSections.value[section].categories.count
            for category in searchedMovieSections.value[section].categories {
                if category.isMovieListVisible {
                    numberOfRows += category.movies.count
                }
            }
        }
        return numberOfRows
    }
    
    func getRowType(section: Int, row: Int) -> RowType{
        var rowNumber = -1
        let movieSection = searchedMovieSections.value[section]
        for category in movieSection.categories {
            rowNumber += 1
            if rowNumber == row {
                return RowType.categoryType
            }
            if category.isMovieListVisible {
                for _ in category.movies {
                    rowNumber += 1
                    if rowNumber == row {
                        return RowType.movieType
                    }
                }
            }
        }
        return RowType.categoryType
    }
    
    func getCategoryForRow(section: Int, row: Int) -> MovieCategory? {
        var rowNumber = -1
        let movieSection = searchedMovieSections.value[section]
        for category in movieSection.categories {
            rowNumber += 1
            if rowNumber == row {
                return category
            }
            if category.isMovieListVisible {
                for _ in category.movies {
                    rowNumber += 1
                    if rowNumber == row {
                        return nil
                    }
                }
            }
        }
        return nil
    }
    
    func getMovieForRow(section: Int, row: Int) -> MovieModel? {
        var rowNumber = -1
        let movieSection = searchedMovieSections.value[section]
        for category in movieSection.categories {
            rowNumber += 1
            if rowNumber == row {
                return nil
            }
            if category.isMovieListVisible {
                for movie in category.movies {
                    rowNumber += 1
                    if rowNumber == row {
                        return movie
                    }
                }
            }
        }
        return nil
    }
    
    func getMovieDetailViewModel(section: Int, row: Int) -> MovieDetailsViewModel {
        return MovieDetailsViewModel(Movie: getMovieForRow(section: section, row: row)!)
    }
    
}
