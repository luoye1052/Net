//
//  NetManager.m
//
//  MBService
//
//  Created by 于兵 on 16/5/3.
//  Copyright © 2016年 com.daimler. All rights reserved.
//


#import "NetManager.h"
#import "NetMangerConfigure.h"

@implementation NetManager

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
/**
 请求数据
 @param urlString 拼接参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)sendPOSTRequestToServerWithURL:(NSString *)urlString
                               success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                               failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    
   [self sendPOSTRequestToServerWithURL:urlString
                               postData:nil
                                showHud:NO
                               progress:nil
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


/**
 请求数据

 @param urlString 拼接参数
 @param messageDic 上传参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)sendPOSTRequestToServerWithURL:(NSString *)urlString
                              postData:(NSDictionary*)messageDic
                               showHud:(BOOL)showHud
                              progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                               success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                               failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    if ([self.delegate respondsToSelector:@selector(requestStart:)]) {
        [self.delegate requestStart:self];
    }
    NSString *URL = [NetMangerConfigure shareConfigure].baseUrl;
    URL = [URL stringByAppendingString:urlString];
    AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/html", nil];
    NSURLSessionDataTask *DataTask=[manger POST:URL
      parameters:messageDic
        progress:uploadProgress
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if (success) {
                success(task,responseObject);
             }
             if ([self.delegate respondsToSelector:@selector(requestDidFinished:result:)]) {
                 [self.delegate requestDidFinished:self result:responseObject];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (failure) {
                 failure(task,error);
             }
             if ([self.delegate respondsToSelector:@selector(requestError:error:)]) {
                 [self.delegate requestError:self error:error];
             }
         }];
    
}
//上传文件
- (void)uploadWithRequestUrl:(NSString *)url
                  parameters:(NSDictionary *)parameters
                     showHud:(BOOL)showHud
   constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))bodyBlock
                    progress:(nullable void (^)(NSProgress * _Nonnull))progress
                     success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                     failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
{
   
    NSString *URL = [NetMangerConfigure shareConfigure].baseUrl;
    URL = [URL stringByAppendingString:url];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager POST:URL
       parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    bodyBlock(formData);
}
         progress:^(NSProgress * _Nonnull uploadProgress) {
             if (progress) {
                 progress(uploadProgress);
             }
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (success) {
                  success(task,responseObject);
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failure(task,error);
          }];
}





@end
