//
//  NoticeStuCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/12.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "NoticeStuCell.h"
#import "DEFINE.h"
@implementation NoticeStuCell


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
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(75.0, 0, (kWidth-160), 50)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
        _nameLabel.text=@"XXXXXX";
    }
    return _nameLabel;
}
 
- (UIButton *)statusBtn{
    if (!_statusBtn) {
        _statusBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-75, 10.0, 60, 30)];
        _statusBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_statusBtn addTarget:self action:@selector(clickNoticeBtn:) forControlEvents:UIControlEventTouchUpInside];
        _statusBtn.layer.cornerRadius=15;
        _statusBtn.layer.masksToBounds=YES;
        
        _statusBtn.backgroundColor=[UIColor whiteColor];
        [_statusBtn setTitle:@"通知" forState:UIControlStateNormal];
        [_statusBtn setTitleColor:GKColorHEX(0x2c92f5,1) forState:UIControlStateNormal];
        
        [_statusBtn.layer setBorderColor:GKColorHEX(0x2c92f5,1).CGColor];
        
        [_statusBtn.layer setBorderWidth:1.0];
        
    }
    return _statusBtn;
}


-(void)clickNoticeBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickNoticeBtn:stuDic:)]){
        [self.delegate clickNoticeBtn:sender stuDic:self.stuDic];
    }
    
} 
@end
