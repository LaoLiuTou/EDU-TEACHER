//
//  StudentClassDetailView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/6.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentClassModel.h"

@class StudentClassModel;

@protocol StudentClassDelegate <NSObject>

- (void)hide;

@end

@interface StudentClassDetailView : UIView

@property (nonatomic, strong) StudentClassModel *model;

@property (nonatomic, assign) id<StudentClassDelegate> delegate;

@end

