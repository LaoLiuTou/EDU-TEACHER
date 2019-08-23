//
//  AddStudentTalkingView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/22.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkingModel.h"

@protocol AddStudentTalkingDelegate <NSObject>
-(void)clickSelectAtta;
-(void)clickSelectStu;
-(void)clickPublishBtn:(UIButton *)btn;
-(void)clickTimeBtn:(UIButton *)btn;
@end
@interface AddStudentTalkingView : UIView
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *talk_timeLabel;//谈话时间
@property (nonatomic,strong) UITextField *addressText;//谈话地点
@property (nonatomic,strong) UITextView *reasonText;//谈话事由
@property (nonatomic,strong) UITextView *commentText;//谈话内容
@property (nonatomic,strong) UITextView *followText;//后续处理
@property (nonatomic,strong) UILabel *filesLabel;//文件
@property (nonatomic, strong) UIButton *publishBtn;

@property (nonatomic, strong) UIButton *nameback;

@property (nonatomic,strong) UIScrollView *filesScrollView;//文件
@property (nonatomic,strong) UIImageView *attaImage;//文件 
@property (nonatomic,strong) UIImageView *selectImage;//学生

@property(nonatomic,strong)id<AddStudentTalkingDelegate>delegate;


-(void)initViewWithId:(NSString *) xs_id Name:(NSString *) xs_name;
@end

