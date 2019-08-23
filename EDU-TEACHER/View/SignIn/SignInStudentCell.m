//
//  SignInStudentCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/2.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SignInStudentCell.h"
#import "DEFINE.h"
@implementation SignInStudentCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self initView];
    }
    return self;
}

#pragma mark - initView
- (void)initView{
    
    [self.contentView addSubview:self.headerImage];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(65);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(20);
    }];
    [self.contentView addSubview:self.leaveLabel];
    [self.leaveLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(20);
    }];
    [self.contentView addSubview:self.statusBtn];
    
}
- (UIImageView *)headerImage{
    if (!_headerImage) {
        _headerImage=[[UIImageView alloc]initWithFrame:CGRectMake(15.0, 5.0, 40, 40)];
        _headerImage.image=[UIImage imageNamed:@"tx"];
        _headerImage.layer.cornerRadius = 20;
        _headerImage.clipsToBounds = YES;
    }
    return _headerImage;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
        _nameLabel.preferredMaxLayoutWidth =250;
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor=[UIColor blackColor];
        
        //202 222 254
    }
    return _nameLabel;
}
- (UILabel *)leaveLabel{
    if (!_leaveLabel) {
        _leaveLabel=[[UILabel alloc]init];
        [_leaveLabel setFont:[UIFont systemFontOfSize:12.0]];
        _leaveLabel.textColor=GKColorHEX(0x2c92f5, 1);
        _leaveLabel.backgroundColor=GKColorRGB(202, 222, 254);
        _leaveLabel.layer.cornerRadius=4;
        _leaveLabel.layer.masksToBounds=YES;
        _leaveLabel.textAlignment=NSTextAlignmentCenter;
        _leaveLabel.text=@"已请假";
        [_leaveLabel setHidden:YES];
    
    }
    return _leaveLabel;
}
- (UIButton *)statusBtn{
    if (!_statusBtn) {
        _statusBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-75, 10.0, 60, 30)];
        _statusBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_statusBtn addTarget:self action:@selector(clickSignInBtn:) forControlEvents:UIControlEventTouchUpInside];
        _statusBtn.layer.cornerRadius=15;
        _statusBtn.layer.masksToBounds=YES;
        
        _statusBtn.backgroundColor=[UIColor whiteColor];
        [_statusBtn setTitle:@"补签" forState:UIControlStateNormal];
        [_statusBtn setTitleColor:GKColorHEX(0x2c92f5,1) forState:UIControlStateNormal];
        
        [_statusBtn.layer setBorderColor:GKColorHEX(0x2c92f5,1).CGColor];
        
        [_statusBtn.layer setBorderWidth:1.0];
        
    }
    return _statusBtn;
}


-(void)clickSignInBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickSignInBtn:stuDic:)]){
        [self.delegate clickSignInBtn:sender stuDic:self.stuDic];
    }
    
}
@end

