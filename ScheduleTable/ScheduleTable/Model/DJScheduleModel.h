//
//  DJScheduleModel.h
//  ScheduleTable
//
//  Created by Mr.Deng on 16/1/5.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJScheduleModel : NSObject<NSCoding>

//课程名称
@property (copy, nonatomic) NSString *resourceName;

//区分全周或者单双周(1表示单周, 2表示双周)
@property (assign, nonatomic) NSInteger weekType;

//表示第几节课
@property (assign, nonatomic) NSInteger resourceOrderNum;

//表示是周几的课
@property (assign, nonatomic) NSInteger weekNum;


@end
