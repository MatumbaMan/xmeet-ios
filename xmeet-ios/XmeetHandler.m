//
//  XmeetHandler.m
//  xmeet-ios
//
//  Created by Kinglong on 15/8/30.
//  Copyright (c) 2015年 Xmeet. All rights reserved.
//

#import "XmeetHandler.h"
#import "XmeetUserInfo.h"
#import "XmeetMembers.h"

#import "JSON.h"

@interface XmeetHandler ()

@property (nonatomic, retain)XmeetMembers * mMembers;
@property (nonatomic, copy) NSString * mId;

@end

@implementation XmeetHandler
@synthesize mMembers = _mMembers, mId = _mId;

- (id)init {
    self = [super init];
    if (self) {
        _mMembers = [[XmeetMembers alloc]init];
    }
    return self;
}

- (void)parseMessage:(id)message {
    @try {
        NSDictionary *object = [message JSONValue];
        NSString * type = [object valueForKey:@"type"];
//        NSLog(@"%@ %@", object, type);
        
        if ([type isEqualToString:@"members"] ) {
            [self parseMembers:object];
        } else if ([type isEqualToString:@"member_count"]) {
            
        } else if ([type isEqualToString:@"normal"]) {
            [self parseNormal:object];
        } else if ([type isEqualToString:@"join"]) {
            [self parseJoin:object];
        } else if ([type isEqualToString:@"leave"]) {
            [self parseLeave:object];
        } else if ([type isEqualToString:@"self"]) {
            [self parseSelf:object];
        } else if ([type isEqualToString:@"changename"]) {
            [self parseChangeName:object];
        } else if ([type isEqualToString:@"history"]) {
            [self parseHisgory:object];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void) parseSelf:(NSDictionary *)object {
    @try {
        
        _mId = [object valueForKey:@"payload"];
        
    } @catch (NSException *exception) {
    }
}

- (void) parseMembers:(NSDictionary *)object {
    @try {
        NSArray *payload = [object valueForKey:@"payload"];
        
        for (int i = 0; i < payload.count; i++) {
            
            NSDictionary * info = [payload objectAtIndex:i];
            
            XmeetUserInfo * user 	=  [[XmeetUserInfo alloc]init];
            user.uid 			= [info valueForKey:@"pid"];
            user.nickname 		= [info valueForKey:@"nickname"];
            
            if ([_mId isEqualToString:user.uid]) {
                [[NSUserDefaults standardUserDefaults]setObject:user.nickname forKey:@"user_nickname"];
                user.isSelf = YES;
            }
            
            [_mMembers addMember:user];
        }
        
    } @catch (NSException *exception) {
        
    }
}

- (void) parseJoin:(NSDictionary *)object {
    @try {
        
        XmeetUserInfo * user 	= [[XmeetUserInfo alloc]init];

        user.uid 			= [object valueForKey:@"from"];
        user.nickname 		= [object valueForKey:@"payload"];
        
        [_mMembers addMember:user];
        
        XmeetMessage * message = [[XmeetMessage alloc]init];
        message.message = [NSString stringWithFormat:@"%@ 加入了聊天室", user.nickname];
        message.type = 2;
        
        if ([self.delegate respondsToSelector:@selector(onJoin:)])
            [self.delegate onJoin:message];
        
    } @catch (NSException *exception) {
        
    }
}

- (void) parseLeave:(NSDictionary *)object {
    @try {
        NSString *uid = [object valueForKey:@"from"];
        NSString *nickname = [_mMembers removeMember:uid];
        XmeetMessage * message = [[XmeetMessage alloc]init];
        message.message = [NSString stringWithFormat:@"%@ 离开了聊天室", nickname];
        message.type = 2;
        
        if ([self.delegate respondsToSelector:@selector(onLeave:)])
            [self.delegate onLeave:message];

    } @catch (NSException *exception) {
       
    }
}

- (void) parseNormal:(NSDictionary *)object {
    @try {
        NSString * uid = [object valueForKey:@"from"];
        NSString * payload = [object valueForKey:@"payload"];
        NSString * send_time = [object valueForKey:@"send_time"];
        
        XmeetUserInfo * user = [_mMembers queryMember:uid];
        NSString * nickname = user.nickname == nil ? @"" : user.nickname;
        
        XmeetMessage * message = [[XmeetMessage alloc]init];
        message.nickName = nickname;
        message.message = payload;
        message.time = send_time;
        message.type = (user.isSelf ? 1 : 0);
        
        if ([self.delegate respondsToSelector:@selector(onMessage:)])
            [self.delegate onMessage:message];
        
    } @catch (NSException *exception) {
        
    }
}

- (void) parseChangeName:(NSDictionary *)object {
    @try {
        
        NSString * uid = [object valueForKey:@"from"];
        NSString * newname = [object valueForKey:@"payload"];
        
        XmeetUserInfo * user = [_mMembers queryMember:uid];
        NSString * nickname = user.nickname == nil ? @"" : user.nickname;
        
        NSString * old = nickname;
        [_mMembers renameMember:newname uid:uid];
        
        XmeetMessage *message = [[XmeetMessage alloc]init];
        message.message = [NSString stringWithFormat:@"%@ 使用了新名字 %@", old, newname];
        message.type = 2;
        message.nickName = newname;
        
        if ([self.delegate respondsToSelector:@selector(onChangeName:)])
            [self.delegate onChangeName:message];
        
    } @catch (NSException *exception) {

    }
}

- (void) parseHisgory:(NSDictionary *)object {
    
    NSMutableArray * list = [[NSMutableArray alloc]init];
//    List<XmeetMessage> list = new ArrayList<XmeetMessage>();
    @try {
//        Thread.sleep(1000);
        NSArray * payload = [object valueForKey:@"payload"];
        
        for (int i = 0; i < payload.count; i ++) {
            NSDictionary * info = [payload objectAtIndex:i];
            
            XmeetMessage * message = [[XmeetMessage alloc]init];
            
            XmeetUserInfo * user 	= [_mMembers queryMember:[info valueForKey:@"from"]];
            NSString * nickname = user.nickname == nil ? @"" : user.nickname;
            message.nickName	= nickname;
            message.message		= [info valueForKey:@"payload" ];
            message.time	= [info valueForKey:@"send_time"];

            if ([_mId isEqualToString:user.uid])
                user.isSelf = true;
            
            [list addObject:message];
        }
        
        
    } @catch (NSException *exception) {

    } @finally {
        XmeetMessage *message = [[XmeetMessage alloc]init];
        message.message		= @"------------以上是历史消息---------------";
        message.type		= 2;
        
        [list addObject:message];
    }
    
    if ([self.delegate respondsToSelector:@selector(onHistroy:)])
        [self.delegate onHistroy:list];
}


@end
