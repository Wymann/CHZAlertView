//
//  CHZPickerModel.h
//  TclIntelliCom
//
//  Created by Wymann Chan on 2019/8/24.
//  Copyright © 2019 tcl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZPickerModel : NSObject

/**
 标题
 */
@property (nonatomic, copy) NSString *string;

/**
 是否已经被选中
 */
@property (nonatomic) BOOL picked;

@end
