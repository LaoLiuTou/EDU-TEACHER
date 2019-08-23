//
//  SHMenuController.h 
//

#import <UIKit/UIKit.h>

/**
 长按菜单
 */
@interface SHMenuController : UIMenuController

/**
 显示菜单

 @param view 父视图
 @param menuArr 集合
 @param showPiont 坐标
 */
+ (void)showMenuControllerWithView:(UIView *)view menuArr:(NSArray *)menuArr showPiont:(CGPoint)showPiont;

@end
