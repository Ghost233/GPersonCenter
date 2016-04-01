//
//  PingTransition.h
//  KYPingTransition
//
//  Created by Kitten Yang on 1/30/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PingTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, readwrite) CGPoint startCenterPoint;
@property (nonatomic, readwrite) CGFloat startRadius;
@property (nonatomic, readwrite) CGFloat duration;

@end
