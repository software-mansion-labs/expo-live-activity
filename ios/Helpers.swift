func resolveImage(from string: String) async throws -> String {
  if let url = URL(string: string), url.scheme?.hasPrefix("http") == true,
     let container = FileManager.default.containerURL(
       forSecurityApplicationGroupIdentifier: "group.expoLiveActivity.sharedData"
     )
  {
    let data = try await Data.download(from: url)
    let filename = UUID().uuidString + ".png"
    let fileURL = container.appendingPathComponent(filename)
    try data.write(to: fileURL)
    return fileURL.lastPathComponent
  } else {
    return string
  }
}
