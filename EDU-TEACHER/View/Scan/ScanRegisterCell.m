//
//  ScanRegisterCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/10/16.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ScanRegisterCell.h"
#import "DEFINE.h"
@implementation ScanRegisterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

#pragma mark - initView
- (void)initViewWith:(ScanRegisterModel*)model{
    self.scanModel=model;
    [self.contentView addSubview:self.labelImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.agreenBtn];
    [self.contentView addSubview:self.rejectBtn];
    [self.contentView addSubview:self.statusBtn];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(15);
         
        make.height.mas_equalTo(14.0f);
    }];
    
    [self.labelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(7);
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.width.mas_equalTo(16.0f);
        make.height.mas_equalTo(16.0f);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(34);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(12.0f);
    }];
    [self.agreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(34);
    }];
    [self.rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.agreenBtn.mas_left).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(34);
    }];
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(34);
    }];
    
    [self.nameLabel setText:model.xs_name];
    [self.timeLabel setText:model.class_name];
    if([model.xs_sex isEqualToString:@"男"]){
        [self.labelImage setImage:[UIImage imageNamed:@"nan-icon"]];
    }
    else{
       [self.labelImage setImage:[UIImage imageNamed:@"nv-icon"]];
    }
    if([model.status isEqualToString:@"0"]){
        [self.statusBtn setHidden:NO];
        [self.agreenBtn setHidden:YES];
        [self.rejectBtn setHidden:YES];
        [_statusBtn setTitle:@"已同意" forState:UIControlStateNormal];
    }
    else if([model.status isEqualToString:@"1"]){
         [self.statusBtn setHidden:YES];
         [self.agreenBtn setHidden:NO];
         [self.rejectBtn setHidden:NO];
    }
    else{
        [self.statusBtn setHidden:NO];
        [self.agreenBtn setHidden:YES];
        [self.rejectBtn setHidden:YES];
        [_statusBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
    }
    
    
    
}
- (UIImageView *)labelImage{
    if (!_labelImage) {
        _labelImage=[[UIImageView alloc]init];
        _labelImage.image=[UIImage imageNamed:@"tongzhi_cell"];
    }
    return _labelImage;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setFont:[UIFont systemFontOfSize:15.0]];
    }
    return _nameLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[[UILabel alloc]init];
        [_timeLabel setFont:[UIFont systemFontOfSize:14.0]];
        _timeLabel.textColor=[UIColor grayColor];
        _timeLabel.text=@"0000-00-00 00:00";
    }
    return _timeLabel;
}
- (UIButton *)agreenBtn{
    if (!_agreenBtn) {
        _agreenBtn=[[UIButton alloc]init];
        _agreenBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_agreenBtn addTarget:self action:@selector(clickAgreenBtn:) forControlEvents:UIControlEventTouchUpInside];
        _agreenBtn.layer.cornerRadius=8;
        _agreenBtn.layer.masksToBounds=YES;
        _agreenBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
         [_agreenBtn setTitle:@"同意申请" forState:UIControlStateNormal];
        [_agreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _agreenBtn;
}
 - (UIButton *)rejectBtn{
     if (!_rejectBtn) {
         _rejectBtn=[[UIButton alloc]init];
         _rejectBtn.titleLabel.font=[UIFont systemFontOfSize:14];
         [_rejectBtn addTarget:self action:@selector(clickRejectBtn:) forControlEvents:UIControlEventTouchUpInside];
         _rejectBtn.backgroundColor=[UIColor clearColor];
          [_rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
         [_rejectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
     }
     return _rejectBtn;
 }

- (UIButton *)statusBtn{
    if (!_statusBtn) {
        _statusBtn=[[UIButton alloc]init];
        _statusBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_statusBtn addTarget:self action:@selector(clickRejectBtn:) forControlEvents:UIControlEventTouchUpInside];
        _statusBtn.backgroundColor=[UIColor clearColor];
         [_statusBtn setTitle:@"已同意" forState:UIControlStateNormal];
        [_statusBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return _statusBtn;
}


-(void)clickAgreenBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickStateBtn:model:state:)]){
        [self.delegate clickStateBtn:sender model:self.scanModel state:@"1"];
    }
    
}
-(void)clickRejectBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickStateBtn:model:state:)]){
        [self.delegate clickStateBtn:sender model:self.scanModel state:@"2"];
    }
    
}
 
@end
