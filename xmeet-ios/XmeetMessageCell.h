//
//  LPLetterDetailCell.h
//  Makefriends
//
//  Created by Ronaldo on 14-11-15.
//  Copyright (c) 2014年 Kinglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XmeetMessage.h"
#import "XmeetUtils.h"

@interface XmeetMessageCell : UITableViewCell

@property (nonatomic, retain) XmeetMessage * msg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(XmeetMessage *)message;


@end
