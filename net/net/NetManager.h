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

@class NetManager;
@protocol NetManagerDelegate <NSObject>
- (void)requestStart:(NetManager *)request;
- (void)requestStart:(NetManager *)request Progress:(NSProgress *)uploadProgress;
- (void)requestDidFinished:(NetManager *)request result:(NSMutableDictionary *)result;
- (void)requestError:(NetManager *)request error:(NSError*)error;
@end

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET = 0,
    RequestMethodPOST,
    RequestMethodHEAD,
    RequestMethodPUT,
    RequestMethodDELETE,
    RequestMethodPATCH,
};


@interface NetManager : NSObject
@property (nonatomic,copy)NSString *requestUrl;
@property (nonatomic,assign)id<NetManagerDelegate> delegate;

/**
 请求数据
 @param urlString 拼接参数
 @param success 成功回调
 @param failure 失败回调
 */
- (NSURLSessionDataTask *)sendPOSTRequestToServerWithURL:(NSString *)urlString
                                                 success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                                                 failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
/**
 请求数据
 
 @param urlString 拼接参数
 @param messageDic 上传参数
 @param success 成功回调
 @param failure 失败回调
 */
- (NSURLSessionDataTask *)sendPOSTRequestToServerWithURL:(NSString *)urlString
                                                postData:(NSDictionary*)messageDic
                                                 showHud:(BOOL)showHud
                                                progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                                                 success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                                                 failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
//上传数据block
- (void)sendPOSTRequestToServerWithURL:(NSString *)urlString
                              postData:(NSDictionary*_Nullable)messageDic
                               showHud:(BOOL)showHud
                               success:(void (^_Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                               failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
@end
