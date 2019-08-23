//
//  SelectActivityCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/31.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SelectActivityCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameLabel;//
@property (nonatomic,strong) UILabel *adressLabel;//
@property (nonatomic,strong) UILabel *timeLabel;//
-(void)initViewWithModel:(NSDictionary *) dic;
@end

