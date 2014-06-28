//
//  MGHappyShakeViewController.h
//  MultipeerGame
//
//  Created by canyingwushang on 6/28/14.
//  Copyright (c) 2014 baidubox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionHelper.h"

@interface MGHappyShakeViewController : UIViewController <SessionHelperDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) IBOutlet UIView *backgroundView;
@property (nonatomic, assign) IBOutlet UITableView *resultTableView;


@property (nonatomic, strong) SessionHelper *sessionHelper;

@end
