//
//  TextViewAlertVC.m
//  CHZAlertViewDemo
//
//  Created by Wymann Chan on 2019/8/28.
//  Copyright © 2019 CHZ. All rights reserved.
//

#import "TextViewAlertVC.h"

@interface TextViewAlertVC ()

@end

@implementation TextViewAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"TextView弹窗";
}

-(void)startPopAlertView {
    CHZAlertSetup *setup = [[CHZAlertSetup alloc] init];
    setup.sideTap = NO; //点击旁边空白处是否关闭弹窗
    setup.alertType = AlertViewType_TextView;
    setup.animationType = ShowAnimationType_FromBottom; //从顶部往下弹出
    setup.icon = [UIImage imageNamed:@"topIcon2"];
    setup.title = @"意见反馈";
    setup.information = @"希望能得到您宝贵的意见，谢谢。";
    setup.placeholder = @"输入您的反馈~";
    CHZAlertButtonItem *item0 = [[CHZAlertButtonItem alloc] initWithTitle:@"取消" titleColor:nil backColor:nil image:nil];
    CHZAlertButtonItem *item1 = [[CHZAlertButtonItem alloc] initWithTitle:@"提交" titleColor:nil backColor:[UIColor greenColor] image:nil];
    setup.buttonItemArray = @[item0, item1];
    setup.buttonsShowType = ButtonsShowType_Horizontal;
    CHZAlertView *alertView = [[CHZAlertView alloc] initWithAlertSetup:setup];
    [alertView showAlertView];
    alertView.buttonBlock = ^(NSInteger buttonIndex, NSString *inputText, NSArray<NSString *> *pickedStrings) {
        if (buttonIndex == 0) {
            NSLog(@"点击了 取消");
            
        } else {
            NSLog(@"点击了 提交，输入：%@", inputText);
        }
        return YES; //点击后是否关闭弹窗
    };
}

@end
