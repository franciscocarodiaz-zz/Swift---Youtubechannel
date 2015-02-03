//
//  APIHelper.swift
//  Emoiste
//
//  Created by Francisco Caro Diaz on 29/01/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import Foundation

class Manager {
    
    typealias ObjectHandler = (AnyObject! , Bool!) -> Void
    class func makeGet(method:String , completionHandler: ObjectHandler!)
    {
        var str:String = ""
        let path = PATH_YOUTUBE_API;
        let baseURL = NSURL(string: path)
        
        let manager = AFHTTPRequestOperationManager(baseURL: baseURL)
        let jsonResponseSerializer = AFJSONResponseSerializer()
        jsonResponseSerializer.stringEncoding = NSUTF8StringEncoding
        manager.responseSerializer = jsonResponseSerializer
        /*
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var youtubechannelid: String
        if (defaults.objectForKey(kYOUTUBE_ID) as String != "") {
            youtubechannelid = defaults.objectForKey(kYOUTUBE_ID) as String!
        }else{
            youtubechannelid = "UCpOz3CN6mDlxkE7-m5AS1aQ"
        }
        */
        
        var params = [
            REQ_YOUTUBE_MAX_RESULT : REQ_YOUTUBE_DEFAULT_MAX_RESULT,
            REQ_YOUTUBE_ORDERBY : REQ_YOUTUBE_DEFAULT_ORDERBY,
            REQ_YOUTUBE_AUTHOR : REQ_YOUTUBE_DEFAULT_ID,
            REQ_YOUTUBE_VERSION : REQ_YOUTUBE_DEFAULT_VERSION,
            REQ_YOUTUBE_TYPE_FILE : REQ_YOUTUBE_DEFAULT_TYPE_FILE,
        ]
        
        manager.GET(method,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                
                if (responseObject != nil) {
                    completionHandler(responseObject,false)
                } else {
                    str = "Error, responseObject is null"
                    completionHandler("Error",true)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                str = "Error: \(error.localizedDescription)"
                completionHandler("Error",true)
        })
    }
}