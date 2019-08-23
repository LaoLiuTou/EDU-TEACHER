//
//  MainView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/1.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MainDelegate <NSObject>

-(void)clickMainBtn:(UIButton *)sender;
-(void)clickStatisticBtn:(UIButton *)sender;

-(void)clickSign;
-(void)clickLeave;
-(void)clickRecord;
@end
@interface MainView : UIView
@property(nonatomic,strong)id<MainDelegate>delegate;
@property (nonatomic,retain) NSDictionary *mainData; 
-(void)initData:(NSDictionary *)mainData;

@end
 
