import Foundation
import UIKit

public class ZoomGridLayout : UICollectionViewLayout {
    
    let itemSize: CGSize
    let columns: CGFloat
    let itemSpacing: CGFloat
    var scale: CGFloat
    
    private var attributes: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = .zero
    
    init(itemSize: CGSize, columns: CGFloat, itemSpacing: CGFloat, scale: CGFloat = 1.0) {
        self.itemSize = itemSize
        self.columns = columns
        self.itemSpacing = itemSpacing
        self.scale = scale
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    func contentSizeForZoomScale(scale: CGFloat) -> CGSize {
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        let rowCount = ceil(CGFloat(itemCount)/CGFloat(columns))
        let sz = CGSize(
            width: itemSize.width * columns + itemSpacing * (columns - 1),
            height: itemSize.height * rowCount + itemSpacing * (rowCount - 1)
        )
        return sz.scale(scale)
    }
    
    func contentOffsetDeltaForCenter(center: CGPoint, fromScale: CGFloat, toScale: CGFloat) -> CGPoint {
        let defaultSize = contentSizeForZoomScale(scale: fromScale)
        let contentSize = contentSizeForZoomScale(scale: toScale)
        let xd = contentSize.width - defaultSize.width
        let yd = contentSize.height - defaultSize.height
        let offset = CGPoint(x: xd * center.x, y: yd * center.y)
        return offset
    }
    
    override public func prepare() {
        super.prepare()
        self.contentSize = contentSizeForZoomScale(scale: self.scale)
        let itemCount = self.collectionView!.numberOfItems(inSection: 0)
        let chunks = [Int]((0..<itemCount)).chunks(size: Int(self.columns))
        let rowIndices = chunks.indices
        let attrs: [[UICollectionViewLayoutAttributes]] = rowIndices.map { rowIdx in
            let chunk = chunks[rowIdx]
            let columnIndices = chunk.indices
            let rowAttributes: [UICollectionViewLayoutAttributes] = columnIndices.map { columnIdx in
                let pt = CGPoint(
                    x: (itemSize.width + itemSpacing) * CGFloat(columnIdx),
                    y: (itemSize.height + itemSpacing) * CGFloat(rowIdx)
                )
                let rect = CGRect(origin: pt, size: self.itemSize)
                let num = chunk[columnIdx]
                let attr = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: num, section: 0))
                attr.frame = rect.scale(self.scale)
                return attr
            }
            return rowAttributes
        }
        
        attributes = attrs.flatMap { $0 }
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes.filter { $0.frame.intersects(rect) }
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes.first { $0.indexPath == indexPath }
    }
    
}
