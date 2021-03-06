//
//  NetworkService.swift
//  test1
//
//  Created by Artem on 12.02.2021.
//

import UIKit

class NetworkService {
    
    //    private init() {}
    //    static let shared = NetworkService()
    
    var cachedImages = NSCache<NSString,UIImage>()
    
    func downloadImage(withURL url: URL, forCell cell: UITableViewCell) {
        
        if let imageCell = cell as? CustomTableViewCell {
            
            print("Download \(url.absoluteString) started")
            imageCell.activityIndicator.startAnimating()
            
            if let image = cachedImages.object(forKey: url.absoluteString as NSString) {
                
                DispatchQueue.main.async {
                    if !imageCell.isHidden {
                        imageCell.loadedImage.image = image
                        imageCell.activityIndicator.stopAnimating()
                        print("Download \(url.absoluteString) finished from cache")
                    } else {
                        print("url: \(url), responce is ignored! Cell is hidden.")
                    }
                }
                
            } else {
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                    
                    guard error == nil,
                          data != nil,
                          //response.statusCode == 200,
                          let image = UIImage(data: data!) else { return }
                    
                    self.cachedImages.setObject(image, forKey: url.absoluteString as NSString)
                    
                    DispatchQueue.main.async {
                        if url == response?.url, !imageCell.isHidden {
                            imageCell.loadedImage.image = image
                            imageCell.activityIndicator.stopAnimating()
                            print("Download \(url.absoluteString) finished")
                        } else {
                            print("url: \(url), responce is ignored! Cell is hidden.")
                        }
                    }
                }.resume()
            }
        }
    }
    
}
