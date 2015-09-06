//
//  XmeetTools.h
//  xmeet-ios
//
//  Created by HouKinglong on 15/8/30.
//  Copyright (c) 2015年 Xmeet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XmeetMessage.h"

@interface XmeetTools : NSObject

+ (CGSize)getMessageSize:(XmeetMessage *)message font:(CGFloat)font;
+ (CGSize)getMessageSize:(XmeetMessage *)message font:(CGFloat)font flag:(Boolean)flag;
+ (CGSize)getStringSize:(NSString *)string font:(CGFloat)font width:(CGFloat)width;
+ (NSString *)md5:(NSString *)str;

@end
