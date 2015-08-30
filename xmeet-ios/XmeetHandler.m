//
//  XmeetHandler.m
//  xmeet-ios
//
//  Created by Kinglong on 15/8/30.
//  Copyright (c) 2015年 Xmeet. All rights reserved.
//

#import "XmeetHandler.h"
#import "SocketRocket/SRWebSocket.h"
#import "JSON/JSON.h"

@interface XmeetHandler () <SRWebSocketDelegate>
{
    SRWebSocket * mWebSocket;
}
@end

@implementation XmeetHandler
//@"ws://meet.xpro.im:8080/xgate/websocket/14009e12d791e664fc0175aecb31d833?nickname=WhiteAnimals"
- (void)connect:(NSString *)url {
    mWebSocket = [[SRWebSocket alloc]initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    mWebSocket.delegate = self;
    [mWebSocket open];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Websocket connected.");
    [self.delegate onOpen];
}

-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"Websocket failed with error %@", error);
    [self.delegate onError:error.localizedFailureReason];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Received %@", message);
    [self parseMessage:message];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Websocket closed.");
    [self.delegate onClose];
}

- (void)parseMessage:(id)message {
    @try {
        NSDictionary *object = [message JSONValue];
        NSString * type = [object valueForKey:@"type"];
        NSLog(@"%@", object);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
