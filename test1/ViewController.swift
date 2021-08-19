//
//  ViewController.swift
//  test1
//
//  Created by Artem on 13.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var imageURL = [String](urlString: "http://placehold.it/375x150?text=", count: 100)
    var networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
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

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { imageURL.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! CustomTableViewCell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("willDisplay cell \(indexPath.row + 1)")
        if let willDisplayCell = cell as? CustomTableViewCell {
            networkService.downloadImage(withURL: URL(string: imageURL[indexPath.row])!, forCell: willDisplayCell)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("didEndDisplaying cell \(indexPath.row + 1)")
        networkService.cancelTask(url: URL(string: imageURL[indexPath.row])!)
    }
}

