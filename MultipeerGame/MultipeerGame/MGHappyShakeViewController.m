//
//  MGHappyShakeViewController.m
//  MultipeerGame
//
//  Created by canyingwushang on 6/28/14.
//  Copyright (c) 2014 baidubox. All rights reserved.
//

#import "MGHappyShakeViewController.h"

@interface MGHappyShakeViewController ()

@property (nonatomic, retain) UIImageView *image1;
@property (nonatomic, retain) UIImageView *image2;
@property (nonatomic, retain) UIImageView *image3;
@property (nonatomic, retain) UIImageView *action1;
@property (nonatomic, retain) UIImageView *action2;
@property (nonatomic, retain) UIImageView *action3;

@end

@implementation MGHappyShakeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int index1 = random()%6 + 1;
    int index2 = random()%6 + 1;
    int index3 = random()%6 + 1;
    
    //逐个添加骰子
    _image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"dice_%d.png", index1]]];
    _image1.frame = CGRectMake(75.0, 115.0, 45.0, 45.0);
    [_backgroundView addSubview:_image1];
    
    _image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"dice_%d.png", index2]]];
    _image2.frame = CGRectMake(135.0, 115.0, 45.0, 45.0);
    [_backgroundView addSubview:_image2];
    
    _image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"dice_%d.png", index3]]];
    _image3.frame = CGRectMake(195.0, 115.0, 45.0, 45.0);
    [_backgroundView addSubview:_image3];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
