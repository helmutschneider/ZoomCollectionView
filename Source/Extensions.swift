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

public extension UICollectionView {
    
    // credit to http://stackoverflow.com/questions/17704527/uicollectionview-not-removing-old-cells-after-scroll
    func getLingeringCells() -> [UICollectionViewCell] {
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let visibleCells: [UIView] = self.visibleCells
        
        return subviews.filter { view in
            view is UICollectionViewCell &&
            visibleRect.intersects(view.frame) &&
            !visibleCells.contains(view)
        } as! [UICollectionViewCell]
    }
    
    func hideLingeringCells() {
        getLingeringCells().forEach { $0.isHidden = true }
    }
}
