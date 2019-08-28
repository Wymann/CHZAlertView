//
//  CHZAlertButtonItem.m
//  TclIntelliCom
//
//  Created by Wymann Chan on 2019/8/26.
//  Copyright © 2019 tcl. All rights reserved.
//

#import "CHZAlertButtonItem.h"

@implementation CHZAlertButtonItem

- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                    backColor:(UIColor *)backColor
                        image:(UIImage *)image {
    self = [super init];
    if (self) {
        _title = title;
        _titleColor = titleColor;
        _backColor = backColor;
        _image = image;
    }
    return self;
}

@end
