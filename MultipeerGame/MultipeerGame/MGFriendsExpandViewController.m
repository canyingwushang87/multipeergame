//
//  MGFriendsExpandViewController.m
//  MCDemo
//
//  Created by wendy on 6/28/14.
//  Copyright (c) 2014 baidu. All rights reserved.
//

#import "MGFriendsExpandViewController.h"
#import "MGFriendsExpandView.h"

@interface MGFriendsExpandViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *friendsTableView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) Friend *currentFriend;

//@property (nonatomic, retain) UIView *messageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, assign) BOOL isMessageShow;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, assign) CGRect backButtonFrame;
@property (nonatomic, assign) BOOL isAppear;

@property (nonatomic, assign) BOOL isMessageShowCanceled;

@end

@implementation MGFriendsExpandViewController

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
    self.view = [[MGFriendsExpandView alloc] init];
    self.view.frame = CGRectMake(0.0f, 0.0f, KFRIEND_APPLICATION_SIZE_WIDTH, KFRIEND_APPLICATION_SIZE_HEIGHT);
    self.view.backgroundColor = [UIColor clearColor];
    _friends = [[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 0; i < 6; i ++)
    {
        Friend *f = [[Friend alloc] init];
        f.name = [NSString stringWithFormat:@"test%d", i];
        f.sex = 0;
        
        [_friends addObject:f];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _backButtonFrame = CGRectMake(KFRIEND_APPLICATION_SIZE_WIDTH - KFRIEND_EXPAND_LIST_WIDTH, 20, KFRIEND_EXPAND_LIST_WIDTH, KFRIEND_EXPAND_BACK_BUTTON_HEIGHT);
    MGFriendsExpandView *contentView = (MGFriendsExpandView *)self.view;
    contentView.isAppear = NO;
    contentView.backButtonFrame = _backButtonFrame;

    
    _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    _coverView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFriendExpand)];
    [_coverView addGestureRecognizer:tapRecognizer];
    [self.view addSubview:_coverView];
    
    [self addBackButton];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(KFRIEND_APPLICATION_SIZE_WIDTH, KFRIEND_EXPAND_BACK_BUTTON_HEIGHT + 20, KFRIEND_EXPAND_LIST_WIDTH, KFRIEDN_EXPAND_LIST_HEIGHT)];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:_maskView];

    _friendsTableView = [[UITableView alloc] initWithFrame:_maskView.bounds];
    _friendsTableView.backgroundColor = [UIColor clearColor];
    _friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_friendsTableView setDelegate:self];
    [_friendsTableView setDataSource:self];
    [_maskView addSubview:_friendsTableView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KFRIEND_APPLICATION_SIZE_HEIGHT - KFRIEND_EXPAND_KEYBOARD_HEIGHT, KFRIEND_APPLICATION_SIZE_WIDTH, KFRIEND_EXPAND_KEYBOARD_HEIGHT)];
    _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _bottomView.hidden = YES;
    [self.view addSubview:_bottomView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 75, KFRIEND_EXPAND_KEYBOARD_HEIGHT)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    [_bottomView addSubview:_nameLabel];
    
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, KFRIEND_APPLICATION_SIZE_WIDTH - 80, KFRIEND_EXPAND_KEYBOARD_HEIGHT)];
    _inputTextField.borderStyle = UITextBorderStyleRoundedRect;
    _inputTextField.backgroundColor = [UIColor whiteColor];
    _inputTextField.delegate = self;
    _inputTextField.returnKeyType = UIReturnKeySend;
    [_bottomView addSubview:_inputTextField];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -KFRIEND_MESSAGE_HEIGHT, KFRIEND_APPLICATION_SIZE_WIDTH, KFRIEND_MESSAGE_HEIGHT)];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_messageLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideFriendExpand
{
    [self hideFriends];
    [self hideBottomView];
    
    MGFriendsExpandView *contentView = (MGFriendsExpandView *)self.view;
    contentView.isAppear = NO;
}

- (void)addBackButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"friends.png"] forState:UIControlStateNormal];
    backButton.frame = _backButtonFrame;
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backAction:(id)sender
{
    if (_maskView.frame.origin.x == 0)
    {
        [self hideFriendExpand];
    }
    else
    {
        [self showFriends];
    }
}

- (void)showFriends
{
    self.view.backgroundColor = [UIColor clearColor];
  
    [UIView animateWithDuration:0.3 animations:^(void) {
        _maskView.frame = CGRectMake(KFRIEND_APPLICATION_SIZE_WIDTH - KFRIEND_EXPAND_LIST_WIDTH,  _maskView.frame.origin.y, KFRIEND_EXPAND_LIST_WIDTH, _maskView.bounds.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
    
    [self hideBottomView];
    
    MGFriendsExpandView *contentView = (MGFriendsExpandView *)self.view;
    contentView.isAppear = YES;
}

- (void)hideFriends
{
    
    self.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^(void)
     {
         _maskView.frame = CGRectMake(KFRIEND_APPLICATION_SIZE_WIDTH, _maskView.frame.origin.y, KFRIEND_EXPAND_LIST_WIDTH, _maskView.bounds.size.height);
     } completion:^(BOOL finished)
     {
         ;
     }];
}

- (void)hideBottomView
{
    _bottomView.frame = CGRectMake(0, KFRIEND_APPLICATION_SIZE_HEIGHT - KFRIEND_EXPAND_KEYBOARD_HEIGHT, KFRIEND_APPLICATION_SIZE_WIDTH - 20, KFRIEND_EXPAND_KEYBOARD_HEIGHT);
    _bottomView.hidden = YES;
    [_inputTextField resignFirstResponder];
};

#pragma mark - UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_friends count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KFRIEND_EXPAND_LIST_CELL_HEIGHT - 20, KFRIEND_EXPAND_LIST_WIDTH, 20)];
        nameLabel.tag = 10000;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:16];
        [cell addSubview:nameLabel];
    }
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:10000];
    Friend *f = [_friends objectAtIndex:indexPath.row];
    nameLabel.text = f.name;
    
    UIImage *sourceImage = [UIImage imageNamed:@"dice_2"];
    UIImage *image = [UIImage imageWithCGImage:sourceImage.CGImage scale:2 orientation:UIImageOrientationUp];
    cell.imageView.image = image;

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KFRIEND_EXPAND_LIST_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentFriend = [_friends objectAtIndex:indexPath.row];
    _bottomView.hidden = NO;
    _nameLabel.text = [NSString stringWithFormat: @"To %@:", _currentFriend.name];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _bottomView.frame = CGRectMake(0, KFRIEND_APPLICATION_SIZE_HEIGHT - 216 - KFRIEND_EXPAND_KEYBOARD_HEIGHT, KFRIEND_APPLICATION_SIZE_WIDTH - 20, KFRIEND_EXPAND_KEYBOARD_HEIGHT);
    [self hideFriends];
}

- (void)messageShow
{
    _isMessageShow = YES;
    self.view.backgroundColor = [UIColor clearColor];
    
    if (_isMessageShow)
    {
        _isMessageShowCanceled = YES;
        _messageLabel.frame = CGRectMake(0,  -KFRIEND_MESSAGE_HEIGHT, _messageLabel.frame.size.width, KFRIEND_MESSAGE_HEIGHT);
    }
    
    [UIView animateWithDuration:0.3 animations:^(void) {
        _messageLabel.frame = CGRectMake(0,  0, _messageLabel.frame.size.width, KFRIEND_MESSAGE_HEIGHT);
    } completion:^(BOOL finished) {
        _isMessageShowCanceled = NO;
        [self performSelector:@selector(messageHide) withObject:nil afterDelay:3.0];
    }];
}

- (void)messageHide
{
    if (_isMessageShowCanceled)
    {
        return;
    }
    self.view.backgroundColor = [UIColor clearColor];
    _messageLabel.frame = CGRectMake(0, -KFRIEND_MESSAGE_HEIGHT,  _messageLabel.frame.size.width, KFRIEND_MESSAGE_HEIGHT);
    _isMessageShow = NO;
}

- (void)showMessage:(NSString *)name message:(NSString *)message
{
    _messageLabel.text = [NSString stringWithFormat:@"%@: %@", name, message];
    [self messageShow];
    
//    [self hideBottomView];
//    _inputTextField.text = @"";
}

-(void)sendMessage
{
//    _messageLabel.text = [NSString stringWithFormat:@"%@:%@", _nameLabel.text, _inputTextField.text];//_inputTextField.text;
//    [self messageShow];
    
    NSMutableDictionary *contentDict = [[NSMutableDictionary alloc] init];
    [contentDict setValue:_nameLabel.text forKey:@"name"];
    [contentDict setValue:_inputTextField.text forKey:@"content"];
    
    NSMutableDictionary *messageDict = [[NSMutableDictionary alloc] init];
    [messageDict setValue:contentDict forKey:@"message"];
    
    NSData *scoreData = [NSJSONSerialization dataWithJSONObject:messageDict options:0 error:nil];
   
    [_sessionHelper sendDataToAll:scoreData];
    
    [self hideBottomView];
    _inputTextField.text = @"";
}

@end


@implementation Friend


@end
