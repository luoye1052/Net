//
//  NetManager+UPRequest.h
//
//  MBService
//
//  Created by 于兵 on 16/5/3.
//  Copyright © 2016年 com.daimler. All rights reserved.
//


#import "NetManager.h"
#import "AFNetworking.h"
@interface NetManager (UPRequest)



#pragma mark - 登录
-(void)loginWithUserName:(NSString *_Nullable)userName password:(NSString *_Nullable)password   Success:(void (^_Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success  failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
@end
