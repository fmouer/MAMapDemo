//
//  MapRectObject.m
//  Etoury
//
//  Created by fmouer on 15/9/5.
//  Copyright (c) 2015年 Etoury. All rights reserved.
//

#import "MapRectObject.h"

@implementation MapRectObject

- (void)setRectForLocationCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (_topLeftCoordinate2D.latitude == 0) {
        _topLeftCoordinate2D = coordinate;
        _topRightCoordinate2D = coordinate;
        _bottomLeftCoordinate2D = coordinate;
        _bottomRightCoordinate2D = coordinate;
    }else{
        //latitude 纬度
        //左上角
        _topLeftCoordinate2D.latitude = MAX(coordinate.latitude, _topLeftCoordinate2D.latitude);
        _topLeftCoordinate2D.longitude = MIN(coordinate.longitude, _topLeftCoordinate2D.longitude);
        //右上角
        _topRightCoordinate2D.latitude = MAX(coordinate.latitude, _topRightCoordinate2D.latitude);
        _topRightCoordinate2D.longitude = MAX(coordinate.longitude, _topRightCoordinate2D.longitude);
        //左下角
        _bottomLeftCoordinate2D.latitude = MIN(coordinate.latitude, _bottomLeftCoordinate2D.latitude);
        _bottomLeftCoordinate2D.longitude = MIN(coordinate.longitude, _bottomLeftCoordinate2D.longitude);
        //右下角
        _bottomRightCoordinate2D.latitude = MIN(coordinate.latitude, _bottomRightCoordinate2D.latitude);
        _bottomRightCoordinate2D.longitude = MAX(coordinate.latitude, _bottomRightCoordinate2D.longitude);
        
    }
}

- (MAMapRect)getCoordinateFitInMAMapRect
{
    MAMapRect zoomRect = MAMapRectNull;
    
    for (int i = 0; i < 4; i ++) {
        CLLocationCoordinate2D coordinate = [self getCoordinateWith:i];
        MAMapPoint annotationPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude));
        MAMapRect pointRect = MAMapRectMake(annotationPoint.x, annotationPoint.y, 1, 1);
        if (MAMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MAMapRectUnion(zoomRect, pointRect);
        }
    }
    return zoomRect;
}

- (CLLocationCoordinate2D)getCoordinateWith:(int)index
{
    float distance = 0.005;
    if (index == 0) {
        return CLLocationCoordinate2DMake(_topLeftCoordinate2D.latitude + distance, _topLeftCoordinate2D.longitude - distance);
    }else if (index == 1){
        return CLLocationCoordinate2DMake(_topRightCoordinate2D.latitude + distance, _topRightCoordinate2D.longitude + distance);
    }else if (index == 2){
        return CLLocationCoordinate2DMake(_bottomLeftCoordinate2D.latitude -  distance, _bottomLeftCoordinate2D.longitude - distance);
    }else{
        return CLLocationCoordinate2DMake(_bottomRightCoordinate2D.latitude -  distance, _bottomRightCoordinate2D.longitude + distance);
    }
}
@end
