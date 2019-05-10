//
//  ViewController.swift
//  MusicProject
//
//  Created by Ilan Zerdoun on 04/04/2019.
//  Copyright © 2019 Ilan Zerdoun. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    
    var albums:[Album] = []
    
    var favAlbum:[Album] = []
    
    var selected = [Int]()
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var artistSearch: UITextField!
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        artistSearch.returnKeyType = UIReturnKeyType.search
        artistSearch.delegate = self
        initData(artistName:"Drake")
    }
    
    func checkInputSize(){
        let newString = artistSearch.text!.replacingOccurrences(of: " ", with: "-")
        if newString.count < 2 {
            let alert = UIAlertController(title: "Pas de résultat", message: "Veuillez saisir 2 caractères minimun",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            initData(artistName: newString)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.checkInputSize()
        textField.resignFirstResponder()
        return true;
    }

    func initData(artistName:String){
        albums.removeAll(keepingCapacity: true)
        
        let loader = UIActivityIndicatorView(style: .gray)
        self.view.addSubview(loader)
        loader.center = CGPoint(x: self.view.frame.size.width*0.5, y: self.view.frame.size.height*0.5)
        loader.startAnimating()
        
        tableView.isHidden = true
        
        Alamofire.request("https://itunes.apple.com/search?term=\(artistName)",method: .get, encoding: URLEncoding.default).responseJSON{ response in
            if let json = response.result.value {
                let data = JSON(json)
                
                
                if data["results"].isEmpty{
                    let alertNoResultat = UIAlertController(title: "Pas de résultat", message: "Il n'y a pas de résultat à votre recherche",preferredStyle: .alert)
                    alertNoResultat.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alertNoResultat, animated: true, completion: nil)
                    loader.stopAnimating()
                    loader.removeFromSuperview()
                }
                
                for i in 0..<data["results"].count{
                    let dataSong = Album()
                    
                    dataSong.artisteName = "\(data["results"][i]["artistName"].stringValue)"
                    dataSong.titleName   = "\(data["results"][i]["trackName"].stringValue)"
                    dataSong.albumName   = "\(data["results"][i]["collectionName"].stringValue)"
                    dataSong.imageAlbum  = "\(data["results"][i]["artworkUrl100"].stringValue)"
                    dataSong.previewUrl  = "\(data["results"][i]["previewUrl"].stringValue)"
                    dataSong.kindUrl     = "\(data["results"][i]["kind"].stringValue)"
                    dataSong.titleId     = "\(data["results"][i]["trackId"].stringValue)"
                    
                    self.albums.append(dataSong)
                }
            }
            DispatchQueue.main.async {
                loader.stopAnimating()
                loader.removeFromSuperview()
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumDetails", for: indexPath ) as! CustomCell
        
        
        cell.favoritesButton.tag = indexPath.row
        cell.favoritesButton.addTarget(self, action: #selector(addFav(sender:)) , for: .touchUpInside)
        
        cell.favoritesButton.isSelected = false
        
        for i in selected{
            print(i)
            if i == cell.favoritesButton.tag{
                cell.favoritesButton.isSelected = true
            }
        }
        
        
        let album = albums[indexPath.row]
        
        cell.album.text = album.albumName
        cell.artist.text = album.artisteName
        cell.song.text = album.titleName
        let urlImg = URL(string: album.imageAlbum)
        let dataImg = try? Data(contentsOf: urlImg!)
        cell.imageAlbum.image = UIImage(data : dataImg!)
        
        return cell
    }

    
    
    
    @objc func addFav(sender:UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            var favIndex = 0

            for favoris in favAlbum{
                if favoris.titleId == albums[sender.tag].titleId {
                    break
                }
                favIndex += 1
            }
            favAlbum.remove(at: favIndex)
            self.selected.remove(at: favIndex)
        }
        else {
            sender.isSelected = true
            favAlbum.append(albums[sender.tag])
            if !self.selected.contains(sender.tag){
                self.selected.append(sender.tag)
            }
        }
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        performSegue(withIdentifier: "listenSong", sender: self)
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listenSong"{
            let playerC = segue.destination as! PlayerVC
            
            playerC.imageAlbum = self.albums[self.index].imageAlbum
            playerC.titleSong = self.albums[self.index].titleName
            playerC.artisteName = self.albums[self.index].artisteName
            playerC.albumName = self.albums[self.index].albumName
            playerC.previewUrlSong = self.albums[self.index].previewUrl
            playerC.kind = self.albums[self.index].kindUrl
        }
        else if segue.identifier == "showFavorites" {
            let favoritesVC = segue.destination as! FavoriteVC
            favoritesVC.favoriteSong = favAlbum
        }
    }
}
