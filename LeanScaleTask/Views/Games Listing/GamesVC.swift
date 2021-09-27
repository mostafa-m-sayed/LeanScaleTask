//
//  GamesVC.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 26/09/2021.
//

import UIKit

class GamesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()

    let search = UISearchController(searchResultsController: nil)
    var gamesVM = GameListVM()

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeSearch()
        initializePullToRefresh()
        tableView.register(UINib(nibName: "GameTableCell", bundle: nil), forCellReuseIdentifier: "GameTableCell")
        getGames()
    }

    func initializeSearch() {
        search.searchBar.placeholder = "Search for the games"
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
    }
    
    func initializePullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshList(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refreshList(_ sender: AnyObject) {
        getGames()
    }
    
    func getGames(isPagination: Bool = false) {
        if !isPagination {
            gamesVM.paginationURL = nil
        }
        gamesVM.getGames {success in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                self.gamesVM.games[0].addToFavourite()
                self.gamesVM.games[3].addToFavourite()
            }
        }
    }
}

extension GamesVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let term = searchController.searchBar.text else { return }
        if term.count > 3 {
            gamesVM.searchTerm = term
            getGames()
        }
    }
}

extension GamesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesVM.games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableCell", for: indexPath) as! GameTableCell
        cell.game = gamesVM.games[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gamesVM.games[indexPath.row].viewed = true
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor(named: "selected-cell")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if floor(bottomEdge) >= floor(scrollView.contentSize.height) {
            getGames(isPagination: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
        }
    }
}
