//
//  PickerAlertVC.m
//  CHZAlertViewDemo
//
//  Created by Wymann Chan on 2019/8/24.
//  Copyright © 2019 CHZ. All rights reserved.
//

#import "PickerAlertVC.h"

@interface PickerAlertVC ()

@end

@implementation PickerAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择器弹窗";
}

-(void)startPopAlertView {
    CHZAlertSetup *setup = [[CHZAlertSetup alloc] init];
    setup.sideTap = NO; //点击旁边空白处是否关闭弹窗
    setup.alertType = AlertViewType_Picker;
    setup.animationType = ShowAnimationType_Fade; //从顶部往下弹出
    setup.title = @"选择器";
    setup.information = @"选择你想去的城市";
    setup.allStringsArray = @[@"深圳", @"广州", @"北京", @"厦门", @"西安", @"杭州"];
    setup.pickedStringsArray = @[@"深圳", @"北京"];
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
            NSLog(@"点击了 确定，选择的城市:%@", pickedStrings);
        }
        return YES; //点击后是否关闭弹窗
    };
}

@end
