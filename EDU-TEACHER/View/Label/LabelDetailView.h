//
//  LabelDetailView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelModel.h"
@protocol LabelDetailDelegate <NSObject>
-(void)clickSelectStuBtn:(UIButton *)btn; 
@end
@interface LabelDetailView : UIView
@property (nonatomic,strong) UITextField *nameLabel;//标题
@property (nonatomic,strong) UITextView *remarkLabel;//备注
@property (nonatomic,strong) UIButton *addStudentBtn;// 
@property (nonatomic,strong) LabelModel *labelModel;
-(int)initModel:(LabelModel *) labelModel;
@property(nonatomic,strong)id<LabelDetailDelegate>delegate;
@end

