//
//  WorkerListObj.m
//  IDIAI
//
//  Created by iMac on 14-10-27.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "WorkerListObj.h"

@implementation WorkerListObj

+(WorkerListObj *)objWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        
        WorkerListObj *obj = [[WorkerListObj alloc] init];
        if(![[dict objectForKey:@"workerId"] isEqual:[NSNull null]])
            [obj setWorkerId:[[dict objectForKey:@"workerId"] integerValue]];
        if(![[dict objectForKey:@"nickName"] isEqual:[NSNull null]])
            [obj setNickName:[dict objectForKey:@"nickName"]];
        if(![[dict objectForKey:@"workerIconPath"] isEqual:[NSNull null]])
            [obj setWorkerIconPath:[dict objectForKey:@"workerIconPath"]];
        if(![[dict objectForKey:@"workerLevel"] isEqual:[NSNull null]])
            [obj setWorkerLevel:[NSString stringWithFormat:@"%@",[dict objectForKey:@"workerLevel"]]];
        if(![[dict objectForKey:@"distance"] isEqual:[NSNull null]])
            [obj setDistance:[[dict objectForKey:@"distance"] doubleValue]];
        if(![[dict objectForKey:@"workerInfo"] isEqual:[NSNull null]])
            [obj setWorkerInfo:[dict objectForKey:@"workerInfo"]];
        if(![[dict objectForKey:@"address"] isEqual:[NSNull null]])
            [obj setAddress:[dict objectForKey:@"address"]];
        if(![[dict objectForKey:@"phoneNumber"] isEqual:[NSNull null]])
            [obj setPhoneNumber:[NSString stringWithFormat:@"%@",[dict objectForKey:@"phoneNumber"]]];
        if(![[dict objectForKey:@"workerLongitude"] isEqual:[NSNull null]])
            [obj setWorkerLongitude:[[dict objectForKey:@"workerLongitude"] floatValue]];
        if(![[dict objectForKey:@"workerLatitude"] isEqual:[NSNull null]])
            [obj setWorkerLatitude:[[dict objectForKey:@"workerLatitude"] floatValue]];
        if(![[dict objectForKey:@"browsePoints"] isEqual:[NSNull null]])
            [obj setWorkerBrower:[NSString stringWithFormat:@"%@",[dict objectForKey:@"browsePoints"]]];
        if(![[dict objectForKey:@"collectPoints"] isEqual:[NSNull null]])
            [obj setWorkerCollect:[NSString stringWithFormat:@"%@",[dict objectForKey:@"collectPoints"]]];
        if([[dict objectForKey:@"authentication"] count])
            obj.authentication_arr=[dict objectForKey:@"authentication"];
        if([[dict objectForKey:@"jobScopeName"] count])
            obj.jobScopeName_arr=[dict objectForKey:@"jobScopeName"];
        if([[dict objectForKey:@"workerImgPath"] count])
            obj.workerImgPath_arr=[dict objectForKey:@"workerImgPath"];
        if(![[dict objectForKey:@"objId"] isEqual:[NSNull null]])
            [obj setObjId:[[dict objectForKey:@"objId"] integerValue]];
//
        
        return obj;
    }
}

@end
