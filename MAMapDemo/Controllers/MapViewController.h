//
//  MapViewController.h
//  MAMapDemo
//
//  Created by fmouer on 15/10/13.
//  Copyright © 2015年 fmouer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomAnnotationView;

@interface MapViewController : UIViewController

- (void)pushShowPhotoControllerWith:(CustomAnnotationView *)annotationView;

@end
