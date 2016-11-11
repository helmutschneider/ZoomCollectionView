import Foundation
import UIKit

open class ZoomCollectionView : UIView, UIScrollViewDelegate, UICollectionViewDelegate {
    
    open let collectionView: UICollectionView
    open let scrollView: UIScrollView
    open let dummyZoomView: UIView
    open let layout: UICollectionViewLayout
    
    public init(frame: CGRect, layout: UICollectionViewLayout) {
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        scrollView = UIScrollView(frame: frame)
        dummyZoomView = UIView(frame: .zero)
        
        self.layout = layout
        
        super.init(frame: frame)
        
        // remove gesture recognizers from the collection
        // view and use the scroll views built-in instead.
        collectionView.gestureRecognizers?.forEach { collectionView.removeGestureRecognizer($0) }
        
        scrollView.delegate = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        addSubview(scrollView)
        scrollView.addSubview(dummyZoomView)
        
        // bounce is currently not supported since the
        // animation does not call scrollViewDidZoom
        scrollView.bouncesZoom = false
        
        bringSubview(toFront: scrollView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if let layout = self.layout as? ScalingLayoutProtocol {
            let size = layout.contentSizeForScale(scrollView.zoomScale)
            scrollView.contentSize = size
            dummyZoomView.frame = CGRect(origin: .zero, size: size)
        }
    }
    
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return dummyZoomView
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.contentOffset = scrollView.contentOffset
        collectionView.hideLingeringCells()
    }
    
    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if let layout = self.layout as? ScalingLayoutProtocol, layout.getScale() != scrollView.zoomScale {
            layout.setScale(scrollView.zoomScale)
            self.layout.invalidateLayout()
            collectionView.contentOffset = scrollView.contentOffset
            collectionView.hideLingeringCells()
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // cells might have been hidden by hideLingeringCells() so we must un-hide them.
        cell.isHidden = false
    }
    
}
