//
//  Person.m
//  SandboxDemo
//
//  Created by dhp on 29/11/16.
//  Copyright © 2016年 dhp. All rights reserved.
//

#import "Person.h"

@implementation Person

//归档 告诉系统要存储对象的哪些属性
//归档（又名序列化），把对象转为字节码，以文件的形式存储到磁盘上；程序运行过程中或者当再次重写打开程序的时候，可以通过解归档（反序列化）还原这些对象
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_personName forKey:@"personName"];
    [aCoder encodeObject:_personPhone forKey:@"personPhone"];
}

//解档 告诉系统要读取对象的哪些属性
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self == [super init])
    {
        self.personName = [aDecoder decodeObjectForKey:@"personName"];
        self.personPhone = [aDecoder decodeObjectForKey:@"personPhone"];
    }
    return self;
}

@end
