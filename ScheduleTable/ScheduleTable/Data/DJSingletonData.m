//
//  DJSingletonData.m
//  ScheduleTable
//
//  Created by Mr.Deng on 16/1/5.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import "DJSingletonData.h"

static DJSingletonData *instance = nil;

@implementation DJSingletonData

// 单例对象
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DJSingletonData alloc] init];
        if(!instance.scheduleSingleWeekData) instance.scheduleSingleWeekData = [NSMutableSet set];
        if(!instance.scheduleDoubleWeekData) instance.scheduleDoubleWeekData = [NSMutableSet set];
    });
    return instance;
}


@end
