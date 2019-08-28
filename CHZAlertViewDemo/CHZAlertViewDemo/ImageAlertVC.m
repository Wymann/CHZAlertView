//
//  ImageAlertVC.m
//  CHZAlertViewDemo
//
//  Created by Wymann Chan on 2019/8/28.
//  Copyright © 2019 CHZ. All rights reserved.
//

#import "ImageAlertVC.h"

@interface ImageAlertVC ()

@end

@implementation ImageAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"图片弹窗";
}

-(void)startPopAlertView {
    CHZAlertSetup *setup = [[CHZAlertSetup alloc] init];
    setup.sideTap = NO; //点击旁边空白处是否关闭弹窗
    setup.alertType = AlertViewType_Image;
    setup.animationType = ShowAnimationType_FromTop; //从顶部往下弹出
    setup.title = @"消息提醒";
    setup.information = @"主人，下午好，有人按了客厅门铃。是否给他开门？";
    setup.icon = [UIImage imageNamed:@"topIcon"];
    setup.image = [UIImage imageNamed:@"image"];
    CHZAlertButtonItem *item0 = [[CHZAlertButtonItem alloc] initWithTitle:@"取消" titleColor:nil backColor:nil image:nil];
    CHZAlertButtonItem *item1 = [[CHZAlertButtonItem alloc] initWithTitle:@"确定" titleColor:nil backColor:[UIColor blueColor] image:nil];
    setup.buttonItemArray = @[item0, item1];
    setup.buttonsShowType = ButtonsShowType_Vertical;
    CHZAlertView *alertView = [[CHZAlertView alloc] initWithAlertSetup:setup];
    [alertView showAlertView];
    alertView.buttonBlock = ^(NSInteger buttonIndex, NSString *inputText, NSArray<NSString *> *pickedStrings) {
        if (buttonIndex == 0) {
            NSLog(@"点击了 取消");
            
        } else {
            NSLog(@"点击了 确定");
        }
        return YES; //点击后是否关闭弹窗
    };
}

@end
