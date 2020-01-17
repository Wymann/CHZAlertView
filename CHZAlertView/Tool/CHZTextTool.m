//
//  CHZTextTool.m
//  OWFormView
//
//  Created by Owen Chen on 2018/6/12.
//  Copyright © 2018年 Owen. All rights reserved.
//

#import "CHZTextTool.h"

@implementation CHZTextTool

//获取单行文字宽度
+ (CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)font
{
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return textSize.width;
}

//获取文字高度
+ (CGFloat)getTextHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font
{
    if ([text isEqualToString:@""]) {
        return 0.0;
    } else {
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        return textSize.height + 2.0;
    }
}

//获取富文本高度
+ (CGFloat)getTextHeightWithAttributedText:(NSAttributedString *)attributted Width:(CGFloat)width
{
    if(width<=0){
        return 0.0;
    }
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0,0, width, MAXFLOAT)];
    lab.attributedText = attributted;
    lab.numberOfLines =0;
    
    CGSize labSize = [lab sizeThatFits:lab.bounds.size];
    
    return labSize.height + 5.0;
}

@end
