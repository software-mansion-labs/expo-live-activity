extension Data {
  static func download(from url: URL) async throws -> Self {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
  }
}
