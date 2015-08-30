//
//  XmeetMessage.h
//  xmeet-ios
//
//  Created by HouKinglong on 15/8/30.
//  Copyright (c) 2015年 Xmeet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmeetMessage : NSObject

@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * nickName;

@property (nonatomic, assign) int type;

@end
