//
//  ExampleActivity.swift
//  GetStreamExample
//
//  Created by Alexey Bukhtin on 12/11/2018.
//  Copyright © 2018 Alexey Bukhtin. All rights reserved.
//

import Foundation
import GetStream

final class Tweet: Activity {
    private enum CodingKeys: String, CodingKey {
        case tweet
    }
    
    var tweet: String?
    
    init(actor: String, tweet: String, foreignId: String? = UUID().uuidString, time: Date? = nil) {
        super.init(actor: actor, verb: "tweet", object: String(arc4random_uniform(100)), foreignId: foreignId, time: time)
        self.tweet = tweet
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tweet = try container.decodeIfPresent(String.self, forKey: .tweet)
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(tweet, forKey: .tweet)
        try super.encode(to: encoder)
    }
    
    override var description: String {
        return super.description.appending(" tweet: \(tweet ?? "<no value>")")
    }
}