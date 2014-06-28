//
//  MGHappyShakeViewController.m
//  MultipeerGame
//
//  Created by canyingwushang on 6/28/14.
//  Copyright (c) 2014 baidubox. All rights reserved.
//

#import "MGHappyShakeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SFCountdownView.h"
#import "MGFriendsExpandViewController.h"
#import "SessionHelper.h"

#define ANIMATION_PLAYIMAGE_DURATION  0.4f
#define ANIMATION_MOVE_DURATION  3.0f
#define ANIMATION_MOVE_REPEATCOUNT  3

#define WIDTH       200
#define HEIGHT      260

@interface MGHappyShakeViewController ()<SFCountdownViewDelegate, SessionHelperDelegate>

@property (nonatomic, retain) UIImageView *image1;
@property (nonatomic, retain) UIImageView *image2;
@property (nonatomic, retain) UIImageView *image3;
@property (nonatomic, retain) UIImageView *action1;
@property (nonatomic, retain) UIImageView *action2;
@property (nonatomic, retain) UIImageView *action3;
@property (nonatomic, strong) SFCountdownView *countDownView;

@property (nonatomic, strong) MGFriendsExpandViewController *friendsVC;

@property (nonatomic, assign) NSUInteger totalCount;

@property (nonatomic, strong) NSMutableDictionary *resultsDict;
@property (nonatomic, strong) NSDictionary *resultsDictBak;
@property (nonatomic, strong) NSArray *sortedKeys;

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

- (void)loadView
{
    [super loadView];
    [self addNaviRightItem];
}

- (void)addNaviRightItem
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    rightBtn.backgroundColor = [UIColor blackColor];
    [rightBtn setTitle:@"好友" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    UIBarButtonItem *tempItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home.png"] style:UIBarButtonItemStylePlain target:nil action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)rightAction
{
    [_friendsVC showFriendsList];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backgroundView.frame = CGRectMake(_backgroundView.frame.origin.x, _backgroundView.frame.origin.y + 60, _backgroundView.frame.size.width, _backgroundView.frame.size.height);
    
    int index1 = random()%6 + 1;
    int index2 = random()%6 + 1;
    int index3 = random()%6 + 1;
    
    //逐个添加骰子
    _image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"dice_%d.png", index1]]];
    _image1.frame = CGRectMake(75.0, 75.0, 100.0, 100.0);
    [_backgroundView addSubview:_image1];
    
    _image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"dice_%d.png", index2]]];
    _image2.frame = CGRectMake(135.0, 205.0, 100.0, 100.0);
    [_backgroundView addSubview:_image2];
    
    _image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"dice_%d.png", index3]]];
    _image3.frame = CGRectMake(195.0, 115.0, 100.0, 100.0);
    [_backgroundView addSubview:_image3];
    
    // Do any additional setup after loading the view from its nib.
    
    _countDownView = [[SFCountdownView alloc] init];
    _countDownView.frame = self.view.bounds;
    [self.view addSubview:_countDownView];
    [_countDownView updateAppearance];
    [_countDownView start];
    _countDownView.delegate = self;
    
    if (_sessionHelper)
    {
        _sessionHelper.delegate = self;
    }
    
    _friendsVC = [[MGFriendsExpandViewController alloc] init];
    _friendsVC.sessionHelper = _sessionHelper;
    [self.view addSubview:_friendsVC.view];
    
    _resultTableView.delegate = self;
    _resultTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) countdownFinished:(SFCountdownView *)view
{
    [view removeFromSuperview];
    [self bobing];
}

- (IBAction)startPlay:(id)sender
{
    [self bobing];
}

- (void)bobing
{
    //引入音频文件
    //    SystemSoundID sound1;
    //    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"yao" ofType:@"wav"];//音频文件的路径
    //    CFURLRef sound1URL = (CFURLRef)[NSURL fileURLWithPath:path1];//将路径转换为CFURLRef
    //    AudioServicesCreateSystemSoundID(sound1URL, &sound1);//加载音频文件并与指定soundID联系起来
    //    AudioServicesPlayAlertSound(sound1);//播放音频文件
    
    static SystemSoundID soundIDTest = 0;
    
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"yao" ofType:@"wav"];
    
    if (path) {
        AudioServicesCreateSystemSoundID( (__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest );
    }
    
    AudioServicesPlaySystemSound( soundIDTest );
    
    //隐藏初始位置的骰子
    _image1.hidden = YES;
    _image2.hidden = YES;
    _image3.hidden = YES;
    _action1.hidden = YES;
    _action2.hidden = YES;
    _action3.hidden = YES;
    
    //******************旋转动画的初始化******************
    //转动骰子的载入
    NSArray *myImages = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"dice_Action_0.png"],
                         [UIImage imageNamed:@"dice_Action_1.png"],
                         [UIImage imageNamed:@"dice_Action_2.png"],
                         [UIImage imageNamed:@"dice_Action_3.png"],nil];
    
    NSArray *myImages2 = [NSArray arrayWithObjects:
                          [UIImage imageNamed:@"dice_Action_3.png"],
                          [UIImage imageNamed:@"dice_Action_1.png"],
                          [UIImage imageNamed:@"dice_Action_2.png"],
                          [UIImage imageNamed:@"dice_Action_0.png"],nil];
    
    NSArray *myImages3 = [NSArray arrayWithObjects:
                          [UIImage imageNamed:@"dice_Action_2.png"],
                          [UIImage imageNamed:@"dice_Action_0.png"],
                          [UIImage imageNamed:@"dice_Action_1.png"],
                          [UIImage imageNamed:@"dice_Action_3.png"],nil];
    //骰子1的转动图片切换
    UIImageView *dong11 = [[UIImageView alloc] initWithFrame:CGRectMake(85.0, 75.0, 100.0, 100.0)];
    dong11.animationImages = myImages;
    dong11.animationDuration = ANIMATION_PLAYIMAGE_DURATION;
    [dong11 startAnimating];
    [_backgroundView addSubview:dong11];
    _action1 = dong11;
    
    //骰子2的转动图片切换
    UIImageView *dong12 = [[UIImageView alloc] initWithFrame:CGRectMake(135.0, 205.0, 100.0, 100.0)];
    dong12.animationImages = myImages2;
    dong12.animationDuration = ANIMATION_PLAYIMAGE_DURATION;
    [dong12 startAnimating];
    [_backgroundView addSubview:dong12];
    _action2 = dong12;
    
    //骰子3的转动图片切换
    UIImageView *dong13 = [[UIImageView alloc] initWithFrame:CGRectMake(195.0, 115.0, 100.0, 100.0)];
    dong13.animationImages = myImages3;
    dong13.animationDuration = ANIMATION_PLAYIMAGE_DURATION;
    [dong13 startAnimating];
    [_backgroundView addSubview:dong13];
    _action3 = dong13;
    
    [self performSelector:@selector(stop) withObject:nil afterDelay:ANIMATION_MOVE_DURATION];
    
//    //******************旋转动画******************
//    //设置动画
//    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    [spin setToValue:[NSNumber numberWithFloat:M_PI * 16.0]];
//    [spin setDuration:4];
//    //******************位置变化******************
//    //骰子1的位置变化
//    
//    srand((unsigned)time(0));  //不加这句每次产生的随机数不变
//    //骰子1的结果
//    int randx = (rand() % WIDTH) + 50.0f;
//    int randy = (rand() % HEIGHT) + 50.0f;
//    CGPoint p1 = CGPointMake(randx * 1.0f, randy*1.0f);
//    
//    randx = (rand() % WIDTH) + 50.0f;
//    randy = (rand() % HEIGHT) + 50.0f;
//    CGPoint p2 = CGPointMake(randx * 1.0f, randy*1.0f);
//    
//    randx = (rand() % WIDTH) + 50.0f;
//    randy = (rand() % HEIGHT) + 50.0f;
//    CGPoint p3 = CGPointMake(randx * 1.0f, randy*1.0f);
//    
//    randx = (rand() % WIDTH) + 50.0f;
//    randy = (rand() % HEIGHT) + 50.0f;
//    CGPoint p4 = CGPointMake(randx * 1.0f, randy*1.0f);
//    
//    NSArray *keypoint = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4], nil];
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    [animation setValues:keypoint];
//    [animation setDuration:ANIMATION_MOVE_DURATION];
//    [animation setDelegate:self];
//    animation.repeatCount = ANIMATION_MOVE_REPEATCOUNT;
//    [_action1.layer setPosition:CGPointMake(85.0, 75.0)];
//    
//    randx = (rand() % WIDTH) + 50.0f;
//    randy = (rand() % HEIGHT) + 50.0f;
//    CGPoint p21 = CGPointMake(randx * 1.0f, randy*1.0f);
//    
//    randx = (rand() % WIDTH) + 50.0f;
//    randy = (rand() % HEIGHT) + 50.0f;
//    CGPoint p22 = CGPointMake(randx * 1.0f, randy*1.0f);
//    
//    randx = (rand() % WIDTH) + 50.0f;
//    randy = (rand() % HEIGHT) + 50.0f;
//    CGPoint p23 = CGPointMake(randx * 1.0f, randy*1.0f);
//    
//    randx = (rand() % WIDTH) + 50.0f;
//    randy = (rand() % HEIGHT) + 50.0f;
//    CGPoint p24 = CGPointMake(randx * 1.0f, randy*1.0f);
//    
//    NSArray *keypoint2 = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p21],[NSValue valueWithCGPoint:p22],[NSValue valueWithCGPoint:p23],[NSValue valueWithCGPoint:p24], nil];
//    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    [animation2 setValues:keypoint2];
//    [animation2 setDuration:ANIMATION_MOVE_DURATION];
//    animation2.repeatCount = ANIMATION_MOVE_REPEATCOUNT;
//    [animation2 setDelegate:self];
//    [_action2.layer setPosition:CGPointMake(135.0, 205.0)];
//    
//    
//    randx = (rand() % WIDTH) + 50.0f;
//    randy = (rand() % HEIGHT) + 50.0f;
//    CGPoint p31 = CGPointMake(randx * 1.0f, randy*1.0f);
//    
//    randx = (rand() % WIDTH) + 50.0f;
//    randy = (rand() % HEIGHT) + 50.0f;
//    CGPoint p32 = CGPointMake(randx * 1.0f, randy*1.0f);
//    
//    randx = (rand() % WIDTH) + 50.0f;
//    randy = (rand() % HEIGHT) + 50.0f;
//    CGPoint p33 = CGPointMake(randx * 1.0f, randy*1.0f);
//    
//    randx = (rand() % WIDTH) + 50.0f;
//    randy = (rand() % HEIGHT) + 50.0f;
//    CGPoint p34 = CGPointMake(randx * 1.0f, randy*1.0f);
//    
//    NSArray *keypoint3 = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p31],[NSValue valueWithCGPoint:p32],[NSValue valueWithCGPoint:p33],[NSValue valueWithCGPoint:p34], nil];
//    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    [animation3 setValues:keypoint3];
//    [animation3 setDuration:ANIMATION_MOVE_DURATION];
//    animation3.repeatCount = ANIMATION_MOVE_REPEATCOUNT;
//    [animation3 setDelegate:self];
//    [_action3.layer setPosition:CGPointMake(195.0, 115.0)];
    
    
//    //******************动画组合******************
//    //骰子1的动画组合
//    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
//    animGroup.animations = [NSArray arrayWithObjects: nil];
//    animGroup.duration = ANIMATION_MOVE_DURATION;
//    animGroup.autoreverses = YES;
//    [animGroup setDelegate:self];
//    [[_action1 layer] addAnimation:animGroup forKey:@"position"];
//    
//    //骰子2的动画组合
//    CAAnimationGroup *animGroup2 = [CAAnimationGroup animation];
//    animGroup2.animations = [NSArray arrayWithObjects: nil];
//    animGroup2.duration = ANIMATION_MOVE_DURATION;
//    animGroup2.autoreverses = YES;
//    [animGroup2 setDelegate:self];
//    [[_action2 layer] addAnimation:animGroup2 forKey:@"position"];
//    
//    //骰子3的动画组合
//    CAAnimationGroup *animGroup3 = [CAAnimationGroup animation];
//    animGroup3.animations = [NSArray arrayWithObjects: nil];
//    animGroup3.duration = ANIMATION_MOVE_DURATION;
//    animGroup3.autoreverses = YES;
//    [animGroup3 setDelegate:self];
//    [[_action3 layer] addAnimation:animGroup3 forKey:@"position"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //停止骰子自身的转动

}

- (void)stop
{
    [_action1 stopAnimating];
    [_action2 stopAnimating];
    [_action3 stopAnimating];
    
    //*************产生随机数，真正博饼**************
    srand((unsigned)time(0));  //不加这句每次产生的随机数不变
    //骰子1的结果
    int result1 = (rand() % 5) +1 ;
    NSString *str1 = [NSString stringWithFormat:@"dice_%d.png", result1];
    _action1.image = [UIImage imageNamed:str1];
    
    int result2 = (rand() % 5) +1 ;
    NSString *str2 = [NSString stringWithFormat:@"dice_%d.png", result2];
    _action2.image = [UIImage imageNamed:str2];
    
    int result3 = (rand() % 5) +1 ;
    NSString *str3 = [NSString stringWithFormat:@"dice_%d.png", result3];
    _action3.image = [UIImage imageNamed:str3];
    
    _totalCount = result1 + result2 + result3;
    NSLog(@"%ld", _totalCount);
    
    [self showDiceResult];
}

- (void)showDiceResult
{
    if (!_resultsDict)
    {
        _resultsDict = [[NSMutableDictionary alloc] init];
    }
    NSDictionary *resultDict = @{@"score": [NSNumber numberWithInteger:_totalCount] };
    NSData *scoreData = [NSJSONSerialization dataWithJSONObject:resultDict options:0 error:nil];
    [_sessionHelper sendDataToAll:scoreData];
    [_resultsDict setObject:[NSNumber numberWithInteger:_totalCount] forKey:@"本尊"];
    [_resultTableView reloadData];
}

- (void)sessionHelperDidAddPeers:(SessionHelper *)sessionHelper addedPeer:(MCPeerID *)peerID
{

}

- (void)sessionHelperDidRemovePeers:(SessionHelper *)sessionHelper removedPeer:(MCPeerID *)peerID
{
    
}

- (void)sessionHelperDidRecieveData:(NSData *)data peer:(MCPeerID *)peerID
{
    if (!_resultsDict)
    {
        _resultsDict = [[NSMutableDictionary alloc] init];
    }
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (jsonDict)
    {
        NSNumber *resNumber = [jsonDict objectForKey:@"score"];
        if (resNumber)
        {
            [_resultsDict setObject:resNumber forKey:peerID.displayName];
            [_resultTableView reloadData];
        };
        NSDictionary *jsonDictM = [jsonDict objectForKey:@"message"];
        if (jsonDictM)
        {
            NSString *name = [jsonDictM objectForKey:@"name"];
            NSString *content = [jsonDictM objectForKey:@"content"];
            if (name && content)
            {
                [_friendsVC showMessage:name message:content];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"fuckfuckfuck";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *key = [self.sortedKeys objectAtIndex:indexPath.row];
    cell.textLabel.text = key;
    NSNumber *value = [_resultsDictBak objectForKey:key];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [value intValue]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.resultsDictBak = _resultsDict;
    NSArray *keys = _resultsDictBak.allKeys;
    self.sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *num1 = [_resultsDictBak objectForKey:obj1];
        NSNumber *num2 = [_resultsDictBak objectForKey:obj2];
        if ([num1 intValue] > [num2 intValue])
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }];
    return [_resultsDictBak allKeys].count;
}

@end
