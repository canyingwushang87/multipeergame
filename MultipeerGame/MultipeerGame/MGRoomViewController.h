//
//  MGRoomViewController.h
//  MultipeerGame
//
//  Created by Admin on 14-6-28.
//  Copyright (c) 2014年 baidubox. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MultipeerConnectivity;

@interface MGRoomViewController : UIViewController<UITextFieldDelegate, MCBrowserViewControllerDelegate>

- (id)initWithName:(NSString *)myName;

@end
