//
//  LabelCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "LabelCell.h"
#import "DEFINE.h"
@implementation LabelCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self initView];
    }
    return self;
}
-(void)initViewWithModel:(LabelModel *) model{
    _labelModel=model;
    self.nameLabel.text=[NSString stringWithFormat:@"%@ | %@人",model.NM_T,model.count];
    self.remarkLabel.text=model.REMARK==nil?@"":model.REMARK;
    self.timeLabel.text=model.C_DT;
}
#pragma mark - initView
- (void)initView{
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorHEX(0x2c92f5,1);
    [self.contentView addSubview:leftview];
    [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(12);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.delBtn];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(22);
        make.top.equalTo(self.contentView).offset(8);
        make.width.mas_equalTo((kWidth-105));
        make.height.mas_equalTo(25);
    }];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(28);
        make.width.mas_equalTo((kWidth-105));
        make.height.mas_equalTo(25);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(45);
        make.width.mas_equalTo((kWidth-105));
        make.height.mas_equalTo(25);
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(34);
    }];
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
        _nameLabel.textColor=[UIColor blackColor];
    }
    return _nameLabel;
}
- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel=[[UILabel alloc]init];
        [_remarkLabel setFont:[UIFont systemFontOfSize:12.0]];
        _remarkLabel.textColor=[UIColor darkGrayColor];
    }
    return _remarkLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[[UILabel alloc]init];
        [_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
        _timeLabel.textColor=[UIColor darkGrayColor];
    }
    return _timeLabel;
}
- (UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn=[[UIButton alloc]init];
        _delBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_delBtn addTarget:self action:@selector(clickDelBtn:) forControlEvents:UIControlEventTouchUpInside];
        _delBtn.layer.cornerRadius=8;
        _delBtn.layer.masksToBounds=YES;
        
        _delBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _delBtn;
}
-(void)clickDelBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickDelBtn:model:)]){
        [self.delegate clickDelBtn:sender model:self.labelModel];
    }
    
}

@end
