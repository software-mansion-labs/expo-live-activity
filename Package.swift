// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "ExpoLiveActivity",
  platforms: [.iOS(.v16)],
  products: [.library(name: "ExpoLiveActivity", targets: ["ExpoLiveActivity"])],
  targets: [.target(name: "ExpoLiveActivity", path: "ios-files")]
)
