//
//  SignInStudentCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/2.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignInStudentDelegate <NSObject>
-(void)clickSignInBtn:(UIButton *)btn stuDic:(NSDictionary *) stu;
@end

@interface SignInStudentCell : UITableViewCell
@property (nonatomic,strong) UIImageView *headerImage;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *leaveLabel;
@property (nonatomic,strong) UIButton *statusBtn;//状态
@property (nonatomic,strong) NSDictionary *stuDic;

@property(nonatomic,strong)id<SignInStudentDelegate>delegate;
@end

