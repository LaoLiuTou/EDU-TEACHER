//
//  SHMessageContentView.m 
//

#import "SHMessageContentView.h"
#import "SHMessageHeader.h"
#import "SHMessageFrame.h"
#import "SHLocation.h"

@implementation SHMessageContentView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
        //图片
        self.backImageView = [[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled = YES;
        self.backImageView.layer.cornerRadius = 5;
        self.backImageView.layer.masksToBounds  = YES;
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.backImageView];
     return self;
}
#pragma mark 剪切视图
- (void)makeMaskView:(UIView *)view image:(UIImage *)image{
    
    UIImageView *imageViewMask = [[UIImageView alloc] init];
    imageViewMask.frame = view.frame;
    imageViewMask.image = image;
    view.layer.mask = imageViewMask.layer;
  
}

@end
