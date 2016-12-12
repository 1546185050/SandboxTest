//
//  Person.h
//  SandboxDemo
//
//  Created by dhp on 29/11/16.
//  Copyright © 2016年 dhp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding>

@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *personPhone;

@end
