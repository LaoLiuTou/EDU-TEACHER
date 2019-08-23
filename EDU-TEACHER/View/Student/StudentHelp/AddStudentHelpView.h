//
//  AddStudentHelpView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/24.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AddStudentHelpDelegate <NSObject>
-(void)clickPublishBtn:(UIButton *)btn;
-(void)clickTimeBtn:(UIButton *)btn;
@end

@interface AddStudentHelpView : UIView
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UITextField *titleTextField;//资助标题
@property (nonatomic,strong) UILabel *dateLabel;//资助日期
@property (nonatomic,strong) UITextField *moneyTextField;//资助金额
@property (nonatomic,strong) UITextField *organizationTextField;//资助单位
@property (nonatomic, strong) UIButton *publishBtn;
@property(nonatomic,strong)id<AddStudentHelpDelegate>delegate;
-(void)initViewWithId:(NSString *) xs_id Name:(NSString *) xs_name;
@end

