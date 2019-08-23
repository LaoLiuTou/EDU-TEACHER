//
//  ContactCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/18.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ContactCell.h"
#import "DEFINE.h" 
#import "UIImageView+WebCache.h"
@implementation ContactCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self initView];
    }
    return self;
}
-(void)initViewWithModel:(ContactModel *) model status:(NSString *) status{
    self.contactModel=model; 
  
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:self.contactModel.I_UPIMG] placeholderImage:[UIImage imageNamed:@"tx"]];
    
    [_nameLabel setText:[NSString stringWithFormat:@"%@_%@",self.contactModel.NM_T,self.contactModel.SN_T]];
    
    [_status setText:self.contactModel.STATUS];
    
    
    _statusIcon.image=[UIImage imageNamed:status];
 
    
    //自适应
    [_nameLabel sizeToFit];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(70);
        make.height.mas_equalTo(60);
    }];
    [_statusIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.statusIcon.mas_right).offset(5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
}
#pragma mark - initView
- (void)initView{
    
    [self.contentView addSubview:self.headerImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.statusIcon];
    [self.contentView addSubview:self.status];
}
- (UIImageView *)headerImage{
    if (!_headerImage) {
        _headerImage=[[UIImageView alloc]initWithFrame:CGRectMake(15.0, 8, 44, 44)];
        _headerImage.layer.cornerRadius = 22;
        _headerImage.userInteractionEnabled = YES;
        _headerImage.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeader:)];
        [_headerImage addGestureRecognizer:tap];
    }
    return _headerImage;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_nameLabel setTextColor:[UIColor blackColor]];
        //[_nameLabel sizeToFit];
    }
    return _nameLabel;
}
- (UIImageView *)statusIcon{
    if (!_statusIcon) {
        _statusIcon=[[UIImageView alloc]init];
        
    }
    return _statusIcon;
}
- (UILabel *)status{
    if (!_status) {
        _status=[[UILabel alloc]init];
        [_status setFont:[UIFont systemFontOfSize:15.0]];
        [_status setTextColor:[UIColor grayColor]];
        
    }
    return _status;
}
-(void)clickHeader:(UITapGestureRecognizer *)tap{
    if([self.delegate respondsToSelector:@selector(clickHeader:model:)]){
        [self.delegate clickHeader:tap model:self.contactModel];
    }
}
@end
