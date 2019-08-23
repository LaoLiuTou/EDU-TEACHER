//
//  DevicesCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/29.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface DevicesCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *statusImage;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) UIImageView *iconImage;


-(void)chageStatus:(NSString *)status;
@end
