//
//  ResgisterSMScodeVC.m
//  IDIAI
//
//  Created by iMac on 14-7-1.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ResgisterSMScodeVC.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "util.h"
#import "CheckSMScodeVC.h"

@interface ResgisterSMScodeVC ()

@end

@implementation ResgisterSMScodeVC

-(void)dealloc{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillDisappear:(BOOL)animated{
    //self.PhonenumTextf.text=@"";
}

//向服务器发送手机号
-(void)SendmobileNumToServer{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
//        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0008\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\"}&body={\"mobileNum\":\"%@\"}",[[NSUserDefaults standardUserDefaults]objectForKey:@"kDefaultServerURLPublic"],self.PhonenumTextf.text];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"返回信息：%@",jsonDict);
                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10091) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CheckSMScodeVC *checkvc=[[CheckSMScodeVC alloc]initWithNibName:@"CheckSMScodeVC" bundle:nil];
                       // resg.phoneNum=self.PhonenumTextf.text;
                        UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
                        returnButtonItem.title = @"";
                        self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:139.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
                        self.navigationItem.backBarButtonItem = returnButtonItem;
                        [self.navigationController pushViewController:checkvc animated:YES];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10092){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"手机号码已经注册过" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [al show];
                        
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10099){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"操作失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [al show];
                        
                    });
                }
                
            });
        }
                               failedBlock:^{
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"操作失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                       [al show];
                                       
                                   });
                               }
                                    method:nil postDict:nil];
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
}

#pragma mark -
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   [self.view endEditing:YES];
    return YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
