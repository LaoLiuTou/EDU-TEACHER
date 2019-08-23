//
//  StudentView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/19.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentModel.h"
@protocol StudentDelegate <NSObject>
 -(void)clickMenuBtn:(UIButton *)btn;
 -(void)clickStudentInfoBtn:(UIButton *)btn;

@end

@interface StudentView : UIView
@property(nonatomic,strong)id<StudentDelegate>delegate;

-(int)initViewModel:(StudentModel *)studentModel;
@end

