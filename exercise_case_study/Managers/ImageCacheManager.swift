import Foundation
import UIKit

class ImageCacheManager {
    static var shared = ImageCacheManager()
    private init() { }
    
    private(set) var images: [String: UIImage] = [:]
    
    func cache(_ image: UIImage, for key: String) {
        images[key] = image
    }
    
    func clear() {
        images.removeAll()
    }
}
