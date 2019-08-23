//
//  SelectStudentCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/8.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h> 

@interface SelectStudentCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *statusImage;
@property (nonatomic,strong) NSString *status;


-(void)chageStatus:(NSString *)status;

@end

