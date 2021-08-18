//
//  CustomTableViewCell.swift
//  test1
//
//  Created by Artem on 03.02.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var loadedImage: UIImageView! 
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        self.loadedImage.image = nil
    }
    
    func configureCell(with withImage: UIImage?) {
        self.loadedImage.image = withImage
    }
    
    func truncateCell() {
        self.loadedImage.image = nil
    }
}
