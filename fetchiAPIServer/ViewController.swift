//
//  ViewController.swift
//  fetchiAPIServer
//
//  Created by Mohan K on 30/01/23.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    

    var viewModel = MovieViewModel.shared
    var pageNumber : Int = 1
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        loadPopularMoviesData()
        }
    
    
    
   
    
 func loadPopularMoviesData(){
     viewModel.fetchPopularMoviesData(page: pageNumber, isFullReload: true) { [weak self] in
         
         guard let self = self else { return }
         DispatchQueue.main.async {
             self.tableView.reloadData()
             self.pageNumber += 1

         }
        }
    }
    
    func triggerPaginationCall() {
        viewModel.fetchPopularMoviesData(page: pageNumber, isFullReload: false) {[weak self] in
        guard let self = self else {return}
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.pageNumber += 1
        }
        }
    }
    
    @IBAction func reloadData(_ sender: Any) {
        
   loadPopularMoviesData()
        
        
        
        
    }
    

    }

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        return viewModel.popularMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        
        let movie = viewModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValueOf(movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !(indexPath.row + 1 < viewModel.popularMovies.count) {
            triggerPaginationCall()
        }
    }
}
