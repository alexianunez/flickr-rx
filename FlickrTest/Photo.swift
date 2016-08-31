//
//  Photo.swift
//  FlickrTest
//
//  Created by Alexia Nunez on 8/30/16.
//  Copyright © 2016 Alexia Nunez. All rights reserved.
//

struct Photo {
    
    let ID: String
    let farmID: Int
    let serverID: String
    let secret: String
    let url: String
    let title: String
    
    init(ID: String, title: String, farmID: Int, serverID: String, secret: String) {
        
        self.ID = ID
        self.title = title
        self.farmID = farmID
        self.serverID = serverID
        self.secret = secret
        self.url = "https://farm\(self.farmID).staticflickr.com/\(self.serverID)/\(self.ID)_\(self.secret).jpg"
        
    }
    
}