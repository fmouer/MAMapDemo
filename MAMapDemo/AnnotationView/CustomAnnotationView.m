//
//  CustomAnnotationView.m
//  Etoury
//
//  Created by fmouer on 15/9/4.
//  Copyright (c) 2015年 Etoury. All rights reserved.
//

#import "CustomAnnotationView.h"

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
        CGRect rect = self.frame;
        float width = rect.size.width;
        _numberBadgeLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,width+5,13}];
        _numberBadgeLabel.font = [UIFont systemFontOfSize:15];
        _numberBadgeLabel.backgroundColor = [UIColor redColor];
        _numberBadgeLabel.textColor = [UIColor whiteColor];
        _numberBadgeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_numberBadgeLabel];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        [btn addTarget:self action:@selector(selectAnnotationViewEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

    }
    _numberBadgeLabel.text = [NSString stringWithFormat:@"%ld",(long)numberBadge];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected){
        return;
    }
    
    if (selected){

    }else{
    }
    
    [super setSelected:selected animated:animated];
}

- (void)selectAnnotationViewEvent:(UIButton *)btn
{
    NSLog(@"_otherAnnotationInfos is %@",_otherAnnotationInfos);

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
