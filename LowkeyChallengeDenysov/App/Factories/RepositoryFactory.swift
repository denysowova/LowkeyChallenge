//
//  RepositoryFactory.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation

enum RepositoryFactory {
    static let photos: PhotosRepository = PhotosRepositoryImpl(dataSource: APIFactory.pexels)
}
