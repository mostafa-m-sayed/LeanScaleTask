//
//  GameDetailsVC.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 27/09/2021.
//

import UIKit
import Kingfisher

class GameDetailsVC: UIViewController {
    @IBOutlet weak var reditView: UIView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(descLabelTapped))
            reditView.addGestureRecognizer(gesture)
        }
    }
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var descLabel: UILabel! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(descLabelTapped))
            descLabel.addGestureRecognizer(gesture)
        }
    }
    var gameId: Int?
    var game: GameVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        getGame()
        
    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        game?.addToFavourite()
    }
    
    func getGame() {
        guard let id = gameId else { return }
        GameVM.get(gameId: id) { game, error in
            self.game = game
            self.bindData()
        }
    }
    
    @objc func descLabelTapped() {
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()
        descLabel.layoutIfNeeded()
    }
    
    func bindData() {
        guard let game = game else { return }
        DispatchQueue.main.async {
            self.titleLabel.text = game.name
            self.descLabel.attributedText = game.description
            self.img.kf.setImage(with: URL(string: game.image), placeholder: UIImage(named: "game-placeholder"))
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
    enum UrlTypes: Int {
        case reddit = 0
        case website = 1
    }
}
