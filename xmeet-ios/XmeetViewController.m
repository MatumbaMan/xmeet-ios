//
//  XmeetViewController.m
//  xmeet-ios
//
//  Created by HouKinglong on 15/8/14.
//  Copyright (c) 2015年 Xmeet. All rights reserved.
//

#import "XmeetViewController.h"
#import "XmeetMessageCell.h"
#import "XmeetUtils.h"
#import "XmeetMessage.h"
#import "XmeetTools.h"
#import "SRWebSocket.h"

#import "XmeetHandler.h"

@interface XmeetViewController ()<UITableViewDataSource, UITableViewDelegate, SRWebSocketDelegate, XmeetDelegate>

@property (nonatomic, retain) UITableView * mMessageList;
@property (nonatomic, retain) UIView *      mSendView;
@property (nonatomic, retain) UITextField * mMessageText;

@property (nonatomic, retain) NSMutableArray * mData;
@property (nonatomic, retain) XmeetHandler * mHandler;
@property (nonatomic, retain) SRWebSocket * mWebSocket;

@property (nonatomic, copy) NSString * mNickname;
@property (nonatomic, copy) NSString * mNestid;

@property (nonatomic, assign) BOOL isPush;
@end


#define VIEW_HEIGHT ([[UIScreen mainScreen]bounds].size.height - (IOS_VERSION >= 7.0 ? 0 : 64) - 48)

@implementation XmeetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     NSLog(@"viewDidLoad");
    _mHandler = [[XmeetHandler alloc]init];
    _mHandler.delegate = self;
    _mWebSocket = [[SRWebSocket alloc]initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self buildUrl]]]];
    _mWebSocket.delegate = self;
    [_mWebSocket open];
}

- (NSString *)buildUrl {
    _mNickname = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_nickname"];
    if (_mNickname == nil)
        _mNickname = @"";
    NSString * bd = [[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString *)kCFBundleIdentifierKey];
    _mNestid = [XmeetTools md5:bd];
    if (_mNestid == nil)
        _mNestid = [XmeetTools md5:@"com.xmeet.iosclient"];
    return [NSString stringWithFormat:@"ws://meet.xpro.im:8080/xgate/websocket/%@?nickname=%@", _mNestid, _mNickname];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
    [self initNavigation];
    [self initListView];
    [self initSendeView];
    NSLog(@"loadView");
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear");
}

- (void)viewWillAppear:(BOOL)animated {
//    NSLog(@"viewWillAppear");
    [self scrollTableToFoot:YES];
}

- (void)initNavigation {
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置navigationbar背景颜色
    if (IOS_VERSION >= 7.0) {
        self.navigationController.navigationBar.translucent = YES;
    } else {

    }
    
    self.navigationItem.backBarButtonItem.title = @"返回";
    
    //设置右按钮
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xmeet_title_user"] style:UIBarButtonItemStylePlain target:self action:@selector(rename)];
    self.navigationItem.rightBarButtonItem = right;
    
    //设置title颜色
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationItem.title = @"我的聊天室";
    
    UIImage * im = [UIImage imageNamed:@"xmeet_navigation_bar"];
    [self.navigationController.navigationBar setBackgroundImage:im forBarMetrics:UIBarMetricsDefault];
    
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 52, 30)];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    UIImageView * backImage = [[UIImageView alloc]initWithFrame:CGRectMake(3, 8, 7, 14)];
    backImage.image = [UIImage imageNamed:@"xmeet_back_arrow"];
    [backButton addSubview:backImage];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor clearColor]];
    
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = back;
    
//    [self.navigationController.navigationBar setBackgroundColor:kGeneralColor(57,67,70)];
}

- (void)initListView {
    _mMessageList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, VIEW_HEIGHT)];
//    _mMessageList.backgroundColor = [UIColor redColor];
    _mMessageList.delegate = self;
    _mMessageList.dataSource = self;
    _mMessageList.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mMessageList.allowsSelection = NO;
    [self.view addSubview:_mMessageList];
    
    _mData = [[NSMutableArray alloc]init];
//    for (int i = 0; i<12; i++)
//    {
//        XmeetMessage * message = [[XmeetMessage alloc]init];
//        message.message = [NSString stringWithFormat:@"需要重载此方法，%d", i];
//        message.time = @"2015-08-08 00:00:00";
//        message.nickName = @"ronaldo1sdfasdfas";
//        message.type = random()%3;
//        [_mData addObject:message];
//    }
    
    
}

- (void)setShowType:(BOOL)flag {
    _isPush = flag;
}

- (void)backClick {
    if (_isPush)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initSendeView {
    _mSendView = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_HEIGHT, VIEW_WEIGHT, 48)];
    _mSendView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"xmeet_navigation_bar"]];
    [self.view addSubview:_mSendView];
    
    _mMessageText = [[UITextField alloc]initWithFrame:CGRectMake(10, 4, VIEW_WEIGHT - 80, 40)];
    _mMessageText.returnKeyType = UIReturnKeySend;
    _mMessageText.placeholder = @"请输入...";
    _mMessageText.borderStyle = UITextBorderStyleRoundedRect;
    _mMessageText.font = [UIFont fontWithName:FONT_NAME size:14];
    [_mSendView addSubview:_mMessageText];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_WEIGHT - 60, 9, 50, 30)];
    button.backgroundColor = [UIColor clearColor];
    button.layer.backgroundColor = kGeneralColor(234, 40, 50).CGColor;
    button.layer.cornerRadius = 5.0f;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [_mSendView addSubview:button];
    
    //键盘遮挡问题
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *keyboardBoundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    
    NSInteger offset = keyboardBounds.origin.y - 48 ;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration + 0.4];
    
    _mSendView.frame = CGRectMake(0, offset, VIEW_HEIGHT, 48);
    _mMessageList.frame = CGRectMake(0, 0, VIEW_WEIGHT, offset);
    
    [self scrollTableToFoot:YES];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration + 0.4];

    _mSendView.frame = CGRectMake(0, VIEW_HEIGHT, VIEW_WEIGHT, 48);
    
    [UIView commitAnimations];
    
    _mMessageList.frame = CGRectMake(0, 0, VIEW_WEIGHT, VIEW_HEIGHT);
}

- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.mMessageList numberOfSections];
    if (s<1) return;
    NSInteger r = [self.mMessageList numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.mMessageList scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

#pragma rename
- (void)rename {
    [self.view endEditing:YES];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"昵称修改" message:@"请输入新的名字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma sendMessage
- (void)sendMessage {
    [_mWebSocket send:_mMessageText.text];
    _mMessageText.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.mMessageText == textField)
        return NO;
    return YES;
}

#pragma mark alertview deltegate
- (void)alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //得到输入框
        UITextField *tf=[alertView textFieldAtIndex:0];
        if (tf && ![tf.text isEqualToString:@""])
            [_mWebSocket send:[NSString stringWithFormat:@"@changename:%@", tf.text]];
    }
}

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XmeetMessage * msg = [_mData objectAtIndex:indexPath.row];
    if (msg.type == 2) {
        return 27;
    }
    
    CGSize size = [XmeetTools getMessageSize:msg font:18 flag:true];
    
    return size.height + 48;
    
//    return size.height + 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XmeetMessage * message = nil;
    if (indexPath.row < _mData.count)
    {
        message = [_mData objectAtIndex:indexPath.row];
    }
    NSString * reuseStr = [NSString stringWithFormat:@"%zi", indexPath.row];
    XmeetMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseStr];
    if (!cell)
    {
        cell = [[XmeetMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseStr message:message];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


#pragma websocket delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Websocket connected.");

}

-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"Websocket failed with error %@", error);

}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    [_mHandler parseMessage:message];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Websocket closed.");

}

#pragma mark handler delegate
- (void)onJoin:(XmeetMessage *) message {
    [self insertData:message];
}

- (void)onLeave:(XmeetMessage *) message {
    [self insertData:message];
}

- (void)onMessage:(XmeetMessage *) message {
    [self insertData:message];
}

- (void)onChangeName:(XmeetMessage *)message {
    [self insertData:message];
}

- (void)onHistroy:(NSMutableArray *)messages {
    for (XmeetMessage * message in messages) {
        [self insertData:message];
    }
}

- (void)insertData:(XmeetMessage *) message {
    [_mData addObject:message];
    
    [_mMessageList beginUpdates];
    NSIndexPath * index = [NSIndexPath indexPathForRow:_mData.count - 1 inSection:0];
    [_mMessageList insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationRight];
    [_mMessageList endUpdates];
    
    _mMessageText.text = @"";
    [self scrollTableToFoot:YES];
}

@end
