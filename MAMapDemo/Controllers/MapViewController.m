//
//  MapViewController.m
//  MAMapDemo
//
//  Created by fmouer on 15/10/13.
//  Copyright © 2015年 fmouer. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "MapRectObject.h"
#import "MAPointAnnotation+privacy.h"
#import "CustomAnnotationView.h"
#import "FadeShowControllerTransitioning.h"
#import "PhotoBrowserViewController.h"

@interface MapViewController ()<MAMapViewDelegate,UINavigationControllerDelegate>
{
    MAMapView   * _mapView;
}
@property (nonatomic, strong)NSArray * contentPoints;

@property (nonatomic, strong)NSMutableDictionary * removeAnnotationFromCoordinate;
@end

@implementation MapViewController
-(void)viewWillDisappear:(BOOL)animated
{
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController.delegate != self) {
        self.navigationController.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.contentPoints = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"points" ofType:@"plist"]];
    _removeAnnotationFromCoordinate = [[NSMutableDictionary alloc] initWithCapacity:0];
    // Do any additional setup after loading the view.
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemEvent)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [self performSelector:@selector(loadAnnotation) withObject:nil afterDelay:1];

}

- (void)rightButtonItemEvent
{
    [_mapView removeAnnotations:[_mapView annotations]];
    [self loadAnnotation];
}

- (void)loadAnnotation
{
    if (_contentPoints.count) {
        MapRectObject * mapRectObject = [[MapRectObject alloc] init];
        
        for (NSDictionary * pointInfo in _contentPoints) {
            [mapRectObject setRectForLocationCoordinate:[self getCoordinate2DWithInfo:pointInfo]];
        }
        //获取地图显示的区域
        MAMapRect zoomRect = [mapRectObject getCoordinateFitInMAMapRect];
        [_mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
    }
}

- (void)reloadAnnotation
{
    NSMutableArray * removeAnnotation = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray * annotations = _mapView.annotations;
    
    for (int i = 0; i < _contentPoints.count; i ++) {
        NSDictionary * pointInfo = [_contentPoints objectAtIndex:i];
        if ([removeAnnotation containsObject:pointInfo]) {
            continue;
        }
        NSInteger   numberBadge = 1;
        
        CLLocationCoordinate2D  coordinate = [self getCoordinate2DWithInfo:pointInfo];
        MAPointAnnotation * pointAnnotation = [self getFilterAnnotationViewWith:[pointInfo objectForKey:@"id"]  from:annotations];
        if (pointAnnotation == nil) {
            //生成地图的大头针
            pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.annotationInfo = pointInfo;
            NSValue * value = [_removeAnnotationFromCoordinate objectForKey:[pointInfo objectForKey:@"id"]];
            if (value) {
                pointAnnotation.newCoordinate2D = [self getCoordinate2DWithInfo:pointInfo];
                
                pointAnnotation.coordinate = [self getCoordinateWithValue:value];
                [_removeAnnotationFromCoordinate removeObjectForKey:[pointInfo objectForKey:@"id"]];
            }else{
                pointAnnotation.coordinate = [self getCoordinate2DWithInfo:pointInfo];
            }
            [_mapView addAnnotation:pointAnnotation];
        }
        
        CustomAnnotationView * annotationView = (CustomAnnotationView *)[_mapView viewForAnnotation:pointAnnotation];

        CGPoint point = [_mapView convertCoordinate:coordinate toPointToView:self.view];
        NSLog(@"point is %@",NSStringFromCGPoint(point));
        
        for (int j = i+1; j < _contentPoints.count; j ++) {
            NSDictionary * otherPointInfo = [_contentPoints objectAtIndex:j];
            CGPoint otherPoint = [_mapView convertCoordinate:[self getCoordinate2DWithInfo:otherPointInfo] toPointToView:self.view];
            NSLog(@"otherPoint is %@",NSStringFromCGPoint(otherPoint));
            BOOL isOverlay = [self IntersectFrom:point with:otherPoint];
            NSLog(@"i is %d , j is %d ,distance is %d",i,j,isOverlay);
            if (isOverlay) {
                numberBadge ++;
                [removeAnnotation addObject:otherPointInfo];
                [annotationView addOtherAnnotationInfo:otherPointInfo];
                [_removeAnnotationFromCoordinate setObject:[self getVauleWithCoordinate:coordinate] forKey:[otherPointInfo objectForKey:@"id"]];
                MAPointAnnotation * otherPointAnnotation = [self getFilterAnnotationViewWith:[otherPointInfo objectForKey:@"id"] from:annotations];
                if (otherPointAnnotation) {
                    [UIView animateWithDuration:0.2 animations:^{
                        [otherPointAnnotation setCoordinate:coordinate];
                    } completion:^(BOOL finished) {
                        [_mapView removeAnnotation:otherPointAnnotation];
                    }];
                }
            }else{
                [annotationView removeOtherAnnotationInfo:otherPointInfo];
            }
        }
        annotationView.numberBadge = numberBadge;
        
    }
}

- (CLLocationCoordinate2D)getCoordinate2DWithInfo:(NSDictionary *)pointInfo
{
    double latitude = [[pointInfo objectForKey:@"latitude"] doubleValue];
    double longitude = [[pointInfo objectForKey:@"longitude"] doubleValue];
    return CLLocationCoordinate2DMake(latitude, longitude);
}
///判断两个annotationView 是否有重叠
- (BOOL)IntersectFrom:(CGPoint)point1 with:(CGPoint)point2
{
    //单个annotationView 的 Frame
    CGRect rect1 = [self getAnnotationViewWith:point1];
    CGRect rect2 = [self getAnnotationViewWith:point2];
    if (CGRectIntersectsRect(rect1, rect2)) {
        return YES;
    }
    return NO;
}

#pragma mark CLLocationCoordinate2D 转换  NSValue
- (NSValue *)getVauleWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    return [NSValue valueWithCGPoint:(CGPoint){coordinate.latitude,coordinate.longitude}];
}

#pragma mark NSValue 转换 CLLocationCoordinate2D
- (CLLocationCoordinate2D)getCoordinateWithValue:(NSValue *)value
{
    CGPoint point = [value CGPointValue];
    return CLLocationCoordinate2DMake(point.x, point.y);
}

#pragma mark 根据ID筛选 MAPointAnnotation
- (MAPointAnnotation *)getFilterAnnotationViewWith:(NSString *)annotationID from:(NSArray *)annotations
{
    for (MAPointAnnotation * annotation in annotations) {
        NSString * ID = [annotation.annotationInfo objectForKey:@"id"];
        if ([ID integerValue] == [annotationID integerValue]) {
            return annotation;
        }
    }
    return nil;
}


#pragma mark 生成MAAnnotationView
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        MAPointAnnotation * pointAnnotation = (MAPointAnnotation *)annotation;
        
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
            annotationView.mapController = self;
            
        }
        NSDictionary * pointInfo = pointAnnotation.annotationInfo;
        annotationView.label.text = [NSString stringWithFormat:@"%lu",(unsigned long)[_contentPoints indexOfObject:pointInfo]];
        
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"location_0"]];
        annotationView.image = image;
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        annotationView.numberBadge = pointAnnotation.numberBadge;

        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        if (pointAnnotation.newCoordinate2D.latitude) {
            annotationView.alpha = 0;
            [PublicObject dispatchQueueDelayTime:0.1 block:^{
                [UIView animateWithDuration:0.2 animations:^{
                    [pointAnnotation setCoordinate:pointAnnotation.newCoordinate2D];
                    annotationView.alpha = 1.0;
                }];
                pointAnnotation.newCoordinate2D = CLLocationCoordinate2DMake(0, 0);
            }];
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"%s",__func__);
    [self reloadAnnotation];
}

- (CGRect)getAnnotationViewWith:(CGPoint)point
{
    float width = 67;
    return CGRectMake(point.x - width/2, point.y - width/2,  width,width);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)pushShowPhotoControllerWith:(CustomAnnotationView *)annotationView
{
    PhotoBrowserViewController * browserViewController = [[PhotoBrowserViewController alloc] init];
    browserViewController.fromRect = annotationView.frame;
    [self.navigationController pushViewController:browserViewController animated:YES];
}

#pragma mark UINavigationControllerDelegate methods
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // Check if we're transitioning from this view controller to a
    if (fromVC == self) {
        return [[FadeShowControllerTransitioning alloc] init];
    }
    else {
        return nil;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
