//
//  CHZAlertSetup.m
//  TclIntelliCom
//
//  Created by Wymann Chan on 2019/8/24.
//  Copyright © 2019 tcl. All rights reserved.
//

#import "CHZAlertSetup.h"

@implementation CHZAlertSetup

/// 初始化
/// @param alertType 弹框类型
/// @param title 标题
/// @param information 描述
/// @param buttonItemArray 按钮集合
/// @param animationType 弹出动画类型
- (instancetype)initWithAlertType:(AlertViewType)alertType
                            title:(NSString *)title
                      information:(NSString *)information
                  buttonItemArray:(NSArray <CHZAlertButtonItem *>*)buttonItemArray
                    animationType:(ShowAnimationType)animationType {
    self = [super init];
    if (self) {
        _alertType = alertType;
        _title = title;
        _information = information;
        _buttonItemArray = buttonItemArray;
        _animationType = animationType;
    }
    return self;
}

@end
