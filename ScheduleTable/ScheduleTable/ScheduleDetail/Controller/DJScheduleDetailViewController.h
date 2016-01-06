//
//  DJScheduleDetailViewController.h
//  ScheduleTable
//
//  Created by Mr.Deng on 16/1/5.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import "DJNavBaseViewController.h"

@interface DJScheduleDetailViewController : DJNavBaseViewController

// 表示对应哪天哪节课
@property (assign, nonatomic) NSInteger sectionNum;

@property (strong, nonatomic) DJScheduleModel *model;

@property (nonatomic, copy)NSString *scheduleName;

//记录单双周数
@property (assign, nonatomic) NSInteger weekType;

@end
