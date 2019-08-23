//
//  SelectActivityCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/31.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SelectActivityCell.h"
#import "DEFINE.h"
@implementation SelectActivityCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self initView];
    }
    return self;
}
-(void)initViewWithModel:(NSDictionary *) dic{
   
    
    self.nameLabel.text=[NSString stringWithFormat:@"活动名称：%@",[dic objectForKey:@"name"] ];
    NSString *tempString = [NSString stringWithFormat:@"活动地点：%@",[dic objectForKey:@"address"] ];
    NSMutableAttributedString *tempAS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",tempString]];
    [tempAS addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:NSMakeRange(0,5)];
    self.adressLabel.attributedText=tempAS;
    tempString = [NSString stringWithFormat:@"报名截止时间：%@",[dic objectForKey:@"jiezhi_time"] ];
    tempAS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",tempString]];
    [tempAS addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:NSMakeRange(0,7)];
    self.timeLabel.attributedText=tempAS;
    
}
#pragma mark - initView
- (void)initView{
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.adressLabel];
    [self.contentView addSubview:self.timeLabel];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(22);
        make.top.equalTo(self.contentView).offset(8);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(25);
    }];
    [self.adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(30);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(25);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
- (UILabel *)adressLabel{
    if (!_adressLabel) {
        _adressLabel=[[UILabel alloc]init];
        [_adressLabel setFont:[UIFont systemFontOfSize:12.0]];
        _adressLabel.textColor=[UIColor darkGrayColor];
    }
    return _adressLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[[UILabel alloc]init];
        [_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
        _timeLabel.textColor=[UIColor darkGrayColor];
    }
    return _timeLabel;
}



@end
