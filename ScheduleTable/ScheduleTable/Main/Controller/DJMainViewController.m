//
//  DJMainViewController.m
//  ScheduleTable
//
//  Created by Mr.Deng on 16/1/5.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import "DJMainViewController.h"
#import "DJScheduleViewCell.h"
#import "DJMainLayout.h"
#import "DJScheduleSettingViewController.h"
#import "DJScheduleDetailViewController.h"
@interface DJMainViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UICollectionView *weekView;

@property (weak, nonatomic) IBOutlet UICollectionView *mainView;

@property (strong, nonatomic) NSMutableArray *weekArray;

@property (strong, nonatomic) NSMutableArray *numArray;

//记录周的类型
@property (nonatomic, assign) NSInteger index;

//数据源
@property (strong, nonatomic) NSMutableSet *dataSource;

//表示设定的课程节数
@property (assign, nonatomic) NSInteger scheduleNum;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeightConstraint;

@end

@implementation DJMainViewController

static NSString *const reuseIdentifier = @"DJScheduleViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableSet set];
    
    [self setupNavigationBarWithLeftBtnImage:nil titleName:@"我的课程表" rightBtnImage:nil];
    [self.leftBtn removeFromSuperview];
    [self.rightBtn setTitle:@"设置" forState:UIControlStateNormal];
    
    self.weekArray = [NSMutableArray arrayWithObjects:@"周一", @"周二", @"周三", @"周四", @"周五", nil];
    
    [self.weekView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.mainView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    //默认选中单周
    self.index = 1;
    [self setupConstraints];
}

- (void)setupConstraints
{
    if(isIPhone5)
    {
        self.mainViewHeightConstraint.constant = 424;
        self.mainViewWidthConstraint.constant = 320;
    }
    if (isIPhone6p) {
        self.mainViewHeightConstraint.constant = 592;
        self.mainViewWidthConstraint.constant = 420;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.index == 1) {
        self.dataSource = [DJFunction getSingleWeekData];
    }
    
    else if(self.index == 2){
        self.dataSource = [DJFunction getDoubleWeekData];
    }

    if ([DJFunction getDataFromSandBoxWithKey:@"maxNum"] == nil) {
        self.scheduleNum = 8;
    }
    else
    {
        self.scheduleNum = [[DJFunction getDataFromSandBoxWithKey:@"maxNum"] integerValue];
    }

    self.numArray = [NSMutableArray array];
    for (int i = 1; i < (self.scheduleNum + 1); i++) {
        NSString *text = [NSString stringWithFormat:@"%d", i];
        [self.numArray addObject:text];
    }
    
    [self.mainView reloadData];
}

- (IBAction)changeWeekType:(UISegmentedControl *)sender
{
    self.index = sender.selectedSegmentIndex + 1;
    
    if (sender.selectedSegmentIndex == 0) {
        self.dataSource = [DJFunction getSingleWeekData];
    }
    
    else if(sender.selectedSegmentIndex == 1){
        self.dataSource = [DJFunction getDoubleWeekData];
    }
    
    [self.mainView reloadData];
}

# pragma mark - UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.weekView) {
        if (indexPath.row == 0) {
            return CGSizeMake(30, 30);
        }
        else
        {
            return CGSizeMake((kUIScreenWidth - 30) / 5, 30);
        }
    }
    if (collectionView == self.mainView) {
        if (indexPath.row % 6 == 0) {
            return CGSizeMake(30, (kUIScreenHeight - kNaviBarHeight - 80) / 8);
        }
        else
        {
            return CGSizeMake((kUIScreenWidth - 30) / 5, (kUIScreenHeight - kNaviBarHeight - 80) / 8);
        }
    }
    return CGSizeMake(0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.weekView)
    {
        return 6;
    }
    else if(collectionView == self.mainView)
    {
        return 6 * self.scheduleNum;
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
     DJScheduleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (collectionView == self.weekView) {
        
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"";
        }
        else
        {
            cell.textLabel.text = self.weekArray[indexPath.row - 1];
        };
    }else if(collectionView == self.mainView){
        
        cell.textLabel.text = @"";
        
        if (indexPath.row % 6 == 0)
        {
            cell.textLabel.text = self.numArray[indexPath.row/6];
        }
        else
        {
            [self.dataSource enumerateObjectsUsingBlock:^(DJScheduleModel *model, BOOL * _Nonnull stop)
             {
                 //如果周几的第几节有课, 设置内容
                 if (indexPath.row%6 == model.weekNum && (indexPath.row/6 + 1) == model.resourceOrderNum) {
                     cell.textLabel.text = model.resourceName;            
                 }
             }];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.mainView){        
        if (indexPath.row % 6 == 0) {
            return;
        }
        NSLog(@"这是周%zd的第%zd节课", (indexPath.row % 6), (indexPath.row / 6 + 1));
        DJScheduleDetailViewController *detailVc = [[UIStoryboard storyboardWithName:@"DJScheduleDetailViewController" bundle:nil] instantiateInitialViewController];
        //row
        detailVc.sectionNum = indexPath.row;
        //周的类型
        detailVc.weekType = self.index;
        //课程名称
        DJScheduleViewCell *cell = (DJScheduleViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        detailVc.scheduleName = cell.textLabel.text;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

- (void)rightBtnAction
{
    DJScheduleSettingViewController *settingVc = [[UIStoryboard storyboardWithName:@"DJScheduleSettingViewController" bundle:nil] instantiateInitialViewController];
    [self.navigationController pushViewController:settingVc animated:YES];
}

@end
