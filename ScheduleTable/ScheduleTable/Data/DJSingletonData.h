//
//  DJSingletonData.h
//  ScheduleTable
//
//  Created by Mr.Deng on 16/1/5.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJSingletonData : NSObject

@property (strong, nonatomic) NSMutableSet *scheduleSingleWeekData;

@property (strong, nonatomic) NSMutableSet *scheduleDoubleWeekData;

+ (instancetype)sharedInstance;

@end
