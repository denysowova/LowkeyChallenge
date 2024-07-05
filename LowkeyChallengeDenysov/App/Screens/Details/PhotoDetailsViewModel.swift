//
//  PhotoDetailsViewModel.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 05.07.2024.
//

import Foundation
import Observation

@Observable
final class PhotoDetailsViewModel {
    
    private let getPhotoUseCase: GetPhotoUseCase
    private let id: Int
    
    private(set) var thumbnailURL: URL?
    private(set) var url: URL?
    
    init(getPhotoUseCase: GetPhotoUseCase, id: Int) {
        self.getPhotoUseCase = getPhotoUseCase
        self.id = id
    }
    
    func fetchPhoto() async {
        do {
            let photo = try await getPhotoUseCase.invoke(by: id)
            thumbnailURL = photo.thumbnailURL
            url = photo.url
        } catch {
            print("Error fetching photo: \(error.localizedDescription)")
        }
    }
}
