//
//  MGViewController.m
//  MultipeerGame
//
//  Created by Admin on 14-6-28.
//  Copyright (c) 2014年 baidubox. All rights reserved.
//

#import "MGViewController.h"
#import "MGRoomViewController.h"
#import "MGHappyShakeViewController.h"
#import "MGPeersViewController.h"


@interface MGViewController ()

@property (nonatomic, retain) UITextField *nameText;

@end

@implementation MGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 120.0f, 320.0f, 50.0f)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"移动互联";
    label.font = [UIFont boldSystemFontOfSize:40.0f];
    [self.view addSubview:label];
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 200.0f, 220.0f, 20.0f)];
    tip.text = @"请输入用户ID";
    tip.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.view addSubview:tip];
    
    self.nameText = [[UITextField alloc] initWithFrame:CGRectMake(50.0f, 220.0f, 220.0f, 30.0f)];
    [self.view addSubview:_nameText];
    _nameText.borderStyle = UITextBorderStyleRoundedRect;
    _nameText.delegate = self;
    
    UIButton *start = [[UIButton alloc] initWithFrame:CGRectOffset(_nameText.frame, 0.0f, 50.0f)];
    [self.view addSubview:start];
    [start setBackgroundImage:[[UIImage imageNamed:@"homebtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 10, 10)] forState:UIControlStateNormal];
    start.titleLabel.textColor = [UIColor whiteColor];
    [start setTitle:@"Start" forState:UIControlStateNormal];
    [start addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)startPlay
{
    if (_nameText.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入用户名" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    MGRoomViewController *roomVC = [[MGRoomViewController alloc] initWithName:_nameText.text];
//    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:roomVC];
//    [self presentViewController:naviVC animated:YES completion:nil];

    /*MGPeersViewController *roomVC = [[MGPeersViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:roomVC animated:YES];*/
    
    /*MGHappyShakeViewController *roomVC = [[MGHappyShakeViewController alloc] initWithNibName:@"MGHappyShakeViewController" bundle:nil];
    [self.navigationController pushViewController:roomVC animated:YES];*/
//    MGHappyShakeViewController *roomVC = [[MGHappyShakeViewController alloc] initWithNibName:@"MGHappyShakeViewController" bundle:nil];
    [self.navigationController pushViewController:roomVC animated:YES];

}

//- (void)startPlay
//{
//    MGHappyShakeViewController *roomVC = [[MGHappyShakeViewController alloc] initWithNibName:@"MGHappyShakeViewController" bundle:nil];
//    [self.navigationController pushViewController:roomVC animated:YES];
//}

@end
