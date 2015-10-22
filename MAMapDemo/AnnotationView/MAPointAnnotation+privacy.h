//
//  MAPointAnnotation+privacy.h
//  Etoury
//
//  Created by fmouer on 15/9/4.
//  Copyright (c) 2015年 Etoury. All rights reserved.
//

/*
 RecordDir = "";
 RecordId = 0000;
 RecordText = "";
 RecordTime = "2015-09-04 13:36:43";
 RecordType = 3;
 point =             {
 X = "116.390808";
 Y = "39.913383";
 };
 }
 */

@interface MAPointAnnotation (privacy)

@property (nonatomic, readwrite)NSDictionary * annotationInfo;

@property (nonatomic, assign)CLLocationCoordinate2D  newCoordinate2D;

@property (nonatomic, assign)NSInteger  numberBadge;

@property (nonatomic, readwrite)NSMutableArray * otherAnnotationInfos;

- (void)addOtherAnnotationInfo:(NSDictionary *)object;
- (void)removeOtherAnnotationInfo:(NSDictionary *)object;

@end

