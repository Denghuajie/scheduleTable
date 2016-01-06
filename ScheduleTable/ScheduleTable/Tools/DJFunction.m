//
//  DJFunction.m
//  ScheduleTable
//
//  Created by Mr.Deng on 16/1/5.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import "DJFunction.h"

@implementation DJFunction

+ (NSMutableSet *)getSingleWeekData
{
    
    NSMutableSet *set = [DJFunction getDataFromSandBoxWithKey:scheduleSingleWeekDataKey];
    
    [set enumerateObjectsUsingBlock:^(DJScheduleModel *model, BOOL * _Nonnull stop) {
        if (model.resourceOrderNum > [[DJFunction getDataFromSandBoxWithKey:@"maxNum"] integerValue]) {
            [set removeObject:model];
        }
    }];
    return set;
    
}

+ (NSMutableSet *)getDoubleWeekData
{
    
    NSMutableSet *set = [DJFunction getDataFromSandBoxWithKey:scheduleDoubleWeekDataKey];
    [set enumerateObjectsUsingBlock:^(DJScheduleModel *model, BOOL * _Nonnull stop) {
        if (model.resourceOrderNum > [[DJFunction getDataFromSandBoxWithKey:@"maxNum"] integerValue]) {
            [set removeObject:model];
        }
    }];
    return set;
    
}

// 保存信息到偏好设置
+ (void)saveData:(id)object key:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 从沙盒中获取用户信息
+ (id)getDataFromSandBoxWithKey:(NSString *)key
{
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
}

@end
