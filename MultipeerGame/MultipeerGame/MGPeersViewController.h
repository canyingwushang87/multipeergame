//
//  MGRoomViewController.h
//  MultipeerGame
//
//  Created by Admin on 14-6-28.
//  Copyright (c) 2014年 baidubox. All rights reserved.
//

#import <UIKit/UIKit.h>

// 用户头像
@interface MGUserCharactor : NSObject
@property (nonatomic, retain) UIImageView *charatorIcon;
@property (nonatomic, assign) CGPoint iconCurrentPosition;
@property (nonatomic, assign) CGPoint iconMovetoPosition;
@end

@interface MGPeersViewController : UIViewController
@end

