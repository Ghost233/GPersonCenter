//
//  LoginViewController.m
//  GPersonCenter
//
//  Created by Ghost on 16/3/23.
//  Copyright © 2016年 Ghost. All rights reserved.
//

#import "LoginViewController.h"

#import "DeformationButton.h"

@interface LoginViewController ()


@property (nonatomic, retain)MMMaterialDesignSpinner *spinnerView;
@property (nonatomic, strong) DeformationButton* deformationBtn;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    MMMaterialDesignSpinner *spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectZero];
    self.spinnerView = spinnerView;
    self.spinnerView.tintColor = [UIColor whiteColor];
    self.spinnerView.lineWidth = 2;
    self.spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.spinnerView.userInteractionEnabled = NO;
    [self.view addSubview:self.spinnerView];
    [self.spinnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.centerY.centerX.equalTo(self.view);
    }];
    [self.spinnerView startAnimating];

    
    self.deformationBtn = [[DeformationButton alloc]initWithFrame:CGRectMake(100, 100, 140, 36) withColor:[UIColor redColor]];
    
    [self.view addSubview:self.deformationBtn];
//    [self.deformationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.centerY.equalTo(self.view);
//    }];
    
    [_deformationBtn.forDisplayButton setTitle:@"微博注册" forState:UIControlStateNormal];
    [_deformationBtn.forDisplayButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_deformationBtn.forDisplayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deformationBtn.forDisplayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [_deformationBtn.forDisplayButton setImage:[UIImage imageNamed:@"username"] forState:UIControlStateNormal];
    
    [_deformationBtn addTarget:self action:@selector(btnEvent) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

- (void)btnEvent{
    NSLog(@"btnEvent");
    _deformationBtn.isLoading = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
