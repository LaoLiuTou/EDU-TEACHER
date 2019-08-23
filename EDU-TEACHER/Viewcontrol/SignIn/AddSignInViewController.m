//
//  AddSignInViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/21.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddSignInViewController.h"
#import "MCPickerView.h"
#import "MCPickerModel.h"
#import "MJExtension.h"
@interface AddSignInViewController ()<MCPickerViewDelegate>
@property (nonatomic , strong) MCPickerView *picker ;
@property (nonatomic , strong) NSMutableArray * schoolData;
@end

@implementation AddSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initSchoolDat];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"方式1" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor purpleColor];
    [button addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 100, self.view.frame.size.width, 40);
    [self.view addSubview:button];
    
}

#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarClick)];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.gk_navRightBarButtonItem = rightitem;
    self.view.backgroundColor=[UIColor whiteColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarClick {
    NSLog(@"more");
    
}

#pragma mark - 初始化学校数据
-(void) initSchoolDat{
    self.schoolData = [NSMutableArray array];
    __weak typeof(self)weakSelf = self;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"school" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSArray *jsonArray = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions|NSJSONWritingPrettyPrinted error:nil] mutableCopy];
    [jsonArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.schoolData addObject:[MCPickerModel mj_objectWithKeyValues:obj]];
    }];
}

#pragma mark - 学校选择器代理
- (void)MCPickerView:(MCPickerView *)MCPickerView selectId:(NSString *)selectId completeTitleArray:(NSMutableArray<MCPickerModel *> *)comtitleArray completeStr:(NSString *)comStr
{
    NSLog(@"%@",selectId);
    NSLog(@"%@",comtitleArray);
    NSLog(@"%@",comStr);
}
- (NSMutableArray<MCPickerModel *> *)MCPickerView:(MCPickerView *)MCPickerView didSelcetedTier:(NSInteger)tier selcetedValue:(MCPickerModel *)value
{
    __block NSMutableArray *tempTown = [NSMutableArray array];
    [value.child enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempTown addObject:[MCPickerModel mj_objectWithKeyValues:obj]];
    }];
    return tempTown;
}

- (void)clickBtn
{
    self.picker  =[[MCPickerView alloc]initWithFrame:self.view.bounds];
    self.picker.delegate = self;
    self.picker.titleText = @"选择区域";
    self.picker.dataArray = self.schoolData;
    [self.view addSubview:self.picker];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
