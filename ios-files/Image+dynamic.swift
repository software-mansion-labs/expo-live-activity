//
//  Image+dynamic.swift
//  
//
//  Created by Artur Bilski on 04/08/2025.
//
import SwiftUI

extension Image {
  static func dynamic(assetNameOrPath: String) -> Self {
    if let container = FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: "group.expoLiveActivity.sharedData"
    ) {
      let contentsOfFile = container.appendingPathComponent(assetNameOrPath).path

      if let uiImage = UIImage(contentsOfFile: contentsOfFile) {
        return Image(uiImage: uiImage)
      }
    }

    return Image(assetNameOrPath)
  }
}
