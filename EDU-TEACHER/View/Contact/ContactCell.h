//
//  ContactCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/18.
//  Copyright © 2019 Jiubai. All rights reserved.
// 
#import <UIKit/UIKit.h>
#import "ContactModel.h"
@protocol ContactDelegate <NSObject>
-(void)clickHeader:(UITapGestureRecognizer *)tap model:(ContactModel *) model;
@end
@interface ContactCell : UITableViewCell
@property (nonatomic,strong) UIImageView *headerImage;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *statusIcon;
@property (nonatomic,strong) UILabel *status;

@property (nonatomic,strong) ContactModel *contactModel; 
-(void)initViewWithModel:(ContactModel *) model status:(NSString *) status;
@property(nonatomic,strong)id<ContactDelegate>delegate;
@end
