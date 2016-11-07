import Foundation
import UIKit

func easeOut(x: CGFloat, k0: CGFloat, easeTarget: CGFloat) -> CGFloat {
    return easeTarget - easeTarget/(k0*x/easeTarget + 1)
}

public class ZoomCollectionView : UICollectionView, UIGestureRecognizerDelegate {

    private var pinchScaleStart: CGFloat = 0.0
    private var pinchDistanceStart: CGFloat = 0.0
    var maxScale: CGFloat = 2.0
    var minScale: CGFloat = 1.0
    
    let layout: ZoomGridLayout
    
    init(frame: CGRect, layout: ZoomGridLayout) {
        self.layout = layout
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        // UICollectionView inherits from UIScrollView (which it probably should not)
        // but does not have a built-in pinch recognizer. fix that.
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchGesture))
        pinch.delegate = self
        self.addGestureRecognizer(pinch)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handlePinchGesture(recognizer: UIPinchGestureRecognizer) {
        let locationInView = recognizer.location(in: self)
        let t1 = recognizer.location(ofTouch: 0, in: nil)
        let t2 = recognizer.location(ofTouch: 1, in: nil)
        let pinchDistance = t1.distance(t2)
        
        //print(t1, t2)
        
        switch recognizer.state {
        case .began:
            self.pinchScaleStart = layout.scale
            self.pinchDistanceStart = pinchDistance
        case .changed:
            var scale = self.pinchScaleStart * recognizer.scale
            
            if scale > maxScale {
                let pinchDelta = pinchDistance - pinchDistanceStart
                let k = (scale - pinchScaleStart) / (pinchDelta)
                let linearX = (maxScale - pinchScaleStart) / k
                let easeX = pinchDelta - linearX
                scale = maxScale + easeOut(x: easeX, k0: k, easeTarget: 1.0)
            }
            else if scale < minScale {
                let pinchDelta = pinchDistance - pinchDistanceStart
                let k = (scale - pinchScaleStart) / (pinchDelta)
                let linearX = (minScale - pinchScaleStart) / k
                let easeX = pinchDelta - linearX
                scale = minScale - easeOut(x: abs(easeX), k0: k, easeTarget: 0.2)
            }
            
            
            
            let size = self.contentSize
            let center = CGPoint(x: locationInView.x/size.width, y: locationInView.y/size.height)
            let offsetDelta = layout.contentOffsetDeltaForCenter(
                center: center,
                fromScale: layout.scale,
                toScale: scale
            )
            layout.scale = scale
            layout.invalidateLayout()
            
            // if we don't call reloadData leftover cells can be
            // seen flying around the viewport. this is caused by
            // us resizing the content size which in turn causes
            // UICollectionView to lose track of which cells are visible.
            self.reloadData()
            
            // update the offset so pinch zooming works as expected.
            self.contentOffset = self.contentOffset.add(offsetDelta)
            self.collectionViewDidZoom(scale: scale)
        default:
            break
        }
    }
    
    func collectionViewDidZoom(scale: CGFloat) {
        // override to act on zoom changes
    }
    
}
