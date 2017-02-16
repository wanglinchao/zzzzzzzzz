//
//  MessgeListObj.m
//  IDIAI
//
//  Created by iMac on 14-7-7.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MessgeListObj.h"

@implementation MessgeListObj

+(MessgeListObj *)objWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        
        MessgeListObj *obj = [[MessgeListObj alloc] init];
        if(![[dict objectForKey:@"content"] isEqual:[NSNull null]])
            [obj setMessagecontent:[dict objectForKey:@"content"]];
        if(![[dict objectForKey:@"messageTitle"] isEqual:[NSNull null]])
            [obj setMessaetitle:[dict objectForKey:@"messageTitle"]];
        if(![[dict objectForKey:@"messageType"] isEqual:[NSNull null]])
            [obj setMessagetype:[dict objectForKey:@"messageType"]];
        if(![[dict objectForKey:@"messageDescript"] isEqual:[NSNull null]])
            [obj setMessagedescri:[dict objectForKey:@"messageDescript"]];
        if(![[dict objectForKey:@"messagePicturl"] isEqual:[NSNull null]])
            [obj setMessagepicture:[dict objectForKey:@"messagePicturl"]];
        if(![[dict objectForKey:@"createTime"] isEqual:[NSNull null]])
            [obj setMessagetime:[dict objectForKey:@"createTime"]];
        
        return obj;
    }
}

@end
