//
//  XmeetMembers.m
//  xmeet-ios
//
//  Created by HouKinglong on 15/8/30.
//  Copyright (c) 2015年 Xmeet. All rights reserved.
//

#import "XmeetMembers.h"
#import "XmeetUserInfo.h"

@interface XmeetMembers ()

@property (nonatomic, retain) NSMutableArray * members;

@end

@implementation XmeetMembers

- (id)init {
    self = [super init];
    if (self) {
        _members = [[NSMutableArray alloc]init];
    }
    return self;
}

- (XmeetUserInfo *)queryMember:(NSString *) uid {
    XmeetUserInfo * result = [[XmeetUserInfo alloc]init];
    result.uid = uid;
    
    for (XmeetUserInfo * user in _members) {
        if ([user.uid isEqualToString:uid]) {
            result.nickname = user.nickname;
            result.isSelf = user.isSelf;
            break;
        }
    }
    return result;
}

- (void)addMembers:(NSMutableArray *)users {
    for (XmeetUserInfo * user in users) {
        [_members addObject:user];
    }
}

- (void)addMember:(XmeetUserInfo *)user {
    [_members addObject:user];
}

- (NSString *)removeMember:(NSString *)uid {
    XmeetUserInfo * user = [self queryMember:uid];
    [_members removeObject:user];
    return user.nickname;
}

- (void)renameMember:(NSString *)name uid:(NSString *)uid {
    for (XmeetUserInfo * user in _members) {
        if ([user.uid isEqualToString:uid]) {
            user.nickname = user.nickname;
            break;
        }
    }
}

@end
