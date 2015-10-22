//
//  PhotoFlowLayout.h
//  MAMapDemo
//
//  Created by ihotdo-fmouer on 15/10/22.
//  Copyright © 2015年 fmouer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PhotoLineSpace      (5.0)

typedef NS_ENUM (NSInteger , FlowLayoutType){
    FlowLayoutTypeNormal    ,
    FlowLayoutTypeElastic   ,
    FlowLayoutTypeCenter    ,
};

@interface PhotoFlowLayout : UICollectionViewFlowLayout
{
    NSInteger       _count;

}
@property (nonatomic, assign)FlowLayoutType flowLayoutType;

@property (nonatomic, assign)CGPoint centerPoint;

@end
