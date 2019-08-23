//
//  AddNoteVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/5.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddNoteVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "AddNoteView.h"
#import "NoteVC.h"
#import "SelectStudentVC.h"
#import "ScrollAddLabel.h"
@interface AddNoteVC ()<AddNoteDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) AddNoteView *addNoteView;
@property (nonatomic, strong) UIButton *publishBtn;

@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation AddNoteVC{
    NSString *xs_names;
    NSString *xs_ids;
    NSString *xs_type;
    NSDictionary *tempStudentDic;
    NSString *notificationName;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initView];
    
    //选择学生
    xs_names=@"";
    xs_ids=@"";
    xs_type=@"";
    tempStudentDic=[NSDictionary new];
    //注册通知：
    notificationName=@"SelectStudentNote";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnSelectDic:) name:notificationName object:nil];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectStudent" object:nil];
}
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=@"创建日志";
    self.gk_navTitleColor=[UIColor blackColor];
}

- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化视图
- (void)initView{
    self.view.backgroundColor=GKColorRGB(246, 246, 246);
    [self.view addSubview:self.publishBtn];
    [self.view addSubview:self.saveBtn];
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:_scrollView];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10-BottomPaddingHeight);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(40);
    }];
  
    
    AddNoteView *addNoteView = [[AddNoteView alloc]init];
    _addNoteView=addNoteView;
    //_addStudentTalkingView.frame = CGRectMake(0, 0, kWidth, kHeight);
    _addNoteView.delegate = self;
    int height=[_addNoteView initView];
    //[self.view addSubview:_addStudentTalkingView];
    [self.scrollView addSubview:_addNoteView];
    _scrollView.contentSize =CGSizeMake(0,height>kHeight?height:kHeight+1);
    
    
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kNavBarHeight, kWidth, kHeight-kNavBarHeight-60-BottomPaddingHeight)];
        
        _scrollView.backgroundColor=GKColorRGB(246, 246, 246);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        //_scrollView.contentSize =CGSizeMake(0,kHeight+10);
        // 设置代理人
        _scrollView.delegate =self;
        
    }
    return _scrollView;
}
-(UIButton *)saveBtn{
    if (!_saveBtn) {
        UIButton *saveBtn=[[UIButton alloc] init];
        _saveBtn=saveBtn;
        _saveBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_saveBtn addTarget:self action:@selector(clickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saveBtn.layer.cornerRadius=12;
        _saveBtn.layer.masksToBounds=YES;
        _saveBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _saveBtn;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}

#pragma mark - 创建
-(void)addNote{
//    if([self.addNoteView.nameText.text isEqualToString:@""]){
//        [[LTAlertView new] showOneChooseAlertViewMessage:@"日志名称不能为空！"];
//    }
//    else if(self.addNoteView.nameText.text.length>50){
//        [[LTAlertView new] showOneChooseAlertViewMessage:@"日志名称最多可输入50个汉字！"];
//    }
//    else
    if(self.addNoteView.commentText.text.length>1000){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"内容最多可输入1000个汉字！"];
    }
    else{
        
        [SVProgressHUD showWithStatus:@"加载中"];
        [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableDictionary *paramDic =[NSMutableDictionary new];
        [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
        //[paramDic setObject:self.addNoteView.nameText.text forKey:@"name"];
        if(![self.addNoteView.commentText.text isEqualToString:@"添加日志内容"]){
            [paramDic setObject:self.addNoteView.commentText.text forKey:@"comment"];
        }
        if(![xs_ids isEqualToString:@""]){
            [paramDic setObject:xs_ids forKey:@"xs_ids"];
        }
        //[paramDic setObject:@[@"日常管理",@"谈心谈话"][self.addNoteView.typeSegment.selectedSegmentIndex] forKey:@"type"];
 
        NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"addRizhi"];
        LTHTTPManager * manager = [LTHTTPManager manager];
        [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *resultDic=responseObject;
            if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
                
                [SVProgressHUD dismiss];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[resultDic objectForKey:@"Point"] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NoteVC *jumpVC=[NoteVC new];
                    NSMutableArray *navViewArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                    int index = (int)[navViewArray indexOfObject:self];
                    [navViewArray removeObjectAtIndex:index];
                    [navViewArray removeObjectAtIndex:index-1];
                    [navViewArray addObject:jumpVC];
                    [self.navigationController setViewControllers:navViewArray animated:YES];
                    
                }])];
                [self presentViewController:alertController animated:YES completion:nil];
                
                
            }
            else{
                [SVProgressHUD dismiss];
                [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
            NSLog(@"请求失败----%@", error);
            [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败！"];
        }];
        
        
    }
    
    
    
}


#pragma mark - 选择学生
- (void)clickSelectStu{
    NSLog(@"clickSelectStuBtn");
    
    SelectStudentVC *jumpVC=[SelectStudentVC new];
    //{tag:@{1:[1,2,3]},class:@{2:[1,2]}}
    if([xs_type isEqualToString:@"tag"]){
        jumpVC.values=@{@"tag":tempStudentDic};
    }
    else if([xs_type isEqualToString:@"class"]){
        jumpVC.selectIndex=1;
        jumpVC.values=@{@"class":tempStudentDic};
    }
    jumpVC.notificationName=notificationName;
    [self.navigationController pushViewController:jumpVC animated:YES];
    
}
- (void)returnSelectDic:(NSNotification *)notification{
    NSLog(@"SelectDic%@",notification.userInfo);
    
    //移除
    xs_names=@"";
    xs_ids=@"";
    xs_type=@"";
    NSArray *views = [self.addNoteView.stuScrollView subviews];
    for(UIView *view in views)
    {
        [view removeFromSuperview];
    }
    
    NSArray *stuIdArray=[notification.userInfo objectForKey:@"studentId"];
    NSArray *stuNameArray=[notification.userInfo objectForKey:@"studentName"];
    tempStudentDic=[notification.userInfo objectForKey:@"tempValue"];
    
    xs_type=[notification.userInfo objectForKey:@"type"];
    xs_ids=[stuIdArray count]>0?[stuIdArray componentsJoinedByString:@","]:@"";
    xs_names=[stuNameArray count]>0?[stuNameArray componentsJoinedByString:@","]:@"";
    //self.addNoteView.studentLabel.text=xs_names;
    [self.addNoteView.selectImage setHidden:YES];
    [[ScrollAddLabel new] addLabelToScrollView:self.addNoteView.stuScrollView labels:stuNameArray];
}

#pragma mark - 保存
- (void)clickSaveBtn:(UIButton *)btn {
    
    [self addNote];
    
    
}
 

@end


