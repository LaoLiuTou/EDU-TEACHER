//
//  StudentHonorCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentHonorCell.h"
#import "DEFINE.h"
@implementation StudentHonorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self initView];
    }
    return self;
}
-(void)initViewWithModel:(StudentHonorModel *) model{
    self.nameLabel.text=[NSString stringWithFormat:@"%@",model.name];
    self.dateLabel.text=[NSString stringWithFormat:@"%@",model.date];
    NSString *tempString = [NSString stringWithFormat:@"颁发机构:%@",model.organization];
    NSMutableAttributedString *tempAS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",tempString]];
    [tempAS addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:NSMakeRange(0,5)];
    self.organizationLabel.attributedText=tempAS;
}
#pragma mark - initView
- (void)initView{
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.organizationLabel];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(22);
        make.top.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(((kWidth-30)/7)*4);
        make.height.mas_equalTo(25);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(((kWidth-30)/7)*3);
        make.height.mas_equalTo(25);
    }];
    
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorRGB(108,180,24);
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
- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel=[[UILabel alloc]init];
        [_dateLabel setFont:[UIFont systemFontOfSize:12.0]];
        _dateLabel.textColor=[UIColor grayColor];
        _dateLabel.textAlignment=NSTextAlignmentRight;
    }
    return _dateLabel;
}

- (UILabel *)organizationLabel{
    if (!_organizationLabel) {
        _organizationLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 38.0, kWidth-30, 25.0)];
        [_organizationLabel setFont:[UIFont systemFontOfSize:12.0]];
        _organizationLabel.textColor=[UIColor grayColor];
    }
    return _organizationLabel;
}



@end

