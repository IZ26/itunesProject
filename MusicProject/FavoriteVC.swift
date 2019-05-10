//
//  FavoriteVC.swift
//  MusicProject
//
//  Created by Ilan Zerdoun on 08/05/2019.
//  Copyright © 2019 Ilan Zerdoun. All rights reserved.
//

import UIKit

/*protocol UpdateSelected: class {
    func updateArray(array: Array<Int>)
}*/

class FavoriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var favoriteSong: [Album] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteSong.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! CustomCell
        
        let albumFav = favoriteSong[indexPath.row]
        
        cell.deleteFav.tag = indexPath.row
        
        cell.deleteFav.addTarget(self, action: #selector(deleteFav(sender:)) , for: .touchUpInside)
        
        
        
        cell.album.text = albumFav.albumName
        cell.artist.text = albumFav.artisteName
        cell.song.text = albumFav.titleName
        let urlImg = URL(string: albumFav.imageAlbum)
        let dataImg = try? Data(contentsOf: urlImg!)
        cell.imageAlbum.image = UIImage(data : dataImg!)
        
        return cell
    }

    @objc func deleteFav(sender:UIButton) {
        favoriteSong.remove(at: sender.tag)
        self.tableView.reloadData()
    }
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true)
    }
}
