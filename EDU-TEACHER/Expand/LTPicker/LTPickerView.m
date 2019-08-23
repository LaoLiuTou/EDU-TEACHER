//
//  LTPickerView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/27.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "LTPickerView.h"
#import "DEFINE.h"
@interface LTPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong)UIView *pickerView;
@property (nonatomic, strong)UIView *back;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSDictionary *selectDic;
@property (nonatomic, assign)NSInteger IdNum;

@end

@implementation LTPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatCaverView];
        [self creatAnimation];
        
    }
    return self;
}


- (void)creatAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        self.back.alpha = 0.3;
        self.picker.frame = CGRectMake(0, kHeight - kWidth / 2., kWidth, kWidth / 2.);
        self.pickerView.frame = CGRectMake(0, kHeight - kWidth / 2. - 30, kHeight, 30);
    }];
}


//添加遮盖层
- (void)creatCaverView
{
    //添加一个遮盖UIView
    _back = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _back.backgroundColor = [UIColor blackColor];
    _back.alpha = 0;
    [self addSubview:_back];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker)];
    tap.numberOfTapsRequired = 1;
    [_back addGestureRecognizer:tap];
    [self creatPickView];
}

//picker上面的取消和确定按钮
- (void)creatPickView
{
    _pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight, kWidth, 30)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerView];
    UIView *headLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];
    headLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:headLine];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 10, 80, 20);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    leftButton.titleLabel.font = [UIFont systemFontOfSize:18.];
    [_pickerView addSubview:leftButton];
    [leftButton addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(kWidth - 30 - 60, 10, 80, 20);
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:GKColorHEX(0x2c92f5,1) forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:18.];
    [_pickerView addSubview:rightButton];
    [rightButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kHeight + 30, kWidth, kWidth / 2.0)];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.backgroundColor = [UIColor whiteColor];
    [self addSubview:_picker];
}

// picker确定按钮点击事件
- (void)confirm
{
    if (!_selectDic) {
        _selectDic = self.dataArray[0];
        if([_delegate respondsToSelector:@selector(pickViewSureBtnClick:)])
            [_delegate pickViewSureBtnClick:_selectDic];
    }
    else
    {
        if([_delegate respondsToSelector:@selector(pickViewSureBtnClick:)])
            [_delegate pickViewSureBtnClick:_selectDic];
    }
    
    [self cancelPicker];
}

// 弹回picker
- (void)cancelPicker
{
    [UIView animateWithDuration:0.25 animations:^{
        self.back.alpha = 0;
        self.picker.frame = CGRectMake(0, kHeight + 30, kWidth, kWidth / 2.);
        self.pickerView.frame = CGRectMake(0, kHeight, kWidth, 30);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}


#pragma mark - UIPickerViewDelegate
// 告诉系统每一行显示什么内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",[self.dataArray[row] objectForKey:@"NM_T"] ];
}

// 监听pickerView的选中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectDic = [self.dataArray objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:20]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}




@end
