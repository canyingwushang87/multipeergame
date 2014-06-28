//
//  MGRoomViewController.m
//  MultipeerGame
//
//  Created by Admin on 14-6-28.
//  Copyright (c) 2014年 baidubox. All rights reserved.
//

#import "MGPeersViewController.h"
#import "MGCommonUtility.h"

@interface MGUserCharactor ()
@end

@interface MGPeersViewController ()

@property (nonatomic, retain) UIButton *clickToStartButton;
@property (nonatomic, retain) NSMutableArray *userCharactorArray;
@property (nonatomic) SessionHelper *sessionHelper;

@end

@implementation MGUserCharactor


@end

@implementation MGPeersViewController

- (id)initWithSession:(SessionHelper *)sessionHelper
{
    self = [super init];
    if (self)
    {
        self.sessionHelper = sessionHelper;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Friends";
    self.userCharactorArray = [NSMutableArray array];
    
    
//    [self addNewUser:@"111"];
//    [self addNewUser:@"222"];
//    [self addNewUser:@"333"];
//    [self addNewUser:@"444"];
//    [self addNewUser:@"555"];
//    [self addNewUser:@"555"];
//    [self addNewUser:@"555"];
//    [self addNewUser:@"555"];
    
    
    /*UIButton *backbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 20.0f)];
    [backbtn setTitle:@"Back" forState:UIControlStateNormal];
    [backbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = back;*/
    
}

- (void)viewWillAppear:(BOOL)animated
{
    _sessionHelper.delegate = self;
    
    for (MCPeerID *item in _sessionHelper.connectedPeerIDs)
    {
        [self addNewUser:item.displayName];
    }
}

- (void)addNewUser:(NSString *)userName
{
    CGPoint offset = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0f, [UIScreen mainScreen].bounds.size.height/2.0f);
    
    NSMutableArray * pointsArray = [NSMutableArray array];
    
    // 添加新对象
    MGUserCharactor * newUser = [[MGUserCharactor alloc] init];
    newUser.charatorIcon = [[UIImageView alloc] initWithImage:[MGCommonUtility getImageByHashString:userName]];
    newUser.charatorIcon.frame = CGRectMake(0.0f, 0.0f, 60.0f, 60.0f);
    switch ([self.userCharactorArray count]) {
        case 0:
            {
                newUser.iconCurrentPosition = CGPointMake(0.0f + offset.x, 0.0f + offset.y);
                newUser.iconMovetoPosition = CGPointMake(0.0f + offset.x, 0.0f + offset.y);
                
                [pointsArray addObject:[NSValue valueWithCGPoint:newUser.iconCurrentPosition]];
            }
            break;
        case 1:
            {
                newUser.iconCurrentPosition = CGPointMake(100.0f + offset.x, 0.0f + offset.y);
                newUser.iconMovetoPosition = CGPointMake(100.0f + offset.x, 0.0f + offset.y);
                
                [pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(-100.0f + offset.x, 0.0f + offset.y)]];
                [pointsArray addObject:[NSValue valueWithCGPoint:newUser.iconCurrentPosition]];
            }
            break;
        default:
            {
                pointsArray = [MGCommonUtility getPolyPointsBySizesCount:[self.userCharactorArray count]+1 radius:120.0f startAngle:0.0f offset:offset];
                newUser.iconCurrentPosition = [[pointsArray objectAtIndex:[self.userCharactorArray count]] CGPointValue];
                newUser.iconMovetoPosition = newUser.iconCurrentPosition;
            }
            break;
    }
    [self.userCharactorArray addObject:newUser];
    newUser.charatorIcon.center = newUser.iconCurrentPosition;
    
    // 更新已有对象座标
    for (NSUInteger i = 0; i < ([self.userCharactorArray count] - 1) ; i++) {
        MGUserCharactor * user = [self.userCharactorArray objectAtIndex:i];
        
        user.iconMovetoPosition = [[pointsArray objectAtIndex:i] CGPointValue];
        
        [UIView animateWithDuration:1.0f animations:^{
            user.charatorIcon.center = user.iconMovetoPosition;
        }
        completion:^(BOOL finished)
        {
            user.iconCurrentPosition = user.iconMovetoPosition;//此处应该动画
        }];
    }
    
    [self.view addSubview:newUser.charatorIcon];
}

- (void)deleteUser:(NSString *)userName
{
    
}

- (void)sessionHelperDidAddPeers:(SessionHelper *)sessionHelper addedPeer:(MCPeerID *)peerID
{
    [self addNewUser:peerID.displayName];
}

- (void)sessionHelperDidRemovePeers:(SessionHelper *)sessionHelper removedPeer:(MCPeerID *)peerID
{
    
}
- (void)sessionHelperDidRecieveData:(NSData *)data peer:(MCPeerID *)peerID
{
    
}

@end
