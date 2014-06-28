//
//  MGHappyShakeViewController.h
//  MultipeerGame
//
//  Created by canyingwushang on 6/28/14.
//  Copyright (c) 2014 baidubox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGHappyShakeViewController : UIViewController

@property (nonatomic, assign) IBOutlet UIView *backgroundView;
@property (nonatomic, assign) IBOutlet UIButton *startButton;

@property (nonatomic, strong) SessionHelper *sessionHelper;

@end
