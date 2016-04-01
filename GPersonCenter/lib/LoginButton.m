//
//  LoginButton.m
//  GPersonCenter
//
//  Created by Ghost on 16/3/25.
//  Copyright © 2016年 Ghost. All rights reserved.
//

#import "LoginButton.h"

@interface LoginButton ()
{
    dispatch_semaphore_t animationFinishSemaphore;
}

@property (nonatomic, strong) GRoundRectangleVector* roundRectangleVector;
@property (nonatomic, strong) MMMaterialDesignSpinner *spinnerView;
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
    self.roundRectangleVector = [[GRoundRectangleVector alloc] init];
    
    self.decrease = 0;
    
    animationFinishSemaphore = dispatch_semaphore_create(0);
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
    anBasic.toValue = @(self.bounds.size.height / 2);
    anBasic.duration = 0.5;
    [self pop_addAnimation:anBasic forKey:@"RoundRadiusIncrease"];
    
    POPAnimatableProperty *sizeProp = [POPAnimatableProperty propertyWithName:RoundRectangleSizeProperty initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            LoginButton* loginButton = (LoginButton*)obj;
            [loginButton setNeedsDisplay];
            self.decrease = values[0];
        };
    }];

    POPBasicAnimation *sizeDecrease = [POPBasicAnimation easeInEaseOutAnimation];
    sizeDecrease.property = sizeProp;
    sizeDecrease.fromValue = @(0);
    sizeDecrease.toValue = @((self.size.width - self.size.height));
    sizeDecrease.duration = 0.3f;
    [self pop_addAnimation:sizeDecrease forKey:@"SizeDecrease"];

    self.spinnerView = [[MMMaterialDesignSpinner alloc] init];
    
    _spinnerView.lineWidth = 1.5f;
    _spinnerView.tintColor = [UIColor greenColor];
    
    [_spinnerView startAnimating];
    
    [self addSubview:_spinnerView];
    
    [_spinnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.equalTo(_spinnerView.mas_height);
        make.top.equalTo(self).with.offset(5);
        make.bottom.equalTo(self).with.offset(-5);
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_semaphore_signal(animationFinishSemaphore);
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(animationFinishSemaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_spinnerView stopAnimating];
            
//            [self initTapGesture];
            if (self.completeBlock != NULL)
            {
                self.completeBlock();
            }
        });
        
        POPBasicAnimation* sizeDecrease = [POPBasicAnimation easeInEaseOutAnimation];
        
        sizeDecrease.property = sizeProp;
        sizeDecrease.toValue = @(0);
        sizeDecrease.fromValue = @((self.size.width - self.size.height));
        sizeDecrease.duration = 0.3f;
        [self pop_addAnimation:sizeDecrease forKey:@"SizeDecrease"];
        
        POPBasicAnimation* anBasic = [POPBasicAnimation linearAnimation];
        anBasic.property = radiusProp;
        anBasic.toValue = @(self.roundRectangleViewRadius);
        anBasic.fromValue = @(self.bounds.size.height / 2);
        anBasic.duration = 0.5;
        [self pop_addAnimation:anBasic forKey:@"RoundRadiusIncrease"];
    });
}

- (void)drawRect:(CGRect)rect {
    
    if (!self.firstLoad) [self load];
    
    _roundRectangleVector.color = _roundRectangleViewColor;
    _roundRectangleVector.radius = _roundRectangleViewRadius;
    
    if (_decrease > (self.size.width - self.size.height)) _decrease = self.size.width - self.size.height;
    
    CGRect tempRect = CGRectMake(_decrease / 2, 0, rect.size.width - _decrease, rect.size.height);
    
    [_roundRectangleVector customDrawRect:tempRect];
    
    [super drawRect:rect];
}

@end
