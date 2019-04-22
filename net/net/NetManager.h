//
//  NetManager.h
//
//  MBService
//
//  Created by 于兵 on 16/5/3.
//  Copyright © 2016年 com.daimler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//typedef void(^callBackSuccess)(NSURLSessionDataTask * _Nonnull, id );
//typedef void(^callBackFailure)(NSURLSessionDataTask * _Nullable, NSError * );

@interface NetManager : NSObject
@property (nonatomic,copy)NSString *requestUrl;
//@property (nonatomic, retain) NSDictionary *requestDic;
//@property (nonatomic,copy)  callBackSuccess  callBackRequestSuccess;
//@property (nonatomic,copy)  callBackFailure  callBackRequestFailure;
//上传文件
- (void)uploadWithUrl:(NSString *)url body:(NSDictionary *_Nullable)body showHud:(BOOL)showHud   constructingBodyWithBlock:(void (^_Nullable)(id <AFMultipartFormData> _Nullable formData))bodyBlock success:(void (^_Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success  failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

//上传数据block
- (void)sendPOSTRequestToServerWithURL:(NSString *)urlString postData:(NSDictionary*_Nullable)messageDic showHud:(BOOL)showHud success:(void (^_Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success  failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
@end
