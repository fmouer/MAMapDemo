//
//  FadeBackControllerTransitioning.m
//  FRBrowserView
//
//  Created by ihotdo-fmouer on 15/7/30.
//  Copyright (c) 2015年 FRBrowserView. All rights reserved.
//

#import "FadeBackControllerTransitioning.h"
#import "AppDelegate.h"

@implementation FadeBackControllerTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    
    
    //controller 动画
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    fromViewController.view.alpha = 1;
    [UIView animateWithDuration:duration animations:^{
        // Fade in the second view controller's view
        fromViewController.view.backgroundColor = [fromViewController.view.backgroundColor colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        // Declare that we've finished
        [PublicObject dispatchQueueDelayTime:0.08 block:^{
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }];
    
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

@end
