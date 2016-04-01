//
//  PingTransition.m
//  KYPingTransition
//
//  Created by Kitten Yang on 1/30/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "PingTransition.h"

@interface PingTransition()

@property (nonatomic,strong)id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation PingTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext = transitionContext;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];    
    
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    CGRect startRect = CGRectMake(_startCenterPoint.x - _startRadius / 2, _startCenterPoint.y - _startRadius / 2, _startRadius, _startRadius);
    
    CGPoint finalPoint;
    
    if(_startCenterPoint.x > (toVC.view.bounds.size.width / 2)){
        if (_startCenterPoint.y < (toVC.view.bounds.size.height / 2)) {
            finalPoint = CGPointMake(_startCenterPoint.x - 0, _startCenterPoint.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            finalPoint = CGPointMake(_startCenterPoint.x - 0, _startCenterPoint.y - 0);
        }
    }else{
        if (_startCenterPoint.y < (toVC.view.bounds.size.height / 2)) {
            finalPoint = CGPointMake(_startCenterPoint.x - CGRectGetMaxX(toVC.view.bounds), _startCenterPoint.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            finalPoint = CGPointMake(_startCenterPoint.x - CGRectGetMaxX(toVC.view.bounds), _startCenterPoint.y - 0);
        }
    }

    CGFloat radius = sqrt(finalPoint.x * finalPoint.x + finalPoint.y * finalPoint.y);
    
    CGRect finalRect = CGRectInset(startRect, -radius, -radius);
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:startRect];
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:finalRect];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pingAnimation.fromValue = (__bridge id)(startPath.CGPath);
    pingAnimation.toValue   = (__bridge id)(finalPath.CGPath);
    pingAnimation.duration = [self transitionDuration:transitionContext];
    pingAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    pingAnimation.delegate = self;
    
    [maskLayer addAnimation:pingAnimation forKey:@"ping"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:![self. transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

@end





