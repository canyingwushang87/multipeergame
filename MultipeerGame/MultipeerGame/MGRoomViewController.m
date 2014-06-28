//
//  MGRoomViewController.m
//  MultipeerGame
//
//  Created by Admin on 14-6-28.
//  Copyright (c) 2014年 baidubox. All rights reserved.
//

#import "MGRoomViewController.h"
#import "SessionHelper.h"
#import "MGPeersViewController.h"

@interface MGRoomViewController ()

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UITextField *joinNameText;
@property (nonatomic, retain) UITextField *createNameText;
@property (nonatomic, retain) SessionHelper *sessionHelper;

@end

@implementation MGRoomViewController

- (id)initWithName:(NSString *)myName
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _name = [myName copy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Room";
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 150.0f, 220.0f, 20.0f)];
    tip.text = @"请输入房间名：";
    tip.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.view addSubview:tip];
    
    UILabel *tip1 = [[UILabel alloc] initWithFrame:CGRectOffset(tip.frame, 0.0f, 20.0f)];
    tip1.numberOfLines = 10;
    tip1.text = @"(若没有此房间则会建立一个房间)";
    tip1.font = [UIFont boldSystemFontOfSize:12.0f];
    [self.view addSubview:tip1];

//    UIButton *backbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 50.0f, 20.0f)];
//    [backbtn setTitle:@"Back" forState:UIControlStateNormal];
//    [backbtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
//    [backbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [backbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
//    self.navigationItem.leftBarButtonItem = back;
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    self.joinNameText = [[UITextField alloc] initWithFrame:CGRectMake(50.0f, 200.0f, 220.0f, 30.0f)];
    [self.view addSubview:_joinNameText];
    _joinNameText.borderStyle = UITextBorderStyleRoundedRect;
    _joinNameText.delegate = self;
    
    UIButton *join = [[UIButton alloc] initWithFrame:CGRectOffset(_joinNameText.frame, 0.0f, 50.0f)];
    [join setBackgroundImage:[[UIImage imageNamed:@"homebtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 10, 10)] forState:UIControlStateNormal];
    [self.view addSubview:join];
    [join setTitle:@"Join" forState:UIControlStateNormal];
    [join addTarget:self action:@selector(Join) forControlEvents:UIControlEventTouchUpInside];
    
//    self.createNameText = [[UITextField alloc] initWithFrame:CGRectOffset(_joinNameText.frame, 0.0f, 100.0f)];
//    [self.view addSubview:_createNameText];
//    _createNameText.borderStyle = UITextBorderStyleRoundedRect;
//    _createNameText.delegate = self;
//    
//    UIButton *create = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.view addSubview:create];
//    create.frame = CGRectOffset(_joinNameText.frame, 0.0f, 150.0f);
//    create.backgroundColor = [UIColor blackColor];
//    create.titleLabel.textColor = [UIColor whiteColor];
//    [create setTitle:@"Create" forState:UIControlStateNormal];
//    [create addTarget:self action:@selector(Create) forControlEvents:UIControlEventTouchUpInside];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)Join
{
    if (_joinNameText.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入房间名" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    self.sessionHelper = [[SessionHelper alloc] initWithJoinRoom:_joinNameText.text WithPlayerName:_name];
    MGPeersViewController *peersVC = [[MGPeersViewController alloc] initWithSession:_sessionHelper];
    [self.navigationController pushViewController:peersVC animated:YES];
//    MCBrowserViewController *viewController = [[MCBrowserViewController alloc] initWithServiceType:self.sessionHelper.serviceType
//                                                                                           session:self.sessionHelper.session];
//    viewController.delegate = self;
//    
//    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)Create
{
    self.sessionHelper = [[SessionHelper alloc] initWithCreateRoom:_createNameText.text WithPlayerName:_name];

}

#pragma mark - MCBrowserViewControllerDelegate methods

- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController
      shouldPresentNearbyPeer:(MCPeerID *)peerID
            withDiscoveryInfo:(NSDictionary *)info
{
    return YES;
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
