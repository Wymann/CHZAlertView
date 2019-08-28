//
//  TextFieldAlertVC.m
//  CHZAlertViewDemo
//
//  Created by Wymann Chan on 2019/8/28.
//  Copyright © 2019 CHZ. All rights reserved.
//

#import "TextFieldAlertVC.h"

@interface TextFieldAlertVC ()

@end

@implementation TextFieldAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"TextField弹窗";
}

-(void)startPopAlertView {
    CHZAlertSetup *setup = [[CHZAlertSetup alloc] init];
    setup.sideTap = NO; //点击旁边空白处是否关闭弹窗
    setup.alertType = AlertViewType_TextField;
    setup.animationType = ShowAnimationType_FromRight; //从顶部往下弹出
    setup.title = @"问题";
    setup.information = @"香港是一个国家吗？";
    setup.placeholder = @"输入答案~";
    CHZAlertButtonItem *item0 = [[CHZAlertButtonItem alloc] initWithTitle:@"放弃" titleColor:nil backColor:nil image:nil];
    CHZAlertButtonItem *item1 = [[CHZAlertButtonItem alloc] initWithTitle:@"提交" titleColor:nil backColor:[UIColor blueColor] image:nil];
    setup.buttonItemArray = @[item0, item1];
    setup.buttonsShowType = ButtonsShowType_Horizontal;
    CHZAlertView *alertView = [[CHZAlertView alloc] initWithAlertSetup:setup];
    [alertView showAlertView];
    alertView.buttonBlock = ^(NSInteger buttonIndex, NSString *inputText, NSArray<NSString *> *pickedStrings) {
        if (buttonIndex == 0) {
            NSLog(@"点击了 放弃");
            
        } else {
            NSLog(@"点击了 提交，答案：%@", inputText);
        }
        return YES; //点击后是否关闭弹窗
    };
}

@end
