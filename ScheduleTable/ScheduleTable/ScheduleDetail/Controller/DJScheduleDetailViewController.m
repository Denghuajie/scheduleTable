//
//  DJScheduleDetailViewController.m
//  ScheduleTable
//
//  Created by Mr.Deng on 16/1/5.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import "DJScheduleDetailViewController.h"
@interface DJScheduleDetailViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *weekTypeField;

@property (weak, nonatomic) IBOutlet UITextField *subjectField;

@property (nonatomic, strong) NSArray *weekTypeArray;

@property (nonatomic, strong) NSArray *subjectArray;

@property (nonatomic, assign) NSInteger currentIndex;

@property(nonatomic,strong) UIToolbar *toolBar;

@property (nonatomic, strong) UIPickerView *weekTypePicker;

@property (nonatomic, strong) UIPickerView *subjectPicker;

@end

@implementation DJScheduleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBarWithLeftBtnImage:@"nav_back_icon" titleName:@"课程详情" rightBtnImage:nil];
    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    
    self.currentIndex = -1;
    self.model = [[DJScheduleModel alloc] init];
    self.subjectArray = [NSArray arrayWithObjects:@"语文", @"数学", @"英语", @"物理", @"化学", @"生物", @"历史", @"地理", @"思想政治", nil];
    self.weekTypeArray = [NSArray arrayWithObjects:@"全周", @"单周", @"双周", nil];
    
    [self setupPickerView];
    [self loadWeekTypeField];
    [self matchField];
    if ( [DJFunction getDataFromSandBoxWithKey:scheduleSingleWeekDataKey] != nil) {
        [DJSingletonData sharedInstance].scheduleSingleWeekData = [DJFunction getDataFromSandBoxWithKey:scheduleSingleWeekDataKey];
    }
    
    if ( [DJFunction getDataFromSandBoxWithKey:scheduleDoubleWeekDataKey] != nil) {
        [DJSingletonData sharedInstance].scheduleDoubleWeekData = [DJFunction getDataFromSandBoxWithKey:scheduleDoubleWeekDataKey];
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

#pragma mark - Action
- (IBAction)deleteBtnClick
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"确定删除吗？" preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {        
        [self deleteSchedule];
    }];
    [alertVc addAction:cancelAction];
    [alertVc addAction:sureAction];
    
    [self presentViewController:alertVc animated:YES completion:^{

    }];
}
- (void)deleteSchedule
{
    DJScheduleModel *model = [[DJScheduleModel alloc] init];
    model.weekNum = self.sectionNum % 6;
    model.resourceOrderNum = self.sectionNum / 6 + 1;
    model.resourceName = self.subjectField.text;
   if([self.weekTypeField.text isEqualToString:@"全周"])
   {
       model.weekType = 1;
       if([[DJSingletonData sharedInstance].scheduleSingleWeekData containsObject:model])
       {
           [[DJSingletonData sharedInstance].scheduleSingleWeekData removeObject:model];
           
           model.weekType = 2;
           
           if([[DJSingletonData sharedInstance].scheduleDoubleWeekData containsObject:model])
           {
               [[DJSingletonData sharedInstance].scheduleDoubleWeekData removeObject:model];
               
               //只有双周的课程也删除成功了才保存单周删除过的新数据
               [DJFunction saveData:[DJSingletonData sharedInstance].scheduleSingleWeekData key:scheduleSingleWeekDataKey];
               [DJFunction saveData:[DJSingletonData sharedInstance].scheduleDoubleWeekData key:scheduleDoubleWeekDataKey];
               [SVProgressHUD showSuccessWithStatus:@"课程删除成功"];
           }
           else
           {
               [SVProgressHUD showErrorWithStatus:@"要删除的课程不存在"];
               return;
           }
       }
       else
       {
           [SVProgressHUD showErrorWithStatus:@"要删除的课程不存在"];
           return;
       }
   }
   else if([self.weekTypeField.text isEqualToString:@"单周"])
   {
       model.weekType = 1;
       if([[DJSingletonData sharedInstance].scheduleSingleWeekData containsObject:model])
       {
           [[DJSingletonData sharedInstance].scheduleSingleWeekData removeObject:model];
           [DJFunction saveData:[DJSingletonData sharedInstance].scheduleSingleWeekData key:scheduleSingleWeekDataKey];
           [SVProgressHUD showSuccessWithStatus:@"删除成功"];
       }
       else
       {
           [SVProgressHUD showErrorWithStatus:@"要删除的课程不存在"];
           return;
       }
   }
   else if([self.weekTypeField.text isEqualToString:@"双周"])
   {
       model.weekType = 2;
       if([[DJSingletonData sharedInstance].scheduleDoubleWeekData containsObject:model])
       {
           [[DJSingletonData sharedInstance].scheduleDoubleWeekData removeObject:model];
           [DJFunction saveData:[DJSingletonData sharedInstance].scheduleDoubleWeekData key:scheduleDoubleWeekDataKey];
           [SVProgressHUD showSuccessWithStatus:@"删除成功"];
       }
       else
       {
           [SVProgressHUD showErrorWithStatus:@"要删除的课程不存在"];
           return;
       }
   }
}


- (void)rightBtnAction
{
    self.model.weekNum = self.sectionNum % 6;
    
    self.model.resourceOrderNum = self.sectionNum / 6 + 1;
    
    self.model.resourceName = self.subjectField.text;
    
    if([self.subjectField.text length] == 0){
        [SVProgressHUD showErrorWithStatus:@"还没选课......"];
        return;
    }    
    if ([self.weekTypeField.text isEqualToString:@"全周"]) {
        self.model.weekType = 1;
        [self saveSingleWeekData];
        
        self.model.weekType = 2;
        [self saveDoubleWeekData];
    }
    else if([self.weekTypeField.text isEqualToString:@"单周"]){
        self.model.weekType = 1;
        [self saveSingleWeekData];
    }
    else if([self.weekTypeField.text isEqualToString:@"双周"]){
        self.model.weekType = 2;
        [self saveDoubleWeekData];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Save
- (void)saveSingleWeekData
{
    [[DJSingletonData sharedInstance].scheduleSingleWeekData removeObject:self.model];
    [[DJSingletonData sharedInstance].scheduleSingleWeekData addObject:self.model];
    [DJFunction saveData:[DJSingletonData sharedInstance].scheduleSingleWeekData key:scheduleSingleWeekDataKey];
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
}

- (void)saveDoubleWeekData
{
    [[DJSingletonData sharedInstance].scheduleDoubleWeekData removeObject:self.model];
    [[DJSingletonData sharedInstance].scheduleDoubleWeekData addObject:self.model];
    [DJFunction saveData:[DJSingletonData sharedInstance].scheduleDoubleWeekData key:scheduleDoubleWeekDataKey];
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
}


#pragma mark - UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.weekTypePicker) {
        return self.weekTypeArray.count;
    }
    else if(pickerView == self.subjectPicker)
    {
        return self.subjectArray.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.weekTypePicker) {
        return self.weekTypeArray[row];
    }
    else if(pickerView == self.subjectPicker)
    {
        return self.subjectArray[row];
    }

    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.weekTypePicker) {
        self.weekTypeField.text = self.weekTypeArray[row];
    }
    else if(pickerView == self.subjectPicker)
    {
        self.subjectField.text = self.subjectArray[row];
    }
}
#pragma mark - load&match Field
- (void)loadWeekTypeField
{
    switch (self.weekType) {
        case 1:
            self.weekTypeField.text = @"单周";
            [self.weekTypePicker selectRow:1 inComponent:0 animated:YES];
            break;
        case 2:
            self.weekTypeField.text = @"双周";
            [self.weekTypePicker selectRow:2 inComponent:0 animated:YES];
            break;
        default:
            break;
    }
}
- (void)matchField
{
    for (int i = 0 ; i < self.subjectArray.count; i++) {
        if ([self.subjectArray[i] isEqualToString: self.subjectField.text])
        {
            [self.subjectPicker selectRow:i inComponent:0 animated:YES];
        }
    }
}

#pragma mark - ToolBarButtonItem
- (void)finishItemClick
{
    if ([self.subjectField.text length] == 0) {
        self.subjectField.text = self.subjectArray[0];
    }
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - setupPickerView
- (void)setupPickerView
{
    self.weekTypePicker = [[UIPickerView alloc] init];
    self.weekTypePicker.dataSource = self;
    self.weekTypePicker.delegate = self;
    self.weekTypeField.inputView = self.weekTypePicker;
    self.weekTypeField.inputAccessoryView = self.toolBar;
    
    self.subjectPicker = [[UIPickerView alloc] init];
    self.subjectPicker.dataSource = self;
    self.subjectPicker.delegate = self;
    self.subjectField.inputView = self.subjectPicker;
    self.subjectField.inputAccessoryView = self.toolBar;
    self.subjectField.text = self.scheduleName; 
}

#pragma mark - Lazy load
- (UIToolbar *)toolBar {
    if (_toolBar == nil) {
        
        _toolBar = [[UIToolbar alloc] init];
        
        _toolBar.frame = CGRectMake(0, 0, 0, 40);
        
        _toolBar.barTintColor = [UIColor orangeColor];
        
        _toolBar.tintColor = [UIColor whiteColor];
        
                UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishItemClick)];
        
        UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        _toolBar.items = @[flexibleSpaceItem,finishItem];
    }
    return _toolBar;
}

@end
