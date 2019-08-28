//
//  BasicViewController.h
//  CHZAnimations
//
//  Created by Wymann Chan on 2019/8/23.
//  Copyright © 2019 TCLSmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHZAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasicViewController : UIViewController

- (void)startPopAlertView;
- (void)changeButtonTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
