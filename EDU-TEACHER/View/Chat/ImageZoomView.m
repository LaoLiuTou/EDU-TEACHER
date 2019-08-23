//
//  ImageZoomView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/14.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ImageZoomView.h"
static CGRect oldframe;
@interface ImageZoomView ()<UIScrollViewDelegate>

@end

@implementation ImageZoomView{
    UIScrollView *holderView;
    UIImageView *showImgView;
    BOOL isFirst;
}
- (instancetype)initWithFrame:(CGRect)frame andWithImage:(UIImageView *)imageview{
    if(self = [super initWithFrame:frame]){
        UIImage *image=imageview.image;
       
        holderView = [[UIScrollView alloc]initWithFrame:frame];
        holderView.backgroundColor=[UIColor blackColor];
        holderView.showsHorizontalScrollIndicator = NO; //水平
        holderView.showsVerticalScrollIndicator = NO; // 竖直
        holderView.scrollEnabled=YES;
        holderView.directionalLockEnabled = NO;
        holderView.bounces=NO;
        holderView.delegate=self;
        holderView.autoresizesSubviews=YES;
        holderView.maximumZoomScale=4;
        holderView.minimumZoomScale=1;
        [holderView setZoomScale:0.5 animated:NO];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        oldframe = [imageview convertRect:imageview.bounds toView:window];
        [holderView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
        //此时视图不会显示
        [holderView setAlpha:0];
        //将所展示的imageView重新绘制
        showImgView = [[UIImageView alloc] initWithFrame:oldframe];
        [showImgView setImage:imageview.image];
        [showImgView setTag:0];
        [holderView addSubview:showImgView];
        [self addSubview:holderView];
        
        //动画放大所展示的ImageView
        [UIView animateWithDuration:0.4 animations:^{
            CGFloat y,width,height;
            y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
            //宽度为屏幕宽度
            width = [UIScreen mainScreen].bounds.size.width;
            //高度 根据图片宽高比设置
            height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
            [self->showImgView setFrame:CGRectMake(0, y, width, height)];
            //重要！ 将视图显示出来
            [self->holderView setAlpha:1];
        } completion:^(BOOL finished) {
            
        }];
        
        
        UITapGestureRecognizer *doubleTapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [holderView addGestureRecognizer:doubleTapGesture];
        [self addSubview:holderView];
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
        [holderView addGestureRecognizer:singleTapGestureRecognizer];
        [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGesture];
        
    }
    return self;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    showImgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                     scrollView.contentSize.height * 0.5 + offsetY);
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return showImgView;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    if(!isFirst){
        isFirst=YES;
        CGPoint pointInView = [gesture locationInView:holderView];
        CGFloat newZoomScale = holderView.zoomScale * 4.0f;
        newZoomScale = MIN(newZoomScale, holderView.maximumZoomScale);
        CGSize scrollViewSize =holderView.bounds.size;
        CGFloat w = scrollViewSize.width / newZoomScale;
        CGFloat h = scrollViewSize.height / newZoomScale;
        CGFloat x = pointInView.x - (w / 2.0f);
        CGFloat y = pointInView.y - (h / 2.0f);
        CGRect rectToZoomTo = CGRectMake(x, y, w, h);
        [holderView zoomToRect:rectToZoomTo animated:YES];
    }else{
        isFirst=NO;
        CGFloat newZoomScale = holderView.zoomScale / 4.0f;
        newZoomScale = MAX(newZoomScale, holderView.minimumZoomScale);
        [holderView setZoomScale:newZoomScale animated:YES];
    }
    
}

- (void)singleTap:(UITapGestureRecognizer*)tap{
    
    [UIView animateWithDuration:0.4 animations:^{
        [self->showImgView setFrame:oldframe];
        [self->holderView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [self->holderView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}

@end
