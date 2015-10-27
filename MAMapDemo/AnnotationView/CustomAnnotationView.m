//
//  CustomAnnotationView.m
//  Etoury
//
//  Created by fmouer on 15/9/4.
//  Copyright (c) 2015年 Etoury. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "MapViewController.h"

@interface CustomAnnotationView ()
@end

@implementation CustomAnnotationView

#define kCalloutWidth       230.0
#define kCalloutHeight      150.0

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:(CGRect){0,20,60,15}];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14];
        [self addSubview:_label];
        _otherAnnotationInfos = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}
-(void)setNumberBadge:(NSInteger)numberBadge
{
    if (_numberBadgeLabel == nil) {
        _numberBadgeLabel = [[UILabel alloc] initWithFrame:(CGRect){0,-7,0,18}];
        _numberBadgeLabel.font = [UIFont systemFontOfSize:15];
        _numberBadgeLabel.backgroundColor = [UIColor redColor];
        _numberBadgeLabel.textColor = [UIColor whiteColor];
        _numberBadgeLabel.textAlignment = NSTextAlignmentCenter;
        
        _numberBadgeLabel.layer.cornerRadius = _numberBadgeLabel.frame.size.height/2;
        _numberBadgeLabel.layer.masksToBounds = YES;
        [self addSubview:_numberBadgeLabel];
//        NSLayoutConstraint * rightConstraint = [NSLayoutConstraint constraintWithItem:_numberBadgeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
//        NSLayoutConstraint * topConstraint = [NSLayoutConstraint constraintWithItem:_numberBadgeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
//        NSLayoutConstraint * widthConstraint = [NSLayoutConstraint constraintWithItem:_numberBadgeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:20];
//        widthConstraint.priority = UILayoutPriorityFittingSizeLevel;
//        NSLayoutConstraint * heightConstraint = [NSLayoutConstraint constraintWithItem:_numberBadgeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:13];
//        heightConstraint.priority = UILayoutPriorityFittingSizeLevel;
//        [self addConstraint:rightConstraint];
//        [self addConstraint:topConstraint];
//        [self addConstraint:widthConstraint];
//        [self addConstraint:heightConstraint];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        [btn addTarget:self action:@selector(selectAnnotationViewEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

    }
    _numberBadgeLabel.text = [NSString stringWithFormat:@"%ld",(long)numberBadge];
    CGSize size = [_numberBadgeLabel.text sizeWithAttributes:@{NSFontAttributeName:_numberBadgeLabel.font}];
    size.width = MAX(_numberBadgeLabel.frame.size.height, size.width + 10);
    _numberBadgeLabel.frame = CGRectMake(self.frame.size.width - size.width+5, _numberBadgeLabel.frame.origin.y, size.width, _numberBadgeLabel.frame.size.height);
}

- (void)selectAnnotationViewEvent:(UIButton *)btn
{
    NSLog(@"_otherAnnotationInfos is %@",_otherAnnotationInfos);
    [_mapController pushShowPhotoControllerWith:self];
}

-(void)addOtherAnnotationInfo:(NSDictionary *)object
{
    if (![self.otherAnnotationInfos containsObject:object]) {
        [self.otherAnnotationInfos addObject:object];
    }
}
-(void)removeOtherAnnotationInfo:(NSDictionary *)object
{
    if ([self.otherAnnotationInfos containsObject:object]) {
        [self.otherAnnotationInfos removeObject:object];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
