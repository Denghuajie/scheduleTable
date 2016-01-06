//
//  DJScheduleModel.m
//  ScheduleTable
//
//  Created by Mr.Deng on 16/1/5.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import "DJScheduleModel.h"

@implementation DJScheduleModel

- (BOOL) isEqual:(DJScheduleModel *)object
{
    if(object.weekNum == self.weekNum && object.weekType == self.weekType && object.resourceOrderNum == self.resourceOrderNum && [object.resourceName isEqualToString:self.resourceName])
    {
        return YES;
    }
    
    return NO;
}

- (NSString *)description
{
    // type + weekNum + resourceOrderNum
    NSMutableString * str = [[NSMutableString alloc] init];
    [str appendFormat:@"%zd%zd%zd", self.weekType, self.weekNum, self.resourceOrderNum];
    return str;
}

- (NSUInteger)hash
{
    
    return (NSUInteger)self.description.hash;
}

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    [aCoder encodeObject:[NSString stringWithFormat:@"%zd", self.weekType] forKey:@"weekType"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%zd", self.weekNum] forKey:@"weekNum"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%zd", self.resourceOrderNum] forKey:@"resourceOrderNum"];
    [aCoder encodeObject:self.resourceName forKey:@"resourceName"];
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.weekType = [[aDecoder decodeObjectForKey:@"weekType"] integerValue];
        self.weekNum = [[aDecoder decodeObjectForKey:@"weekNum"] integerValue];
        self.resourceOrderNum = [[aDecoder decodeObjectForKey:@"resourceOrderNum"] integerValue];
        self.resourceName = [aDecoder decodeObjectForKey:@"resourceName"];
        
    }
    return self;
}


@end
