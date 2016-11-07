import Foundation
import UIKit

public class ZoomCollectionView : UIView, UIScrollViewDelegate {
    
    let collectionView: UICollectionView
    let scrollView: UIScrollView
    let dummyZoomView: UIView
    let layout: UICollectionViewLayout
    
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if let layout = self.layout as? ScalingLayoutProtocol {
            let size = layout.contentSizeForScale(scrollView.zoomScale)
            scrollView.contentSize = size
            dummyZoomView.frame = CGRect(origin: .zero, size: size)
        }
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return dummyZoomView
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.contentOffset = scrollView.contentOffset
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if let layout = self.layout as? ScalingLayoutProtocol {
            layout.setScale(scrollView.zoomScale)
        }
        
        layout.invalidateLayout()
        collectionView.contentOffset = scrollView.contentOffset
        collectionView.reloadData()
    }
    
}
