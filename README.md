README
===========================
弹窗效果封装，支持显示图片、TextField、TextView、tableVeiw选择器等类型，也定时消失。欢迎邮箱反馈

****
	
|Author|陈怀章Owen|
|---|---
|E-mail 1|wymannchan@163.com
|E-mail 2|wymannchan@gmail.com


****
## 目录
* [使用方式](#使用方式)
* [效果图](#效果图)

### 安装
1. 使用 Cocoapod
2. 下载相关代码，引入项目

### 使用方式
-----------
```Java
//引入头文件 NormalAlertVC.h

-(void)startPopAlertView {
    CHZAlertSetup *setup = [[CHZAlertSetup alloc] init];
    setup.sideTap = YES; //点击旁边空白处是否关闭弹窗
    setup.alertType = AlertViewType_Normal;
    setup.animationType = ShowAnimationType_FromLeft; //从左边弹出
    setup.title = @"消息提醒";
    setup.information = @"主人，下午好，有人按了客厅门铃。是否给他开门？";
    setup.icon = [UIImage imageNamed:@"topIcon"];
    CHZAlertButtonItem *item0 = [[CHZAlertButtonItem alloc] initWithTitle:@"取消" titleColor:nil backColor:nil image:nil];
    CHZAlertButtonItem *item1 = [[CHZAlertButtonItem alloc] initWithTitle:@"确定" titleColor:nil backColor:[UIColor redColor] image:nil];
    setup.buttonItemArray = @[item0, item1];
    setup.buttonsShowType = ButtonsShowType_Horizontal;
    CHZAlertView *alertView = [[CHZAlertView alloc] initWithAlertSetup:setup];
    [alertView showAlertView];
    alertView.buttonBlock = ^(NSInteger buttonIndex, NSString *inputText, NSArray<NSString *> *pickedStrings) {
        if (buttonIndex == 0) {
            NSLog(@"点击了 取消");
        } else if (buttonIndex == 1) {
            NSLog(@"点击了 确定");
        }
        return YES; //点击后是否关闭弹窗
    };
}
```
其他各种样式请下载Demo参考
-----------

### 效果图（GIF动图，网络不好的话可能会卡，等一会就会动了）
-----------
#### 普通弹窗
![image](https://github.com/Wymann/CHZAlertView/blob/master/GIFs/01.gif)
#### 图片弹窗
![image](https://github.com/Wymann/CHZAlertView/blob/master/GIFs/02.gif)
#### TextField弹窗
![image](https://github.com/Wymann/CHZAlertView/blob/master/GIFs/03.gif)
#### TextView弹窗
![image](https://github.com/Wymann/CHZAlertView/blob/master/GIFs/04.gif)
#### 选择器弹窗
![image](https://github.com/Wymann/CHZAlertView/blob/master/GIFs/05.gif)
#### 倒计时消失弹窗
![image](https://github.com/Wymann/CHZAlertView/blob/master/GIFs/06.gif)
-----------
