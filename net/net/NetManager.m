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
static NSString *const netMangerLockName=@"com.bingyu.NetManger.lock";
static NSString *const RequestPost=@"post";
static inline NSString *RequesMethod(RequestMethod methodType){
    return @[RequestPost][methodType];
}
@interface NetManager ()
@property (nonatomic,copy)AFHTTPSessionManager *manger;
@property (nonatomic,strong)NSMutableDictionary *storageTask;
@property (nonatomic,strong)NSLock *lock;
@end
@implementation NetManager

- (id)init
{
    self = [super init];
    if (self) {
        _manger=[AFHTTPSessionManager manager];
        _lock=[[NSLock alloc]init];
        _lock.name=netMangerLockName;
       
    }
    return self;
}
/**
 请求数据
 @param urlString 拼接参数
 @param success 成功回调
 @param failure 失败回调
 */
- (NSURLSessionDataTask *)sendPOSTRequestToServerWithURL:(NSString *)urlString
                               success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                               failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    
   return [self sendPOSTRequestToServerWithURL:urlString
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
- (NSURLSessionDataTask *)sendPOSTRequestToServerWithURL:(NSString *)urlString
                              postData:(NSDictionary*)messageDic
                               showHud:(BOOL)showHud
                              progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                               success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                               failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    if ([self.delegate respondsToSelector:@selector(requestStart:)]) {
        [self.delegate requestStart:self];
    }
    
    NSURLSessionDataTask *DataTask =[self dataTaskWithHTTPMethod:RequestMethodPOST
                                                       URLString:urlString
                                                      parameters:messageDic
                                                  uploadProgress:uploadProgress
                                                downloadProgress:nil
                                                         success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                if (success) {
                                                                    success(task,responseObject);
                                                                }
                                                                if ([self.delegate respondsToSelector:@selector(requestDidFinished:result:)]) {
                                                                    [self.delegate requestDidFinished:self result:responseObject];
                                                                }
                                                         }
                                                         failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                             if(failure){
                                                                 failure(task,error);
                                                             }
                                                             if([self.delegate respondsToSelector:@selector(requestError:error:)]){
                                                                 [self.delegate requestError:self error:error];
                                                             }
                                                         }];
    return DataTask;
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




- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(RequestMethod)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    
    NSString *URLStr = [[NetMangerConfigure shareConfigure].baseUrl stringByAppendingString:URLString];
    
    _manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/html", nil];
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [_manger.requestSerializer requestWithMethod:RequesMethod(method) URLString:URLStr parameters:parameters error:&serializationError];
    
    if (serializationError) {
        if (failure) {
            dispatch_async(_manger.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_manger dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               if (failure) {
                                   failure(dataTask, error);
                               }
                           } else {
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                       }];
    
    return dataTask;
}
-(void)setDataTask:(NSURLSessionDataTask *)dataTask taskIdentifier:(NSUInteger)taskIdentifier{
    [self.lock lock];
    self.storageTask[@(taskIdentifier)]=dataTask;
    [self.lock unlock];
}
@end
