//
//  PhotoFlowLayout.m
//  MAMapDemo
//
//  Created by ihotdo-fmouer on 15/10/22.
//  Copyright © 2015年 fmouer. All rights reserved.
//

#import "PhotoFlowLayout.h"

#define ActionSpace 3
@interface PhotoFlowLayout ()
{
    
}
@property (nonatomic, assign)CGPoint centerPoint;
@end

@implementation PhotoFlowLayout

-(void)setToRect:(CGRect)toRect
{
    _toRect = toRect;
    _centerPoint = CGPointMake(CGRectGetMidX(_toRect), CGRectGetMidY(_toRect));
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = PhotoLineSpace;
        self.minimumInteritemSpacing = PhotoLineSpace;
        _centerPoint = CGPointMake(100, 100);
    }
    return self;
}
-(void)prepareLayout
{
    [super prepareLayout];
    _count = [[self collectionView] numberOfItemsInSection:0];
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}


-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < _count; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    if (_flowLayoutType == FlowLayoutTypeNormal) {
         return [super layoutAttributesForItemAtIndexPath:path];
    }
    
    if (_flowLayoutType == FlowLayoutTypeElastic) {
        UICollectionViewLayoutAttributes * temp = [super layoutAttributesForItemAtIndexPath:path];
        NSLog(@"center is %@",NSStringFromCGPoint(temp.center));
        CGPoint point = temp.center;
        if (point.x > _centerPoint.x) {
            point.x += ActionSpace;
        }else{
            point.x -= ActionSpace;
        }
        if (point.y > _centerPoint.y) {
            point.y += ActionSpace;
        }else{
            point.y -= ActionSpace;
        }
        temp.center =point;
        return temp;
    }
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    attributes.size = _toRect.size;
    attributes.center = _centerPoint;
    if (path.row == 9) {
        attributes.zIndex = _count;
    }else{
        attributes.zIndex = 0;
    }
    return attributes;
}
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = CGPointMake(100, 100);
    return attributes;
}
@end
