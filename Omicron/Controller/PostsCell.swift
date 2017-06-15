//
//  PostsCell.swift
//  Omicron
//
//  Created by Jason Picallos on 6/13/17.
//  Copyright © 2017 Greek APP. All rights reserved.
//

import UIKit

class PostsCell: UITableViewCell {
    
    
    
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberOfVotesLbl: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    private var imageCache = [String:UIImage]()
    
    // Prevent innapropriate key words
    private var flagWord = "fuck"
    
    var post: Posts? {
        didSet {
            
            guard let title = post?.title else {return}
            guard let subReddit = post?.subReddit else {return}
            guard let over18 = post?.over18 else {return}
            guard let votes = post?.votes else {return}
            guard let time = post?.time else {return}
            
            // String of URL
            guard let imgString = post?.imgURL else {return}
            
            
            // URL
            guard let imgURL = URL(string: imgString) else {return}
            
            // Prevent posts that are innapropriate
            guard over18 != true else {return}
            
            
            // flag word
            let wordCheck = title.components(separatedBy: " ")
            guard !wordCheck.contains(flagWord.capitalized) else {return}
            
            
            
            // Cache if image already downloaded
            if let cachedImage = imageCache[imgString]{
                self.avaImage.image = cachedImage
                titleLabel.text = "\(title)/\(subReddit)"
                numberOfVotesLbl.text = String("\(votes) votes")
                dateLabel.text = convertDate(dateDoube: time)
                return
            }
            
            
            // Call get Image
            getImage(imgURL: imgURL)
            
            
            // Assign values to view
            titleLabel.text = "\(title)/\(subReddit)"
            numberOfVotesLbl.text = String("\(votes) votes")
            dateLabel.text = convertDate(dateDoube: time)
            
        }
    }
    
    // Get images
    fileprivate func getImage(imgURL:URL) {
        
        // Set nil everytime prior to load
        avaImage.image = nil
        
        // Request image loading in background
        DispatchQueue.global(qos: .userInteractive).async {[weak self] in
            URLSession.shared.dataTask(with: imgURL) { (data, response, error) in
                if error != nil {
                    print("Failed loading image \(error!.localizedDescription)")
                } else {
                    if let data = data {
                        guard  let image = UIImage(data: data) else {return}
                        self?.imageCache[imgURL.absoluteString] = image
                        DispatchQueue.main.async {
                            self?.avaImage.image = image
                        }
                    }
                }
            }.resume()
        }
    }
    
    // Convert from UTC to readable date
    fileprivate func convertDate(dateDoube:Double)->String {
        let dateFormatter = DateFormatter()
        let theDate = Date(timeIntervalSince1970: dateDoube)
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: theDate)
    }
}


