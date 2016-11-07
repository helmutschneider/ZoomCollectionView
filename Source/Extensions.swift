import Foundation
import CoreGraphics

public extension CGSize {
    func scale(_ factor: CGFloat) -> CGSize {
        let transform = CGAffineTransform(scaleX: factor, y: factor)
        return self.applying(transform)
    }
}

public extension CGRect {
    func scale(_ factor: CGFloat) -> CGRect {
        let transform = CGAffineTransform(scaleX: factor, y: factor)
        return self.applying(transform)
    }
}

public extension Array {
    func chunks(size: Int) -> [[Element]] {
        let chunkCount = Int(ceil(Double(self.count)/Double(size)))
        return (0..<chunkCount).map { num in
            let start = num * size
            let end = Swift.min((num+1) * size, self.count - 1)
            let chunk = self[start...end]
            return [Element](chunk)
        }
    }
}
