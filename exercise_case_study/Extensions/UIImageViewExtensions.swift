import Foundation
import UIKit

extension UIImageView {
    func setImage(for url: URL) {
        if let cachedImage = ImageCacheManager.shared.images[url.absoluteString] {
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
