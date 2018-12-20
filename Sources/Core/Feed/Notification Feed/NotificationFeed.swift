//
//  NotificationFeed.swift
//  GetStream-iOS
//
//  Created by Alexey Bukhtin on 20/12/2018.
//  Copyright © 2018 Stream.io Inc. All rights reserved.
//

import Foundation
import Result

public final class NotificationFeed: Feed {
    /// Receive a notification feed activities type of `Activity`.
    ///
    /// - Parameters:
    ///     - enrich: when using collections, you can request to enrich activities to include them.
    ///     - pagination: a pagination options.
    ///     - markOption: mark options to update feed notifications as read/seen.
    ///     - reactionsOptions: options to include reactions to activities. Check optionsin docs for `FeedReactionsOptions`
    ///     - completion: a completion handler with a notification group with the `Activity` type.
    /// - Returns:
    ///     - a cancellable object to cancel the request.
    @discardableResult
    public func get(enrich: Bool = true,
                    pagination: Pagination = .none,
                    markOption: FeedMarkOption = .none,
                    reactionsOptions: FeedReactionsOptions = [],
                    completion: @escaping GroupCompletion<Activity, NotificationGroup<Activity>>) -> Cancellable {
        return get(typeOf: Activity.self,
                   enrich: enrich,
                   pagination: pagination,
                   markOption: markOption,
                   reactionsOptions: reactionsOptions,
                   completion: completion)
    }
    
    /// Receive a notification feed activities with a custom activity type.
    ///
    /// - Parameters:
    ///     - typeOf: a type of activities that conformed to `ActivityProtocol`.
    ///     - enrich: when using collections, you can request to enrich activities to include them.
    ///     - pagination: a pagination options.
    ///     - markOption: mark options to update feed notifications as read/seen.
    ///     - reactionsOptions: options to include reactions to activities. Check optionsin docs for `FeedReactionsOptions`
    ///     - completion: a completion handler with a notification group with a custom activity type.
    /// - Returns:
    ///     - a cancellable object to cancel the request.
    @discardableResult
    public func get<T: ActivityProtocol>(typeOf: T.Type,
                                         enrich: Bool = true,
                                         pagination: Pagination = .none,
                                         markOption: FeedMarkOption = .none,
                                         reactionsOptions: FeedReactionsOptions = [],
                                         completion: @escaping GroupCompletion<T, NotificationGroup<T>>) -> Cancellable {
        return client.request(endpoint: FeedEndpoint.get(feedId, enrich, pagination, "", markOption, reactionsOptions)) {
            $0.parseGroup(completion)
        }
    }
}

// MARK: - Client Notification Feed

extension Client {
    /// Get a notification feed with a given feed group `feedSlug` and `userId`.
    public func notificationFeed(feedSlug: String, userId: String) -> NotificationFeed {
        return notificationFeed(FeedId(feedSlug: feedSlug, userId: userId))
    }
    
    /// Get a notification feed with a given feed group `feedSlug` for the current user if it specified in the Token.
    ///
    /// - Note: If the current user is nil in the Token, then the returned feed would be nil.
    ///
    /// - Parameters:
    ///     - feedSlug: a feed group name.
    public func notificationFeed(feedSlug: String) -> NotificationFeed? {
        guard let userId = currentUserId else {
            return nil
        }
        
        return notificationFeed(FeedId(feedSlug: feedSlug, userId: userId))
    }
    
    /// Get a notification feed with a given `feedId`.
    public func notificationFeed(_ feedId: FeedId) -> NotificationFeed {
        return NotificationFeed(feedId, client: self)
    }
}
