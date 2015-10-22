/*
 **************************************************************************************
 * Copyright (c) 2013-2015年 testNavi. All rights reserved.
 
 *
 * Project	    : TestNavigation
 *
 * File			: FadeShowControllerTransitioning.m
 *
 * Author		: Ihotdo-fmouer on 15-4-21.
 *
 **************************************************************************************
 **/

#import "FadeShowControllerTransitioning.h"

@implementation FadeShowControllerTransitioning
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toViewController.view];
   
    //controller 切换动画
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];

    NSTimeInterval duration = [self transitionDuration:transitionContext];
    toViewController.view.alpha = 0;
    [UIView animateWithDuration:duration animations:^{
        // Fade in the second view controller's view
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];

}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

@end
