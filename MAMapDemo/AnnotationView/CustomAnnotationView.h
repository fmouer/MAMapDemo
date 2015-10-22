//
//  CustomAnnotationView.h
//  Etoury
//
//  Created by fmouer on 15/9/4.
//  Copyright (c) 2015年 Etoury. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CustomAnnotationView : MAAnnotationView
{
    UILabel     * _numberBadgeLabel;
}
@property (nonatomic, strong)UILabel    * label;

@property (nonatomic, strong)NSString * annotationID;

@property (nonatomic, assign)NSInteger  numberBadge;

@property (nonatomic, strong)NSMutableArray * otherAnnotationInfos;

-(void)removeOtherAnnotationInfo:(NSDictionary *)object;

-(void)addOtherAnnotationInfo:(NSDictionary *)object;

@end
