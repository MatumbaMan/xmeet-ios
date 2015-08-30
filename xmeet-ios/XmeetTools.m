//
//  XmeetTools.m
//  xmeet-ios
//
//  Created by HouKinglong on 15/8/30.
//  Copyright (c) 2015年 Xmeet. All rights reserved.
//

#import "XmeetTools.h"
#import "XmeetUtils.h"

@implementation XmeetTools

+ (CGSize)getMessageSize:(XmeetMessage *)message font:(CGFloat)font {
    return [self getMessageSize:message font:font flag:false];
}

+ (CGSize)getMessageSize:(XmeetMessage *)message font:(CGFloat)font flag:(Boolean)flag {
    CGFloat maxWidth = VIEW_WEIGHT - 110;
    CGSize size = [self getStringSize:message.message font:font width:maxWidth];
    if (size.width < maxWidth && flag) {
        size.height += [self getStringSize:message.nickName font:11 width:40].height + 7;
    }

    return size;
}

+ (CGSize)getStringSize:(NSString *)string font:(CGFloat)font width:(CGFloat)width{
    CGSize size;
    if (IOS_VERSION < 6.5) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:FONT_NAME size:font]};
        size = [string sizeWithAttributes: attributes];
        float maxWidth = width;
        if (size.width > maxWidth) {
            size = [string boundingRectWithSize:CGSizeMake(maxWidth, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        }
        
    } else {
        size = [string sizeWithFont:[UIFont systemFontOfSize:font]];
        float maxWidth = width;
        if (size.width > maxWidth) {
            size = [string sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(maxWidth, 300) lineBreakMode:NSLineBreakByWordWrapping];
        }
        
    }
    return size;
}

@end
