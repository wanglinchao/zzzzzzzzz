//
//  CrashLogsObj.m
//  IDIAI
//
//  Created by iMac on 14-7-10.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CrashLogsObj.h"
#import "OpenUDID.h"
#import "util.h"
#import "NetworkRequest.h"
#import "JSONKit.h"

@implementation CrashLogsObj

+(void)deleteCrashLog{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"crashlog.plist"];
    [[NSFileManager defaultManager]removeItemAtPath:_filename error:nil]; //删除plist文件
}

+(NSMutableDictionary *)getCrashLog{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"crashlog.plist"];
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
    return dataDict;
}

+(void)saveCrashLog:(NSString *)message userID:(NSString *)userid{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* filepath = [doc_path stringByAppendingPathComponent:@"crashlog.plist"];
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
    if (!dataDict) {
        dataDict=[NSMutableDictionary dictionary];
    }
    
    //获取日期时间
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    NSMutableArray *array=[dataDict objectForKey:@"list"];
    if(!array) array=[NSMutableArray array];
    NSMutableDictionary *dict_sub=[NSMutableDictionary dictionary];
    [dict_sub setObject:message forKey:@"crashMessage"];
    [dict_sub setObject:locationString forKey:@"createDate"];
    [array addObject:dict_sub];
    
    [dataDict setObject:array forKey:@"list"];
    [dataDict setObject:[OpenUDID value] forKey:@"mobileUUID"];
    [dataDict setObject:@"iOS" forKey:@"OSType"];
    [dataDict setObject:[util platformString] forKey:@"mobileModel"];
    [dataDict setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"version"];
    if(userid) [dataDict setObject:userid forKey:@"userID"];
    else  [dataDict setObject:@"" forKey:@"userID"];

    NSString *filename=@"crashlog.plist";
    [self writeFile:filename data:dataDict];
}

+(void)writeFile:(NSString*)filename data:(NSMutableDictionary *)dataDict
{
    //获得应用程序沙盒的Documents目录，官方推荐数据文件保存在此
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:filename];
 
    [dataDict writeToFile:_filename atomically:NO];
}

+(void)sendCrashLogtoLServer
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
        
        
        NSString *string_body=[[self getCrashLog] JSONString];
        
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
                //NSLog(@"sendlog返回信息：%@",jsonDict);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[jsonDict objectForKey:@"resCode"] integerValue]==10211) {
                        [self deleteCrashLog];
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
