//
//  MGRoomViewController.m
//  MultipeerGame
//
//  Created by Admin on 14-6-28.
//  Copyright (c) 2014年 baidubox. All rights reserved.
//

#import "MGPeersViewController.h"
#import "MGCommonUtility.h"
#import "MGHappyShakeViewController.h"

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
    
    UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(50.0f, 500.0f, 220.0f, 30.0f)];
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[[UIImage imageNamed:@"homebtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 10, 10)] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    _sessionHelper.delegate = self;
    
    [self addNewUser:_sessionHelper.myPeerID.displayName];
    for (MCPeerID *item in _sessionHelper.connectedPeerIDs)
    {
        [self addNewUser:item.displayName];
    }
}

#pragma mark - user logic
// 用户进入响应
- (void)addNewUser:(NSString *)userName
{
    CGPoint offset = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0f, [UIScreen mainScreen].bounds.size.height/2.0f);
    
    NSMutableArray * pointsArray = [NSMutableArray array];
    
    // 添加新对象
    MGUserCharactor * newUser = [[MGUserCharactor alloc] init];
    newUser.displayName = userName;
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
    
    // 更新已有对象座标
    for (NSUInteger i = 0; i < ([self.userCharactorArray count] - 1) ; i++) {
        MGUserCharactor * user = [self.userCharactorArray objectAtIndex:i];
        
        user.iconMovetoPosition = [[pointsArray objectAtIndex:i] CGPointValue];
        
        [UIView animateWithDuration:0.6f animations:^{
            user.charatorIcon.center = user.iconMovetoPosition;
        }
        completion:^(BOOL finished)
        {
            user.iconCurrentPosition = user.iconMovetoPosition;//此处应该动画
        }];
    }
    
    newUser.charatorIcon.center = newUser.iconCurrentPosition;
    newUser.charatorIcon.alpha = 0.0f;
    [self.view addSubview:newUser.charatorIcon];
    
    [UIView animateWithDuration:1.0f animations:^{
        newUser.charatorIcon.alpha = 1.0f;
    }
    completion:^(BOOL finished)
    {
    }];
}

// 用户退出响应
- (void)deleteUser:(NSString *)userName
{
    CGPoint offset = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0f, [UIScreen mainScreen].bounds.size.height/2.0f);
    
    NSMutableArray * pointsArray = [NSMutableArray array];
    
    NSInteger index = -1;
    for (MGUserCharactor * user in self.userCharactorArray)
    {
        if ([user.displayName isEqualToString:userName])
        {
            break;
        }
        index ++;
    }
    
    if (index >= -1 && index < (self.userCharactorArray.count - 1))
    {
        MGUserCharactor * user = [self.userCharactorArray objectAtIndex:0];
        [pointsArray removeObjectAtIndex:(index+1)];
        
        [UIView animateWithDuration:0.6f animations:^{
            user.charatorIcon.alpha = 0.0f;
        }
        completion:^(BOOL finished)
        {
            [user.charatorIcon removeFromSuperview];
        }];
    }
    
    switch ([self.userCharactorArray count]) {
        case 0:
            break;
        case 1:
            {
                MGUserCharactor * user = [self.userCharactorArray objectAtIndex:0];
                user.iconMovetoPosition = CGPointMake(0.0f + offset.x, 0.0f + offset.y);
                
                [UIView animateWithDuration:0.6f animations:^{
                    user.charatorIcon.center = user.iconMovetoPosition;
                }
                completion:^(BOOL finished){
                    user.iconCurrentPosition = user.iconMovetoPosition;
                }];
            }
            break;
        case 2:
            {
                MGUserCharactor * user = [self.userCharactorArray objectAtIndex:0];
                user.iconMovetoPosition = CGPointMake(0.0f + offset.x, 0.0f + offset.y);
                [UIView animateWithDuration:0.6f animations:^{
                    user.charatorIcon.center = user.iconMovetoPosition;
                }
                 completion:^(BOOL finished){
                     user.iconCurrentPosition = user.iconMovetoPosition;
                 }];
                
                user = [self.userCharactorArray objectAtIndex:1];
                user.iconMovetoPosition = CGPointMake(100.0f + offset.x, 0.0f + offset.y);
                [UIView animateWithDuration:0.6f animations:^{
                    user.charatorIcon.center = user.iconMovetoPosition;
                }
                 completion:^(BOOL finished){
                     user.iconCurrentPosition = user.iconMovetoPosition;
                 }];
            }
            break;
        default:
            {
                pointsArray = [MGCommonUtility getPolyPointsBySizesCount:[self.userCharactorArray count]+1 radius:120.0f startAngle:0.0f offset:offset];
                
                // 更新已有对象座标
                for (NSUInteger i = 0; i < [self.userCharactorArray count] ; i++) {
                    
                    MGUserCharactor * user = [self.userCharactorArray objectAtIndex:i];
                    
                    user.iconMovetoPosition = [[pointsArray objectAtIndex:i] CGPointValue];
                    
                    [UIView animateWithDuration:0.6f animations:^{
                        user.charatorIcon.center = user.iconMovetoPosition;
                    }
                    completion:^(BOOL finished)
                    {
                        user.iconCurrentPosition = user.iconMovetoPosition;//此处应该动画
                    }];
                }
            }
            break;
    }
}

#pragma mark - events
- (void)startPlay
{
    NSData *startData = [NSJSONSerialization dataWithJSONObject:@{@"startplay": @"start"} options:0 error:nil];
    [self.sessionHelper sendDataToAll:startData];
    
    MGHappyShakeViewController * shakeViewController = [[MGHappyShakeViewController alloc] initWithNibName:@"MGHappyShakeViewController" bundle:nil];
    shakeViewController.sessionHelper = self.sessionHelper;
    [self.navigationController pushViewController:shakeViewController animated:YES];
}

#pragma mark - delegate

- (void)sessionHelperDidAddPeers:(SessionHelper *)sessionHelper addedPeer:(MCPeerID *)peerID
{
    [self addNewUser:peerID.displayName];
}

- (void)sessionHelperDidRemovePeers:(SessionHelper *)sessionHelper removedPeer:(MCPeerID *)peerID
{
    [self deleteUser:peerID.displayName];
}

- (void)sessionHelperDidRecieveData:(NSData *)data peer:(MCPeerID *)peerID
{
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *startStr = jsonDict[@"startplay"];
    if (startStr && startStr .length > 0)
    {
        [self startPlay];
    }
}

@end
