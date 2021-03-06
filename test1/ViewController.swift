//
//  ViewController.swift
//  test1
//
//  Created by Artem on 13.01.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var imageData = [String](urlString: "http://placehold.it/375x150?text=", count: 100)
    var networkService = NetworkService()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! CustomTableViewCell
        networkService.downloadImage(withURL: URL(string: imageData[indexPath.row])!, forCell: cell)
        return cell
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
