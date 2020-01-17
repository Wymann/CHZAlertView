//
//  CHZAlertView.h
//  TclIntelliCom
//
//  Created by Wymann Chan on 2019/8/24.
//  Copyright © 2019 tcl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHZAlertSetup.h"

/** 点击按钮回调 */
typedef BOOL(^ButtonBlock)(NSInteger buttonIndex, NSString *inputText, NSArray <NSString *>*pickedStrings);
/** 显示回调 */
typedef void(^ShowBlock)(void);
/** 消失回调 */
typedef void(^HideBlock)(NSString *inputText, NSArray <NSString *>*pickedStrings);
/** 倒计时回调 */
typedef void(^CountdownBlock)(NSInteger remainingTime);

@interface CHZAlertView : UIView

#pragma mark - Public

/**
 按钮点击回调
 */
@property (nonatomic, copy) ButtonBlock buttonBlock;

/**
 显示回调
 */
@property (nonatomic, copy) ShowBlock showBlock;

/**
 消失回调
 */
@property (nonatomic, copy) HideBlock hideBlock;

/**
 倒计时回调
 */
@property (nonatomic, copy) CountdownBlock countdownBlock;

/**
 初始化

 @param setup 配置信息
 @return CHZAlertView
 */
-(instancetype)initWithAlertSetup:(CHZAlertSetup *)setup;

/**
 弹窗
 */
- (void)showAlertView;

/**
 关闭
 */
- (void)closeAlertView;

@end
