//
//  ActivityCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ActivityCell.h"
#import "DEFINE.h"
@implementation ActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        //[self initView];
    }
    return self;
}

#pragma mark - initView
- (void)initViewWith:(ActivityModel *) activityModel{
    _activityModel=activityModel;
    
    [self.contentView addSubview:self.activityImage];
    [self.contentView addSubview:self.nameLabel];
    
    [self.contentView addSubview:self.publish_timeLabel];
    
    [self.contentView addSubview:self.publish_nameLabel];
    
    [self.contentView addSubview:self.baoming_endtimeLabel];
    
    [self.contentView addSubview:self.statusBtn];
    
    self.nameLabel.text=activityModel.name;
    self.publish_timeLabel.text=activityModel.publish_time;
    self.publish_nameLabel.text=[NSString stringWithFormat:@"发布人：%@",activityModel.publish_name];
    self.baoming_endtimeLabel.text=[NSString stringWithFormat:@"报名截止时间：%@",activityModel.baoming_endtime];
    if([self.activityModel.status isEqualToString:@"待发布"]){
        
        [_statusBtn addTarget:self action:@selector(clickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
        _statusBtn.layer.cornerRadius=8;
        _statusBtn.layer.masksToBounds=YES;
        _statusBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_statusBtn setTitle:@"待发布" forState:UIControlStateNormal];
        [_statusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else{
        
        _statusBtn.backgroundColor=[UIColor whiteColor];
        [_statusBtn setTitle:self.activityModel.status forState:UIControlStateNormal];
        [_statusBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    
    [self.activityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(50.0f);
        make.height.mas_equalTo(50.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityImage.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo((kWidth-100)/2);
        make.height.mas_equalTo(14.0f);
    }];
    [self.publish_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo((kWidth-100)/2);
        make.height.mas_equalTo(12.0f);
    }];
    [self.publish_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityImage.mas_right).offset(10);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
        make.width.mas_equalTo((kWidth-170));
        make.height.mas_equalTo(12.0f);
    }];
    [self.baoming_endtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityImage.mas_right).offset(10);
        make.top.equalTo(self.publish_nameLabel.mas_bottom).offset(6);
        make.width.mas_equalTo((kWidth-160));
        make.height.mas_equalTo(12.0f);
    }];
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.publish_timeLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(34);
    }];
    
}
- (UIImageView *)activityImage{
    if (!_activityImage) {
        _activityImage=[[UIImageView alloc]init];
        _activityImage.image=[UIImage imageNamed:@"huodong_cell"];
    }
    return _activityImage;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
    }
    return _nameLabel;
}
- (UILabel *)publish_timeLabel{
    if (!_publish_timeLabel) {
        _publish_timeLabel=[[UILabel alloc]init];
        [_publish_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
        _publish_timeLabel.textColor=[UIColor grayColor];
        _publish_timeLabel.textAlignment=NSTextAlignmentRight;
       
    }
    return _publish_timeLabel;
}
- (UILabel *)publish_nameLabel{
    if (!_publish_nameLabel) {
        _publish_nameLabel=[[UILabel alloc]init];
        [_publish_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        _publish_nameLabel.textColor=[UIColor grayColor];
    }
    return _publish_nameLabel;
}
- (UILabel *)baoming_endtimeLabel{
    if (!_baoming_endtimeLabel) {
        _baoming_endtimeLabel=[[UILabel alloc]init];
        [_baoming_endtimeLabel setFont:[UIFont systemFontOfSize:12.0]];
        _baoming_endtimeLabel.textColor=[UIColor grayColor];
    }
    return _baoming_endtimeLabel;
}
- (UIButton *)statusBtn{
    if (!_statusBtn) {
        _statusBtn=[[UIButton alloc]init];
        _statusBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        
    }
    return _statusBtn;
}



-(void)clickPublishBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickPublishBtn:activity:)]){
        [self.delegate clickPublishBtn:sender activity:self.activityModel];
    }
    
}

@end
