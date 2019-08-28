//
//  BasicViewController.m
//  CHZAnimations
//
//  Created by Wymann Chan on 2019/8/23.
//  Copyright © 2019 TCLSmartHome. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@property (nonatomic, strong) UIButton *animationButton;

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _animationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _animationButton.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 60, CGRectGetWidth(self.view.bounds), 40.0);
    [_animationButton setTitle:@"弹窗" forState:UIControlStateNormal];
    [_animationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_animationButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _animationButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _animationButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_animationButton];
    [_animationButton addTarget:self action:@selector(startPopAlertView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startPopAlertView {
    
}

- (void)changeButtonTitle:(NSString *)title {
    [_animationButton setTitle:title forState:UIControlStateNormal];
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
