//
//  SHMessageContentView.h 
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <WebKit/WebKit.h>
#import "SHMessage.h"
#import "SHActivityIndicatorView.h"
#import "SHTextView.h"

@class SHActivityIndicatorView;
@interface SHMessageContentView : UIButton

//bubble imgae
@property (nonatomic, retain) UIImageView *backImageView;
//剪切视图
- (void)makeMaskView:(UIView *)view image:(UIImage *)image;

@end
