//
//  ViewController.swift
//  Miniyoutube
//
//  Created by Antoine Feuerstein on 02/03/2019.
//  Copyright © 2019 Antoine Feuerstein. All rights reserved.
//

import UIKit
import YoutubeKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    static var shared: ViewController!
    
    @IBOutlet var collectionView: UICollectionView!
    
    class VideoData: NSObject {
        var id: String
        var preview: String
        
        var channelTitle: String
        var channelId: String
        
        var title: String
        
        var viewsCount: String
        var likeCount: String
        var unlikeCount: String
        var duration: String
        
        var image: UIImage!
        var item: IndexPath
        
        init?(video: Video, item: IndexPath) {
            guard let stats = video.statistics, let snippet = video.snippet,
                let details = video.contentDetails, let preview = snippet.thumbnails.default.url else {
                return nil
            }
            
            self.item = item
            self.id = video.id
            self.preview = preview
            self.channelTitle = snippet.channelTitle
            self.channelId = snippet.channelID
            self.title = snippet.title
            self.viewsCount = stats.viewCount.numberWithSpace()
            self.likeCount = stats.likeCount
            self.unlikeCount = stats.dislikeCount
            let a = details.duration.replacingOccurrences(of: "PT", with: "")
            let b = a.replacingOccurrences(of: "M", with: ":")
            let c = b.replacingOccurrences(of: "S", with: "")
            
            self.duration = c
            super.init()
            if let imageUrl = URL.init(string: self.preview) {
                let request = URLRequest.init(url: imageUrl)
                
                URLSession.shared.downloadTask(with: request, completionHandler: { url, reponse, error in
                    if let path = url?.path, let image = UIImage.init(contentsOfFile: path) {
                        DispatchQueue.main.async {
                            self.image = image
                            ViewController.shared.collectionView.reloadItems(at: [self.item])
                        }
                    }
                }).resume()
            }
            else {
                print(self.preview)
            }
        }
    }
    
    var videos: [VideoData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.shared = self
        self.calculateFlow()
        self.collectionView.register(UINib.init(nibName: "VideoCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "VideoCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.calculateFlow),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)
        self.requestVideos()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
        
        if self.videos.count > indexPath.row {
            cell.fill(with: self.videos[indexPath.row])
        }
        return cell
    }
    
    @objc func calculateFlow() {
        let flow = UICollectionViewFlowLayout.init()
        let count: CGFloat = UIDevice.current.orientation == .portrait ? 2 : 4
        
        flow.itemSize = .init(width: self.collectionView.bounds.width / count - 8, height: 250)
        flow.minimumInteritemSpacing = 4
        flow.minimumLineSpacing = 4
        flow.sectionInset = .init(top: 4, left: 4, bottom: 4, right: 4)
        flow.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = flow
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height - scrollView.bounds.height
        
        if scrollView.contentOffset.y > contentHeight {
            self.requestVideos()
        }
    }
    
    var nextPageToken: String? = nil
    var nextPageLoading: Bool = false
    let nextPageCount: Int = 10
    func requestVideos() {
        if self.nextPageLoading {
            return
        }
        let request = VideoListRequest.init(part: [.id, .contentDetails, .statistics, .snippet],
                                            filter: .chart,
                                            maxResults: self.nextPageCount, onBehalfOfContentOwner: nil,
                                            pageToken: self.nextPageToken,
                                            regionCode: "fr", videoCategoryID: nil)
        var items: [IndexPath] = []
        
        self.nextPageLoading = true
        for i in 0..<self.nextPageCount {
            items.append(IndexPath.init(row: self.videos.count + i, section: 0))
        }
        ApiSession.shared.send(request, closure: { result in
            switch result {
            case .success(let reponse):
                self.nextPageToken = reponse.nextPageToken
                for (index, video) in reponse.items.enumerated() {
                    
                    if let newVideoData = VideoData.init(video: video,
                                                         item: items[index]) {
                        self.videos.append(newVideoData)
                    }
                }
                self.collectionView.insertItems(at: items)
                self.nextPageLoading = false
            default: break
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell, let v = cell.video {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController {
                vc.video = v
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
}

class VideoViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet var videoView: UIView!
    @IBOutlet var videoTitle: UILabel!
    
    @IBOutlet var likeVersusView: UIView!
    @IBOutlet var likeDislikeLabel: UILabel!
    
    @IBOutlet var viewsLabel: UILabel!
    
    @IBOutlet var views2Separator: UIView!
    
    @IBOutlet var channelTitle: UILabel!
    
    var video: ViewController.VideoData!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.likeVersusView.layer.cornerRadius = self.likeVersusView.bounds.height / 2
        self.likeVersusView.layer.masksToBounds = true
        self.views2Separator.layer.cornerRadius = self.views2Separator.bounds.height / 2
        let player = YTSwiftyPlayer.init(frame: self.videoView.bounds,
                                         playerVars: [.videoID(self.video.id), .autoplay(true),
                                                      .showControls(.show), .playsInline(true)])
        
        player.translatesAutoresizingMaskIntoConstraints = false
        self.videoView.addSubview(player)
        NSLayoutConstraint.init(item: player, attribute: .top, relatedBy: .equal, toItem: self.videoView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: player, attribute: .bottom, relatedBy: .equal, toItem: self.videoView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: player, attribute: .leading, relatedBy: .equal, toItem: self.videoView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: player, attribute: .trailing, relatedBy: .equal, toItem: self.videoView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        player.loadPlayer()
        let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(self.pinchReceive))
        
        self.view.addGestureRecognizer(pinch)
        
        self.videoTitle.text = video.title
        self.likeDislikeLabel.text = video.likeCount.numberWithSpace() + " likes vs " +
            video.unlikeCount.numberWithSpace() + " dislikes"
        let dislike = Int(video.unlikeCount)!
        let like = Int(video.likeCount)!
        let percent: CGFloat
        let gradient = CAGradientLayer.init()
        
        gradient.frame = self.likeVersusView.bounds
        gradient.colors = [UIColor.green.cgColor, UIColor.red.cgColor]
        gradient.startPoint = .init(x: 0, y: 0.5)
        gradient.endPoint = .init(x: 1, y: 0.5)
        if dislike > like {
            percent = CGFloat(dislike / like)
        }
        else if like > dislike {
            percent = CGFloat(like / dislike)
        }
        else {
            percent = 0.5
        }
        gradient.locations = [NSNumber.init(value: Float(percent))]
        self.likeVersusView.layer.addSublayer(gradient)
        self.viewsLabel.text = video.viewsCount.numberWithSpace() + " vues"
        self.channelTitle.text = video.channelTitle
        self.tableView.register(UINib.init(nibName: "CommentTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "CommentTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.requestComments()
    }
    
    @objc func pinchReceive() {
        self.dismiss(animated: true, completion: nil)
    }
    
    struct Comment {
        let author: String
        let comment: String
        let like: Int
        let dislike: Int
        
        init(comment: CommentThread) {
            self.author = comment.snippet.topLevelComment.snippet.authorDisplayName
            self.comment = comment.snippet.topLevelComment.snippet.textOriginal
            self.like = comment.snippet.topLevelComment.snippet.likeCount
            self.dislike = 0
        }
    }
    var commentsNextPageToken: String? = nil
    var commentsCount: Int = 20
    var comments: [Comment] = []
    var commentsRequesting: Bool = false
    func requestComments() {
        if self.commentsRequesting {
            return
        }
        let r = CommentThreadsListRequest.init(part: [.id, .snippet], filter: .videoID(video.id),
                                               maxResults: self.commentsCount, moderationStatus: nil,
                                               order: nil, pageToken: self.commentsNextPageToken,
                                               searchTerms: nil, textFormat: .plainText)
        var indexs: [IndexPath] = []
        
        self.commentsRequesting = true
        for i in 0..<self.commentsCount {
            indexs.append(IndexPath.init(row: self.comments.count + i, section: 0))
        }
        ApiSession.shared.send(r, closure: { result in
            switch result {
            case .success(let reponse):
                self.commentsNextPageToken = reponse.nextPageToken
                for item in reponse.items {
                    self.comments.append(Comment.init(comment: item))
                }
                self.tableView.insertRows(at: indexs, with: .automatic)
                self.commentsRequesting = false
            case .failed(let e): fatalError(e.localizedDescription)
            }
        })
    }
    
}

extension VideoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        let comment = self.comments[indexPath.row]
        
        cell.authorLabel.text = comment.author
        cell.commentLabel.text = comment.comment
        return cell
    }
    
}
