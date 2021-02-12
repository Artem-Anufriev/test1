//
//  NetworkService.swift
//  test1
//
//  Created by Artem on 12.02.2021.
//

import Foundation
import UIKit

class NetworkService {
    
    private init() {}
    static let shared = NetworkService()

    public func downloadImage(withURL url: URL, forCell cell: UITableViewCell){
        
        func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
        
        if let imageCell = cell as? CustomTableViewCell {
            print("Download \(url.absoluteString) started")
            imageCell.activityIndicator.startAnimating()
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    imageCell.loadedImage.image = UIImage(data: data)
                    imageCell.activityIndicator.stopAnimating()
                }
                print("Download \(url.absoluteString) finished")
            }
        }
    }
    
}
