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

@interface MGViewController ()

@property (nonatomic, retain) UITextField *nameText;

@end

@implementation MGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.nameText = [[UITextField alloc] initWithFrame:CGRectMake(50.0f, 100.0f, 220.0f, 30.0f)];
    [self.view addSubview:_nameText];
    _nameText.borderStyle = UITextBorderStyleRoundedRect;
    _nameText.delegate = self;
    
    UIButton *start = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:start];
    start.frame = CGRectOffset(_nameText.frame, 0.0f, 50.0f);
    start.backgroundColor = [UIColor blackColor];
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

//- (void)startPlay
//{
//    MGRoomViewController *roomVC = [[MGRoomViewController alloc] initWithName:_nameText.text];
//    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:roomVC];
//    [self presentViewController:naviVC animated:YES completion:nil];
//}

- (void)startPlay
{
    MGHappyShakeViewController *roomVC = [[MGHappyShakeViewController alloc] initWithNibName:@"MGHappyShakeViewController" bundle:nil];
    [self.navigationController pushViewController:roomVC animated:YES];
}

@end
