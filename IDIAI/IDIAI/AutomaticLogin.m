//
//  AutomaticLogin.m
//  IDIAI
//
//  Created by iMac on 14-7-9.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "AutomaticLogin.h"
#import "LoginView.h"
#import "JSONKit.h"
#import "NetworkRequest.h"
#import "util.h"
#import "SPKitExample.h"
@implementation AutomaticLogin

+(void)Automaticlogin:(id)target{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0011" forKey:@"cmdID"];
        [postDict setObject:@"" forKey:@"token"];
        [postDict setObject:@"" forKey:@"userID"];
        [postDict setObject:@"iOS" forKey:@"deviceType"];
        [postDict setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
         [postDict setObject:@"1" forKey:@"httpver"];
        NSString *string=[postDict JSONString];
        
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:User_Name] forKey:@"loginName"];
        [postDict02 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:User_Password] forKey:@"password"];
        
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken]) {
            [postDict02 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken] forKey:@"deviceToken"];  //推送的token
        }
        if ([OpenUDID value].length) [postDict02 setObject:[OpenUDID value] forKey:@"uniqueDeviceNumber"];   //设备唯一标识
        NSString *string02=[postDict02 JSONString];
        
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:string forKey:@"header"];
        [post setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"login返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[jsonDict objectForKey:@"resCode"] integerValue]==10121) {
                       
                        
                        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:User_Token];
                        [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_Token] forKey:User_Token];//huangrun 20141219
                        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[jsonDict objectForKey:User_ID]] forKey:User_ID];
                        
                         if(![[jsonDict objectForKey:User_ProvinceName] isEqual:[NSNull null]])
                             [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:User_ProvinceName] forKey:User_ProvinceName];
                         if(![[jsonDict objectForKey:User_CityName] isEqual:[NSNull null]])
                             [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:User_CityName] forKey:User_CityName];
                         if(![[jsonDict objectForKey:User_AreaName] isEqual:[NSNull null]])
                             [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:User_AreaName] forKey:User_AreaName];
                         if(![[jsonDict objectForKey:User_ProvinceCode] isEqual:[NSNull null]])
                             [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:User_ProvinceCode] forKey:User_ProvinceCode];
                         if(![[jsonDict objectForKey:User_CityCode] isEqual:[NSNull null]])
                             [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:User_CityCode] forKey:User_CityCode];
                         if(![[jsonDict objectForKey:User_AreaCode] isEqual:[NSNull null]])
                             [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:User_AreaCode] forKey:User_AreaCode];
                        
                        if(![[jsonDict objectForKey:User_nickName] isEqual:[NSNull null]])
                            [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_nickName] forKey:User_nickName];
                        if(![[jsonDict objectForKey:User_Mobile] isEqual:[NSNull null]])
                            [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_Mobile] forKey:User_Mobile];
                        if(![[jsonDict objectForKey:User_sex] isEqual:[NSNull null]]){
                            if([[jsonDict objectForKey:User_sex] integerValue]==1)
                                [[NSUserDefaults standardUserDefaults]setObject:@"男" forKey:User_sex];
                            else
                                [[NSUserDefaults standardUserDefaults]setObject:@"女" forKey:User_sex];
                        }
                        if([[jsonDict objectForKey:User_logo]length]>10){
//                             UIImage *image=[UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:[[jsonDict objectForKey:@"userLogo"] stringByReplacingOcc urrencesOfString:@"\n" withString:@""]  options:NSDataBase64DecodingIgnoreUnknownCharacters]];
//                             NSData *photo_data = UIImageJPEGRepresentation(image, 0.5);
//                             NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
//                             [photo_data writeToFile:aPath atomically:YES];
                            [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_logo] forKey:User_logo];
                        }
                        if(![[jsonDict objectForKey:User_Addrss] isEqual:[NSNull null]])
                            [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_Addrss] forKey:User_Addrss];
                        if(![[jsonDict objectForKey:User_Village] isEqual:[NSNull null]])
                            [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_Village] forKey:User_Village];
                        
                        //IM帐户与密码
                        NSString * userMobile;
                        if (![[jsonDict objectForKey:User_Mobile] isEqual:[NSNull null]]) {
                            if ([[jsonDict objectForKey:User_Mobile] isKindOfClass:[NSString class]]) {
                                userMobile = [jsonDict objectForKey:User_Mobile];
                            }
                   
                            
                            
                        }
            
                        //个人信息中区域
                        if(![[jsonDict objectForKey:kUDUserDistrict] isEqual:[NSNull null]])
                           if(![[jsonDict objectForKey:@"areaCode"] isEqual:[NSNull null]]) [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:@"areaCode"] forKey:kUDUserDistrict];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNCAutoLoginedUpdatePersonalInfo object:nil];
                        
                      /*************************IM登录****************************/
                        //app 一启动便登录IM游客帐号。 1 游客帐号登录成功  当App用户帐号登录后————>退出IM游客帐号—————>登录用户IM帐号
                        //                         2 游客帐号未登录成功 当App用户帐号登录后————>直接登录用户IM帐号
                        SPKitExample  *spKitExample  =  [SPKitExample sharedInstance];
                        __weak typeof(spKitExample) weakSpKitExample=spKitExample;
                         __weak typeof(self) weakSelf=self;
                        if ([[SPKitExample sharedInstance].whichAccountLoginSuccess isEqualToString:IMVisitorAccountLoginSucccess]) {
                            [[[SPKitExample sharedInstance].ywIMKit.IMCore getLoginService] asyncLogoutWithCompletionBlock:^(NSError *aError, NSDictionary *aResult) {
                                if (aError==nil) {
                                    weakSpKitExample.whichAccountLoginSuccess=@"";
                                    [weakSpKitExample callThisAfterISVAccountLoginSuccessWithYWLoginId:userMobile passWord:IMUserPassword preloginedBlock:^{
                                        
                                    } successBlock:^{
                                        weakSpKitExample.whichAccountLoginSuccess=IMAppAccountLoginSucccess;
                                        
                                        /******判断联系人列表中是否已经添加了客服为好友*****/
                                        util * utilObj = [[util alloc]init];
                                        [utilObj DetermineWhetherIsCustomerService];
                                        

                                    } failedBlock:^(NSError * error) {
                                        NSLog(@"error====%@",error);
                                    }];
                                }else{//没有退出游客帐号成功
                                
                                NSLog(@"error====%@",aError);
                                }
                            }];
                            
                        }else{
                         [[SPKitExample sharedInstance]callThisAfterISVAccountLoginSuccessWithYWLoginId:userMobile passWord:IMUserPassword preloginedBlock:^{
                             
                         } successBlock:^{
                             weakSpKitExample.whichAccountLoginSuccess = IMAppAccountLoginSucccess;
                             /******判断联系人列表中是否已经添加了客服为好友*****/
                             util * utilObj = [[util alloc]init];
                             [utilObj DetermineWhetherIsCustomerService];
                             
                         } failedBlock:^(NSError *error) {
                             NSLog(@"error====%@",error);

                         }];
                         
                        }
                        
                      
                        
                    }
                    
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                              });
                          }
                               method:url postDict:post];
    });

}


@end
