//
//  CustomTabBarController.m
 
//

#import "LTTabBarController.h"

#import "CustomTabBar.h"
#import "MainViewController.h"
#import "ContactVC.h"
#import "MessageVC.h"
#import "MyVC.h"
#import "LGSocketServe.h"
#import "AppDelegate.h"
#import "YBPopupMenu.h"
#import "AddNoteVC.h"
#import "AddMemoVC.h"
@interface LTTabBarController ()<CustomTabBarDelegate,YBPopupMenuDelegate>

@property(nonatomic, strong)CustomTabBar *mainTabBar;

@end

@implementation LTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTabBar];
    [self setupControllers];
    [self initUserInfo];
}

-(void)initUserInfo{
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"configInfo.plist"];
    NSMutableDictionary *localConfigDic=[[[NSMutableDictionary alloc]initWithContentsOfFile:filename] mutableCopy];
    jbad.userInfoDic=[localConfigDic objectForKey:@"userInfo"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    LGSocketServe *socketServe = [LGSocketServe sharedSocketServe];
    [socketServe cutOffSocket];
    socketServe.socket.userData = SocketOfflineByServer;
    [socketServe startConnectSocket];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ 
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    });
}

- (void)initTabBar{
    CustomTabBar *mainTabBar = [[CustomTabBar alloc] init];
    mainTabBar.frame = self.tabBar.bounds;
    mainTabBar.delegate = self;
    [self.tabBar addSubview:mainTabBar];
    _mainTabBar = mainTabBar;
//    
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];
    [self dropShadowWithOffset:CGSizeMake(0, -1) radius:1 color:[UIColor lightGrayColor] opacity:0.2];
    
   
}

- (void)setupControllers{
    NSArray *titles = @[@"首页", @"消息", @"学生管理", @"我的"];
    NSArray *selectedImages = @[@"shouye", @"xiaoxi", @"tongxunlu", @"wode"];
    
    NSArray *images = @[@"shouye-hui", @"xiaoxi-hui", @"tongxunlu-hui", @"wode-hui"];
    
    MainViewController * homeVC = [[MainViewController alloc] init];
    
    MessageVC * messageVC = [[MessageVC alloc] init];
    
    ContactVC * notificationVc = [[ContactVC alloc] init];
    
    MyVC * meVc = [[MyVC alloc] init];
    
    NSArray *viewControllers = @[homeVC, messageVC, notificationVc, meVc];
    
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *childVc = viewControllers[i];
        [self setupChildVc:childVc title:titles[i] image:images[i] selectedImage:selectedImages[i]];
    }
}

- (void)setupChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName{
    
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.title = title;
    [self.mainTabBar addTabBarButtonWithTabBarItem:childVc.tabBarItem];
    [self addChildViewController:childVc];
}

#pragma mark --------------------mainTabBar delegate
- (void)tabBar:(CustomTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag{
    self.selectedIndex = toBtnTag;
    if(toBtnTag == 0){
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"refreshMain" object:nil userInfo:nil]];
    }
}

- (void)postAddBtn:(UIButton *)addBtn {
    NSLog(@"click add");
    [YBPopupMenu showRelyOnView:addBtn titles:@[@"工作备忘", @"工作日志"] icons:@[@"addmemo",@"addnote"] menuWidth:150 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.borderWidth = 0;
        popupMenu.delegate = self;
        popupMenu.dismissOnSelected = YES;
        popupMenu.isShowShadow = NO;
        popupMenu.itemHeight=50;
        //popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        popupMenu.type = YBPopupMenuTypeDefault;
    }];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    NSLog(@"点击了 %@ 选项",@[@"工作备忘",@"工作日志"][index]);
    switch (index) {
        case 0:
            [self.navigationController pushViewController:[AddMemoVC new] animated:YES];
            break;
        case 1:
            
            [self.navigationController pushViewController:[AddNoteVC new] animated:YES];
            break;
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.view.window==nil) {
        self.view=nil;
    }
}


//tabBar顶部加阴影
- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.tabBar.clipsToBounds = NO;
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


@end
