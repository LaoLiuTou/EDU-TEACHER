//
//  ResigninCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/1.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResigninCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *statusImage;
@property (nonatomic,strong) NSString *status; 


-(void)chageStatus:(NSString *)status;
@end

NS_ASSUME_NONNULL_END
