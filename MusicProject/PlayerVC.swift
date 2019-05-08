//
//  PlayerVC.swift
//  MusicProject
//
//  Created by Ilan Zerdoun on 11/04/2019.
//  Copyright © 2019 Ilan Zerdoun. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerVC: UIViewController {
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var moviePlayer:MPMoviePlayerController!
    
    var titleSong = ""
    var imageAlbum = ""
    var artisteName = ""
    var albumName = ""
    var previewUrlSong = ""
    var kind = ""
    
    @IBOutlet weak var imageAlbumLAbel: UIImageView!
    @IBOutlet weak var titleSongLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if kind == "song"{
            titleSongLabel.text = titleSong
            albumNameLabel.text = albumName
            artistNameLabel.text = artisteName
            
            let urlImg = URL(string: imageAlbum)
            let dataImg = try? Data(contentsOf: urlImg!)
            
            imageAlbumLAbel.image = UIImage(data: dataImg!)
            
            let url = URL(string: previewUrlSong)
            let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            player?.play()
            
        }else{
            let urlVideo:NSURL = NSURL(string: previewUrlSong)!
            
            moviePlayer = MPMoviePlayerController(contentURL: urlVideo as URL)
            moviePlayer.view.frame = CGRect(x: 10, y: 300, width: 350, height: 250)
            
            self.view.addSubview(moviePlayer.view)
            moviePlayer.isFullscreen = true
            
            moviePlayer.controlStyle = MPMovieControlStyle.embedded
        }
        }
    }



    



