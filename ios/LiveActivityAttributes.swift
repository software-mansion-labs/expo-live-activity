//
//  LiveActivityAttributes.swift
//  ExpoLiveActivity
//
//  Created by Anna Olak on 03/06/2025.
//

import Foundation
import ActivityKit

struct LiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var title: String
        var subtitle: String
        var date: Date
        var imageName: String
    }
    
    var name: String
}
