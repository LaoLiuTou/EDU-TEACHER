//
//  AddMemoView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/5.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddMemoDelegate <NSObject>
-(void)clickSelectStu;
-(void)clickSaveBtn:(UIButton *)btn;
-(void)clickTimeBtn:(UIButton *)btn;
-(void)clickTypeBtn:(UIButton *)btn;
@end

@interface AddMemoView : UIView

@property (nonatomic,strong) UITextField *nameText;//标题
@property (nonatomic,strong) UITextView *commentText;//内容
@property (nonatomic,strong) UILabel *timeLabel;//日期
@property (nonatomic,strong) UILabel *studentLabel;//通知范围
@property (nonatomic,strong) NSString  *selectType;
@property (nonatomic,strong) UISegmentedControl *typeSegment ;
@property (nonatomic,strong) UIImageView *selectImage;//学生
@property (nonatomic,strong) UIScrollView *stuScrollView;//学生
@property (nonatomic, strong) UIButton *saveBtn;
- (int)initView;
@property(nonatomic,strong)id<AddMemoDelegate>delegate;
@end
