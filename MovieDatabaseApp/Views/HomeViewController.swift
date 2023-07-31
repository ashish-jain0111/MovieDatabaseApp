//
//  HomeViewController.swift
//  MovieDatabaseApp
//
//  Created by Ashish Jain on 28/07/23.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let viewModel = HomeViewModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderView")
        searchBar.delegate = self
        viewModel.searchedMovieSections.bind(listener:  {_ in
            self.tableView.reloadData()
        })
    }
    
    @objc
    private func hideSection(sender: UIButton) {
        let section = sender.tag
        viewModel.toggleCategoryListVisibleForSection(section: section)
    }
    //MARK: - TableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.searchedMovieSections.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        viewModel.getHeightForSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getHeightForCategoryInSection(section: indexPath.section, category: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
        headerView.titleLabel.text = viewModel.searchedMovieSections.value[section].sectionName
        headerView.arrowImageView.image = viewModel.searchedMovieSections.value[section].isCategoryListVisible ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
        headerView.headerButton.tag = section
        headerView.headerButton.addTarget(self,
                                          action: #selector(self.hideSection(sender:)),
                                          for: .touchUpInside)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.getRowType(section: indexPath.section, row: indexPath.row){
        case .categoryType :
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
            if let category = viewModel.getCategoryForRow(section: indexPath.section, row: indexPath.row) {
                cell.categoryTitleLabel.text = category.value
            }
            return cell
        case .movieType:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
            if let movie = viewModel.getMovieForRow(section: indexPath.section, row: indexPath.row){
                cell.movieTitleLabel.text = movie.Title
                cell.languageLabel.text = movie.Language
                cell.yearLabel.text = movie.Year
                if let url = URL(string: movie.Poster) {
                    cell.posterImageView.load(url: url, defaultImage: "DefaultPoster")
                }
            }
            return cell
        }
        
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell is CategoryTableViewCell {
            viewModel.toggleMovieListVisible(section: indexPath.section, row: indexPath.row)
        }
        else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
            vc.viewModel = viewModel.getMovieDetailViewModel(section: indexPath.section, row: indexPath.row)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
        

    // MARK: - Searchbar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.filterMovies(searchText: searchBar.text)
        view.endEditing(true)
    }
}
