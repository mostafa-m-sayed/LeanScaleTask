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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "GameTableCell", bundle: nil), forCellReuseIdentifier: "GameTableCell")
        getGames()
    }
    
    func getGames() {
        gamesVM.getFavouriteGames()
        tableView.reloadData()
    }

}
extension FavouritesVC: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            gamesVM.games[indexPath.row].removeFromFavourite()
            getGames()
        }
    }
}
