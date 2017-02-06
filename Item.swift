//
//  Item.swift
//  demo
//
//  Created by dusan vesic on 06/02/2017.
//  Copyright © 2017 dusan vesic. All rights reserved.
//

import Foundation

struct Item {
    var title: String
    var image: String
    var description: String
    
    init(title: String, image: String, description: String) {
        self.title = title
        self.image = image
        self.description = description
    }
}
