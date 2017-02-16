//
//  savelogObj.m
//  IDIAI
//
//  Created by iMac on 14-6-30.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "savelogObj.h"
#import "OpenUDID.h"
#import "util.h"
#import "NetworkRequest.h"
#import "JSONKit.h"

@implementation savelogObj

+(void)deleteLog{
    NSMutableArray *arrayList=[NSMutableArray array];
    for(int i=1;i<=91;i++){
        [arrayList addObject:[NSString stringWithFormat:@"list%d",i]];
    }
    NSArray *array=[[NSUserDefaults standardUserDefaults]objectForKey:Log_OperationType];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"log.plist"];
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
    
    //[[NSFileManager defaultManager]removeItemAtPath:_filename error:nil]; //删除plist文件
    
    //删除plist文件里的部分内容
    for(int i=0;i<[array count];i++){
        [dataDict removeObjectForKey:[arrayList objectAtIndex:[[array objectAtIndex:i] intValue]-1]];
    }
    
    NSString *filename=@"log.plist";
    [self writeFile:filename data:dataDict];
}

+(NSMutableDictionary *)getLog{

    NSMutableArray *arrayList=[NSMutableArray array];
    for(int i=1;i<=91;i++){
        [arrayList addObject:[NSString stringWithFormat:@"list%d",i]];
    }
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"log.plist"];
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
   
    if (!dataDict) {
        dataDict=[NSMutableDictionary dictionary];
    }

    NSArray *array=[NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:Log_OperationType]];
    NSMutableDictionary *GetDict=[NSMutableDictionary dictionary];
    NSMutableArray *Array_save=[NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<[array count]; i++) {
        if([[dataDict objectForKey:[arrayList objectAtIndex:[[array objectAtIndex:i] intValue]-1]] objectForKey:@"OSType"]){
            [GetDict setObject:[[dataDict objectForKey:[arrayList objectAtIndex:[[array objectAtIndex:i] intValue]-1]] objectForKey:@"OSType"] forKey:@"OSType"];
            [GetDict setObject:[[dataDict objectForKey:[arrayList objectAtIndex:[[array objectAtIndex:i] intValue]-1]] objectForKey:@"mobileModel"] forKey:@"mobileModel"];
            [GetDict setObject:[[dataDict objectForKey:[arrayList objectAtIndex:[[array objectAtIndex:i] intValue]-1]] objectForKey:@"mobileUUID"] forKey:@"mobileUUID"];
            [GetDict setObject:[[dataDict objectForKey:[arrayList objectAtIndex:[[array objectAtIndex:i] intValue]-1]] objectForKey:@"version"] forKey:@"version"];
            if([[dataDict objectForKey:[arrayList objectAtIndex:[[array objectAtIndex:i] intValue]-1]] objectForKey:@"userID"])
                [GetDict setObject:[[dataDict objectForKey:[arrayList objectAtIndex:[[array objectAtIndex:i] intValue]-1]] objectForKey:@"userID"] forKey:@"userID"];
            else
                [GetDict setObject:@"" forKey:@"userID"];
        }
        
        NSArray *array_sub=[[dataDict objectForKey:[arrayList objectAtIndex:[[array objectAtIndex:i] intValue]-1]] objectForKey:@"list"];
         for (NSDictionary *dict in array_sub) {
             [Array_save addObject:dict];
       }
    }
    [GetDict setObject:Array_save forKey:@"list"];
    
    return GetDict;
}

+(void)saveLog:(NSString *)message userID:(NSString *)userid modelType:(NSInteger)modeltype{
    
    NSMutableArray *arrayList=[NSMutableArray array];
    for(int i=1;i<=91;i++){
        [arrayList addObject:[NSString stringWithFormat:@"list%d",i]];
    }
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* filepath = [doc_path stringByAppendingPathComponent:@"log.plist"];
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
    if (!dataDict) {
        dataDict=[NSMutableDictionary dictionary];
    }
    
    NSMutableDictionary *saveDict=[dataDict objectForKey:[arrayList objectAtIndex:modeltype-1]];
    if (!saveDict) {
        saveDict=[NSMutableDictionary dictionary];
    }

    //获取日期时间
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    NSMutableArray *array=[saveDict objectForKey:@"list"];
    if(!array) array=[NSMutableArray array];
    NSMutableDictionary *dict_sub=[NSMutableDictionary dictionary];
    [dict_sub setObject:message forKey:@"message"];
    [dict_sub setObject:locationString forKey:@"createDate"];
    [dict_sub setObject:[NSString stringWithFormat:@"%ld",(long)modeltype] forKey:@"operateType"];
    [array addObject:dict_sub];
    
    [saveDict setObject:array forKey:@"list"];
    [saveDict setObject:[OpenUDID value] forKey:@"mobileUUID"];
    [saveDict setObject:[NSString stringWithFormat:@"iOS %@",[UIDevice currentDevice].systemVersion] forKey:@"OSType"];
    [saveDict setObject:[util platformString] forKey:@"mobileModel"];
    [saveDict setObject:[NSString stringWithFormat:@"屋托邦(v%@)",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] forKey:@"version"];
    if(userid) [saveDict setObject:userid forKey:@"userID"];
    else  [saveDict setObject:@"" forKey:@"userID"];
    [dataDict setObject:saveDict forKey:[arrayList objectAtIndex:modeltype-1]];
    
    NSString *filename=@"log.plist";
    [self writeFile:filename data:dataDict];
}

+(void)writeFile:(NSString*)filename data:(NSMutableDictionary *)dataDict
{
    //获得应用程序沙盒的Documents目录，官方推荐数据文件保存在此
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    
    //创建文件管理器对象
    //NSFileManager *fm = [NSFileManager defaultManager];
    NSString* _filename = [doc_path stringByAppendingPathComponent:filename];
    //NSString* new_folder = [doc_path stringByAppendingPathComponent:@"test"];
    //创建目录
    //[fm createDirectoryAtPath:new_folder withIntermediateDirectories:YES attributes:nil error:nil];
    //创建文件
    //[fm createFileAtPath:_filename contents:[data dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
    [dataDict writeToFile:_filename atomically:NO];
 
}

+(void)sendLogtoLServer
{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
       NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSMutableDictionary *post01 = [[NSMutableDictionary alloc] init];
        [post01 setObject:@"ID0019" forKey:@"cmdID"];
        [post01 setObject:@"" forKey:@"token"];
        [post01 setObject:@"" forKey:@"userID"];
        [post01 setObject:@"iOS" forKey:@"deviceType"];
        [post01 setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
        NSString *string_header=[post01 JSONString];


        NSString *string_body=[[self getLog] JSONString];

        NSMutableDictionary *postDict= [[NSMutableDictionary alloc] init];
        [postDict setObject:string_header forKey:@"header"];
        [postDict setObject:string_body forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
               NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"sendlog返回信息：%@",jsonDict);
              
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[jsonDict objectForKey:@"resCode"] integerValue]==10211) {
                        [self deleteLog];
                    }
                });
                
            });
        }
                               failedBlock:^{
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                   });
                               }
                                    method:url postDict:postDict];
    });
  
}

@end
