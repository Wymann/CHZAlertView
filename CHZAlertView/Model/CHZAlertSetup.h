//
//  CHZAlertSetup.h
//  TclIntelliCom
//
//  Created by Wymann Chan on 2019/8/24.
//  Copyright © 2019 tcl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHZAlertButtonItem.h"

/**
 出现时动画
 
 - ShowAnimationType_FromTop: 从上往下
 - ShowAnimationType_FromLeft: 从左往右
 - ShowAnimationType_FromBottom: 从下往上
 - ShowAnimationType_FromRight: 从右往左
 - ShowAnimationType_Fade: 渐渐显示（透明度动画）
 - ShowAnimationType_None: 无动画（默认）
 */
typedef NS_ENUM(NSInteger, ShowAnimationType) {
    ShowAnimationType_FromTop = 0,
    ShowAnimationType_FromLeft = 1,
    ShowAnimationType_FromBottom = 2,
    ShowAnimationType_FromRight = 3,
    ShowAnimationType_Fade = 4,
    ShowAnimationType_None = 5,
};

/**
 AlertView 类型
 
 - AlertViewType_Normal: 普通类型
 - AlertViewType_TextField: 带TextField
 - AlertViewType_TextView: 带TextView
 - AlertViewType_Image: 带图片
 - AlertViewType_Picker: 选择器类型
 */
typedef NS_ENUM(NSInteger, AlertViewType) {
    AlertViewType_Normal = 0,
    AlertViewType_TextField = 1,
    AlertViewType_TextView = 2,
    AlertViewType_Image = 3,
    AlertViewType_Picker = 4,
};

/**
 按钮排版类型
 
 - ButtonsShowType: 横向水平排版
 - ButtonsShowType: 垂直排版
 */
typedef NS_ENUM(NSInteger, ButtonsShowType) {
    ButtonsShowType_Horizontal = 0,
    ButtonsShowType_Vertical = 1,
};

@interface CHZAlertSetup : NSObject

#pragma mark - common
/**
 AlertView 类型 默认AlertViewType_Normal类型
 */
@property (nonatomic) AlertViewType alertType;

/**
 出现时动画 默认ShowAnimationType_FromTop: 从上往下
 */
@property (nonatomic) ShowAnimationType animationType;

/**
 顶部icon
 */
@property (nonatomic, strong) UIImage *icon;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 描述信息
 */
@property (nonatomic, copy) NSString *information;

/**
 标题字体 默认：boldSystemFontOfSize:16
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 标题颜色 默认：[UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 描述信息字体 默认：systemFontOfSize:14
 */
@property (nonatomic, strong) UIFont *infoFont;

/**
 描述信息颜色 默认：[UIColor darkGrayColor]
 */
@property (nonatomic, strong) UIColor *infoColor;

/**
 是否点击旁边空白处消失
 */
@property (nonatomic) BOOL sideTap;

/**
 倒数指定时间后消失
 */
@property (nonatomic) NSInteger countDownTimer;

/**
 倒数时间占位字符串
 */
@property (nonatomic, copy) NSString *replaceTimeString;

/**
 按钮数组
 */
@property (nonatomic, strong) NSArray <CHZAlertButtonItem *>*buttonItemArray;

/**
 按钮排版方向
 */
@property (nonatomic) ButtonsShowType buttonsShowType;

#pragma mark - AlertViewType_TextField || AlertViewType_TextView
/**
 占位符（用于 AlertViewType_TextField和 AlertViewType_TextView ）
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 TextView高度
 */
@property (nonatomic) CGFloat textViewHeight;

#pragma mark - AlertViewType_Image
/**
 图片（用于AlertViewType_Image）
 */
@property (nonatomic, strong) UIImage *image;

#pragma mark - AlertViewType_Picker
/**
 供选择的字符串组成的数组（用于AlertViewType_Picker）
 */
@property (nonatomic, strong) NSArray <NSString *>*allStringsArray;

/**
 已经选中的字符串（用于AlertViewType_Picker）
 */
@property (nonatomic, strong) NSArray <NSString *>*pickedStringsArray;

/**
 pickerTableView Cell高度（用于AlertViewType_Picker）
 */
@property (nonatomic) CGFloat pickerCellHeight;

#pragma mark - init methods

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
                    animationType:(ShowAnimationType)animationType;

@end
