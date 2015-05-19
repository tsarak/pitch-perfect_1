//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Athanasios Sarakatsianou on 12/5/15.
//  Copyright (c) 2015 tsarakatsianou. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}