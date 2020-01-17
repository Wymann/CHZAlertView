//
//  CHZAlertButtonItem.h
//  TclIntelliCom
//
//  Created by Wymann Chan on 2019/8/24.
//  Copyright © 2019 tcl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CHZAlertButtonItem : NSObject

/**
 按钮标题
 */
@property (nonatomic, copy) NSString *title;

/**
 按钮标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 按钮背景色
 */
@property (nonatomic, strong) UIColor *backColor;

/**
 按钮图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 快速创建实例

 @param title 文字
 @param titleColor 文字颜色
 @param backColor 背景色
 @param image 图标
 @return 实例
 */
- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                    backColor:(UIColor *)backColor
                        image:(UIImage *)image;

@end
