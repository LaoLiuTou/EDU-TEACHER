//
//  AddNoticeView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/11.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddNoticeDelegate <NSObject>
-(void)clickSelectAtta;
-(void)clickSelectStu;
-(void)clickSaveBtn:(UIButton *)btn;
-(void)clickPublishBtn:(UIButton *)btn;
@end

@interface AddNoticeView : UIView

@property (nonatomic,strong) UITextField *nameText;//标题
@property (nonatomic,strong) UITextView *commentText;//内容
@property (nonatomic,strong) UIImageView *addImageView;//添加图片
@property (nonatomic,strong) NSString *selectedImage;//添加图片
@property (nonatomic,strong) UIView *addFileView;//添加文件
@property (nonatomic,strong) UIView *selectView;//通知范围
@property (nonatomic,strong) UILabel *filesLabel;//文件
@property (nonatomic,strong) UIScrollView *filesScrollView;//文件
@property (nonatomic,strong) UIImageView *attaImage;//文件
@property (nonatomic,strong) UIImageView *selectImage;//学生
@property (nonatomic,strong) UIScrollView *stuScrollView;//学生
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *publishBtn;
@property(nonatomic,strong)id<AddNoticeDelegate>delegate;
@end

