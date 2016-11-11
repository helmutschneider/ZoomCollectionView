import Foundation
import UIKit

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

public extension UICollectionView {
    
    // credit to http://stackoverflow.com/questions/17704527/uicollectionview-not-removing-old-cells-after-scroll
    func getLingeringCells() -> [UICollectionViewCell] {
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        
        return subviews
            .filter { ($0 as? UICollectionViewCell) != nil }
            .map { $0 as! UICollectionViewCell }
            .filter { visibleRect.intersects($0.frame) && !visibleCells.contains($0) }
    }
    
    func hideLingeringCells() {
        getLingeringCells().forEach { $0.isHidden = true }
    }
}
