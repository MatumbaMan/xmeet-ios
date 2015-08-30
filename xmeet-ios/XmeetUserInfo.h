//
//  XmeetUserInfo.h
//  xmeet-ios
//
//  Created by HouKinglong on 15/8/30.
//  Copyright (c) 2015年 Xmeet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmeetUserInfo : NSObject

@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, assign) BOOL isSelf;

@end
