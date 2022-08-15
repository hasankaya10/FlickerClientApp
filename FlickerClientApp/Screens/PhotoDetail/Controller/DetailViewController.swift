//
//  DetailViewController.swift
//  FlickerClientApp
//
//  Created by Hasan Kaya on 20.07.2022.
//

import UIKit

class DetailViewController: UIViewController {
    var photo : PhotoElement?
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.fetchImage(with: photo?.urlZ) { data in
            self.imageView.image = UIImage(data: data)
        }
        if let iconServer = photo?.iconserver ,
           let iconFarm = photo?.iconfarm,
           let nsid = photo?.owner,
           NSString(string: iconServer).intValue > 0{
            NetworkManager.shared.fetchImage(with: "http://farm\(iconFarm).staticflickr.com/\(iconServer)/buddyicons/\(nsid).jpg") { data in
                self.ownerImageView.image = UIImage(data: data)
            }
        } else {
            NetworkManager.shared.fetchImage(with: "https://www.flickr.com/images/buddyicon.gif") { data in
                self.ownerImageView.image = UIImage(data: data)
            }
        }
        ownerNameLabel.text = photo?.ownername
        descriptionLabel.text = photo?.photoDescription?.content
        title = photo?.title
    }
    

  

}
