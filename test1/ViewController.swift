//
//  ViewController.swift
//  test1
//
//  Created by Artem on 13.01.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var imageURL = [String](urlString: "http://placehold.it/375x150?text=", count: 100)
    var networkService = NetworkService()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageURL.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! CustomTableViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("willDisplay \(indexPath.row)")
        if let willDisplayCell = cell as? CustomTableViewCell {
            networkService.downloadImage(withURL: URL(string: imageURL[indexPath.row])!, forCell: willDisplayCell)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("didEndDisplaying \(indexPath.row)")
        networkService.cancelTask(url: URL(string: imageURL[indexPath.row])!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension Array where ArrayLiteralElement == String {
    init(urlString url: String, count i: Int) {
        self.init()
        for index in 0..<i {
            self.append("\(url)\(index + 1)")
        }
    }
}
