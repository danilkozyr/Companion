import Foundation

extension String {
    func convertToDisplayViewFrom() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        dateFormatter.dateFormat = "MMM d, h:mm a"

        return dateFormatter.string(from: date)
    }
}
