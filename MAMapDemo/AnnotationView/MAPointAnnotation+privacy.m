//
//  MAPointAnnotation+privacy.m
//  Etoury
//
//  Created by fmouer on 15/9/4.
//  Copyright (c) 2015年 Etoury. All rights reserved.
//

#import "MAPointAnnotation+privacy.h"
#import <objc/runtime.h>

void * annotationInfoKey = @"annotationInfoKey";
void * annotationCoordinateKey = @"annotationCoordinateKey" ;
void * annotationNumberKey = @"annotationNumberKey" ;
void * annotationOtherAnnotionKey = @"annotationOtherAnnotionKey" ;

@implementation MAPointAnnotation (privacy)

- (void)setAnnotationInfo:(NSDictionary *)annotationInfo
{
    objc_setAssociatedObject(self, annotationInfoKey,annotationInfo , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSDictionary *)annotationInfo
{
    NSDictionary * annotationInfo = objc_getAssociatedObject(self, annotationInfoKey);
    return annotationInfo;
}

-(void)setOtherAnnotationInfos:(NSMutableArray *)otherAnnotationInfos
{
    objc_setAssociatedObject(self, annotationOtherAnnotionKey,otherAnnotationInfos , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSMutableArray *)otherAnnotationInfos
{
    NSMutableArray * otherAnnotationInfos = objc_getAssociatedObject(self, annotationOtherAnnotionKey);
    if (otherAnnotationInfos == nil) {
        otherAnnotationInfos = [[NSMutableArray alloc] initWithCapacity:0];
        self.otherAnnotationInfos = otherAnnotationInfos;
    }
    return otherAnnotationInfos;
}

-(void)addOtherAnnotationInfo:(NSDictionary *)object
{
    if (![self.otherAnnotationInfos containsObject:object]) {
        [self.otherAnnotationInfos addObject:object];
    }
}
-(void)removeOtherAnnotationInfo:(NSDictionary *)object
{
    if ([self.otherAnnotationInfos containsObject:object]) {
        [self.otherAnnotationInfos removeObject:object];
    }
}
-(void)dealloc
{
    objc_removeAssociatedObjects(self);
}

-(void)setNewCoordinate2D:(CLLocationCoordinate2D)newCoordinate2D
{
    objc_setAssociatedObject(self, annotationCoordinateKey,[NSValue valueWithCGPoint:(CGPoint){newCoordinate2D.latitude,newCoordinate2D.longitude}] , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CLLocationCoordinate2D)newCoordinate2D
{
    NSValue * value = objc_getAssociatedObject(self, annotationCoordinateKey);
    NSLog(@"value is %@",value);
    if (value) {
        CGPoint point = [value CGPointValue];
        CLLocationCoordinate2D  coordinate = CLLocationCoordinate2DMake(point.x, point.y);
        return coordinate;
    }
    return CLLocationCoordinate2DMake(0, 0);
}

- (void)setNumberBadge:(NSInteger)numberBadge
{
    objc_setAssociatedObject(self, annotationNumberKey,[NSNumber numberWithInteger:numberBadge] , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSInteger)numberBadge
{
    NSNumber * numberBadge = objc_getAssociatedObject(self, annotationNumberKey);
    return [numberBadge integerValue];
}

@end
