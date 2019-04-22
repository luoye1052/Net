//
//  NetMangerConfigure.m
//  net
//
//  Created by yubing on 2019/4/22.
//  Copyright © 2019 Emadata. All rights reserved.
//

#import "NetMangerConfigure.h"

@implementation NetMangerConfigure
+(NetMangerConfigure *)shareConfigure{
    static id sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedInstance=[[self alloc]init];
    });
    return sharedInstance;
}
-(instancetype)init{
    self=[super init];
    if (self) {
        _baseUrl=@"";
        _debugLogEnabled=NO;
    }
    return self;
}
@end
