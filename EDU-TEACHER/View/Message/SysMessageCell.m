//
//  SysMessageCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/17.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SysMessageCell.h"
#import "DEFINE.h"
#import "ConverseTool.h"
@implementation SysMessageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self initView];
    }
    return self;
}
-(void)initViewWithModel:(SysMessageModel *) model{
    self.messageModel=model;
    
  
    if([self.messageModel.MESSAGE_TYPE isEqualToString:@"memo"]){
        //[_nameLabel setText:[NSString stringWithFormat:@"备忘通知：%@",self.messageModel.TITLE]];
        [_nameLabel setText:@"备忘通知"];
    }
    else{
        [_nameLabel setText:[NSString stringWithFormat:@"请假通知：%@",self.messageModel.TITLE]];
    }
    
    [_contentLabel setText:[ConverseTool formBase64Str:self.messageModel.LAST_CONTEXT]];
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:self.messageModel.ADD_TIME];
    [_timeLabel setText:[ConverseTool compareCurrentTime:timeDate]];
}
#pragma mark - initView
- (void)initView{ 
    self.contentView.backgroundColor=[UIColor clearColor];
    self.contentView.backgroundColor=GKColorRGB(246, 246, 246);
    UIView *backGroundView=[[UIView alloc] initWithFrame:CGRectMake(15.0, 10.0, (kWidth-30), 70.0)];
    backGroundView.layer.cornerRadius = 8;
    backGroundView.layer.masksToBounds = YES;
    backGroundView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:backGroundView];
    [backGroundView addSubview:self.nameLabel];
    [backGroundView addSubview:self.timeLabel];
    [backGroundView addSubview:self.contentLabel];
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(15.0, 12.0, (kWidth-70-80), 25.0)];
        [_nameLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_nameLabel setTextColor:[UIColor blackColor]];
        
    }
    return _nameLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(15.0, 40.0, (kWidth-70), 25.0)];
        [_contentLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_contentLabel setTextColor:[UIColor grayColor]];
        
    }
    return _contentLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-95-30, 12.0, 80, 25.0)];
        [_timeLabel setFont:[UIFont systemFontOfSize:14.0]];
        _timeLabel.textAlignment=NSTextAlignmentRight;
        [_timeLabel setTextColor:[UIColor grayColor]];
        
    }
    return _timeLabel;
}


@end
