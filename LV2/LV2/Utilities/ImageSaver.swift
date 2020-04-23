//
//  ImageSaver.swift
//  LV2
//
//  Created by Zvonimir Pavlović on 22/04/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import Foundation
import UIKit

class ImageSaver {
    
    static let shared = ImageSaver()
    
    func saveImage(image: UIImage) -> String{
        let uuid = UUID().uuidString
        let fileManager = FileManager.default
        let imageName = "image"+uuid+".jpg"
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        if let imagePath = documentsPath?.appendingPathComponent(imageName){
            try! image.jpegData(compressionQuality: 0.0)?.write(to: imagePath)
            return imagePath.absoluteString
        }else{
            return "No name"
        }
    }
}
