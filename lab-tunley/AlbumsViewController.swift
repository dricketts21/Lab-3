//
//  AlbumsViewController.swift
//  lab-tunley
//
//  Created by Dante Ricketts on 9/16/23.
//

import UIKit
import Nuke

class AlbumsViewController: UIViewController, UICollectionViewDataSource {
    
    
    var albums: [Album] = []
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        // Create a search URL for fetching albums (`entity=album`)
        let url = URL(string: "https://itunes.apple.com/search?term=yeat&attribute=artistTerm&entity=album&media=music")!
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in

            // Handle any errors
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
            }

            // Make sure we have data
            guard let data = data else {
                print("❌ Data is nil")
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(AlbumSearchResponse.self, from: data)
                let albums = response.results
                DispatchQueue.main.async {
                    self?.albums = albums
                    self?.collectionView.reloadData()
                }
                
                
            } catch {
                print("❌ Error parsing JSON: \(error.localizedDescription)")
            }
        }

        // Initiate the network request
        task.resume()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        let numberOfColumns: CGFloat = 3
        let width = (collectionView.bounds.width - layout.minimumInteritemSpacing * (numberOfColumns - 1)) / numberOfColumns
        layout.itemSize = CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        let album = albums[indexPath.item]
        let imageUrl = album.artworkUrl100
        Nuke.loadImage(with: imageUrl, into: cell.albumImageView)
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
