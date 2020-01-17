//
//  CHZTextTool.h
//  OWFormView
//
//  Created by Owen Chen on 2018/6/12.
//  Copyright © 2018年 Owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CHZTextTool : NSObject

/**
 获取单行文本高度
 
 @param text 普通单行文本
 @param font 字体
 @return 计算出的普通单行文本宽度
 */
+ (CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)font;

/**
 获取普通文字高度
 
 @param text 普通文本
 @param width 宽度
 @param font 字体
 @return 计算出的普通文本高度
 */
+ (CGFloat)getTextHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;

/**
 获取富文本高度
 
 @param attributted 需要操作的富文本
 @param width 宽度
 @return 计算出的富文本高度
 */
+ (CGFloat)getTextHeightWithAttributedText:(NSAttributedString *)attributted Width:(CGFloat)width;

@end
