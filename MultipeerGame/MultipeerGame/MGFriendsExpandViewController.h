//
//  MGFriendsExpandViewController.h
//  MCDemo
//
//  Created by wendy on 6/28/14.
//  Copyright (c) 2014 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionHelper.h"

#define KFRIEND_APPLICATION_SIZE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define KFRIEND_APPLICATION_SIZE_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define KFRIEND_EXPAND_LIST_WIDTH 70
#define KFRIEND_EXPAND_LIST_CELL_HEIGHT 70

#define KFRIEND_EXPAND_BACK_BUTTON_HEIGHT 40

#define KFRIEND_EXPAND_KEYBOARD_HEIGHT 30
#define KFRIEND_MESSAGE_HEIGHT 50

#define KFRIEDN_EXPAND_LIST_HEIGHT (KFRIEND_APPLICATION_SIZE_HEIGHT - KFRIEND_EXPAND_BACK_BUTTON_HEIGHT - KFRIEND_EXPAND_KEYBOARD_HEIGHT - 60)

#define KMG_BLUE_COLOR [UIColor colorWithRed:0 green:118/255.0 blue:1.0 alpha:1.0]


@interface MGFriendsExpandViewController : UIViewController

@property (nonatomic, strong) SessionHelper *sessionHelper;

- (void)showMessage:(NSString *)name message:(NSString *)message;
- (void)showFriendsList;

@end
