import Foundation

extension String {
    
    func transformToDate() -> Date {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = iso.date(from: self)
        return date!
    }
    
}
