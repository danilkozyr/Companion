import Foundation
import UIKit

// MARK: TODO: Handle imageURL = URL(string: friend.imageURL)!

class FriendViewStateFactory {

    // MARK: Internal Methods

    func make(from friend: Friend) -> FriendViewState {
        var image: UIImage?

        if let friendImage = friend.image, let imageFromData = UIImage(data: friendImage) {
            image = imageFromData
        }

        return FriendViewState(id: friend.id,
                               fullName: friend.name,
                               email: friend.email,
                               level: friend.level,
                               levelProgress: friend.levelProgress,
                               imageURL: nil,
                               image: image)
    }
}
