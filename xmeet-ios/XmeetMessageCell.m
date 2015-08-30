//
//  LPLetterDetailCell.m
//  Makefriends
//
//  Created by Ronaldo on 14-11-15.
//  Copyright (c) 2014年 Kinglong. All rights reserved.
//

#import "XmeetMessageCell.h"
#import "XmeetUtils.h"
#import "XmeetTools.h"

@implementation XmeetMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(XmeetMessage *)message
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _msg = message;
        float h = [self initTime:message.time];
        if (message.type == 2) {
            
        } else {
            [self initMessage:h];
        }
        
    }
    return self;
}

- (float)initTime:(NSString *)time {
    time = [NSString stringWithFormat:@"  %@  ", time];
    CGSize size = [XmeetTools getStringSize:time font:14 width:VIEW_WEIGHT - 20];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, size.width, size.height)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    label.text = time;
    label.userInteractionEnabled = YES;
    label.layer.cornerRadius = 3;
    label.layer.backgroundColor = kGeneralColor(234, 234, 234).CGColor;
    [self addSubview:label];
    
    label.center = CGPointMake(VIEW_WEIGHT/2, label.center.y);
    return 5 + size.height;
}

- (void)initMessage:(float)h
{
    CGSize size = [XmeetTools getStringSize:_msg.message font:18 width:VIEW_WEIGHT - 110];
    
    float imWidth = size.width + 26;
    float imHeight = size.height + 20;
    
    UIEdgeInsets edge = {28, 14, 7, 14};
    
    int type = _msg.type;
    
    //聊天消息背景
    UIImageView * bImage = [[UIImageView alloc]initWithFrame:CGRectMake( (type == 1 ? (VIEW_WEIGHT - 55 - imWidth) : 55), h + 10, imWidth, imHeight)];
    bImage.image = [[UIImage imageNamed:(type == 1 ? @"xmeet_message_mine" : @"xmeet_message_other")]resizableImageWithCapInsets:edge];
    bImage.userInteractionEnabled = YES;
    [self addSubview:bImage];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake((type == 1 ? 10 : 16), 10, size.width, size.height)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.text = _msg.message;
    label.userInteractionEnabled = YES;
    [bImage addSubview:label];
    
    //头像
    UIImageView * head = [[UIImageView alloc]initWithFrame:CGRectMake(( type == 1 ? VIEW_WEIGHT - 50 : 10), h + 10, 40, 40)];
    head.image = [UIImage imageNamed:@"ic_launcher"];
    head.layer.masksToBounds = YES;
    head.userInteractionEnabled = YES;
    [head setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:head];
    
    //昵称
    CGFloat f = [XmeetTools getStringSize:_msg.nickName font:12 width:40].height;
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake((type == 1 ? VIEW_WEIGHT - 50 : 10), h + 52, 40, f)];
    name.numberOfLines = 0;
    name.font = [UIFont systemFontOfSize:11];
    name.backgroundColor = [UIColor clearColor];
    name.text = _msg.nickName;
    name.textAlignment = NSTextAlignmentJustified;
    name.userInteractionEnabled = YES;
    [self addSubview:name];
    
//    [label addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];
}

-(void)longTap:(UILongPressGestureRecognizer *)longTap
{
    [self becomeFirstResponder];
    UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(fuzhi:)];
    UIMenuItem *approve = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(shanchu:)];
    UIMenuItem *hidden = [[UIMenuItem alloc] initWithTitle:@"取消"action:@selector(hidden:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    [menu setMenuItems:[NSArray arrayWithObjects:flag, approve, hidden, nil]];
    
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
}

- (BOOL)canBecomeFirstResponder
{
    [super canBecomeFirstResponder];
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(fuzhi:) || action == @selector(shanchu:) || action == @selector(hidden:))
    {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}

- (void)fuzhi:(id)sender
{
    
}

- (void)shanchu:(id)sender
{
    
}

- (void)hidden:(id)sender
{
    
}

@end
