//
//  PostsVC.swift
//  Omicron
//
//  Created by Jason Picallos on 6/13/17.
//  Copyright © 2017 Greek APP. All rights reserved.
//

import UIKit


class PostsVC: UITableViewController {
    
    var posts = [Posts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       getPosts()
    }
    
   
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell", for: indexPath)as? PostsCell else {return UITableViewCell()}
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    fileprivate func getPosts() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let url = URL(string:redditURL) else {return}
            URLSession.shared.dataTask(with:url , completionHandler: { (data, response, error) in
                guard error == nil else {
                    print("Error in GET \(error!.localizedDescription)")
                    return}
                guard let data = data else {return}
                let rawJSON = try? JSONSerialization.jsonObject(with: data)
                guard let json = rawJSON as? [String:Any] else {return}
                
                // GET INSIDE JSON NODES
                if let parentData = json["data"] as? [String:Any] {
                    if let childrenNode = parentData["children"] as? [[String:Any]] {
                        childrenNode.forEach({ (key) in
                            if let childData = key["data"]as? [String:Any] {
                                guard let post = Posts(json: childData) else {return}
                                self?.posts.append(post)
                            }
                        })
                        DispatchQueue.main.async { [weak self] in
                            self?.tableView.reloadData()
                        }
                    }
                }
            }).resume()
        }
    }
}
