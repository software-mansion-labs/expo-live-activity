//
//  ViewHelpers.swift
//  
//
//  Created by Artur Bilski on 04/08/2025.
//
import SwiftUI

func resizableImage(imageName: String) -> some View {
  Image.dynamic(assetNameOrPath: imageName)
    .resizable()
    .scaledToFit()
}
