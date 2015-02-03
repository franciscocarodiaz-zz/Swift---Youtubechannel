//
//  Util.swift
//  Emoiste
//
//  Created by Juan Manuel Hernandez del Olmo on 19/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import Foundation

class Util {
    
    class func showMessage(title: String, message: String) -> UIAlertController {
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        return alertController
        
    }
    
}
