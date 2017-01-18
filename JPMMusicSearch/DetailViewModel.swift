//
//  DetailViewModel.swift
//  JPMMusicSearch
//
//  Created by Larry on 1/8/17.
//  Copyright © 2017 Savings iOS Dev. All rights reserved.
//

import Foundation


protocol DetailViewModelDelegate: class {
    
    func imageDataDownloadDidFinished()
    func lyricsDownloadDidFinished()
}


final class DetailViewModel {
    
    weak var delegate: DetailViewModelDelegate?
    
    let artistName: String
    let trackName: String
    let albumName: String
    let artworkUrl: String
    let price: String
    let releaseDate: String
    let priceTitle: String
    
    
    private let track: Track
    private let dataSource: ITunesDataSource
    
    var imageData: Data? {
        didSet {
            if imageData != nil {
                print("Did set image data")
                delegate?.imageDataDownloadDidFinished()
            }
        }
    }
    
    var lyrics: String? {
        didSet {
            if lyrics != nil {
                print("Did set lyrics")
                delegate?.lyricsDownloadDidFinished()
            }
        }
    }

    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        
        return dateFormatter
    }()
    
    
    init(track: Track, dataSource: ITunesDataSource) {
        self.track = track
        self.dataSource = dataSource
        
        artistName = track.artistname
        albumName = track.albumName
        trackName = track.trackName
        artworkUrl = track.artworkUrl
        price = String(describing: track.price)
        releaseDate = dateFormatter.string(from: track.releaseDate)
        priceTitle = "Price (\(track.currency))"
        
        downloadImageData()
        downloadLyrics()
    }
    
    deinit {
        print("Deinitialized detail view model...")
    }
    
    // MARK: - Get image data for using in DetailView - return image data
    private func downloadImageData() {
        print("Downloading artwork with url: \(artworkUrl)")
        dataSource.downloadImage(from: artworkUrl, completion: { [weak self] data in
            if data != nil {
                self?.imageData = data
            }
        })
    }
    //MARK: - Download lyrics - return type : String
    private func downloadLyrics() {
        
        let lyricsURL = "http://lyrics.wikia.com/api.php?func=getSong&artist=\(artistName.replacingOccurrences(of: " ", with: "+",options: .literal, range: nil))&song=\(trackName.replacingOccurrences(of: " ", with: "+"))&fmt=xml"
        print("Downloading artwork with url: \(lyricsURL)")
        dataSource.downloadLyrics(from: lyricsURL, completion: { [weak self] aString in
            
            if aString != nil {
               self?.lyrics = aString
            }
        })
    }

    
}
