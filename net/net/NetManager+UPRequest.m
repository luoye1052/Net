
//  NetManager+UPRequest.m
//
//  MBService
//
//  Created by 于兵 on 16/5/3.
//  Copyright © 2016年 com.daimler. All rights reserved.
//


#import "NetManager+UPRequest.h"
@implementation NetManager (UPRequest)




#pragma mark - 登录
-(void)loginWithUserName:(NSString *_Nullable)userName
                password:(NSString *_Nullable)password
                 Success:(void (^_Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                 failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
{
     NSDictionary *dic=@{@"username":userName,@"password":password};
    [self sendPOSTRequestToServerWithURL:@""
                                postData:dic
                                 showHud:YES
                                progress:^(NSProgress * _Nonnull uploadProgress) {
                                    
                                }
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                     if (success) {
                                         success(task,responseObject);
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     if (failure) {
                                         failure(task,error);
                                     }
                                 }];

}

@end












