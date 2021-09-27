//
//  GameDetailsVC.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 27/09/2021.
//

import UIKit
import Kingfisher

class GameDetailsVC: UIViewController {
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var redditView: UIView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(goToURL))
            redditView.addGestureRecognizer(gesture)
        }
    }
    @IBOutlet weak var websiteView: UIView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(goToURL))
            websiteView.addGestureRecognizer(gesture)
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var gameId: Int?
    var game: GameVM?

    override func viewDidLoad() {
        super.viewDidLoad()
        getGame()
        tableView.register(UINib(nibName: "GameDetailsTableCell", bundle: nil), forCellReuseIdentifier: "GameDetailsTableCell")
    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        game?.isFavourited() ?? false ? game?.removeFromFavourite() : game?.addToFavourite()
        setFavouriteButtonTitle()
    }
    
    func getGame() {
        guard let id = gameId else { return }
        GameVM.get(gameId: id) { game, error in
            self.game = game
            self.bindData()
        }
    }
    
    func bindData() {
        guard let game = game else { return }
        DispatchQueue.main.async {
            self.titleLabel.text = game.name
            self.img.kf.setImage(with: URL(string: game.image), placeholder: UIImage(named: "game-placeholder"))
            self.setFavouriteButtonTitle()
        }
    }
    
    @objc func goToURL(_ gesture: UITapGestureRecognizer) {
        let urlType = UrlTypes(rawValue: gesture.view?.tag ?? 0)
        switch urlType {
            case .reddit:
                if let url = game?.redditURL {
                    UIApplication.shared.open(url)
                }
            case .website:
                if let url = game?.website {
                    UIApplication.shared.open(url)
                }
            case .none:
                return
        }
    }

    func setFavouriteButtonTitle() {
        favouriteButton.setTitle(game?.isFavourited() ?? false ? "Favourited" : "Favourite", for: .normal)
    }
    
    enum UrlTypes: Int {
        case reddit = 0
        case website = 1
    }
}
extension GameDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameDetailsTableCell", for: indexPath) as! GameDetailsTableCell
        cell.delegate = self
        cell.descLabel.attributedText = game?.description
        return cell
    }
    
    
}
extension GameDetailsVC: DescriptionStatus {
    func DescriptionExpanded() {
        tableView.reloadData()
    }
}
