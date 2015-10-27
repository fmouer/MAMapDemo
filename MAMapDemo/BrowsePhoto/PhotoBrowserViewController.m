//
//  PhotoBrowserViewController.m
//  MAMapDemo
//
//  Created by ihotdo-fmouer on 15/10/22.
//  Copyright © 2015年 fmouer. All rights reserved.
//

#import "PhotoBrowserViewController.h"
#import "PhotoCell.h"
#import "PhotoFlowLayout.h"
#import "MapViewController.h"
#import "FadeBackControllerTransitioning.h"

#define SingleLineNumber    4


@interface PhotoBrowserViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>
{
    UICollectionView            *   _photoCollectionView;
    PhotoFlowLayout             *   _flowLayout;
    PhotoFlowLayout             *   _otherFlowLayout;
    PhotoFlowLayout             *   _centerFlowLayout;
    float       width;
}
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@end

@implementation PhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    
     /*
     *设置三个PhotoFlowLayout，为了切换时有过渡效果。
     *仅通过一个改变相应位置不会有过渡效果。
     */
    _flowLayout = [[PhotoFlowLayout alloc] init];
    
    /*
     根据view的宽度和一行显示个数计算item的宽度
     */
    width = (self.view.frame.size.width - _flowLayout.minimumLineSpacing)/SingleLineNumber - _flowLayout.minimumLineSpacing;
    _flowLayout.itemSize = CGSizeMake(width, width);
    
    _otherFlowLayout = [[PhotoFlowLayout alloc] init];
    _otherFlowLayout.itemSize = _flowLayout.itemSize;
    _otherFlowLayout.flowLayoutType = FlowLayoutTypeElastic;
    _otherFlowLayout.toRect = _fromRect;
    
    _centerFlowLayout = [[PhotoFlowLayout alloc] init];
    _centerFlowLayout.itemSize = _flowLayout.itemSize;
    _centerFlowLayout.flowLayoutType = FlowLayoutTypeCenter;
    _centerFlowLayout.toRect = _fromRect;
    
    CGRect rect = self.view.bounds;
    rect.size.height -= 64;
    _photoCollectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:_centerFlowLayout];
    _photoCollectionView.backgroundColor = [UIColor clearColor];
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    _photoCollectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_photoCollectionView];
    [_photoCollectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photoCell"];
    
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemEvent)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
    popRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:popRecognizer];
}

- (void)rightButtonItemEvent
{
    __weak UICollectionView * wCollectionView = _photoCollectionView;
    /*
     *单独改变 collectionViewLayout 相关属性不会有动画效果
     *需要 setCollectionViewLayout:animated:方法设置新的collectionViewLayout才有过渡效果
     */
    if (_photoCollectionView.collectionViewLayout == _flowLayout) {
        [_photoCollectionView setCollectionViewLayout:_centerFlowLayout animated:YES completion:nil];
        /*
         *必须设置contentOffset为原点才会是最初展示的位置
         */
        [_photoCollectionView setContentOffset:CGPointZero animated:NO];
    }else{
        __weak PhotoFlowLayout * wLayout = _flowLayout;
        /*
         *先设置弹性（远一点）位置，在设置正常位置
         */
        [_photoCollectionView setCollectionViewLayout:_otherFlowLayout animated:YES completion:^(BOOL finished) {
            [wCollectionView setCollectionViewLayout:wLayout animated:YES ];
        }];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell   * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    [cell setImageName:@"location_0"];
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(PhotoLineSpace, PhotoLineSpace, PhotoLineSpace, PhotoLineSpace);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
    [self rightButtonItemEvent];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController.delegate != self) {
        self.navigationController.delegate = self;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [PublicObject dispatchQueueDelayTime:0.01 block:^{
        [self rightButtonItemEvent];
    }];
}

#pragma mark UINavigationControllerDelegate methods
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // Check if we're transitioning from this view controller to a DSLSecondViewController
    if (fromVC == self && [toVC isKindOfClass:[MapViewController class]]) {
        return [[FadeBackControllerTransitioning alloc] init];
    }
    else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    // Check if this is for our custom transition
    if ([animationController isKindOfClass:[FadeBackControllerTransitioning class]]) {
        return self.interactivePopTransition;
    }
    else {
        return nil;
    }
}

- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // Create a interactive transition and pop the view controller
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Update the interactive transition's progress
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        if (progress > 0.5) {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }
    
}


/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return CGSizeMake(width, width);collectionView: shouldSelectItemAtIndexPath
    }else{
        return CGSizeMake(width*1.2,width*1.2);
    }
}*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
