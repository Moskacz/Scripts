//
//  main.swift
//  IconResizer
//
//  Created by Michal Moskala on 24.10.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import Foundation
import Cocoa

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

struct IconDataFactory {
    static func getData() -> [IconData] {
        let sizes = [NSSize(width: 40, height: 40),
                     NSSize(width: 58, height: 58),
                     NSSize(width: 60, height: 60),
                     NSSize(width: 80, height: 80),
                     NSSize(width: 87, height: 87),
                     NSSize(width: 120, height: 120),
                     NSSize(width: 180, height: 180),
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
                let rect = NSRect(x: 0, y: 0, width: imageData.size.width, height: imageData.size.height)
                let resizedImg = NSImage(size: imageData.size)
                image.size = imageData.size
                resizedImg.lockFocus()
                NSGraphicsContext.current?.imageInterpolation = .high
                image.draw(at: .zero, from: rect, operation: .copy, fraction: 1)
                resizedImg.unlockFocus()
                if let imgData = resizedImg.tiffRepresentation {
                    if let bitmap = NSBitmapImageRep(data: imgData) {
                        let pngRepresentation = bitmap.representation(using: .png, properties: [:])
                        do {
                            let imageName = imageData.iconName.appending(".png")
                            let destinationPath = imagePath.deletingLastPathComponent().appendingPathComponent(imageName)
                            try pngRepresentation?.write(to: destinationPath, options: .atomic)
                        } catch {
                            print(error.localizedDescription)
                        }
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

