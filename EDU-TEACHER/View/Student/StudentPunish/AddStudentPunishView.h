//
//  AddStudentPunishView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/24.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddStudentPunishDelegate <NSObject>
-(void)clickPublishBtn:(UIButton *)btn;
-(void)clickTimeBtn:(UIButton *)btn;
@end

@interface AddStudentPunishView : UIView
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UITextField *titleTextField;//标题
@property (nonatomic,strong) UILabel *dateLabel;//日期
@property (nonatomic,strong) UITextView *commentText;
@property (nonatomic, strong) UIButton *publishBtn;
@property(nonatomic,strong)id<AddStudentPunishDelegate>delegate;
-(void)initViewWithId:(NSString *) xs_id Name:(NSString *) xs_name;
@end

