import Foundation
import UIKit

protocol ImageFileProtocol {
    var uiImage: UIImage { get }
    var size: Int { get }
    var format: ImageFormat { get }
}

enum ImageFormat: String, CaseIterable {
    case jpg = "jpg"
    case png = "png"
    case gif = "gif"
}