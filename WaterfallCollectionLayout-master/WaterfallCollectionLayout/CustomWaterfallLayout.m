//
//  CustomWaterfallLayout.m
//  WaterfallCollectionLayout
//
//  Created by 黄露 on 2017/1/19.
//  Copyright © 2017年 tanhui. All rights reserved.
//

#import "CustomWaterfallLayout.h"

#define COL_MARGIN (5)
#define COL_COUNT  (4)
#define ROW_MARGIN (5)

@interface CustomWaterfallLayout ()

//存放每列的总高度
@property (nonatomic ,strong) NSMutableArray * col_heights;

//单元格的宽度
@property (nonatomic ,assign) CGFloat col_width;

@end

@implementation CustomWaterfallLayout

#pragma mark - setter 
- (CGFloat) col_width {
    if (!_col_width) {
        _col_width = (self.collectionView.bounds.size.width - (COL_COUNT + 1) * COL_MARGIN ) / COL_COUNT;
    }
    
    return _col_width;
}

- (NSMutableArray *)col_heights {
    if (!_col_heights) {
        _col_heights = [NSMutableArray array];
        for (int i = 0; i < COL_COUNT; i ++) {
            [_col_heights addObject:@0];
        }
    }
    
    return _col_heights;
}

#pragma mark - 
- (void)prepareLayout {
    [super prepareLayout];
    
    self.col_heights = nil;
}

//
- (CGSize) collectionViewContentSize {
    NSNumber * longest = self.col_heights[0];
    
    for (int i = 0; i < self.col_heights.count; i ++) {
        if ([longest floatValue] < [self.col_heights[i] floatValue]) {
            longest = self.col_heights[i];
        }
    }
    
    return CGSizeMake(self.collectionView.frame.size.width, [longest floatValue]);
}

- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //初始化一个attribute
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //假定一个高度最小值
    NSNumber *shortest = self.col_heights[0];
    
    //获取高度最小的列
    //假定高度最小的列为第一列
    NSInteger shortest_h_col = 0;
    for (int i = 0 ; i < self.col_heights.count; i ++) {
        NSNumber * rowheight = self.col_heights[i];
        if ([shortest floatValue] > [rowheight floatValue]) {
            //取出列高度最小的列
            shortest = rowheight;
            shortest_h_col = i;
        }
    }
    
    //取出高度最小的列后 ，给cell 指定位置
    CGFloat x = ( shortest_h_col + 1 ) * COL_MARGIN + self.col_width * shortest_h_col;
    CGFloat y = ROW_MARGIN + [shortest floatValue];
    
    //给cell 一个高度值
    CGFloat cell_height = arc4random() % 40 + 40;
    attributes.frame = CGRectMake(x, y, self.col_width, cell_height);
    
    self.col_heights[shortest_h_col] = @([shortest floatValue] + ROW_MARGIN + cell_height);

    return attributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *mutalArr = [NSMutableArray array];
    
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < items; i ++) {
        UICollectionViewLayoutAttributes *att = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        [mutalArr addObject:att];
    }
    
    return mutalArr;
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

@end
