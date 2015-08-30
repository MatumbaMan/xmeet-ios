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

@interface XmeetViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView * mMessageList;
@property (nonatomic, retain) UIView *      mSendView;

@property (nonatomic, retain) NSMutableArray * mData;
@end


#define VIEW_HEIGHT ([[UIScreen mainScreen]bounds].size.height - (IOS_VERSION >= 7.0 ? 0 : 64) - 48)

@implementation XmeetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     NSLog(@"viewDidLoad");
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
    NSLog(@"viewWillAppear");
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
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationItem.title = @"我的聊天室";
    
//    UIImage * im = [UIImage imageNamed:@"navigationbar"];
//    [self.navigationController.navigationBar setBackgroundImage:im forBarMetrics:UIBarMetricsDefault];
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
    for (int i = 0; i<12; i++)
    {
        XmeetMessage * message = [[XmeetMessage alloc]init];
        message.message = [NSString stringWithFormat:@"需要重载此方法，%d", i];
        message.time = @"2015-08-08 00:00:00";
        message.nickName = @"ronaldo1sdfasdfas";
        message.type = random()%3;
        [_mData addObject:message];
    }
}

- (void)initSendeView {
    _mSendView = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_HEIGHT, VIEW_WEIGHT, 48)];
    _mSendView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"xmeet_toolbar_bottom_bar"]];
    [self.view addSubview:_mSendView];
    
    UITextField * mMessageText = [[UITextField alloc]initWithFrame:CGRectMake(10, 4, VIEW_WEIGHT - 80, 40)];
    mMessageText.returnKeyType = UIReturnKeySend;
    mMessageText.placeholder = @"请输入...";
    mMessageText.borderStyle = UITextBorderStyleRoundedRect;
    mMessageText.font = [UIFont fontWithName:FONT_NAME size:14];
    [_mSendView addSubview:mMessageText];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_WEIGHT - 60, 9, 50, 30)];
    button.backgroundColor = [UIColor clearColor];
    button.layer.backgroundColor = kGeneralColor(234, 40, 50).CGColor;
    button.layer.cornerRadius = 5.0f;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [_mSendView addSubview:button];
}


#pragma rename
- (void)rename {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"昵称修改" message:@"请输入新的名字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma sendMessage
- (void)sendMessage {
    
}

#pragma mark alertview deltegate
- (void)alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //得到输入框
    UITextField *tf=[alertView textFieldAtIndex:0];
    NSLog(@"%@", tf.text);
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

@end
