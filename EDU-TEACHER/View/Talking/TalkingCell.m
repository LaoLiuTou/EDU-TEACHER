//
//  TalkingCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "TalkingCell.h"
#import "DEFINE.h" 
@implementation TalkingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self initView];
    }
    return self;
}
-(void)initViewWithModel:(TalkingModel *) model{
    self.xs_nameLabel.text=[NSString stringWithFormat:@"%@",model.xs_name];
    self.talk_timeLabel.text=[NSString stringWithFormat:@"谈话时间:%@",model.talk_time];
    self.c_timeLabel.text=[NSString stringWithFormat:@"%@",model.c_time];
    self.addressLabel.text=[NSString stringWithFormat:@"谈话地址:%@",model.address];
}
#pragma mark - initView
- (void)initView{
    [self.contentView addSubview:self.talkingImage];
    [self.contentView addSubview:self.xs_nameLabel];
    [self.contentView addSubview:self.talk_timeLabel];
    [self.contentView addSubview:self.c_timeLabel];
    [self.contentView addSubview:self.addressLabel];
    
    
    [self.xs_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(70);
        make.top.equalTo(self.contentView).offset(6);
        make.width.mas_equalTo(((kWidth-30)/7)*4);
        make.height.mas_equalTo(25);
    }];
    [self.talk_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(70);
        make.top.equalTo(self.contentView).offset(26);
        make.width.mas_equalTo(kWidth-100);
        make.height.mas_equalTo(25);
    }];
    [self.c_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView).offset(6);
        make.width.mas_equalTo(((kWidth-30)/7)*3);
        make.height.mas_equalTo(25);
    }];
    
  
    
}
- (UIImageView *)talkingImage{
    if (!_talkingImage) {
        _talkingImage=[[UIImageView alloc]initWithFrame:CGRectMake(15.0, 10.0, 50, 50)];
        _talkingImage.image=[UIImage imageNamed:@"tanxintanhau_list"];
    }
    return _talkingImage;
}
- (UILabel *)xs_nameLabel{
    if (!_xs_nameLabel) {
        _xs_nameLabel=[[UILabel alloc]init];
        [_xs_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
        _xs_nameLabel.textColor=[UIColor blackColor];
    }
    return _xs_nameLabel;
}
- (UILabel *)talk_timeLabel{
    if (!_talk_timeLabel) {
        _talk_timeLabel=[[UILabel alloc]init];
        [_talk_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
        _talk_timeLabel.textColor=[UIColor grayColor];
    }
    return _talk_timeLabel;
}
- (UILabel *)c_timeLabel{
    if (!_c_timeLabel) {
        _c_timeLabel=[[UILabel alloc]init];
        [_c_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
        _c_timeLabel.textColor=[UIColor grayColor];
        _c_timeLabel.textAlignment=NSTextAlignmentRight;
    }
    return _c_timeLabel;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 45.0, kWidth-100, 25.0)];
        [_addressLabel setFont:[UIFont systemFontOfSize:12.0]];
        _addressLabel.textColor=[UIColor grayColor];
    }
    return _addressLabel;
}



@end
