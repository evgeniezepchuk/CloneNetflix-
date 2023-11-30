//
//  YouTubeSearchResponse.swift
//  Netflix
//
//  Created by Евгений Езепчук on 19.10.23.
//

import Foundation

struct YouTubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IDVideoElement
}

struct IDVideoElement: Codable {
    let kind: String
    let videoId: String
}
