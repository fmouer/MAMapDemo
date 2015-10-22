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

#define SingleLineNumber    4


@interface PhotoBrowserViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView            *   _photoCollectionView;
    PhotoFlowLayout             *   _flowLayout;
    PhotoFlowLayout             *   _otherFlowLayout;
    PhotoFlowLayout             *   _centerFlowLayout;
    float       width;
}
@end

@implementation PhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    CGPoint point = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _flowLayout = [[PhotoFlowLayout alloc] init];
    
    width = (self.view.frame.size.width - _flowLayout.minimumLineSpacing)/SingleLineNumber - _flowLayout.minimumLineSpacing;
    _flowLayout.itemSize = CGSizeMake(width, width);
    
    _otherFlowLayout = [[PhotoFlowLayout alloc] init];
    _otherFlowLayout.itemSize = _flowLayout.itemSize;
    _otherFlowLayout.flowLayoutType = FlowLayoutTypeElastic;
    _otherFlowLayout.centerPoint = point;
    
    _centerFlowLayout = [[PhotoFlowLayout alloc] init];
    _centerFlowLayout.itemSize = _flowLayout.itemSize;
    _centerFlowLayout.flowLayoutType = FlowLayoutTypeCenter;
    _centerFlowLayout.centerPoint = point;
    
    _photoCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_flowLayout];
    _photoCollectionView.backgroundColor = [UIColor clearColor];
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    _photoCollectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_photoCollectionView];
    [_photoCollectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photoCell"];
    
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemEvent)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)rightButtonItemEvent
{
    __weak UICollectionView * wCollectionView = _photoCollectionView;

    if (_photoCollectionView.collectionViewLayout == _flowLayout) {
        [_photoCollectionView setCollectionViewLayout:_centerFlowLayout animated:YES completion:^(BOOL finished) {
//            [_photoCollectionView setCollectionViewLayout:_centerFlowLayout animated:YES ];
        }];
    }else{
        __weak PhotoFlowLayout * wLayout = _flowLayout;
        [_photoCollectionView setCollectionViewLayout:_otherFlowLayout animated:YES completion:^(BOOL finished) {
            [wCollectionView setCollectionViewLayout:wLayout animated:YES ];
        }];
    }
//    _flowLayout.allItemInternalPoint = !_flowLayout.allItemInternalPoint;
//    [_flowLayout invalidateLayout];


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
//    PhotoCell * cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.selected = NO;
//    cell.highlighted =YES;
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
