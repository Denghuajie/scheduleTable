//
//  DJScheduleSettingViewController.m
//  ScheduleTable
//
//  Created by Mr.Deng on 16/1/5.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import "DJScheduleSettingViewController.h"

@interface DJScheduleSettingViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *numField;

@property(nonatomic,strong) UIToolbar *toolBar;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign) NSInteger selectRow;

@property (nonatomic, strong) NSArray *numArray;

@end

@implementation DJScheduleSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self setupNavigationBarWithLeftBtnImage:@"nav_back_icon" titleName:@"课程设置" rightBtnImage:nil];

    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.numField.inputView = self.pickerView;
    self.numField.inputAccessoryView = self.toolBar;
    
    self.numArray = [NSArray arrayWithObjects:@"5", @"6", @"7", @"8", @"9", @"10", nil];
    
    [self loadNumField];
    [self matchField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}


#pragma mark - load & match Field
- (void)loadNumField
{
    if ([DJFunction getDataFromSandBoxWithKey:@"maxNum"] != nil)
    {
        self.numField.text = [DJFunction getDataFromSandBoxWithKey:@"maxNum"];
    }
    else
    {
        self.numField.text = @"8";
    }
}

- (void)matchField
{
    for (int i = 0 ; i < self.numArray.count; i++) {
        if ([self.numArray[i] isEqualToString: self.numField.text])
        {
            [self.pickerView selectRow:i inComponent:0 animated:YES];
        }
    }
}

- (void)backMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.numArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.numArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.numField.text = self.numArray[row];
}

#pragma mark - ToolBarButtonItem
- (void)cancelItemClick
{
    [self loadNumField];
    [self.view endEditing:YES];
}

- (void)finishItemClick
{
    [DJFunction saveData:self.numField.text key:@"maxNum"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showSuccessWithStatus:@"设置生效"];
    
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancelItemClick];
}

#pragma mark - KeyboardEvent
- (void)keyboardWillShow:(NSNotification *)note
{
    [self matchField];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Lazy load
- (UIToolbar *)toolBar {
    if (_toolBar == nil) {
        
        _toolBar = [[UIToolbar alloc] init];
        
        _toolBar.frame = CGRectMake(0, 0, 0, 40);
        
        _toolBar.barTintColor = [UIColor orangeColor];
        
        _toolBar.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClick)];
        
        UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(finishItemClick)];
     
        UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        _toolBar.items = @[cancelItem,flexibleSpaceItem,finishItem];
    }
    return _toolBar;
}

@end
