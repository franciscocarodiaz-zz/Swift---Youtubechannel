//
//  User.swift
//  Emoiste
//
//  Created by Juan Manuel Hernandez del Olmo on 16/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import Foundation
import UIKit

class YoutubeVideo {
    var id:AnyObject = "";
    var description:AnyObject = "";
    var updated:AnyObject = "";
    var duration:AnyObject = "";
    var title:AnyObject = "";
    var thumbnail:AnyObject = "";
    
    init(){}
    
    init(id:AnyObject, description:AnyObject, updated:AnyObject, duration:AnyObject, title:AnyObject, thumbnail:AnyObject){
        self.id = id
        self.description = description
        self.updated = updated
        self.duration = duration
        self.title=title
        self.thumbnail = thumbnail
    }
    
}