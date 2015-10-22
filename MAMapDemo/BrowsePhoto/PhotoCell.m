//
//  PhotoCell.m
//  MAMapDemo
//
//  Created by ihotdo-fmouer on 15/10/22.
//  Copyright © 2015年 fmouer. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:_imageView];
        
        _indexLabel = [[UILabel alloc] initWithFrame:_imageView.frame];
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.textColor = [UIColor whiteColor];
        [self addSubview:_indexLabel];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:_imageView.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName
{
    _imageView.image = [UIImage imageNamed:imageName];
}

-(void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    _indexLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
//    float componet = selected?0.3:1;
//    [UIView animateWithDuration:0.2 animations:^{
//        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:componet];
//    }];
}

@end
