import Foundation

extension String {
    var url: URL? {
        return URL(string: self)
    }
}
