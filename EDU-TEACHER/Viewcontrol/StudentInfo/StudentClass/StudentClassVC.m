//
//  StudentClassVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentClassVC.h"
#import "DEFINE.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "StudentClassModel.h"
#import "CourseButton.h"
#import "TwoTitleButton.h"
#import "StudentClassDetailView.h"
#define kWidthGrid  (SCREENWIDTH / 8)   //周课表中一个格子的宽度
#define kHeightGrid 60
#define kWeekHeaderHeight 60  //顶部周视图的高度
@interface StudentClassVC ()<StudentClassDelegate>{
    UIScrollView *scrollView; //日课表的滚动视图（里面装了7个tableView）
    UIScrollView *weekScrollView;  //周课表的滚动视图
    UIView       *weekView; //周课表的视图
    
    NSArray *horTitles;  //横向的标题，（月份、日期）
    NSDateComponents *todayComp;  //今天的扩展
    NSArray *dataArray;   //日课表中每个cell的数据
}

/**
 *  课程表普通课程背景颜色数组
 */
@property (nonatomic, strong) NSArray *colorsArray;
/**
 *  课程表选修课程背景颜色
 */
@property (nonatomic, copy) NSString *selectedClassColor;
/**
 *  课时数据
 */
@property (nonatomic, strong) NSMutableArray *classOrderArray;
/**
 *  课程数据
 */
@property (nonatomic, strong) NSMutableArray *classArray;
/**
 *  点击课程的弹层视图
 */
@property (nonatomic, strong) StudentClassDetailView *showView;
@end

@implementation StudentClassVC{
    NSInteger count;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    count = 0;
    
    [self loadBaseData];
    
    [SVProgressHUD show];
    
    [self getCLassOrderData];
    
    [self getClassData];
}

#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    
    
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=@"本学期课表";
    self.gk_navTitleColor=[UIColor blackColor];
}


- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 获取课时
- (void)getCLassOrderData{
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"USER_ID":[jbad.userInfoDic objectForKey:@"USER_ID"],@"xs_id": self.xs_id};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryClassTimeList"];
    //NSString *postUrl = @"http://192.168.1.169/life/public/api.php/Api/queryClassTimeList";
    //NSDictionary *paramDic = @{@"xs_id":@"2225"};
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            NSArray *array = [resultDic objectForKey:@"Result"];
            for (NSDictionary *dic in array){
                ClassOrderModel *model = [[ClassOrderModel alloc] initWithDictionary:dic error:nil];
                [self.classOrderArray addObject:model];
            }
            [self loadUI];
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败！"];
    }];
    
    
    
}

#pragma mark - 获取课程数据
- (void)getClassData{
    
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"USER_ID":[jbad.userInfoDic objectForKey:@"USER_ID"],@"xs_id": self.xs_id,@"date":[[JBPersonalTools sharedInstance] getNowDateStrWithFormat:Date_YearMonthDay]};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryStudentTimeTable"];
    
    //NSString *postUrl = @"http://192.168.1.169/life/public/api.php/Api/queryStudentTimeTable";
    
    //NSDictionary *paramDic = @{@"xs_id":@"2225", @"date":[[JBPersonalTools sharedInstance] getNowDateStrWithFormat:Date_YearMonthDay]};
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            NSArray *array = [resultDic objectForKey:@"Result"];
            
            for (NSDictionary *dic in array){
                [self.classArray addObject:dic];
            }
            [self loadUI];
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败！"];
    }];
    
    
    
}

#pragma mark - 请求完数据后课程UI
- (void)loadUI{
    
    count += 1;
    
    if(count == 2){
        
        [SVProgressHUD dismiss];
        
        if(self.classOrderArray.count > 0){
            
            [self initWeekView];
            
            [self handleWeek:self.classArray week:@"1"];
            
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:self.showView];
            [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }else{
            [SVProgressHUD showInfoWithStatus:@"辅导员未创建课程表.."];
        }
    }
}

#pragma mark - 不需要请求的数据
- (void)loadBaseData{
    
    self.colorsArray = @[@"#28d6b1",
                         @"#ff8694",
                         @"#fdbb4b",
                         @"#87abfa",
                         @"#ff764d",
                         @"#8088ac",
                         @"#f52c57",
                         @"#28bbd6",
                         @"#bd87fa"];
    
    self.selectedClassColor = @"#d0cece";
    
    //如果数据当前周为空，则默认为第一周
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString  *currentWeek = [userDefaults objectForKey:@"currentWeek"];
    if (currentWeek == nil) {
        [userDefaults setObject:@"1" forKey:@"currentWeek"];
        [userDefaults synchronize];
    }
    
    //先加载本周的月份以及日期
    horTitles = [[JBPersonalTools sharedInstance] getDatesOfCurrence:Date_Day];
    
    //赋值计算今天的日期
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    todayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
}

#pragma mark - 解析数据
- (void)handleWeek:(NSArray *)array week:(NSString *)week{
    
    NSArray *dateArray = [[JBPersonalTools sharedInstance] getDatesOfCurrence:Date_YearMonthDay];
    NSString *date = @"";
    NSMutableArray *allCourses =[NSMutableArray array];
    
    if (array != nil && array.count > 0) {
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dayDict = array[i];
            NSArray *dayCourses = [dayDict objectForKey:@"data"];
            NSString *weekDay = [dayDict objectForKey:@"weekDay"];
            NSString *weekNum;
            if ([@"monday" isEqualToString:weekDay]) {
                weekNum = @"1";
                date = dateArray[1];
            }else if ([@"tuesday" isEqualToString:weekDay]){
                weekNum = @"2";
                date = dateArray[2];
            }else if ([@"wednesday" isEqualToString:weekDay]){
                weekNum = @"3";
                date = dateArray[3];
            }else if ([@"thursday" isEqualToString:weekDay]){
                weekNum = @"4";
                date = dateArray[4];
            }else if ([@"friday" isEqualToString:weekDay]){
                weekNum = @"5";
                date = dateArray[5];
            }else if ([@"saturday" isEqualToString:weekDay]){
                weekNum = @"6";
                date = dateArray[6];
            }else if([@"sunday" isEqualToString:weekDay]){
                weekNum = @"7";
                date = dateArray[7];
            }else {
                weekNum = weekDay;
            }
            for (int j = 0; j<dayCourses.count; j++) {
                NSMutableDictionary *course = [NSMutableDictionary dictionaryWithDictionary:dayCourses[j]];
                [course setObject:weekNum forKey:@"weekDay"];
                StudentClassModel *weekCourse = [[StudentClassModel alloc] initWithPropertiesDictionary:course];
                weekCourse.date = date;
                [allCourses addObject:weekCourse];
            }
        }
    }
    
    //对数据解析
    [self handleData:allCourses];
}

#pragma mark - 数据解析后，展示在UI上
- (void)handleData:(NSArray *)courses
{
    if (dataArray || dataArray.count > 0) {
        dataArray = nil;
    }
    
    for (UIView *view in weekScrollView.subviews) {
        if ([view isKindOfClass:[CourseButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (courses.count > 0) {
        //处理周课表
        for (int i = 0; i < courses.count; i++) {
            StudentClassModel *course = courses[i];
            
            int rowNum = course.lesson.intValue - 1;
            int colNum = course.day.intValue;
            int lessonsNum = course.lessonsNum.intValue;
            
            CourseButton *courseButton = [[CourseButton alloc] initWithFrame:CGRectMake((colNum - 0) * kWidthGrid, kHeightGrid * rowNum + 1, kWidthGrid - 2, kHeightGrid * lessonsNum - 2)];
            courseButton.weekCourse = course;
            int index = i % self.colorsArray.count;
            courseButton.backgroundColor = [UIColor colorWithHexString:self.colorsArray[index]];
            [courseButton addTarget:self action:@selector(courseClick:) forControlEvents:UIControlEventTouchUpInside];
            [weekScrollView addSubview:courseButton];
        }
        
        //日课表数据处理
        dataArray = [self getCoursesWithServerData:courses];
    } else {
        dataArray = [self getCoursesWithServerData:nil];
    }
    
    for (int i = 0; i< 7; i++) {
        UITableView *tableView = (UITableView *)[scrollView viewWithTag:10000+i];
        [tableView reloadData];
    }
}

#pragma mark - 初始化周视图
- (void)initWeekView{
    weekView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - JB_StatusBarAndNavigationBarHeight - 0)];
    //初始化周视图的头
    UIView *weekHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREENWIDTH, kWeekHeaderHeight)];
    
    //顶部星期
    NSArray *weekDays = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    for (int i = 0; i < 8; i++) {
        TwoTitleButton *button = [[TwoTitleButton alloc] initWithFrame:CGRectMake(i * kWidthGrid, 0, kWidthGrid, kWeekHeaderHeight)];
        if(i == 0){
            button.title = horTitles[0];
            button.subtitle = @"月";
            button.textColor = [UIColor blackColor];
        }else{
            NSString *title = [NSString stringWithFormat:@"周%@",weekDays[i - 1]];
            button.tag = 9000 + i;
            button.title = title;
            button.subtitle = horTitles[i];
            
            //判断是不是当天，如果是当天则文字变色
            NSString *month = @"";
            if(todayComp.month < 10){
                month = [NSString stringWithFormat:@"0%ld",(long)[todayComp month]];
            }else{
                month = [NSString stringWithFormat:@"%ld",(long)[todayComp month]];
            }
            NSString *day = [NSString stringWithFormat:@"%ld",(long)[todayComp day]];
            if ([month isEqualToString:horTitles[0]] && [day isEqualToString:horTitles[i]]) {
                button.textColor = kGreenColor;
            }
        }
        
        
        [weekHeaderView addSubview:button];
    }
    [weekView addSubview:weekHeaderView];
    
    //主体部分
    weekScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kWeekHeaderHeight+kNavBarHeight, SCREENWIDTH, weekView.frame.size.height - kWeekHeaderHeight)];
    weekScrollView.bounces = NO;
    weekScrollView.contentSize = CGSizeMake(SCREENWIDTH, kHeightGrid * self.classOrderArray.count);
    for (int i = 0; i < self.classOrderArray.count; i++) {
        ClassOrderModel *model = self.classOrderArray[i];
        for (int j = 0; j < 8; j++) {
            if (j == 0) {
                
                //开头课时
                TwoTitleButton *button = [[TwoTitleButton alloc] initWithFrame:CGRectMake(j * kWidthGrid, i * kHeightGrid , kWidthGrid, kHeightGrid)];
                button.title = model.ST_T;
                button.subtitle = model.CLASS_ORDER;
                button.title_color = kDarkGrayColor;
                button.subtitle_color = [UIColor blackColor];
                button.subtitle_font = [UIFont boldSystemFontOfSize:16.f];
                [weekScrollView addSubview:button];
            }
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kWidthGrid, kHeightGrid * (i + 1), SCREENWIDTH - kWidthGrid, 0.3)];
        line.backgroundColor = kLightGrayColor;
        [weekScrollView addSubview:line];
        
    }
    [weekView addSubview:weekScrollView];
    
    [self.view addSubview:weekView];
    [self.view sendSubviewToBack:weekView];
}

#pragma mark - 课程点击事件
- (void)courseClick:(CourseButton *)btn{
    
    self.showView.model = btn.weekCourse;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.alpha = 1.f;
    }];
}

#pragma mark - ClassDetailViewDelegate
- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.alpha = 0.f;
    }];
}

#pragma mark - 私有方法
/**
 *  获取星期几的课程
 *
 *  @param weekDay 星期几，如：星期一是monday
 *  @param courses 服务器返回的课程数组
 *
 *  @return 返回课程 （按照上课顺序 从第一节......到第第十二节）
 */
- (NSMutableArray *)getDayCoursesByWeekDay:(NSString *)weekDay srcArray:(NSArray *)courses
{
    //返回时使用的数组
    NSMutableArray *newCourses = [NSMutableArray array];
    int rowNum = 1;//默认从第一节开始计算
    if (courses == nil) { //如果没有数据时
        for (int j = rowNum; j< 13; j++) {
            StudentClassModel *weekCourse = [[StudentClassModel alloc] init];
            [newCourses addObject:weekCourse];
        }
        return newCourses;
    }
    //星期几的课程  --- 用到了谓词
    NSString *string = [NSString stringWithFormat:@"day == '%@'",weekDay];
    NSPredicate *pre = [NSPredicate predicateWithFormat:string];
    //应该只有一条记录
    NSArray *coursesOfDay = [courses filteredArrayUsingPredicate:pre]; //筛选出某天的课程信息
    //终于拿到课程了
    for (int i = 0; i < coursesOfDay.count; i++) {
        //每一条记录为一个cell的数据，这里给Model添加capter属性,设置哪几节上课
        StudentClassModel *course = [coursesOfDay objectAtIndex:i];
        NSString *lesson = course.lesson;
        NSString *lessonsNum = course.lessonsNum;
        int endCapter = lesson.intValue+lessonsNum.intValue -1;
        //判断是否之前有空着的，如果有插入空节数
        if (rowNum != lesson.intValue) {
            for (int j = rowNum; j<lesson.intValue; j++) {
                StudentClassModel *weekCourse = [[StudentClassModel alloc] init];
                [newCourses addObject:weekCourse];//把一些只包含节数信息的对象 插入数组
            }
        }
        
        //把重新组装的dict 加入数组
        [newCourses addObject:course];
        rowNum = endCapter +1;
    }
    
    //如果还没计算到第12节，后面的也要插入只包含节数的dict
    if (rowNum < 12) {
        for (int j = rowNum; j< 13; j++) {
            StudentClassModel *weekCourse = [[StudentClassModel alloc] init];
            [newCourses addObject:weekCourse];
        }
    }
    return newCourses;
}

//计算出周一至周日的课程，封装成数组
- (NSMutableArray *)getCoursesWithServerData:(NSArray *)array
{
    NSMutableArray *dayAllCourses = [[NSMutableArray alloc] initWithCapacity:7];
    NSArray *weekDays = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",];
    //计算出周一至周日的课程，封装成数组
    for (int i = 0; i < weekDays.count; i++) {
        NSString *weekday = [weekDays objectAtIndex:i];
        NSMutableArray *newCourses = [self getDayCoursesByWeekDay:weekday srcArray:array];
        [dayAllCourses addObject:newCourses];
    }
    return dayAllCourses;
}

#pragma mark - 懒加载
- (NSMutableArray *)classOrderArray{
    if(!_classOrderArray){
        _classOrderArray = [NSMutableArray array];
    }
    return _classOrderArray;
}

- (NSMutableArray *)classArray{
    if(!_classArray){
        _classArray = [NSMutableArray array];
    }
    return _classArray;
}

- (StudentClassDetailView *)showView{
    if(!_showView){
        _showView = [[StudentClassDetailView alloc]init];
        _showView.delegate = self;
        _showView.tag = 10086;
        _showView.alpha = 0.f;
    }
    return _showView;
}

- (void)dealloc{
    [[[UIApplication sharedApplication].keyWindow viewWithTag:10086] removeFromSuperview];
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
