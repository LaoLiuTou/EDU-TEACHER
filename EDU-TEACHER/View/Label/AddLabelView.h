//
//  AddLabelView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddLabelDelegate <NSObject>
-(void)clickSelectStu ;
-(void)clickPublishBtn:(UIButton *)btn;
@end

@interface AddLabelView : UIView
@property (nonatomic,strong) UITextField *nameLabel;
@property (nonatomic,strong) UITextView *remarkTextView;
@property (nonatomic, strong) UIButton *nameback;
@property (nonatomic,strong) UILabel *stuLabel;

@property (nonatomic,strong) UIImageView *selectImage;//学生
@property (nonatomic,strong) UIScrollView *stuScrollView;//学生
@property (nonatomic, strong) UIButton *publishBtn;
@property(nonatomic,strong)id<AddLabelDelegate>delegate;

 
@end
 
