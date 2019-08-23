//
//  SelectStudentCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/8.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SelectStudentCell.h"
#import "DEFINE.h"
@implementation SelectStudentCell


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
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.statusImage];
    
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 0, kWidth-50, 40.0)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        _nameLabel.textColor=[UIColor blackColor];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        
    }
    return _nameLabel;
}
- (UIImageView *)statusImage{
    if (!_statusImage) {
        UIImageView *iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(50, 8, 24, 24)];
        _statusImage=iconImageView;
        
        if([_status isEqualToString:@"select"]){
            _statusImage.image = [UIImage imageNamed:@"xuanzhong"];
        }
        else{
            _statusImage.image = [UIImage imageNamed:@"weixuanzhong"];
        }
        
    }
    return _statusImage;
}
-(void)chageStatus:(NSString *)status{
    
    if([status isEqualToString:@"select"]){
        _statusImage.image = [UIImage imageNamed:@"xuanzhong"];
    }
    else{
        _statusImage.image = [UIImage imageNamed:@"weixuanzhong"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
