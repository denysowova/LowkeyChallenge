//
//  PhotoListItem.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation

struct PhotoListItem: Identifiable {
    let id: Int
    let thumbnailURL: URL
    let url: URL
    let author: String
    let photo: Photo
}
