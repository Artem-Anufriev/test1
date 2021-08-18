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
    // fill the array with 100 nil first, then replace the nil with the loaded news object at its corresponding index/position
    var dataTasks : [URLSessionDataTask] = []
    var imagesArray : [UIImage?] = [UIImage?](repeating: nil, count: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self
    }
    
    func fetchImages(ofIndex index: Int, withURL url: URL) {
        if dataTasks.firstIndex(where: { task in
            task.originalRequest?.url == url
        }) != nil {
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { [self] data, response, error in
            guard let data = data else {
                print("No data")
                return
            }
            guard let image = UIImage(data: data) else {
                print("Error: Couldn't decode data into image")
                return
            }
            // replace the initial 'nil' value with the loaded images
            // to indicate that the images have been loaded for the table view
            imagesArray[index] = image
            // Update UI on main thread
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: index, section: 0)
                if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                }
            }
        }
        // run the task of fetching image, and append it to the dataTasks array
        dataTask.resume()
        dataTasks.append(dataTask)
    }
    
    // the 'index' parameter indicates the row index of tableview
    func cancelFetchImages(ofIndex index: Int, withURL url: URL) {
        guard let dataTaskIndex = dataTasks.firstIndex(where: { task in
            task.originalRequest?.url == url
        }) else {
            return
        }
        let dataTask =  dataTasks[dataTaskIndex]
        // cancel and remove the dataTask from the dataTasks array
        // so that a new datatask will be created and used to load images next time
        // since we already cancelled it before it has finished loading
        dataTask.cancel()
        dataTasks.remove(at: dataTaskIndex)
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
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        return tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! CustomTableViewCell
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! CustomTableViewCell
        // get the corresponding image object to show from the array
        if let image = imagesArray[indexPath.row] {
            cell.configureCell(with: image)
        } else {
            // if the image havent loaded (nil havent got replaced), reset all the label
            cell.truncateCell()
            // fetch the images from API
            fetchImages(ofIndex: indexPath.row, withURL: URL(string: imageURL[indexPath.row])!)
        }
        return cell
    }
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        print("willDisplay cell \(indexPath.row + 1)")
    //        if let willDisplayCell = cell as? CustomTableViewCell {
    //            networkService.downloadImage(withURL: URL(string: imageURL[indexPath.row])!, forCell: willDisplayCell)
    //        }
    //    }
    //
    //    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        print("didEndDisplaying cell \(indexPath.row + 1)")
    //        //        guard let cell = cell as? CustomTableViewCell,
    //        //              cell.loadedImage.image != nil else { return }
    //        networkService.cancelTask(url: URL(string: imageURL[indexPath.row])!)
    //    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // fetch images from API for those rows that are being prefetched (near to visible area)
        print("prefetching row of \(indexPaths)")
        for indexPath in indexPaths {
            fetchImages(ofIndex: indexPath.row, withURL: URL(string: imageURL[indexPath.row])!)
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        // cancel the task of fetching images from API when user scroll away from them
        print("cancel prefetch row of \(indexPaths)")
        for indexPath in indexPaths {
            cancelFetchImages(ofIndex: indexPath.row, withURL: URL(string: imageURL[indexPath.row])!)
        }
    }
}

