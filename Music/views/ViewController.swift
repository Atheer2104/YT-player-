//
//  ViewController.swift
//  Music
//
//  Created by Atheer on 2018-06-05.
//  Copyright © 2018 Atheer. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
    let vc = videoViewController()
    let cellId = "cellId"
    var videos = [item]()
    var search: String?
    var videoId: String?
    var videosTitle: String?
    var videosChannelTitle: String?
    var isPlayerNotDismissed = true
    var videosIDArray: [String] = []
    var videosTitlesArray: [String] = []
    var videosChannelTitlesArray: [String] = []
    
    //nil for know but later we wvar to bring the player view
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.tintColor = .white
        tableView.register(customCell.self, forCellReuseIdentifier: cellId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])
        
        tableView.backgroundColor = .darkGray

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("the statment i'm looking for", isPlayerNotDismissed)
        
        if isPlayerNotDismissed {
            
            navigationItem.title = "Search"
            navigationController?.navigationBar.prefersLargeTitles = true
            
            //setup searchController
            searchController.searchResultsUpdater = self
            // placeholder for seachbar
            searchController.searchBar.placeholder = "Search song"
            searchController.searchBar.tintColor = .white
            searchController.searchBar.delegate = self
            
            //asagin the searchController to navbar
            navigationItem.searchController = searchController
            // the seachbar disappears even if it's active
            definesPresentationContext = true
            navigationItem.searchController?.searchBar.isHidden = false
            
            navigationItem.rightBarButtonItem = nil
            
        } else {
            
            navigationItem.title = "now Playing"
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.searchController?.searchBar.isHidden = true
            navigationItem.searchController = nil
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDoneShowingList))
            
            isPlayerNotDismissed = !isPlayerNotDismissed
            
        }
        super.viewWillAppear(animated)
    }
    
    @objc func handleDoneShowingList() {
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
        struct Video: Decodable {
            let items: [item]

        }

        struct item: Decodable {
            let snippet: snippet
            let id: ID
            
        }
    
        struct ID: Decodable {
            let videoId: String
        }
    
        struct snippet: Decodable {
            let title: String
            let description: String
            let channelTitle: String
            let thumbnails: thumbnails

        }

        struct thumbnails: Decodable {
            var `default`: defal
        }

        struct defal: Decodable {
            var url: String
        }
    
    //checks is we have typed or not
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        fetchJSON()
        searchController.isActive = true
        guard let searchText = search else {return}
        searchBar.text = searchText
        searchBar.setImage(UIImage(), for: .clear, state: .normal)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        guard let searchText = search else {return}
        searchBar.text = searchText
        searchBar.setImage(UIImage(), for: .clear, state: .normal)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setImage(nil, for: .clear, state: .normal)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }
    
    
    fileprivate func fetchJSON() {
        // json parsing we get inside the aray that contains etag and that kind of stuff then there is a dictionary called snippet we get in that and get the valubel information, inside snippet is also thumbnails which is divied in default, medium, high we want default so we retrive it's data
        
        // the url string
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q=\(search!)&regionCode=SE&type=video&key=AIzaSyCX4vo7OpYOOYKTYn5qkn1E6Lu7t4hZvNY"
        
        
        
        //check so url is not nil
        guard let url = URL(string: urlString) else { return }
        
        // we begin a data task make sure the data is not nil and setup the decoder it can throw an error so we catch it if that happens
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.sync {
                if let error = error {
                    print("Failed to get data from url:", error)
                }
                
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(Video.self, from: data)
                    self.videos = data.items
                    self.tableView.reloadData()
                
//                    print(self.videos)
                
                    
                } catch let err {
                    print("err", err)
                }
                
            }
            
        }.resume()
        
    }
    
    // return how many cells there should be according to how many videos there is
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! customCell
        
        // url for thumbnail
        let thumbnailUrl = videos[indexPath.row].snippet.thumbnails.default.url
        
//        print(thumbnailUrl)
        
        cell.mainImageView.loadImageUsingUrlString(urlString: thumbnailUrl)
        cell.title = videos[indexPath.row].snippet.title
        cell.descriptionVideo = videos[indexPath.row].snippet.description
        cell.videosID = videos[indexPath.row].id.videoId
        cell.channelTitle = videos[indexPath.row].snippet.channelTitle
        
        var VideosId = String()
        VideosId = cell.videosID!
        videosIDArray.append(VideosId)
        
        var videosTitle = String()
        videosTitle = cell.title!
        videosTitlesArray.append(videosTitle)
        
        var videosChannelTitle = String()
        videosChannelTitle = cell.channelTitle!
        videosChannelTitlesArray.append(videosChannelTitle)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    // heigt for each cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // we get refrence to each
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        videoId = videos[indexPath.row].id.videoId
        videosTitle = videos[indexPath.row].snippet.title
        videosChannelTitle = videos[indexPath.row].snippet.channelTitle
        
        vc.videoTitle = videosTitle
        vc.videoID = videoId
        vc.videoChannelTitle = videosChannelTitle
        vc.videosID = videosIDArray
        vc.videosTitles = videosTitlesArray
        vc.videosChannelTitle = videosChannelTitlesArray
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

//protocol to define methods to update results based on what you search
extension ViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if !searchBarIsEmpty() {
        guard let scope = searchBar.text else { return }
        search = scope
        
        print(search)
        
        }
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
