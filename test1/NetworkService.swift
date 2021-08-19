//
//  NetworkService.swift
//  test1
//
//  Created by Artem on 12.02.2021.
//

import UIKit

class NetworkService {
    
    var cachedImages = NSCache<NSString,UIImage>()
    var tasks : [URL:URLSessionTask] = [:]
    
    func downloadImage(withURL url: URL, forCell cell: UITableViewCell) {
        if let imageCell = cell as? CustomTableViewCell {
            print("Download \(url.absoluteString) started")
            imageCell.activityIndicator.startAnimating()
            fetchImage(withURL: url) { image in
                guard image != nil else { return }
                DispatchQueue.main.async {
                    imageCell.loadedImage.image = image
                    imageCell.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func fetchImage(withURL url: URL, completion: @escaping(UIImage?) -> Void) {
        if let image = cachedImages.object(forKey: url.absoluteString as NSString) {
            print("Download \(url.absoluteString) finished from cache")
            completion(image)
        } else {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil,
                      data != nil,
                      let image = UIImage(data: data!) else {
                        self.tasks[url] = nil
                        completion(nil)
                        return
                      }
                self.cachedImages.setObject(image, forKey: url.absoluteString as NSString)
                print("Download \(url.absoluteString) finished from url")
                self.tasks[url] = nil
                completion(image)
            }
            task.resume()
            tasks[url] = task
        }
    }
    
    func cancelTask(url: URL) {
        guard let task = tasks[url] else {
            print("Image \(url.absoluteString) is ignored")
            return
        }
        print("Download \(url.absoluteString) cancelled")
        task.cancel()
        tasks[url] = nil
    }
}
