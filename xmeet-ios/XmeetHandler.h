//
//  XmeetHandler.h
//  xmeet-ios
//
//  Created by Kinglong on 15/8/30.
//  Copyright (c) 2015年 Xmeet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmeetMessage.h"

@protocol XmeetDelegate <NSObject>

- (void)onJoin:(XmeetMessage *) message;
- (void)onLeave:(XmeetMessage *) message;
- (void)onMessage:(XmeetMessage *) message;
- (void)onChangeName:(XmeetMessage *)message;
- (void)onHistroy:(NSMutableArray *)messages;

@end

@interface XmeetHandler : NSObject

@property(nonatomic, assign) id<XmeetDelegate> delegate;

- (void)parseMessage:(id)message;
- (id)init;

@end
