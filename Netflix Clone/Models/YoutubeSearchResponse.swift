//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Dang Hung on 31/01/2024.
//

import Foundation

/*
 items =     (
             {
         etag = "nokcGt9OrQ0QycurR_Z6fJV5eFQ";
         id =             {
             kind = "youtube#video";
             videoId = LbKIKjgfT90;
         };
         kind = "youtube#searchResult";
     },
 */

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
