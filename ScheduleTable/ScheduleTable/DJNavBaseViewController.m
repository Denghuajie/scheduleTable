//
//  DJNavBaseViewController.m
//  ScheduleTable
//
//  Created by Mr.Deng on 16/1/5.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import "DJNavBaseViewController.h"

@interface DJNavBaseViewController ()

@end

@implementation DJNavBaseViewController

- (void)viewDidLoad {
    self.naviView = [[UIView alloc] init];
    self.naviView.backgroundColor = DJColor(134, 215, 245, 1.0);
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(kNaviBarHeight);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - 设置导航条子控件, 中间label + 左右按钮
- (void)setupNavigationBarWithLeftBtnImage:(NSString *)leftBtnImageName titleName:(NSString *)title rightBtnImage:(NSString *)rightBtnImageName
{
    
    
    //添加中间的title
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = title;
    [self.naviView addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.naviView.mas_centerX);
        make.centerY.mas_equalTo(self.naviView.mas_centerY).offset(10);
    }];
    
    //添加左按钮
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed: leftBtnImageName] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.naviView.mas_left).offset(5);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.width.mas_equalTo(kNavButtonWidth);
        make.height.mas_equalTo(kNavButtonHeight);
    }];

    
    //添加右边按钮
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //    [self.rightBtn setTitle:@"右上角" forState:UIControlStateNormal];
    
    [self.rightBtn setBackgroundImage:[UIImage imageNamed: rightBtnImageName] forState:UIControlStateNormal];
    
    [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-5);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.width.mas_equalTo(kNavButtonWidth + 10);
        make.height.mas_equalTo(kNavButtonHeight);
    }];
    
}

- (void)backMethod
{
    NSLog(@"点击了左按钮");
}


- (void)rightBtnAction
{
    NSLog(@"点击了右上角按钮");
}

@end
