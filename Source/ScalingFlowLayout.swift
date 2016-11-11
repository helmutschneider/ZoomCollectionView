//
//  ScalingFlowLayout.swift
//  ZoomCollectionView
//
//  Created by Johan Björk on 2016-11-11.
//  Copyright © 2016 Johan Björk. All rights reserved.
//

import Foundation
import UIKit

class ScalingFlowLayout : UICollectionViewFlowLayout, ScalingLayoutProtocol {
    
    private var scale: CGFloat
    
    override var collectionViewContentSize: CGSize {
        return super.collectionViewContentSize.scale(scale)
    }
    
    init(initialScale: CGFloat) {
        self.scale = initialScale
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func scaleLayoutAttribute(_ attr: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let copied = attr.copy() as! UICollectionViewLayoutAttributes
        copied.frame = copied.frame.scale(scale)
        return copied
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let downscaledRect = rect.scale(1/scale)
        let downscaledAttributes = super.layoutAttributesForElements(in: downscaledRect)
        return downscaledAttributes?.map(scaleLayoutAttribute)
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItem(at: indexPath).map(scaleLayoutAttribute)
    }
    
    open func getScale() -> CGFloat {
        return scale
    }
    
    open func setScale(_ scale: CGFloat) {
        self.scale = scale
    }
    
    open func contentSizeForScale(_ scale: CGFloat) -> CGSize {
        return collectionViewContentSize.scale(scale/self.scale)
    }
    
}
