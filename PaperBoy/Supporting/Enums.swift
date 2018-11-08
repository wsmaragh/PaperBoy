//
//  Enums.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/10/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation

enum NotificationNames: String {
    case toggleSideMenu
    case UIApplicationDidBecomeActiveNotification
}

enum StoryboardIDs: String {
    case containerToSideMenuVC
    case containerToMainTabBarVC
    case mainVCToArticleVC
    case mainVCToSearchVC
    case mainVCToFaveArticlesVC
    case searchVCToArticleVC
    case faveArticlesVCToArticleVC
    case articleVCToWebVC
    case radioVCToNowPlayingVC
    case embeddedAVPlayer
}
