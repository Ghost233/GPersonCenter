//
//  LoginButton.m
//  GPersonCenter
//
//  Created by Ghost on 16/3/25.
//  Copyright © 2016年 Ghost. All rights reserved.
//

#import "LoginButton.h"

@interface LoginButton ()

@property (nonatomic, strong) GRoundRectangleView* roundRectangleView;
@property (nonatomic, readwrite) bool firstLoad;
@property (nonatomic, readwrite) CGFloat decrease;

@end

@implementation LoginButton

- (instancetype)init
{
    if (!(self = [super init]))
        return NULL;
    self.firstLoad = false;
    if (!self.firstLoad) [self load];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withColor:(UIColor*)color
{
    if (!(self = [super initWithFrame:frame]))
        return NULL;
    if (!self.firstLoad) [self load];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder]))
        return NULL;
    if (!self.firstLoad) [self load];
    return self;
}

- (void)load
{
    self.userInteractionEnabled = YES;
    
    self.decrease = 0;
    
    [self initTapGesture];
    
    self.firstLoad = true;
    GRoundRectangleView* roundRectangleView = [[GRoundRectangleView alloc] init];
    [self addSubview:roundRectangleView];
    self.roundRectangleView = roundRectangleView;
    [self.roundRectangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(@(80));
    }];
    
    self.decrease = _roundRectangleView.size.width;
    
    roundRectangleView.hidden = YES;
}

- (void)initTapGesture
{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)click:(UITapGestureRecognizer*)gesture
{
    [self removeGestureRecognizer:gesture];
  
    static NSString* RoundRectangleRadiusProperty = @"RoundRectangleRadius";
    static NSString* RoundRectangleSizeProperty = @"RoundRectangleSize";
    
    POPAnimatableProperty *radiusProp = [POPAnimatableProperty propertyWithName:RoundRectangleRadiusProperty initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            LoginButton* loginButton = (LoginButton*)obj;
            loginButton.roundRectangleViewRadius = values[0];
            [loginButton setNeedsDisplay];
        };
    }];
    
    POPBasicAnimation *anBasic = [POPBasicAnimation linearAnimation];
    anBasic.property = radiusProp;
    anBasic.fromValue = @(self.roundRectangleViewRadius);
    anBasic.toValue = @(_roundRectangleView.bounds.size.height / 2);
    anBasic.duration = 0.5;
    [self pop_addAnimation:anBasic forKey:@"RoundRadiusIncrease"];
    
    POPAnimatableProperty *sizeProp = [POPAnimatableProperty propertyWithName:RoundRectangleSizeProperty initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            LoginButton* loginButton = (LoginButton*)obj;
            [loginButton setNeedsDisplay];
            _decrease = values[0];
        };
    }];

    POPSpringAnimation *anSpring = [POPSpringAnimation animation];
    anSpring.property = sizeProp;
    anSpring.fromValue = @(0);
    anSpring.toValue = @((self.size.width - self.size.height));
    anSpring.springBounciness = 20;
    anSpring.springSpeed = 50;
    [self pop_addAnimation:anSpring forKey:@"SizeDecrease"];
}

- (void)drawRect:(CGRect)rect {
    
    if (!self.firstLoad) [self load];
    
    _roundRectangleView.color = _roundRectangleViewColor;
    _roundRectangleView.radius = _roundRectangleViewRadius;
    
    if (_decrease > (self.size.width - self.size.height)) _decrease = self.size.width - self.size.height;
    
    CGRect tempRect = CGRectMake(_decrease / 2, 0, rect.size.width - _decrease, rect.size.height);
    
    [_roundRectangleView drawCustomView:tempRect];
    
    [super drawRect:rect];
}

@end
