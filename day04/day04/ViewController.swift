//
//  ViewController.swift
//  day04
//
//  Created by Antoine Feuerstein on 03/03/2019.
//  Copyright © 2019 Antoine Feuerstein. All rights reserved.
//

import UIKit

struct VideoData {
    let image: String
    let video: String
    let name: String
    
    var imageDocumentFileName: String {
        return self.name + ".png"
    }
    var videoDocumentFileName: String {
        return self.name + ".mp4"
    }
}

fileprivate let videosData: [VideoData] = [
    VideoData.init(image: "https://cdn.intra.42.fr/video/video/755/Piscine_Swift-IOS_-_D03_-_01_-_Multithread_sthumb_10.png",
    video: "https://cdn.intra.42.fr/video/video/755/Piscine_Swift-IOS_-_D03_-_01_-_Multithread.mp4",
    name: "Multithread")]

class ViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    var images: [UIImage?] = Array<UIImage?>.init(repeating: nil, count: videosData.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib.init(nibName: "VideoDataCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "VideoDataCollectionViewCell")
        self.collectionView.dataSource = self
        var errors: [Error] = []
        let document = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        print(document)
        for (index, videoData) in videosData.enumerated() {
            var request = URLRequest.init(url: URL.init(string: videoData.image)!)
            
            request.httpMethod = "GET"
            URLSession.shared.downloadTask(with: request, completionHandler: { url, reponse, error in
                if let error = error {
                    errors.append(error)
                }
                else if let url = url {
                    do {
                        let fileLocation = document.appendingPathComponent(videoData.imageDocumentFileName)
                        
                        try FileManager.default.moveItem(at: url, to: fileLocation)
                        DispatchQueue.main.async {
                            if let image = UIImage.init(data: try! Data.init(contentsOf: fileLocation)) {
                                self.images[index] = image
                                self.collectionView.reloadItems(at: [IndexPath.init(row: index, section: 0)])
                            }
                        }
                    }
                    catch { errors.append(error) }
                }
            }).resume()
        }
        if errors.count > 0 {
            func showError() {
                let error = errors.popLast()!
                let alert = UIAlertController.init(title: "Error", message: error.localizedDescription,
                                                   preferredStyle: .alert)
                
                alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: {
                    if errors.count > 0 {
                        showError()
                    }
                })
            }
            showError()
        }
        self.layoutChange()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.layoutChange),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    @objc func layoutChange() {
        let flow = UICollectionViewFlowLayout.init()
        
        flow.itemSize = .init(width: self.collectionView.bounds.width / 2 - 12,
                              height: self.collectionView.bounds.height / 2 - 12)
        flow.minimumInteritemSpacing = 4
        flow.minimumLineSpacing = 4
        flow.sectionInset = .init(top: 4, left: 4, bottom: 4, right: 4)
        self.collectionView.collectionViewLayout = flow
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videosData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoDataCollectionViewCell",
                                                      for: indexPath) as! VideoDataCollectionViewCell
        
        cell.titleLabel.text = videosData[indexPath.row].name
        if let image = self.images[indexPath.row] {
            cell.imageView.image = image
        }
        return cell
    }
    
}

