//
//  XmeetMembers.h
//  xmeet-ios
//
//  Created by HouKinglong on 15/8/30.
//  Copyright (c) 2015年 Xmeet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XmeetUserInfo;

@interface XmeetMembers : NSObject

- (id)init;
- (XmeetUserInfo *)queryMember:(NSString *) uid;
- (void)addMembers:(NSMutableArray *)users;
- (void)addMember:(XmeetUserInfo *)user;
- (NSString *)removeMember:(NSString *)uid;
- (void)renameMember:(NSString *)name uid:(NSString *)uid;

@end
