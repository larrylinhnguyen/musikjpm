//
//  ListItemCell.swift
//  JPMMusicSearch
//
//  Created by Larry on 1/8/17.
//  Copyright © 2017 Savings iOS Dev. All rights reserved.
//

import UIKit

final class ListItemCell: UITableViewCell {
    
    @IBOutlet weak var artworkThumbnailView: UIImageView!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    
    var viewModel: ListItemCellViewModel? {
        didSet {
            artistNameLabel.text = viewModel?.artistName
            trackNameLabel.text = viewModel?.trackName
            
            viewModel?.delegate = self
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ListItemCell: ListItemCellViewModelDelegate {
    
    func imageDataDownloadDidFinished() {
        DispatchQueue.main.async {
            self.artworkThumbnailView.image = UIImage(data: (self.viewModel?.imageData!)!)
        }
    }
}
