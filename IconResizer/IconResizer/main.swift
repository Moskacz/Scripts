//
//  main.swift
//  IconResizer
//
//  Created by Michal Moskala on 24.10.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import Foundation
import Cocoa

extension NSImage {
    func resized(toSize size: NSSize) -> NSImage? {
        let rect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let representation = bestRepresentation(for: rect, context: nil, hints: nil) else {
            return nil
        }
        
        return NSImage(size: size, flipped: false, drawingHandler: { (_) -> Bool in
            return representation.draw(in: rect)
        })
    }
    
    func savePNG(toURL url: URL) throws {
        guard let pngData = pngRepresentation else {
            throw NSError(domain: "ImageResizer",
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "cannot create png representation"])
        }
        
        try pngData.write(to: url)
    }
    
    var pngRepresentation: Data? {
        guard let tiff = tiffRepresentation, let bitmap = NSBitmapImageRep(data: tiff) else { return nil }
        return bitmap.representation(using: .png, properties: [:])
    }
}


struct IconData {
    let size: NSSize
    let iconName: String
    
    init(size: NSSize, iconName: String) {
        self.size = size
        self.iconName = iconName
    }
    
    init(size: NSSize) {
        self.size = size
        self.iconName = "\(size.width)x\(size.height)"
    }
}

class IconDataFactory {
    static func getData() -> [IconData] {
        let sizes = [NSSize(width: 40, height: 40),
                     NSSize(width: 58, height: 58),
                     NSSize(width: 60, height: 60),
                     NSSize(width: 80, height: 80),
                     NSSize(width: 87, height: 87),
                     NSSize(width: 120, height: 120),
                     NSSize(width: 180, height: 180),
                     NSSize(width: 1024, height: 1024),
                     ]
        return sizes.map {
            return IconData(size: $0)
        }
    }
}

let arguments = CommandLine.arguments
if arguments.count < 2 {
    print("You need to pass path to icon")
} else {
    let path = arguments[1]
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: path) {
        let imagePath = URL(fileURLWithPath: path)
        let image = NSImage(byReferencing: imagePath)
        if image.isValid {
            let imagesData = IconDataFactory.getData()
            
            for imageData in imagesData {
                if let resizedImage = image.resized(toSize: imageData.size) {
                    let imageName = imageData.iconName.appending(".png")
                    let destinationPath = imagePath.deletingLastPathComponent().appendingPathComponent(imageName)
                    do {
                        try resizedImage.savePNG(toURL: destinationPath)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
            }
        } else {
            print("Not valid image")
        }
    } else {
        print("File doesn't exist at given path")
    }
}


