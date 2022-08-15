//
//  RecentPhotosTableViewController.swift
//  FlickerClientApp
//
//  Created by Hasan Kaya on 20.07.2022.
//

import UIKit
import Alamofire
import Kingfisher
class RecentPhotosTableViewController: UITableViewController, UISearchResultsUpdating {
    private var choosenPhoto : PhotoElement?
    private var responseGeneral : Photo? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController()
        fetchRecentPhotos()
        
        
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.responseGeneral?.photos?.photo?.count ?? .zero
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = responseGeneral?.photos?.photo![indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell
        
        cell.ownerNameLabel.text = photo?.ownername!
        
        NetworkManager.shared.fetchImage(with: photo?.urlN) { data in
            cell.photoImageView.image = UIImage(data: data)
        }
        if let iconServer = photo?.iconserver ,
           let iconFarm = photo?.iconfarm,
           let nsid = photo?.owner,
           NSString(string: iconServer).intValue > 0{
            NetworkManager.shared.fetchImage(with: "http://farm\(iconFarm).staticflickr.com/\(iconServer)/buddyicons/\(nsid).jpg") { data in
                cell.ownerImageView.image = UIImage(data: data)
            }
        } else {
            NetworkManager.shared.fetchImage(with: "https://www.flickr.com/images/buddyicon.gif") { data in
                cell.ownerImageView.image = UIImage(data: data)
            }
        }
        
        cell.titleLabel.text = photo?.title
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.choosenPhoto = responseGeneral?.photos?.photo?[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? DetailViewController {
            viewController.photo = self.choosenPhoto
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 2 {
            searchPhotos(with: text)
        }
        if text.count == 0 {
            fetchRecentPhotos()
        }
        
    }
    private func searchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
    private func fetchRecentPhotos(){
        DispatchQueue.main.async {
            guard let url = URL(string:"https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=c81a8e91087f096660e69a62532a012b&format=json&nojsoncallback=1&extras=description,license,date_upload,date_taken,owner_name,icon_server,original_format,last_update,geo,tags,machine_tags,o_dims,views,media,path_alias,url_sq,url_t,url_s,url_q,url_m,url_n,url_z,url_c,url_l,url_o") else { return }
            let request  = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                if error == nil {
                    if let data = data {
                        let dataString = String(data: data, encoding: .utf8)
                        do {
                            let response = try JSONDecoder().decode(Photo.self, from: data)
                            self.responseGeneral = response
                        } catch {
                            
                        }
                    }
                }
                

            }.resume()
            
            
        }
    }
    private func searchPhotos(with text : String){
        guard let url = URL(string:"https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=c81a8e91087f096660e69a62532a012b&text=\(text)&format=json&nojsoncallback=1&extras=description,license,date_upload,date_taken,owner_name,icon_server,original_format,last_update,geo,tags,machine_tags,o_dims,views,media,path_alias,url_n,url_z") else { return }
        let request  = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            if let error = error {
                return
            }
            if let data = data , let response = try? JSONDecoder().decode(Photo.self, from: data){
                self.responseGeneral = response
            }
            
        }.resume()
            
        
        
    }
    
}

