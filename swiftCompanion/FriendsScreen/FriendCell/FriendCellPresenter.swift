import Foundation
import UIKit

// MARK: TODO: Get from LocationModel the current place

protocol FriendCellPresenterDelegate {
    func showLastLocation(_ location: String)
}

class FriendCellPresenter {

    // MARK: Private properties

    private var delegate: FriendCellPresenterDelegate?

    // MARK: Internal methods

    func setDelegate(_ delegate: FriendCellPresenterDelegate) {
        self.delegate = delegate
    }

    func loadLastLocation(with id: Int) {
        FetcherService.getLocation(with: id).onSuccess { locations in
            guard let lastLocationEndDate = locations.first?.endAt else {
                return
            }

            guard let lastLocationDate = lastLocationEndDate.convertToDisplayViewFrom() else {
                return
            }

            self.delegate?.showLastLocation(Constants.Labels.lastOnline + lastLocationDate)
        }
    }

}
