//
//  UIAlertController+supportedInterfaceOrientations.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "UIAlertController+supportedInterfaceOrientations.h"

@implementation UIAlertController (supportedInterfaceOrientations)
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations{
        return UIInterfaceOrientationMaskPortrait;
}
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
        return UIInterfaceOrientationMaskPortrait;
}
#endif

@end

