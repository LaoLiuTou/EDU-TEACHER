//
//  ScrollAddLabel.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/8.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ScrollAddLabel.h"
#import "DEFINE.h"
@implementation ScrollAddLabel

-(void)addLabelToScrollView:(UIScrollView *)scrollView labels:(NSArray *) labels{
    
    int tempX = 0;
    for(NSString *label in labels){
        UILabel *tempLabel = [UILabel new];
        tempLabel.backgroundColor=GKColorRGB(246, 246, 246);
        tempLabel.layer.cornerRadius=12;
        tempLabel.layer.masksToBounds=YES;
        tempLabel.font=[UIFont systemFontOfSize:12];
        tempLabel.text=[NSString stringWithFormat:@"  %@  ",label];
        CGSize size = [[NSString stringWithFormat:@"  %@  ",label] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        [scrollView addSubview:tempLabel];
        [tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(scrollView).offset(tempX);
            make.centerY.equalTo(scrollView);
            make.width.mas_equalTo(size);
            make.height.mas_equalTo(24);
        }];
        tempX += size.width + 10;
    }
    CGSize size = scrollView.contentSize;
    size.width = tempX;
    scrollView.contentSize=size;
}
@end
