//
//  ScrollAddLabel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/8.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ScrollAddLabel : NSObject
-(void)addLabelToScrollView:(UIScrollView *)scrollView labels:(NSArray *) labels;
@end

NS_ASSUME_NONNULL_END
