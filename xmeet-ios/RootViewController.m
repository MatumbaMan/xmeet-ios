//
//  RootViewController.m
//  xmeet-ios
//
//  Created by HouKinglong on 15/8/14.
//  Copyright (c) 2015年 Xmeet. All rights reserved.
//

#import "RootViewController.h"
#import "XmeetViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    NSString * bd = [[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString *)kCFBundleIdentifierKey];
    NSLog(@"%@", bd);
    XmeetViewController *xmeet = [[XmeetViewController alloc]init];
    [self.navigationController pushViewController:xmeet animated:YES];
}

@end
