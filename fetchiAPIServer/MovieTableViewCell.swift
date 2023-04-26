//
//  MovieTableViewCell.swift
//  fetchiAPIServer
//
//  Created by Mohan K on 31/01/23.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieYear: UILabel!
    
    @IBOutlet weak var movieOverView: UILabel!
    
    @IBOutlet weak var movieRate: UILabel!
    
    
    private var urlString: String = ""
    
    func setCellWithValueOf(_ movie:Movie) {
        updateUI(title: movie.title!, releaseDate: movie.year, rating: movie.rate
                 , overview: movie.overview, poster: movie.posterImage)
    }
    
    private func updateUI(title: String, releaseDate: String?, rating: Double?, overview: String?, poster: String?) {
        
        self.movieTitle.text = title
        self.movieYear.text = convertDateFormatter(releaseDate)
        guard let rate = rating else {return}
        self.movieRate.text = String(rate)
        self.movieOverView.text  = overview
        guard let posterString = poster else {return}
        urlString = "https://image.tmdb.org/t/p/w300" +  posterString
        
        guard let posterImageURL = URL(string: urlString) else {
            self.moviePoster.image = UIImage(named: "")
            return
        }
        
        self.moviePoster.image = nil
        
        getImageDataFrom(url: posterImageURL)
    }
    
    func convertDateFormatter(_ date: String?) -> String {
        
    var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let originalDate = date {
            if let newDate = dateFormatter.date( from: originalDate) {
                dateFormatter.dateFormat = "dd.MM.yyyy"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.moviePoster.image = image
                }
            }
        }.resume()
    }
}
