//
//  NetMangerConfigure.h
//  net
//
//  Created by yubing on 2019/4/22.
//  Copyright © 2019 Emadata. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetMangerConfigure : NSObject
@property (nonatomic,copy)NSString *baseUrl;
@property (nonatomic,assign) BOOL debugLogEnabled;

+(NetMangerConfigure *)shareConfigure;
@end

NS_ASSUME_NONNULL_END
