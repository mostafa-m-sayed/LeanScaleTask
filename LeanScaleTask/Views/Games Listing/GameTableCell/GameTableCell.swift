//
//  GameTableCell.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 26/09/2021.
//

import UIKit

class GameTableCell: UITableViewCell {
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var metacriticLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var metacriticStack: UIStackView!
    
    var game: GameVM? {
        didSet {
            if let game = game {
                self.bindData(game: game)
            }
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.img.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindData(game: GameVM) {
        titleLabel.text = game.name
        genreLabel.text = game.genres
        self.img.kf.indicatorType = .activity
        img.kf.setImage(with: URL(string: game.image), placeholder: UIImage(named: "game-placeholder"))
        metacriticLabel.text = game.metacritic
        self.backgroundColor = game.viewed ? UIColor(named: "selected-cell") : UIColor.white
    }
    
}
