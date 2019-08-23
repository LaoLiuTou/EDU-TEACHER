//
//  MessageCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/16.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageCell : UITableViewCell
@property (nonatomic,strong) UIImageView *headerImage;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *redLabel;

@property (nonatomic,strong) MessageModel *messageModel;
-(void)initViewWithModel:(MessageModel *) model;
@end

