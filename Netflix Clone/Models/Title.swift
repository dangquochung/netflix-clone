//
//  Movie.swift
//  Netflix Clone
//
//  Created by Dang Hung on 28/01/2024.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}

/*
 adult = 0;
 "backdrop_path" = "/jXJxMcVoEuXzym3vFnjqDW4ifo6.jpg";
 "genre_ids" =             (
     28,
     12,
     14
 );
 id = 572802;
 "media_type" = movie;
 "original_language" = en;
 "original_title" = "Aquaman and the Lost Kingdom";
 overview = "Black Manta, still driven by the need to avenge his father's death and wielding the power of the mythic Black Trident, will stop at nothing to take Aquaman down once and for all. To defeat him, Aquaman must turn to his imprisoned brother Orm, the former King of Atlantis, to forge an unlikely alliance in order to save the world from irreversible destruction.";
 popularity = "5876.8";
 "poster_path" = "/7lTnXOy0iNtBAdRP3TZvaKJ77F6.jpg";
 "release_date" = "2023-12-20";
 title = "Aquaman and the Lost Kingdom";
 video = 0;
 "vote_average" = "6.9";
 "vote_count" = 937;
},
 */
