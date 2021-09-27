//
//  FavouritesVC.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 26/09/2021.
//

import UIKit

class FavouritesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var gamesVM = GameListVM()
    let noDataLabel: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeNoDataLabel()
        tableView.register(UINib(nibName: "GameTableCell", bundle: nil), forCellReuseIdentifier: "GameTableCell")
    }
    
    func initializeNoDataLabel() {
        noDataLabel.text = "There are no favourites found."
        noDataLabel.textColor = .black
        noDataLabel.textAlignment = NSTextAlignment.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getGames()
    }
    
    func getGames() {
        gamesVM.getFavouriteGames()
        if gamesVM.games.count > 0 {
            navigationController?.navigationItem.title = "Favourites\(gamesVM.games.count)"
        } else {
            let label = UILabel()
            label.backgroundColor = .red
            label.text = "There is no favourites found."
            
            tableView.addSubview(label)
        }
        
        tableView.reloadData()
    }
    
    func removeFromFavourite(game: GameVM) {
        game.removeFromFavourite()
        getGames()
    }

}
extension FavouritesVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection: Int = 0

        if gamesVM.games.count > 0 {
            numOfSection = 1
            noDataLabel.removeFromSuperview()
        } else {

            if tableView.subviews.contains(noDataLabel) {
                return 0
            }
            self.tableView.addSubview(noDataLabel)
            noDataLabel.translatesAutoresizingMaskIntoConstraints = false
            noDataLabel.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
            noDataLabel.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor, constant: -(self.tableView.frame.height / 2.2)).isActive = true
            noDataLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        }

        return numOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesVM.games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableCell", for: indexPath) as! GameTableCell
        cell.game = gamesVM.games[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "GameDetailsVC") as? GameDetailsVC {
            nextVC.gameId = gamesVM.games[indexPath.row].id
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alert = UIAlertController(title: "Delete", message: "Delete from favourites ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
                self.removeFromFavourite(game: self.gamesVM.games[indexPath.row])
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                return
            }))
            present(alert, animated: true)
        }
    }
}
