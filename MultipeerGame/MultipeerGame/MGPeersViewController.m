//
//  MGRoomViewController.m
//  MultipeerGame
//
//  Created by Admin on 14-6-28.
//  Copyright (c) 2014年 baidubox. All rights reserved.
//

#import "MGPeersViewController.h"

@interface MGPeersViewController ()

@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UIButton *clickToStartButton;
@property (nonatomic, retain) NSArray *userCharactorArray;

@end

@implementation MGPeersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Room";
    UIButton *backbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 20.0f)];
    [backbtn setTitle:@"Back" forState:UIControlStateNormal];
    [backbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = back;
    
    self.joinNameText = [[UITextField alloc] initWithFrame:CGRectMake(50.0f, 100.0f, 220.0f, 30.0f)];
    [self.view addSubview:_joinNameText];
    _joinNameText.borderStyle = UITextBorderStyleRoundedRect;
    _joinNameText.delegate = self;
    
    UIButton *join = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:join];
    join.frame = CGRectOffset(_joinNameText.frame, 0.0f, 50.0f);
    join.backgroundColor = [UIColor blackColor];
    join.titleLabel.textColor = [UIColor whiteColor];
    [join setTitle:@"Join" forState:UIControlStateNormal];
    [join addTarget:self action:@selector(Join) forControlEvents:UIControlEventTouchUpInside];
    
    self.createNameText = [[UITextField alloc] initWithFrame:CGRectOffset(_joinNameText.frame, 0.0f, 100.0f)];
    [self.view addSubview:_createNameText];
    _createNameText.borderStyle = UITextBorderStyleRoundedRect;
    _createNameText.delegate = self;
    
    UIButton *create = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:create];
    create.frame = CGRectOffset(_joinNameText.frame, 0.0f, 150.0f);
    create.backgroundColor = [UIColor blackColor];
    create.titleLabel.textColor = [UIColor whiteColor];
    [create setTitle:@"Create" forState:UIControlStateNormal];
    [create addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
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
    
}

- (void)create
{
    
}

@end
