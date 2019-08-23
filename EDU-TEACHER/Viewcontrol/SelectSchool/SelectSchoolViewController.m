//
//  SelectSchoolViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/27.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SelectSchoolViewController.h"  
#import "SHChatMessageViewController.h"
#import "DEFINE.h"
#import "LTSearchBar.h"
@interface SelectSchoolViewController ()<UITableViewDelegate,UITableViewDataSource,
UISearchBarDelegate>
{
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *serverDataArr;//数据源
@property(nonatomic,assign)BOOL isEdit;
@property (nonatomic, strong) LTSearchBar *searchBar;
@property (nonatomic, strong) UIBarButtonItem *rightitem;

@end

@implementation SelectSchoolViewController
NSMutableArray *_searchResultArr;//搜索结果Arr


- (void)viewDidLoad {
    [super viewDidLoad];
    _searchResultArr=[NSMutableArray array];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self serverDataArr];
    [self initNavBar];
    [self.view addSubview:[self addSearchBar]];
    [self.view addSubview:self.tableView];
    
}
#pragma mark - dataArr(数据)
- (NSArray *)serverDataArr{
    if (!_serverDataArr) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"selectschool" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSArray *jsonArray = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions|NSJSONWritingPrettyPrinted error:nil] mutableCopy];
        _serverDataArr=jsonArray;
    }
    return _serverDataArr;
}
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navTitle= @"选择学校";
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 添加搜索条
- (LTSearchBar *)addSearchBar {
    //加上 搜索栏
    self.searchBar= [[LTSearchBar alloc] initWithFrame:CGRectMake(10,kNavBarHeight+5, kWidth-20 , 40)];
    
    self.searchBar.isChangeFrame=NO;
    self.searchBar.showCancel=YES;
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.delegate = self;
    //输入框提示
    self.searchBar.placeholder = @"搜索";
    //光标颜色
    self.searchBar.cursorColor = [UIColor darkGrayColor];
    //TextField
    self.searchBar.searchBarTextField.layer.cornerRadius = 4;
    self.searchBar.searchBarTextField.layer.masksToBounds = YES;
    self.searchBar.searchBarTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    self.searchBar.searchBarTextField.layer.borderWidth = 1.0;
    self.searchBar.searchBarTextField.backgroundColor=GKColorHEX(0xf7f7f7, 1);
    
    //清除按钮图标
    self.searchBar.clearButtonImage = [UIImage imageNamed:@"deleteicon_channel"];
    
    //去掉取消按钮灰色背景
    self.searchBar.hideSearchBarBackgroundImage = YES;
    _isEdit=NO;
    return self.searchBar;
}
#pragma mark - 已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    LTSearchBar *sear = (LTSearchBar *)searchBar;
    //取消按钮
    sear.cancleButton.backgroundColor = [UIColor clearColor];
    [sear.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [sear.cancleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    sear.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _isEdit=YES;
    [_searchResultArr removeAllObjects];
    [self.tableView reloadData];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
}

#pragma mark - 编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText:%@",searchText);
    [self filterContentForSearchText:searchText scope:[self.searchBar scopeButtonTitles][self.searchBar.selectedScopeButtonIndex]];
}
#pragma mark - 搜索按钮点击的回调
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

#pragma mark - 取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
    _isEdit=NO;
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+50, kWidth, kHeight-kNavBarHeight-44) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listCell"];
        _tableView.rowHeight = 50.0f;
    }
    return _tableView;
}


#pragma mark - 数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_isEdit){
        return _searchResultArr.count;
    }
    else{
        return _serverDataArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
     if(_isEdit){
         cell.textLabel.text = [[_searchResultArr objectAtIndex:indexPath.row] objectForKey:@"name"] ;
     }
     else{
         cell.textLabel.text = [[_serverDataArr objectAtIndex:indexPath.row] objectForKey:@"name"] ;
     }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_seletedSchool) {
        if(_isEdit){
            self.seletedSchool([_searchResultArr objectAtIndex:indexPath.row]);
        }
        else{
            self.seletedSchool([_serverDataArr objectAtIndex:indexPath.row]);
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 源字符串内容是否包含或等于要搜索的字符串内容
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    for (int i = 0; i < self.serverDataArr.count; i++) {
        NSString *storeString = [[_serverDataArr objectAtIndex:i] objectForKey:@"name"] ;
        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            [tempResults addObject:[_serverDataArr objectAtIndex:i]];
        }
    }
    [_searchResultArr removeAllObjects];
    [_searchResultArr addObjectsFromArray:tempResults];
    [self.tableView reloadData];
}


 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
