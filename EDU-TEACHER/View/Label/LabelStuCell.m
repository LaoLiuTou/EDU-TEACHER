//
//  LabelStuCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/31.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "LabelStuCell.h"
#import "DEFINE.h"
@implementation LabelStuCell


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
 
@end

