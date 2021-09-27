//
//  GameDetailsVC.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 27/09/2021.
//

import UIKit

class GameDetailsVC: UIViewController {
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

    }

    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        game?.addToFavourite()
    }
    
    func getGame() {
        guard let id = gameId else { return }
        GameVM.get(gameId: id) { game, error in
            self.game = game
            
        }
    }
    
    @objc func descLabelTapped() {
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()
        descLabel.layoutIfNeeded()
    }
    func bindData() {
        guard let game = game else { return }
        titleLabel.text = game.name
        descLabel.attributedText = game.description
    }
}
