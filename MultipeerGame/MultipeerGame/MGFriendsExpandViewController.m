//
//  MGFriendsExpandViewController.m
//  MCDemo
//
//  Created by wendy on 6/28/14.
//  Copyright (c) 2014 baidu. All rights reserved.
//

#import "MGFriendsExpandViewController.h"
#import "MGFriendsExpandView.h"
#import "MGCommonUtility.h"
#import "MGAppDelegate.h"

@interface MGFriendsExpandViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *friendsTableView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIBarButtonItem *sendMessageButton;
@property (nonatomic, strong) UIToolbar *bottomToolBar;

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, assign) BOOL isMessageShow;
@property (nonatomic, assign) BOOL isMessageShowCanceled;

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, assign) BOOL isAppear;

@property (nonatomic, strong) NSMutableArray *myPeersArray;
@property (nonatomic, strong) MCPeerID *selectedPeerID;

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
    
    _myPeersArray = [[NSMutableArray alloc] initWithCapacity:3];
    MCPeerID *all = [[MCPeerID alloc] initWithDisplayName:@"all"];
    [_myPeersArray addObject:all];
    _selectedPeerID = all;
    for (MCPeerID *peerId in _sessionHelper.connectedPeerIDs)
    {
        [_myPeersArray addObject:peerId];
    }
    
    _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    _coverView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFriendExpand)];
    [_coverView addGestureRecognizer:tapRecognizer];
    [self.view addSubview:_coverView];
    
    _friendsTableView = [[UITableView alloc] initWithFrame:CGRectMake(KFRIEND_APPLICATION_SIZE_WIDTH, KFRIEND_EXPAND_BACK_BUTTON_HEIGHT + 20, KFRIEND_EXPAND_LIST_WIDTH, KFRIEDN_EXPAND_LIST_HEIGHT)];
    _friendsTableView.backgroundColor = [UIColor clearColor];
    _friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_friendsTableView setDelegate:self];
    [_friendsTableView setDataSource:self];
    [self.view addSubview:_friendsTableView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, 0, 40, KFRIEND_EXPAND_KEYBOARD_HEIGHT)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.text = @"to all:";
    
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 7, 210, KFRIEND_EXPAND_KEYBOARD_HEIGHT)];
    _inputTextField.borderStyle = UITextBorderStyleRoundedRect;
    _inputTextField.backgroundColor = [UIColor whiteColor];
    _inputTextField.delegate = self;
    _inputTextField.returnKeyType = UIReturnKeySend;
    _inputTextField.placeholder = @"to all:";
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -KFRIEND_MESSAGE_HEIGHT, KFRIEND_APPLICATION_SIZE_WIDTH, KFRIEND_MESSAGE_HEIGHT)];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *messageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageHide)];
    [_messageLabel addGestureRecognizer:messageTapRecognizer];
    
    MGAppDelegate *delegate = (MGAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_messageLabel];
    
    _bottomToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height - 44, 320, 44)];
    [self.view addSubview:_bottomToolBar];

    _sendMessageButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage)];
    UIBarButtonItem *inputItem = [[UIBarButtonItem alloc] initWithCustomView:_inputTextField];
//    UIBarButtonItem *nameItem = [[UIBarButtonItem alloc] initWithCustomView:_nameLabel];
    
    UIButton *phtoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phtoBtn.frame = CGRectMake(0, 0, 25, KFRIEND_EXPAND_KEYBOARD_HEIGHT);
    [phtoBtn setImage:[UIImage imageNamed:@"PhotoButton.png"] forState:UIControlStateNormal];
 
    UIBarButtonItem *photoItem = [[UIBarButtonItem alloc] initWithCustomView:phtoBtn];
    [photoItem setTintColor:[UIColor lightGrayColor]];
    [photoItem setStyle:UIBarButtonItemStyleBordered];
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:photoItem, inputItem, _sendMessageButton, nil];
    [_bottomToolBar setItems:items];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    MGFriendsExpandView *contentView = (MGFriendsExpandView *)self.view;
    contentView.isAppear = NO;
    contentView.toolbarFrame = _bottomToolBar.frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

- (void)showFriends
{
    self.view.backgroundColor = [UIColor clearColor];
  
    [UIView animateWithDuration:0.3 animations:^(void) {
        _friendsTableView.frame = CGRectMake(KFRIEND_APPLICATION_SIZE_WIDTH - KFRIEND_EXPAND_LIST_WIDTH,  _friendsTableView.frame.origin.y, KFRIEND_EXPAND_LIST_WIDTH, _friendsTableView.bounds.size.height);
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
         _friendsTableView.frame = CGRectMake(KFRIEND_APPLICATION_SIZE_WIDTH, _friendsTableView.frame.origin.y, KFRIEND_EXPAND_LIST_WIDTH, _friendsTableView.bounds.size.height);
     } completion:^(BOOL finished)
     {
         ;
     }];
}

- (void)hideBottomView
{
    [_inputTextField resignFirstResponder];
};

#pragma mark - UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_myPeersArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KFRIEND_EXPAND_LIST_CELL_HEIGHT - 16, KFRIEND_EXPAND_LIST_WIDTH, 20)];
        nameLabel.tag = 10000;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:15];
        [cell addSubview:nameLabel];
    }
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:10000];
    MCPeerID *f = [_myPeersArray objectAtIndex:indexPath.row];
    nameLabel.text = [NSString stringWithFormat:@" %@", f.displayName];
    
    if ([f.displayName isEqualToString:_selectedPeerID.displayName])
    {
        nameLabel.textColor = KMG_BLUE_COLOR;
    }
    else
    {
        nameLabel.textColor = [UIColor blackColor];
    }
    
    UIImage *sourceImage = [MGCommonUtility getImageByHashString:f.displayName];
    UIImage *image = [UIImage imageWithCGImage:sourceImage.CGImage scale:5 orientation:UIImageOrientationUp];
    cell.imageView.image = image;

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KFRIEND_EXPAND_LIST_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedPeerID = [_myPeersArray objectAtIndex:indexPath.row];
    _nameLabel.text = [NSString stringWithFormat: @"to %@:", _selectedPeerID.displayName];

    _inputTextField.text = @"";
    _inputTextField.placeholder =  [NSString stringWithFormat: @"to %@:", _selectedPeerID.displayName];
    [_inputTextField becomeFirstResponder];
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:10000];
    nameLabel.textColor = [UIColor blackColor];
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
    [self hideFriends];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger length = _inputTextField.text.length - range.length + string.length;
    if (length > 0) {
        self.sendMessageButton.enabled = YES;
    }
    else {
        self.sendMessageButton.enabled = NO;
    }
    return YES;
}

#pragma mark - message

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
        [self performSelector:@selector(messageHide) withObject:nil afterDelay:2.0];
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
    _messageLabel.text = [NSString stringWithFormat:@"To %@: %@", name, message];
    [self messageShow];
}

-(void)sendMessage
{
//    [self showMessage:_selectedPeerID.displayName message:_inputTextField.text];
    
    NSMutableDictionary *contentDict = [[NSMutableDictionary alloc] init];
    [contentDict setValue:_selectedPeerID.displayName forKey:@"name"];
    [contentDict setValue:_inputTextField.text forKey:@"content"];
    
    NSMutableDictionary *messageDict = [[NSMutableDictionary alloc] init];
    [messageDict setValue:contentDict forKey:@"message"];
    
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDict options:0 error:nil];
    if ([_selectedPeerID.displayName isEqualToString:@"all"])
    {
        [_sessionHelper sendDataToAll:messageData];
    }
    else
    {
        [_sessionHelper sendData:messageData toPeerID:_selectedPeerID];
    }
    
    [self hideBottomView];
    _inputTextField.text = @"";
}

- (void)showFriendsList
{
    if (_friendsTableView.frame.origin.x != KFRIEND_APPLICATION_SIZE_WIDTH)
    {
        [self hideFriendExpand];
    }
    else
    {
        [self showFriends];
    }
}


#pragma mark - Toolbar animation helpers

// Helper method for moving the toolbar frame based on user action
- (void)moveToolBarUp:(BOOL)up forKeyboardNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    // Animate up or down
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
 
    [_bottomToolBar setFrame:CGRectMake(_bottomToolBar.frame.origin.x, _bottomToolBar.frame.origin.y + (keyboardFrame.size.height * (up ? -1 : 1)), _bottomToolBar.frame.size.width, _bottomToolBar.frame.size.height)];

    MGFriendsExpandView *contentView = (MGFriendsExpandView *)self.view;
    contentView.isAppear = YES;
    contentView.toolbarFrame = _bottomToolBar.frame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // move the toolbar frame up as keyboard animates into view
    [self moveToolBarUp:YES forKeyboardNotification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    // move the toolbar frame down as keyboard animates into view
    [self moveToolBarUp:NO forKeyboardNotification:notification];
}

@end
