import Foundation
import CoreGraphics

public protocol ScalingLayoutProtocol {
    func setScale(_ scale: CGFloat) -> Void
    func contentSizeForScale(_ scale: CGFloat) -> CGSize
}
