//
//  DJFunction.h
//  ScheduleTable
//
//  Created by Mr.Deng on 16/1/5.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJFunction : NSObject

//获取单周的数据
+ (NSMutableSet *)getSingleWeekData;

//获取双周的数据
+ (NSMutableSet *)getDoubleWeekData;

// 保存信息到偏好设置
+ (void)saveData:(id)object key:(NSString *)key;

// 从沙盒中获取用户信息
+ (id)getDataFromSandBoxWithKey:(NSString *)key;
@end
