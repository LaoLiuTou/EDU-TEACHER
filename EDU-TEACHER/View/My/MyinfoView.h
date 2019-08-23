//
//  MyinfoView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"
@protocol MyInfoDelegate <NSObject>
-(void)clickSelectImage:(UITapGestureRecognizer *)tap;

@end
@interface MyinfoView : UIView
@property (nonatomic,retain)  UIImageView *header;
@property (nonatomic,retain) UIImageView *idImageView;
@property(nonatomic,strong)id<MyInfoDelegate>delegate;
-(int)initViewModel:(MyModel *) myModel;

@end

