import Foundation
import CoreGraphics

public protocol ScalingLayoutProtocol {
    func getScale() -> CGFloat
    func setScale(_ scale: CGFloat) -> Void
    func contentSizeForScale(_ scale: CGFloat) -> CGSize
}
