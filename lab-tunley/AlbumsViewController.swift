//
//  AlbumsViewController.swift
//  lab-tunley
//
//  Created by Dante Ricketts on 9/16/23.
//

import UIKit

class AlbumsViewController: UIViewController {
    var albums: [Album] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                self?.albums = albums
                
            } catch {
                print("❌ Error parsing JSON: \(error.localizedDescription)")
            }
        }

        // Initiate the network request
        task.resume()
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
