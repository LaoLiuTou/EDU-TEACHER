//
//  MessageCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/16.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "MessageCell.h"
#import "DEFINE.h"
#import "ConverseTool.h"
#import "UIImageView+WebCache.h"
@implementation MessageCell

 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self initView];
    }
    return self;
}
-(void)initViewWithModel:(MessageModel *) model{
    self.messageModel=model;
    
    NSInteger unreadNumber=[self.messageModel.UNREAD integerValue];
    if(unreadNumber>0){
        [self.redLabel setHidden:NO];
    }
    else{
        [self.redLabel setHidden:YES];
    }
  
    
    //系统消息图标
    if([self.messageModel.FLAG isEqualToString:@"7"]){
        _headerImage.image=[UIImage imageNamed:@"xitongtongzhi_cell"];
    }
    else{
        [_headerImage sd_setImageWithURL:[NSURL URLWithString:self.messageModel.FRIEND_IMAGE] placeholderImage:[UIImage imageNamed:@"tx"]];
    }
    
    [_nameLabel setText:self.messageModel.FRIEND_NAME];
    [_contentLabel setText:[ConverseTool formBase64Str:self.messageModel.LAST_CONTEXT]];
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:self.messageModel.LAST_TIME];
    [_timeLabel setText:[ConverseTool compareCurrentTime:timeDate]];
}
#pragma mark - initView
- (void)initView{
    
    [self.contentView addSubview:self.headerImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.redLabel];
}
- (UIImageView *)headerImage{
    if (!_headerImage) {
        _headerImage=[[UIImageView alloc]initWithFrame:CGRectMake(15.0, 10.0, 50, 50)];
       
        _headerImage.layer.cornerRadius = 25;
        _headerImage.userInteractionEnabled = YES;
        _headerImage.clipsToBounds = YES;
        
    }
    return _headerImage;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(75.0, 12.0, (kWidth-130-80), 25.0)];
        [_nameLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_nameLabel setTextColor:[UIColor blackColor]];
        
    }
    return _nameLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(75.0, 35.0, (kWidth-130), 25.0)];
        [_contentLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_contentLabel setTextColor:[UIColor grayColor]];
        
    }
    return _contentLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-80-15, 12.0, 80, 25.0)];
        [_timeLabel setFont:[UIFont systemFontOfSize:14.0]];
        _timeLabel.textAlignment=NSTextAlignmentRight;
        [_timeLabel setTextColor:[UIColor grayColor]];
        
    }
    return _timeLabel;
}

- (UILabel *)redLabel{
    if (!_redLabel) {
        _redLabel=[[UILabel alloc]initWithFrame:CGRectMake(52, 14, 10, 10)];
        _redLabel.layer.cornerRadius = 5;
        _redLabel.clipsToBounds = YES;
        _redLabel.backgroundColor=[UIColor redColor];
     
        
    }
    return _redLabel;
}
@end
