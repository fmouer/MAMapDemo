//
//  MapRectObject.h
//  Etoury
//
//  Created by fmouer on 15/9/5.
//  Copyright (c) 2015年 Etoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAGeometry.h>

@interface MapRectObject : NSObject
{
    CLLocationCoordinate2D    _topLeftCoordinate2D;
    CLLocationCoordinate2D    _topRightCoordinate2D;
    
    CLLocationCoordinate2D    _bottomLeftCoordinate2D;
    CLLocationCoordinate2D    _bottomRightCoordinate2D;
}

- (void)setRectForLocationCoordinate:(CLLocationCoordinate2D)coordinate;

- (MAMapRect)getCoordinateFitInMAMapRect;

@end
