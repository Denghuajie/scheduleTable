//
//  DJScheduleViewCell.h
//  ScheduleTable
//
//  Created by Mr.Deng on 16/1/5.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJScheduleViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
