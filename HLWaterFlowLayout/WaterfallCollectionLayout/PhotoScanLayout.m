//
//  PhotoScanLayout.m
//  WaterfallCollectionLayout
//
//  Created by 黄露 on 2017/1/19.
//  Copyright © 2017年 tanhui. All rights reserved.
//

#import "PhotoScanLayout.h"

@implementation PhotoScanLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    //滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.itemSize = CGSizeMake(160, 160);
    
    CGFloat insert = (self.collectionView.frame.size.width - self.itemSize.width) / 2;
    
    //内边距
    self.sectionInset = UIEdgeInsetsMake(0, insert, 0, insert);
}

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用 layoutAttributesForElementsInRect:方法
 */
- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

/**
 * 返回的数组里面存放着rect范围内所有元素的布局属性
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 * 一个cell对应一个UICollectionViewLayoutAttributes对象
 */
- (NSArray <UICollectionViewLayoutAttributes *> *) layoutAttributesForElementsInRect:(CGRect)rect {
    
    //取出父类算出的布局属性
    NSArray *superAtts = [super layoutAttributesForElementsInRect:rect];
    
    //collectionView 的中心点X的值 + contentOff.x   ---- 为了计算cell 的显示大小
    CGFloat collectionView_center_x = self.collectionView.frame.size.width / 2 + self.collectionView.contentOffset.x;
    
    //将cell 遍历一遍，当cell 在屏幕中间时，显示最大，离屏幕越远，将cell 的transform.scale 变小
    for (int i = 0; i < superAtts.count; i ++) {
        
        UICollectionViewLayoutAttributes *attribute = superAtts[i];
        
        //cell 的中心点与collectionView 的contentSize 在屏幕上显示的中心点的间距
        CGFloat space = ABS(attribute.center.x - collectionView_center_x);
        CGFloat scale = 1 - space / self.collectionView.frame.size.width/2;
        attribute.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return superAtts;
}


/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 */
- (CGPoint) targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    //最终显示collectionView的矩形区域
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    //屏幕中心点的对应的collectionView的ContentSize 的X
    CGFloat center_x = self.collectionView.frame.size.width / 2 + self.collectionView.contentOffset.x;
    
    //计算每个cell 距离 center_x 的距离，并取最小值
    CGFloat space = CGFLOAT_MAX;
    //取出所有的布局属性
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    for (int i = 0 ; i < attributes.count ; i ++) {
        UICollectionViewLayoutAttributes *attribute = attributes[i];
        CGFloat temSpace = attribute.center.x - center_x;
        if (ABS(space) > ABS(temSpace)) {
            space = temSpace;
        }
    }
    
    proposedContentOffset.x += space;
    
    return proposedContentOffset;
}
@end
