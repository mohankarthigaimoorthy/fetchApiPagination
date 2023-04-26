//
//  MovieViewModel.swift
//  fetchiAPIServer
//
//  Created by Mohan K on 30/01/23.
//

import Foundation

class MovieViewModel {
    
    var apiService = ApiService()
    static let shared = MovieViewModel()
    var popularMovies = [Movie]()
    var fullReload: Bool = false
    
    func fetchPopularMoviesData(page: Int, isFullReload:Bool ,completion: @escaping () -> ()) {
        
        // weak self - prevent retain cycles
        apiService.getPopularMoviesData(pageNumber: page) { [weak self] (result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let listOf):
                
                if isFullReload == true {
                    strongSelf.popularMovies = []
                    strongSelf.popularMovies = listOf.movies
                    completion()
                }else if isFullReload == false {
                    strongSelf.popularMovies.append(contentsOf: listOf.movies)
                    completion()
                }
            
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }
    
    
//    func numberOfRowsInSection(section: Int) -> Int {
//        if popularMovies.count != 0 {
//            return popularMovies.count
//        }
//        return 0
//    }
    func getArrayCount() -> Int{
        print("array count: \(popularMovies.count)")
        return popularMovies.count
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Movie {
        return popularMovies[indexPath.row]
    }
}
