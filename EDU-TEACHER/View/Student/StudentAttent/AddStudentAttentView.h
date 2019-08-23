//
//  AddStudentAttentView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddStudentAttentDelegate <NSObject>
-(void)clickPublishBtn:(UIButton *)btn;
-(void)clickTimeBtn:(UIButton *)btn;
@end

@interface AddStudentAttentView : UIView
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;//谈话时间
@property (nonatomic, strong) UISegmentedControl *levelSegment;
@property (nonatomic,strong) UITextView *commentText;//谈话内容
@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, strong) UIButton *nameback;
@property(nonatomic,strong)id<AddStudentAttentDelegate>delegate;
-(void)initViewWithId:(NSString *) xs_id Name:(NSString *) xs_name;
@end

