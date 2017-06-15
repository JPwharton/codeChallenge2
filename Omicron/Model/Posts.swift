//
//  Posts.swift
//  Omicron
//
//  Created by Jason Picallos on 6/13/17.
//  Copyright © 2017 Greek APP. All rights reserved.
//

import Foundation


struct jsonKey {
    static let title = "title"
    static let subReddit = "subreddit"
    static let imgURL = "thumbnail"
    static let over18 = "over_18"
    static let time = "created_utc"
    static let votes = "ups"
    static let postURL = "url"
}


struct Posts {
    
    var title:String
    var time: Double
    var imgURL: String
    var votes: Int
    var subReddit: String
    var postURL : String
    var over18 : Bool
    
    init?(json:[String:Any]) {
        
        guard let title = json[jsonKey.title],
        let subReddit = json[jsonKey.subReddit],
        let imgURL = json[jsonKey.imgURL],
        let over18 = json[jsonKey.over18],
        let time = json[jsonKey.time],
        let votes = json[jsonKey.votes],
        let postURL = json[jsonKey.postURL]
        else {return nil}
        
        
        self.title = title as? String ?? ""
        self.imgURL = imgURL as? String ?? ""
        self.votes = votes as? Int ?? 0
        self.subReddit = subReddit as? String ?? ""
        self.postURL = postURL as? String ?? ""
        self.over18 = over18 as? Bool ?? false
        self.time = time as? Double ?? 0.00
        
        
    }
}


