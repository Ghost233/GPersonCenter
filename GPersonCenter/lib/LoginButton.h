//
//  LoginButton.h
//  GPersonCenter
//
//  Created by Ghost on 16/3/25.
//  Copyright © 2016年 Ghost. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface LoginButton : UIView

@property (nonatomic, readwrite) IBInspectable CGFloat roundRectangleViewRadius;
@property (nonatomic, strong) IBInspectable UIColor* roundRectangleViewColor;

@property (nonatomic, strong) void(^executeBlock)();
@property (nonatomic, strong) void(^completeBlock)();

- (instancetype)initWithFrame:(CGRect)frame withColor:(UIColor*)color;

@end