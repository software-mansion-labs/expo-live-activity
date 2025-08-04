//
//  Data+download.swift
//  
//
//  Created by Artur Bilski on 04/08/2025.
//

extension Data {
  static func download(from url: URL) async throws -> Self {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
  }
}
