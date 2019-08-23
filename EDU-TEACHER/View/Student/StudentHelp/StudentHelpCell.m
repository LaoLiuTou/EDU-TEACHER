//
//  StudentHelpCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentHelpCell.h"
#import "DEFINE.h"
@implementation StudentHelpCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self initView];
    }
    return self;
}
-(void)initViewWithModel:(StudentHelpModel *) model{
    self.nameLabel.text=[NSString stringWithFormat:@"%@",model.name];
    NSString *tempString = [NSString stringWithFormat:@"资助金额：%@元",model.money];
    NSMutableAttributedString *tempAS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",tempString]];
    [tempAS addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:NSMakeRange(0,5)];
    self.moneyLabel.attributedText=tempAS;
    tempString = [NSString stringWithFormat:@"资助单位：%@",model.organization==nil?@"无":model.organization];
    tempAS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",tempString]];
    [tempAS addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:NSMakeRange(0,5)];
    self.organizationLabel.attributedText=tempAS;
    self.timeLabel.text=model.date;
}
#pragma mark - initView
- (void)initView{
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.organizationLabel];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(22);
        make.top.equalTo(self.contentView).offset(8);
        make.width.mas_equalTo((kWidth-130));
        make.height.mas_equalTo(25);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(30);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(25);
    }];
    [self.organizationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(45);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(25);
    }];
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorRGB(239, 165, 0);
    [self.contentView addSubview:leftview];
    [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(12);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
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
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[[UILabel alloc]init];
        [_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
        _timeLabel.textAlignment=NSTextAlignmentRight;
        _timeLabel.textColor=[UIColor darkGrayColor];
    }
    return _timeLabel;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel=[[UILabel alloc]init];
        [_moneyLabel setFont:[UIFont systemFontOfSize:12.0]];
        _moneyLabel.textColor=[UIColor darkGrayColor];
    }
    return _moneyLabel;
}

- (UILabel *)organizationLabel{
    if (!_organizationLabel) {
        _organizationLabel=[[UILabel alloc]init];
        [_organizationLabel setFont:[UIFont systemFontOfSize:12.0]];
        _organizationLabel.textColor=[UIColor darkGrayColor];
    }
    return _organizationLabel;
}



@end
