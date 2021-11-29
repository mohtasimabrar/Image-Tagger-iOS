//
//  Person.swift
//  Image Tagger
//
//  Created by Mohtasim Abrar Samin on 29/11/21.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.image = image
        self.name = name
    }
}
