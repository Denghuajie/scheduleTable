//
//  DJNavBaseViewController.h
//  ScheduleTable
//
//  Created by Mr.Deng on 16/1/5.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJNavBaseViewController : UIViewController

@property (nonatomic, strong) UIView *naviView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

- (void)setupNavigationBarWithLeftBtnImage:(NSString *)leftBtnImageName titleName:(NSString *)title rightBtnImage:(NSString *)rightBtnImageName;

- (void)backMethod;
- (void)rightBtnAction;
@end
