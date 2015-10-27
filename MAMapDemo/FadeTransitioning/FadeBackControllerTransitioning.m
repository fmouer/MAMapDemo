//
//  FadeBackControllerTransitioning.m
//  FRBrowserView
//
//  Created by fmouer on 15/7/30.
//  Copyright (c) 2015年 FRBrowserView. All rights reserved.
//

#import "FadeBackControllerTransitioning.h"

@implementation FadeBackControllerTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];

    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    //controller 动画
    [UIView animateWithDuration:duration animations:^{
        // Fade in the second view controller's view
        fromViewController.view.backgroundColor = [fromViewController.view.backgroundColor colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        // Declare that we've finished
        //返回时最后状态停留0.1秒
        [PublicObject dispatchQueueDelayTime:0.1 block:^{
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }];
    
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

@end
