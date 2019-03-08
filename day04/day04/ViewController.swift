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
    name: "Multithread"),
    VideoData.init(image: "https://cdn.intra.42.fr/video/video/756/Piscine_Swift-IOS_-_D03_-_02_-_Scrollview_sthumb_10.png",
    video: "https://cdn.intra.42.fr/video/video/756/Piscine_Swift-IOS_-_D03_-_02_-_Scrollview.mp4",
    name: "ScrollView"),
    VideoData.init(image: "https://cdn.intra.42.fr/video/video/734/Piscine_Swift-IOS_-_D03_-_00_-_Introduction_sthumb_10.png",
    video: "https://cdn.intra.42.fr/video/video/734/Piscine_Swift-IOS_-_D03_-_00_-_Introduction.mp4",
    name: "Introduction")]

class ViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    var images: [UIImage?] = Array<UIImage?>.init(repeating: nil, count: videosData.count)
    var document: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib.init(nibName: "VideoDataCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "VideoDataCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        var errors: [Error] = []
        self.document = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        print(self.document)
        for (index, videoData) in videosData.enumerated() {
            let fileLocation = self.document.appendingPathComponent(videoData.imageDocumentFileName)
            
            if FileManager.default.fileExists(atPath: fileLocation.path) {
                self.images[index] = UIImage.init(data: try! Data.init(contentsOf: fileLocation))
                self.collectionView.reloadItems(at: [IndexPath.init(row: index, section: 0)])
                continue
            }
            var request = URLRequest.init(url: URL.init(string: videoData.image)!)
            
            request.httpMethod = "GET"
            URLSession.shared.downloadTask(with: request, completionHandler: { url, reponse, error in
                if let error = error {
                    errors.append(error)
                }
                else if let url = url {
                    do {
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
        for (index, videoData) in videosData.enumerated() {
            let fileLocation = self.document.appendingPathComponent(videoData.videoDocumentFileName)
            let indexPath = IndexPath.init(row: index, section: 0)
            
            if FileManager.default.fileExists(atPath: fileLocation.path) {
                continue
            }
            var request = URLRequest.init(url: URL.init(string: videoData.video)!)
            
            request.httpMethod = "GET"
            let task = URLSession.shared.downloadTask(with: request, completionHandler: { url, reponse, error in
                if let error = error {
                    errors.append(error)
                }
                else if let url = url {
                    do {
                        try FileManager.default.moveItem(at: url, to: fileLocation)
                    }
                    catch { errors.append(error) }
                }
            })
            task.resume()
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
                                               name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    @objc func layoutChange() {
        let flow = UICollectionViewFlowLayout.init()
        let lenght = self.collectionView.bounds.width / 2 - 8
        
        flow.itemSize = .init(width: lenght, height: lenght)
        flow.minimumInteritemSpacing = 0
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

import AVFoundation
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? VideoDataCollectionViewCell {
            let path = self.document.appendingPathComponent(videosData[indexPath.row].videoDocumentFileName)
            
            if FileManager.default.fileExists(atPath: path.path), cell.player == nil { // || if fileExist
                cell.player = AVPlayerLayer.init()
                cell.player.player = AVPlayer.init(url: path)
                cell.player.videoGravity = .resize
                cell.player.frame = cell.imageView.bounds
                cell.imageView.layer.addSublayer(cell.player)
                cell.player.player?.play()
            }
            else if cell.player == nil {
                let alert = UIAlertController.init(title: "Erreur", message: videosData[indexPath.row].name + " n'est pas encore telecharger", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}







