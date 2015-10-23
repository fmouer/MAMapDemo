//
//  PhotoCell.h
//  MAMapDemo
//
//  Created by ihotdo-fmouer on 15/10/22.
//  Copyright © 2015年 fmouer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell
{
    UIImageView     *   _imageView;
    UILabel         *   _indexLabel;
}
- (void)setImageName:(NSString *)imageName;

@property (nonatomic, assign)NSIndexPath * indexPath;
@end
