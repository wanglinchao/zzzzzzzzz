//
//  DecorateProcessObj.m
//  IDIAI
//
//  Created by iMac on 14-7-17.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DecorateProcessObj.h"

@implementation DecorateProcessObj

+(DecorateProcessObj *)objWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        
        DecorateProcessObj *obj = [[DecorateProcessObj alloc] init];
        if(![[dict objectForKey:@"knowledgeID"] isEqual:[NSNull null]])
            [obj setKnowledgeID:[dict objectForKey:@"knowledgeID"]];
        if(![[dict objectForKey:@"knowledgeTitle"] isEqual:[NSNull null]])
            [obj setKnowledgeTitle:[dict objectForKey:@"knowledgeTitle"]];
        if(![[dict objectForKey:@"knowledgeDescription"] isEqual:[NSNull null]])
            [obj setKnowledgeDescription:[dict objectForKey:@"knowledgeDescription"]];
        if(![[dict objectForKey:@"knowledgeLogoPath"] isEqual:[NSNull null]])
            [obj setKnowledgeLogoPath:[dict objectForKey:@"knowledgeLogoPath"]];
        if(![[dict objectForKey:@"knowledgeInfoPath"] isEqual:[NSNull null]])
            [obj setKnowledgeInfoPath:[dict objectForKey:@"knowledgeInfoPath"]];
        if(![[dict objectForKey:@"objId"] isEqual:[NSNull null]])
            [obj setObjId:[dict objectForKey:@"objId"]];
        
        return obj;
    }
}

@end
