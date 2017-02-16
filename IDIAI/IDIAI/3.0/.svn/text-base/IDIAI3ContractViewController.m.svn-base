//
//  IDIAI3ContractViewController.m
//  IDIAI
//
//  Created by Ricky on 15/12/21.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3ContractViewController.h"
#import "NewContractObject.h"//1
#import "IDIAIAppDelegate.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "LoginView.h"
#import "TLToast.h"
#import "IDIAI3ContractDetailViewController.h"
#import "IDIAI3OrderDetailViewController.h"
#import "savelogObj.h"
#import "PayingConfirmViewController.h"
#import "IDIAI3ConfirmPaymentViewController.h"
#import "AfterSaleViewController.h"
#import "RefundViewController.h"
#import "NewOrderDetailObject.h"//2
#import "util.h"
#import "UIImageView+WebCache.h"
#import "CommentViewForGJS.h"
#import "IDIAI3CommentViewController.h"
#import "CustomPromptView.h"
#import "OnlinePayViewController.h"
@interface IDIAI3ContractViewController ()<UIAlertViewDelegate,CommentsViewDelegate,LoginViewDelegate>{
    CommentViewForGJS *comment;
    CustomPromptView *customPromp;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger ismerge;
@property(nonatomic,assign)NSInteger oldsection;
@property(nonatomic,strong)NewOrderObject *selectOrder;
@property(nonatomic,strong)NewContractObject *selectContract;
@property(nonatomic,assign)BOOL isMakeUp;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)BOOL isEnbleDeposit;//是否能托管
@end

@implementation IDIAI3ContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.nav setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.currentPage=0;
    self.type =7;
    
    self.dataArray =[NSMutableArray array];
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-44-64) pullingDelegate:self];
    self.mtableview.backgroundColor=[UIColor clearColor];
    self.mtableview.dataSource=self;
    self.mtableview.delegate=self;
    self.mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    backView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.mtableview.tableHeaderView =backView;
    self.isRefresh =YES;
//    [self.mtableview launchRefreshing];
    [self.view addSubview:self.mtableview];
    [self loadImageviewBG];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isRefresh ==YES) {
        [self.mtableview launchRefreshing];
        if (self.isMakeUp ==YES) {
            [self requestOrderDetail];
        }
    }
    self.isRefresh =YES;
}
- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:YES];
}
-(void)requestOrderDetail{
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSString *string_token;
        NSString *string_userid;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        else{
            string_token=@"";
            string_userid=@"";
        }
        
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0307" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"phaseOrderCode":self.selectOrder.phaseOrderCode};
        NSString *string02=[bodyDic JSONString];
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:string forKey:@"header"];
        [post setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setTimeOutSeconds:15];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                // NSLog(@"login返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopRequest];
                    //token为空或验证未通过处理 huangrun
//                    if (kResCode == 10002 || kResCode == 10003) {
//                        self.view.tag = 1002;
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
//                            login.delegate=self;
//                            [login show];
//                        });
//                        
//                        return;
//                    }
                    
                    if (kResCode == 103071) {
                        for (NSDictionary *phasedic in [jsonDict objectForKey:@"contractProjects"]) {
                            NSMutableDictionary *phase =[NSMutableDictionary dictionaryWithDictionary:phasedic];
                            [phase removeObjectForKey:@"orderCode_"];
                            DCKeyValueObjectMapping *parser1 = [DCKeyValueObjectMapping mapperForClass:[NewOrderDetailObject class]];
                            NewOrderDetailObject *orderobject =[parser1 parseDictionary:phase];
                            if ([self.selectOrder.phaseOrderCode isEqualToString:orderobject.phaseOrderCode]) {
                                if (orderobject.phaseOrderState==7&&orderobject.makeUpState ==3) {
                                    [self performSelector:@selector(delayAction:) withObject:orderobject afterDelay:0.5];
                                }
                            }
                        }
                        
                        //                        [self.mtableview launchRefreshing];
                        //                        [TLToast showWithText:@"合同确认成功"];
                    } else if (kResCode == 103089) {
                        //                        [TLToast showWithText:@"合同确认失败"];
                    } else if (kResCode == 103082) {
                        //                        [TLToast showWithText:@"该合同已被拒绝"];
                    }
                    //                            }else if (kResCode == 11305) {
                    //                                [TLToast showWithText:@"支付密码不正确"];
                    //                            }else{
                    //                                [TLToast showWithText:@"订单确认失败"];
                    //                            }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  //                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:post];
    });
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}
-(void)delayAction:(NewOrderDetailObject *)orderobject{
    IDIAI3ConfirmPaymentViewController *confirmPay =[[IDIAI3ConfirmPaymentViewController alloc] init];
    confirmPay.orderType =4;
    
    float orderPhraseFee =orderobject.phaseOrderFee+[self.selectOrder.makeUpFee floatValue];
    confirmPay.payforMoney =orderPhraseFee;
    confirmPay.orderCode =orderobject.phaseOrderCode;
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.nav pushViewController:confirmPay animated:YES];
    self.isMakeUp =NO;
}
#pragma mark - 确认、拒绝订单与确定付款
-(void)requestConfirmOrder:(UIButton *)sender{
    
    
    sender.userInteractionEnabled =NO;
    UIView *cellView;
    if ([[UIDevice currentDevice].systemVersion floatValue]>8.0) {
        cellView =[sender superview];
    }else{
        cellView =[[sender superview] superview];
    }
    if ([cellView isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)cellView;
        NSIndexPath *indexPath = [self.mtableview indexPathForCell:cell];
        NewContractObject *contract = [self.dataArray objectAtIndex:indexPath.section];
        if (contract.orderState ==1) {
            [self startRequestWithString:@"加载中..."];
            dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(parsingQueue, ^{
                
                NSString *string_token;
                NSString *string_userid;
                if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
                    string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
                    string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
                }
                else{
                    string_token=@"";
                    string_userid=@"";
                }
                NSString *url =[NSString string];
                
                url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0349\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":10,\"currentPage\":1,\"isAvailable\":1,\"orderType\":%d,\"objIds\":\"%d\",\"orderCode\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],contract.orderType,contract.servantId,contract.orderCode];
                
                NetworkRequest *req = [[NetworkRequest alloc] init];
                req.isCacheRequest=YES;
                [req setHttpMethod:GetMethod];
                
                [req sendToServerInBackground:^{
                    dispatch_async(parsingQueue, ^{
                        ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                        [request setResponseEncoding:NSUTF8StringEncoding];
                        NSString *respString = [request responseString];
                        NSDictionary *jsonDict = [respString objectFromJSONString];
                        NSLog(@"可用优惠列表返回信息：%@",jsonDict);
                        NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                        if (kResCode == 10002 || kResCode == 10003) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self stopRequest];
                                LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                                login.delegate=self;
                                [login show];
                                return;
                            });
                        }
                        if (code==103491) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self stopRequest];
                                NSArray *arr_=[jsonDict objectForKey:@"coupons"];
                                if ([arr_ count]) {
                                    NewContractObject *contraObject =[self.dataArray objectAtIndex:indexPath.section];
                                    IDIAI3ContractDetailViewController *contract =[[IDIAI3ContractDetailViewController alloc] init];
                                    contract.title =@"合同详情";
                                    contract.orderCode =contraObject.orderCode;
                                    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                                    self.isRefresh =NO;
                                    [delegate.nav pushViewController:contract animated:YES];
                                }else{
                                    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                    dispatch_async(parsingQueue, ^{
                                        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
                                        
                                        NSString *string_token;
                                        NSString *string_userid;
                                        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
                                            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
                                            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
                                        }
                                        else{
                                            string_token=@"";
                                            string_userid=@"";
                                        }
                                        
                                        
                                        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
                                        [postDict setObject:@"ID0355" forKey:@"cmdID"];
                                        [postDict setObject:string_token forKey:@"token"];
                                        [postDict setObject:string_userid forKey:@"userID"];
                                        [postDict setObject:@"ios" forKey:@"deviceType"];
                                        [postDict setObject:kCityCode forKey:@"cityCode"];
                                        
                                        NSString *string=[postDict JSONString];
                                        NSDictionary *bodyDic = @{@"orderCode":contract.orderCode,@"actionType":@1};
                                        NSString *string02=[bodyDic JSONString];
                                        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
                                        [post setObject:string forKey:@"header"];
                                        [post setObject:string02 forKey:@"body"];
                                        
                                        NetworkRequest *req = [[NetworkRequest alloc] init];
                                        [req setHttpMethod:PostMethod];
                                        
                                        [req sendToServerInBackground:^{
                                            dispatch_async(parsingQueue, ^{
                                                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                                                [request setTimeOutSeconds:15];
                                                [request setResponseEncoding:NSUTF8StringEncoding];
                                                NSString *respString = [request responseString];
                                                NSDictionary *jsonDict = [respString objectFromJSONString];
                                                // NSLog(@"login返回信息：%@",jsonDict);
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    NSLog(@"currentStread========%@",[NSThread currentThread]);
                                                    [NSThread sleepForTimeInterval:1];//让线程休眠一秒钟，便面后台处理太慢，刷新页面时请求回来的数据还是原来的数据
                                                    [self stopRequest];
                                                    sender.userInteractionEnabled =YES;
                                                    //token为空或验证未通过处理 huangrun
                                                    if (kResCode == 10002 || kResCode == 10003) {
                                                        self.view.tag = 1002;
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                                                            login.delegate=self;
                                                            [login show];
                                                            
                                                        });
                                                        
                                                        return;
                                                    }
                                                    
                                                    if (kResCode == 103551) {
                                                        [self.mtableview launchRefreshing];
                                                       
                                                        [TLToast showWithText:@"合同确认成功"];
                                                    } else if (kResCode == 103559) {
                                                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                                        customPromp.contenttxt =@"合同确认失败";
                                                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                                        [customPromp addGestureRecognizer:tap];
                                                        [customPromp show];
                                                        //                                [TLToast showWithText:@"合同确认失败"];
                                                    } else if (kResCode == 103552||kResCode ==103553) {
                                                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                                        customPromp.contenttxt =@"该合同已被拒绝";
                                                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                                        [customPromp addGestureRecognizer:tap];
                                                        [customPromp show];
                                                        //                                [TLToast showWithText:@"该合同已被拒绝"];
                                                    }else if (kResCode ==103554){
                                                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                                        customPromp.contenttxt =@"没有相关的城市阶段配置";
                                                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                                        [customPromp addGestureRecognizer:tap];
                                                        [customPromp show];
                                                        //                                [TLToast showWithText:@"该合同重复提交"];
                                                    }
                                                    //                            }else if (kResCode == 11305) {
                                                    //                                [TLToast showWithText:@"支付密码不正确"];
                                                    //                            }else{
                                                    //                                [TLToast showWithText:@"订单确认失败"];
                                                    //                            }
                                                });
                                            });
                                        }
                                                          failedBlock:^{
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [self stopRequest];
                                                                  //                                          sender.userInteractionEnabled =NO;
                                                                  customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                                                  customPromp.contenttxt =@"操作失败";
                                                                  UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                                                  [customPromp addGestureRecognizer:tap];
                                                                  [customPromp show];
                                                                  //                                          [TLToast showWithText:@"操作失败"];
                                                              });
                                                          }
                                                               method:url postDict:post];
                                    });
                                }
                                
                                //                        self.isrequst =NO;
                            });
                        }
                        else if (code==103499) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self stopRequest];
                                customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                customPromp.contenttxt =@"获取优惠券失败";
                                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                [customPromp addGestureRecognizer:tap];
                                [customPromp show];
                            });
                        }
                        else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self stopRequest];
                                customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                customPromp.contenttxt =@"获取优惠券失败";
                                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                [customPromp addGestureRecognizer:tap];
                                [customPromp show];
                            });
                        }
                    });
                }
                                  failedBlock:^{
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self stopRequest];
                                          customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                          customPromp.contenttxt =@"获取优惠券失败";
                                          UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                          [customPromp addGestureRecognizer:tap];
                                          [customPromp show];
                                      });
                                  }
                                       method:url postDict:nil];
            });
            
        }
    }
    
    
    
    
    
//    NSString *secretKeyStr;
    
//    if (myOrderModel.orderState == 7) {
//        [savelogObj saveLog:@"确认付款" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:62];
//        
//        InputPayPsdViewController *inputPayPsdVC = [[InputPayPsdViewController alloc]init];
//        inputPayPsdVC.myOrderModel = myOrderModel;
//        inputPayPsdVC.fromStr = @"orderDetailOfGoodsVC";
//        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate.nav pushViewController:inputPayPsdVC animated:YES];
//        return;
//        
//    } else if (myOrderModel.orderState == 8) {
//        
//    } else {
//        secretKeyStr = @"";
//    }
//    
//    //确认订单（合同）记日志
//    if(myOrderModel.orderState == 1) [savelogObj saveLog:@"确认订单（合同）" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:59];
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewContractObject *newcontract =[self.dataArray objectAtIndex:indexPath.section];
    if (newcontract.orderState ==1||newcontract.orderState==3){
        return 181;
    }else{
        if (indexPath.row ==0) {
             NewOrderObject *currentorder =[newcontract.phaseOrders objectAtIndex:indexPath.row];
            if (newcontract.orderType ==4) {
                NewOrderObject *neworder =[newcontract.phaseOrders objectAtIndex:0];
                NewOrderObject *newsecondorder =[[NewOrderObject alloc] init];
                if (newcontract.phaseOrders.count>2) {
                    newsecondorder =[newcontract.phaseOrders objectAtIndex:1];
                }
                if (neworder.phaseOrderState==33&&newsecondorder.phaseOrderState==2) {
                    CGFloat height =0;
                    if ([neworder.phaseOrderFee doubleValue]!=[neworder.originalOrderFee doubleValue]) {
                        height +=26;
                    }
                    if ([newsecondorder.phaseOrderFee doubleValue]!=[newsecondorder.originalOrderFee doubleValue]) {
                        height+=26;
                    }
                    if ([neworder.phaseOrderFee doubleValue]!=[neworder.originalOrderFee doubleValue]||[newsecondorder.phaseOrderFee doubleValue]!=[newsecondorder.originalOrderFee doubleValue]) {
                        height+=26;
                    }
                    if (newcontract.isChangeAttchment ==1) {
                        height+=26;
                    }
                    return 470+height;
                }
            }
            if (newcontract.orderType ==4) {
                NewOrderObject *neworder =[newcontract.phaseOrders objectAtIndex:0];
                CGFloat height =0;
                if ([neworder.phaseOrderFee doubleValue]!=[neworder.originalOrderFee doubleValue]) {
                    height +=26;
                }
                if (newcontract.isChangeAttchment ==1) {
                    height+=26;
                }
                if ([[neworder.phaseOrderCode substringToIndex:1] isEqualToString:@"G"]) {
                    if (neworder.phaseOrderState==17) {
                        return 294+height;
                    }
                }
            }
            if (currentorder.phaseOrderState ==12) {
                CGFloat height =0;
                if ([currentorder.phaseOrderFee doubleValue]!=[currentorder.originalOrderFee doubleValue]) {
                    height +=26;
                }
                if (newcontract.isChangeAttchment ==1) {
                    height+=26;
                }
                return 309+height;
            }
            if (currentorder.phaseOrderState ==36) {
                CGFloat height =0;
                if ([currentorder.phaseOrderFee doubleValue]!=[currentorder.originalOrderFee doubleValue]) {
                    height +=26;
                }
                if (newcontract.isChangeAttchment ==1) {
                    height+=26;
                }
                return 369;
            }
            if (currentorder.phaseOrderState ==35&&currentorder.makeUpState==5) {
                CGFloat height =0;
                if ([currentorder.phaseOrderFee doubleValue]!=[currentorder.originalOrderFee doubleValue]) {
                    height +=26;
                }
                if (newcontract.isChangeAttchment ==1) {
                    height+=26;
                }
                return 349+height;
            }
            CGFloat height =0;
            if ([currentorder.phaseOrderFee doubleValue]!=[currentorder.originalOrderFee doubleValue]) {
                height +=26;
            }
            if (newcontract.isChangeAttchment ==1) {
                height+=26;
            }
            return 329+height;
        }else{
            NewOrderObject *neworder =[newcontract.phaseOrders objectAtIndex:0];
            NewOrderObject *newsecondorder =[[NewOrderObject alloc] init];
            NewOrderObject *currentorder;
            if (newcontract.phaseOrders.count-1>=indexPath.row) {
                currentorder =[newcontract.phaseOrders objectAtIndex:indexPath.row];
            }
            if (newcontract.phaseOrders.count>2) {
                newsecondorder =[newcontract.phaseOrders objectAtIndex:1];
            }
            if (neworder.phaseOrderState==33&&newsecondorder.phaseOrderState==2) {
                if (newcontract.phaseOrders.count-2==indexPath.row) {
                    CGFloat height =0;
                    if ([currentorder.phaseOrderFee doubleValue]!=[currentorder.originalOrderFee doubleValue]) {
                        height +=26;
                    }
//                    if ([newsecondorder.phaseOrderFee doubleValue]!=[newsecondorder.originalOrderFee doubleValue]) {
//                        height+=26;
//                    }
//                    if ([neworder.phaseOrderFee doubleValue]!=[neworder.originalOrderFee doubleValue]||[newsecondorder.phaseOrderFee doubleValue]!=[newsecondorder.originalOrderFee doubleValue]) {
//                        height+=26;
//                    }
                    return 193+height;
                }
            }
            if (newcontract.phaseOrders.count-1==indexPath.row) {
                if (currentorder.phaseOrderState ==36) {
                    CGFloat height =0;
                    if ([currentorder.phaseOrderFee doubleValue]!=[currentorder.originalOrderFee doubleValue]) {
                        height +=26;
                    }
                    return 233+height;
                }
                if (currentorder.phaseOrderState ==35&&currentorder.makeUpState==5) {
                    CGFloat height =0;
                    if ([currentorder.phaseOrderFee doubleValue]!=[currentorder.originalOrderFee doubleValue]) {
                        height +=26;
                    }
                    return 213+height;
                }
                CGFloat height =0;
                if ([currentorder.phaseOrderFee doubleValue]!=[currentorder.originalOrderFee doubleValue]) {
                    height +=26;
                }
                return 183+height;
            }
            if (currentorder.phaseOrderState ==12) {
                CGFloat height =0;
                if ([currentorder.phaseOrderFee doubleValue]!=[currentorder.originalOrderFee doubleValue]) {
                    height +=26;
                }
                return 173+height;
            }
            if (currentorder.phaseOrderState ==36) {
                CGFloat height =0;
                if ([currentorder.phaseOrderFee doubleValue]!=[currentorder.originalOrderFee doubleValue]) {
                    height +=26;
                }
                return 223+height;
            }
            if (currentorder.phaseOrderState ==35&&currentorder.makeUpState==5) {
                CGFloat height =0;
                if ([currentorder.phaseOrderFee doubleValue]!=[currentorder.originalOrderFee doubleValue]) {
                    height +=26;
                }
                return 203+height;
            }
            CGFloat height =0;
            if ([currentorder.phaseOrderFee doubleValue]!=[currentorder.originalOrderFee doubleValue]) {
                height +=26;
            }
            return 183+height;
        }
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count>0) {
        return self.dataArray.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NewContractObject *newcontract =[self.dataArray objectAtIndex:section];
    if (newcontract.orderState ==1||newcontract.orderState==3) {
        return 1;
    }else{
        if (newcontract.orderType ==4) {
            NewOrderObject *neworder =[newcontract.phaseOrders objectAtIndex:0];
            NewOrderObject *newsecondorder =[[NewOrderObject alloc] init];
            if (newcontract.phaseOrders.count>2) {
                newsecondorder =[newcontract.phaseOrders objectAtIndex:1];
            }
            if (neworder.phaseOrderState==33&&newsecondorder.phaseOrderState==2) {
                return newcontract.phaseOrders.count-1;
            }
            return newcontract.phaseOrders.count;
        }
        return newcontract.phaseOrders.count;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    backView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    return backView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid=[NSString stringWithFormat:@"mycellid_%d_%d",(int)indexPath.section,(int)indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    NewContractObject *newcontract =[self.dataArray objectAtIndex:indexPath.section];
    
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.row ==0) {
//            self.userLogo =[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
//            self.userLogo.layer.masksToBounds = YES;
//            self.userLogo.layer.cornerRadius = 15;
//            [self addSubview:self.userLogo];
//
//            self.namelbl =[[UILabel alloc] initWithFrame:CGRectMake(self.userLogo.frame.size.width+self.userLogo.frame.origin.x+15, 15, 100, 15)];
//            self.namelbl.textColor =[UIColor colorWithHexString:@"#575757"];
//            self.namelbl.font =[UIFont systemFontOfSize:15.0];
//            [self addSubview:self.namelbl];
            
            UIImageView *headimage =[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
            headimage.layer.masksToBounds = YES;
            headimage.layer.cornerRadius = 15;
            headimage.tag =999;
            [cell addSubview:headimage];
            
            UILabel *servanName =[[UILabel alloc] initWithFrame:CGRectMake(headimage.frame.size.width+headimage.frame.origin.x+15, 15, kMainScreenWidth, 17)];
            servanName.font =[UIFont systemFontOfSize:17];
            servanName.textColor =[UIColor colorWithHexString:@"#575757"];
            servanName.tag =1000;
            [cell addSubview:servanName];
            
            UIImageView *lineimage =[[UIImageView alloc] initWithFrame:CGRectMake(15, servanName.frame.origin.y+servanName.frame.size.height+15, kMainScreenWidth-30, 1)];
            lineimage.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
            [cell addSubview:lineimage];
            
            UILabel *contractCode =[[UILabel alloc] initWithFrame:CGRectMake(15, lineimage.frame.size.height+lineimage.frame.origin.y+14, kMainScreenWidth-30, 15)];
            contractCode.font =[UIFont systemFontOfSize:15];
            contractCode.tag =1001;
            contractCode.textColor =[UIColor colorWithHexString:@"#575757"];
            [cell addSubview:contractCode];
            
            UILabel *contractType =[[UILabel alloc] initWithFrame:CGRectMake(15, contractCode.frame.size.height+contractCode.frame.origin.y+11, kMainScreenWidth-30, 15)];
            contractType.font =[UIFont systemFontOfSize:15];
            contractType.tag =1002;
            contractType.textColor =[UIColor colorWithHexString:@"#575757"];
            [cell addSubview:contractType];
            
            UILabel *contractFee =[[UILabel alloc] initWithFrame:CGRectMake(15, contractType.frame.size.height+contractType.frame.origin.y+11, kMainScreenWidth-30, 15)];
            contractFee.font =[UIFont systemFontOfSize:15];
            contractFee.tag =1004;
            contractFee.textColor =[UIColor colorWithHexString:@"#575757"];
            [cell addSubview:contractFee];
            
            UIImageView *exclamationimg =[[UIImageView alloc] initWithFrame:CGRectMake(15, contractFee.frame.size.height+contractFee.frame.origin.y+10, 17, 17)];
            exclamationimg.image =[UIImage imageNamed:@"ic_tx"];
            exclamationimg.hidden =YES;
            exclamationimg.tag =1007;
            [cell addSubview:exclamationimg];
            
            UILabel *ischangeAttchment =[[UILabel alloc] initWithFrame:CGRectMake(exclamationimg.frame.origin.x+exclamationimg.frame.size.width+5, contractFee.frame.size.height+contractFee.frame.origin.y+11, kMainScreenWidth-30-exclamationimg.frame.origin.x-exclamationimg.frame.size.width-5, 15)];
            ischangeAttchment.font =[UIFont systemFontOfSize:15];
            ischangeAttchment.textColor =[UIColor colorWithHexString:@"#ef6562"];
            ischangeAttchment.tag =1006;
            [cell addSubview:ischangeAttchment];
            
            UIButton *commentbtn =[UIButton buttonWithType:UIButtonTypeCustom];
            commentbtn.frame =CGRectMake(kMainScreenWidth-94, contractFee.frame.origin.y, 79, 30);
            [commentbtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
            [commentbtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
            commentbtn.tag =998;
            commentbtn.titleLabel.font =[UIFont systemFontOfSize:15];
            [commentbtn setTitle:@"评论" forState:UIControlStateNormal];
            [commentbtn setTitle:@"评论" forState:UIControlStateHighlighted];
            [commentbtn addTarget:self action:@selector(myappraise:) forControlEvents:UIControlEventTouchUpInside];
            commentbtn.layer.masksToBounds = YES;
            commentbtn.layer.cornerRadius = 3;
            commentbtn.layer.borderColor = kThemeColor.CGColor;
            commentbtn.layer.borderWidth = 1;
            //                if (newcontract.orderState ==3) {
            commentbtn.hidden =YES;
            //                }
            [cell addSubview:commentbtn];
            if (newcontract.orderState ==1||newcontract.orderState==3) {
                UILabel *orderstate =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-108, 17, 80, 15)];
                orderstate.font =[UIFont systemFontOfSize:15];
                orderstate.tag =102;
                orderstate.textAlignment =NSTextAlignmentRight;
                orderstate.textColor =[UIColor colorWithHexString:@"#ef6562"];
                [cell addSubview:orderstate];
                
                UIButton *firstBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                firstBtn.tag =112;
                firstBtn.frame =CGRectMake(88*kMainScreenWidth/375, 181-40, 79, 30);
                [firstBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                [firstBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                firstBtn.titleLabel.font =[UIFont systemFontOfSize:15];
//                if (newcontract.orderState ==3) {
                    firstBtn.hidden =YES;
//                }
                [cell addSubview:firstBtn];
                
                UIButton *secondBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                secondBtn.tag =113;
                [secondBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                [secondBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                secondBtn.frame =CGRectMake(181*kMainScreenWidth/375, 181-40, 79, 30);
                secondBtn.titleLabel.font =[UIFont systemFontOfSize:15];
//                if (newcontract.orderState ==3) {
                    secondBtn.hidden =YES;
//                }
                [cell addSubview:secondBtn];
                
                UIButton *thirdBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                thirdBtn.tag =114;
                [thirdBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                [thirdBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                thirdBtn.frame =CGRectMake(275*kMainScreenWidth/375, 181-40, 79, 30);
                thirdBtn.titleLabel.font =[UIFont systemFontOfSize:15];
//                if (newcontract.orderState ==3) {
                    thirdBtn.hidden =YES;
//                }
                [cell addSubview:thirdBtn];
//                cell.backgroundColor =[UIColor redColor];
            }else{
                if (newcontract.orderType ==4) {
                    NewOrderObject *neworder =[newcontract.phaseOrders objectAtIndex:0];
                    NewOrderObject *newsecondorder =[[NewOrderObject alloc] init];
                    if (newcontract.phaseOrders.count>2) {
                        newsecondorder =[newcontract.phaseOrders objectAtIndex:1];
                    }

                    UIView *contentbackView =[[UIView alloc] initWithFrame:CGRectMake(15, contractFee.frame.origin.y+contractFee.frame.size.height+24, kMainScreenWidth-30, 312)];
                    if (newcontract.isChangeAttchment ==1) {
                        contentbackView.frame =CGRectMake(15, ischangeAttchment.frame.origin.y+ischangeAttchment.frame.size.height+24, kMainScreenWidth-30, 312);
                    }
                    contentbackView.backgroundColor =[UIColor whiteColor];
                    contentbackView.layer.masksToBounds = YES;
                    contentbackView.layer.cornerRadius = 10;
                    contentbackView.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
                    contentbackView.layer.borderWidth = 1;
                    contentbackView.tag =1005;
                    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrderAction:)];
                    [contentbackView addGestureRecognizer:tap];
                    [cell addSubview:contentbackView];
                    
                    UILabel *ordername =[[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 15)];
                    ordername.font =[UIFont systemFontOfSize:15];
                    ordername.tag =100;
                    ordername.textColor =[UIColor colorWithHexString:@"#575757"];
                    [contentbackView addSubview:ordername];
                    
                    UILabel *orderstate =[[UILabel alloc] initWithFrame:CGRectMake(contentbackView.frame.size.width-93, 10, 80, 15)];
                    orderstate.font =[UIFont systemFontOfSize:15];
                    orderstate.tag =102;
                    orderstate.textAlignment =NSTextAlignmentRight;
                    orderstate.textColor =[UIColor colorWithHexString:@"#ef6562"];
                    [contentbackView addSubview:orderstate];
                    
                    UIImageView *contenttopline =[[UIImageView alloc] initWithFrame:CGRectMake(15, ordername.frame.origin.y+ordername.frame.size.height+8, contentbackView.frame.size.width-30, 1)];
                    contenttopline.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                    [contentbackView addSubview:contenttopline];
                    
                    UILabel *orderCode =[[UILabel alloc] initWithFrame:CGRectMake(15, contenttopline.frame.size.height+contenttopline.frame.origin.y+11, kMainScreenWidth-60, 15)];
                    orderCode.font =[UIFont systemFontOfSize:15];
                    orderCode.tag =103;
                    orderCode.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    [contentbackView addSubview:orderCode];
                    
                    UILabel *orderfee =[[UILabel alloc] initWithFrame:CGRectMake(15, orderCode.frame.size.height+orderCode.frame.origin.y+11, kMainScreenWidth-30, 15)];
                    orderfee.font =[UIFont systemFontOfSize:15];
                    orderfee.tag =104;
                    orderfee.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    [contentbackView addSubview:orderfee];
                    UILabel *realpay;
                    if ([neworder.originalOrderFee doubleValue]!=[neworder.phaseOrderFee doubleValue]) {
                        realpay =[[UILabel alloc] initWithFrame:CGRectMake(15, orderfee.frame.size.height+orderfee.frame.origin.y+11, kMainScreenWidth-30, 15)];
                        realpay.font =[UIFont systemFontOfSize:15];
                        realpay.tag =120;
                        realpay.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        [contentbackView addSubview:realpay];
                        contentbackView.frame =CGRectMake(contentbackView.frame.origin.x, contentbackView.frame.origin.y, contentbackView.frame.size.width, contentbackView.frame.size.height+26);
                    }
                    
                    UILabel *orderlasttime =[[UILabel alloc] initWithFrame:CGRectMake(15, orderfee.frame.size.height+orderfee.frame.origin.y+11, kMainScreenWidth-30, 15)];
                    if ([neworder.originalOrderFee doubleValue]!=[neworder.phaseOrderFee doubleValue]) {
                        orderlasttime.frame =CGRectMake(15, realpay.frame.size.height+realpay.frame.origin.y+11,kMainScreenWidth-30, 15);
                    }
                    orderlasttime.font =[UIFont systemFontOfSize:15];
                    orderlasttime.tag =105;
                    orderlasttime.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    [contentbackView addSubview:orderlasttime];
                    
                    UIImageView *contentmidline =[[UIImageView alloc] initWithFrame:CGRectMake(15, orderlasttime.frame.origin.y+orderlasttime.frame.size.height+13, contentbackView.frame.size.width-30, 1)];
                    contentmidline.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                    [contentbackView addSubview:contentmidline];
                    
                    UILabel *ordersecondname =[[UILabel alloc] initWithFrame:CGRectMake(15, contentmidline.frame.origin.y+contentmidline.frame.size.height+10, 80, 15)];
                    ordersecondname.font =[UIFont systemFontOfSize:15];
                    ordersecondname.tag =106;
                    ordersecondname.textColor =[UIColor colorWithHexString:@"#575757"];
                    [contentbackView addSubview:ordersecondname];
                    
                    UILabel *ordersecondstate =[[UILabel alloc] initWithFrame:CGRectMake(contentbackView.frame.size.width-93, contentmidline.frame.origin.y+contentmidline.frame.size.height+10, 80, 15)];
                    ordersecondstate.font =[UIFont systemFontOfSize:15];
                    ordersecondstate.tag =107;
                    ordersecondstate.textAlignment =NSTextAlignmentRight;
                    ordersecondstate.textColor =[UIColor colorWithHexString:@"#ef6562"];
                    [contentbackView addSubview:ordersecondstate];
                    
                    UIImageView *contentfootline =[[UIImageView alloc] initWithFrame:CGRectMake(15, ordersecondname.frame.origin.y+ordersecondname.frame.size.height+8, contentbackView.frame.size.width-30, 1)];
                    contentfootline.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                    [contentbackView addSubview:contentfootline];
                    
                    UILabel *ordersecondCode =[[UILabel alloc] initWithFrame:CGRectMake(15, contentfootline.frame.size.height+contentfootline.frame.origin.y+11, kMainScreenWidth-60, 15)];
                    ordersecondCode.font =[UIFont systemFontOfSize:15];
                    ordersecondCode.tag =108;
                    ordersecondCode.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    [contentbackView addSubview:ordersecondCode];
                    
                    UILabel *ordersecondfee =[[UILabel alloc] initWithFrame:CGRectMake(15, ordersecondCode.frame.size.height+ordersecondCode.frame.origin.y+11, kMainScreenWidth-30, 15)];
                    ordersecondfee.font =[UIFont systemFontOfSize:15];
                    ordersecondfee.tag =109;
                    ordersecondfee.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    [contentbackView addSubview:ordersecondfee];
                    
                    UILabel *secondrealpay;
                    if ([newsecondorder.originalOrderFee doubleValue]!=[newsecondorder.phaseOrderFee doubleValue]) {
                        secondrealpay =[[UILabel alloc] initWithFrame:CGRectMake(15, ordersecondfee.frame.size.height+ordersecondfee.frame.origin.y+11, kMainScreenWidth-30, 15)];
                        secondrealpay.font =[UIFont systemFontOfSize:15];
                        secondrealpay.tag =121;
                        secondrealpay.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        [contentbackView addSubview:secondrealpay];
                        contentbackView.frame =CGRectMake(contentbackView.frame.origin.x, contentbackView.frame.origin.y, contentbackView.frame.size.width, contentbackView.frame.size.height+26);
                    }
                    
                    UILabel *ordersecondlasttime =[[UILabel alloc] initWithFrame:CGRectMake(15, ordersecondfee.frame.size.height+ordersecondfee.frame.origin.y+11, kMainScreenWidth-30, 15)];
                    if ([newsecondorder.originalOrderFee doubleValue]!=[newsecondorder.phaseOrderFee doubleValue]) {
                        ordersecondlasttime.frame =CGRectMake(15, secondrealpay.frame.size.height+secondrealpay.frame.origin.y+11,kMainScreenWidth-30, 15);
                    }
                    ordersecondlasttime.font =[UIFont systemFontOfSize:15];
                    ordersecondlasttime.tag =110;
                    ordersecondlasttime.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    [contentbackView addSubview:ordersecondlasttime];
                    
                    UILabel *totalFee =[[UILabel alloc] initWithFrame:CGRectMake(15, ordersecondlasttime.frame.origin.y+ordersecondlasttime.frame.size.height+11, kMainScreenWidth-80, 15)];
                    totalFee.font =[UIFont systemFontOfSize:15];
                    totalFee.tag =111;
                    totalFee.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    [contentbackView addSubview:totalFee];
                    UILabel *totalFeeRealPay;
                    if ([newsecondorder.originalOrderFee doubleValue]!=[newsecondorder.phaseOrderFee doubleValue]||[neworder.originalOrderFee doubleValue]!=[neworder.phaseOrderFee doubleValue]) {
                        totalFeeRealPay =[[UILabel alloc] initWithFrame:CGRectMake(15, totalFee.frame.size.height+totalFee.frame.origin.y+11, kMainScreenWidth-30, 15)];
                        totalFeeRealPay.font =[UIFont systemFontOfSize:15];
                        totalFeeRealPay.tag =122;
                        totalFeeRealPay.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        [contentbackView addSubview:totalFeeRealPay];
                        contentbackView.frame =CGRectMake(contentbackView.frame.origin.x, contentbackView.frame.origin.y, contentbackView.frame.size.width, contentbackView.frame.size.height+26);
                    }
                    if (neworder.phaseOrderState==33&&newsecondorder.phaseOrderState==2){
                        
                    }else{
                        contentbackView.frame=CGRectMake(15, contractFee.frame.origin.y+contractFee.frame.size.height+24, kMainScreenWidth-30, 170);
                        if (newcontract.isChangeAttchment ==1) {
                            contentbackView.frame =CGRectMake(15, ischangeAttchment.frame.origin.y+ischangeAttchment.frame.size.height+24, kMainScreenWidth-30, 170);
                        }
                        if (neworder.phaseOrderState ==36) {
                            contentbackView.frame = CGRectMake(15, contentbackView.frame.origin.y, kMainScreenWidth-30, 210);
                        }
                        if (neworder.phaseOrderState ==35&&neworder.makeUpState ==5) {
                            contentbackView.frame = CGRectMake(15, contentbackView.frame.origin.y, kMainScreenWidth-30, 190);
                        }
                        if (realpay) {
                            contentbackView.frame=CGRectMake(15, contentbackView.frame.origin.y, kMainScreenWidth-30, contentbackView.frame.size.height+26);
                        }
                        if (neworder.phaseOrderState==33&&newsecondorder.phaseOrderState==2) {
                            if (totalFeeRealPay) {
                                contentbackView.frame=CGRectMake(15, contentbackView.frame.origin.y, kMainScreenWidth-30, contentbackView.frame.size.height+26);
                            }
                            
                            if (secondrealpay) {
                                contentbackView.frame=CGRectMake(15, contentbackView.frame.origin.y, kMainScreenWidth-30, contentbackView.frame.size.height+26);
                            }
                        }
                        contentmidline.hidden =YES;
                        ordersecondname.hidden =YES;
                        ordersecondstate.hidden =YES;
                        contentfootline.hidden =YES;
                        ordersecondCode.hidden =YES;
                        ordersecondfee.hidden =YES;
                        ordersecondlasttime.hidden =YES;
                        totalFee.hidden =YES;
                    }
                    if (neworder.phaseOrderState ==36) {
                        if ([newsecondorder.originalOrderFee doubleValue]!=[newsecondorder.phaseOrderFee doubleValue]||[neworder.originalOrderFee doubleValue]!=[neworder.phaseOrderFee doubleValue]) {
                            totalFeeRealPay.frame =CGRectMake(15, orderlasttime.frame.origin.y+orderlasttime.frame.size.height+11, 150, 15);
                        }
                        UILabel *alreadyname =[[UILabel alloc] initWithFrame:CGRectMake(15, orderlasttime.frame.origin.y+orderlasttime.frame.size.height+11, 150, 15)];
//                        if ([newsecondorder.originalOrderFee doubleValue]!=[newsecondorder.phaseOrderFee doubleValue]||[neworder.originalOrderFee doubleValue]!=[neworder.phaseOrderFee doubleValue]){
//                            alreadyname.frame =CGRectMake(15, totalFeeRealPay.frame.origin.y+totalFeeRealPay.frame.size.height+11, 150, 15);
//                        }
                        alreadyname.font =[UIFont systemFontOfSize:15];
                        alreadyname.tag =115;
                        alreadyname.textColor =[UIColor colorWithHexString:@"#ef6562"];
                        [contentbackView addSubview:alreadyname];
                        
                        UILabel *nevername =[[UILabel alloc] initWithFrame:CGRectMake(15, alreadyname.frame.origin.y+alreadyname.frame.size.height+11, 150, 15)];
                        nevername.font =[UIFont systemFontOfSize:15];
                        nevername.tag =116;
                        nevername.textColor =[UIColor colorWithHexString:@"#ef6562"];
                        [contentbackView addSubview:nevername];
                        
                    }
                    if (neworder.phaseOrderState ==35&&neworder.makeUpState ==5) {
                        if ([newsecondorder.originalOrderFee doubleValue]!=[newsecondorder.phaseOrderFee doubleValue]||[neworder.originalOrderFee doubleValue]!=[neworder.phaseOrderFee doubleValue]) {
                            totalFeeRealPay.frame =CGRectMake(15, orderlasttime.frame.origin.y+orderlasttime.frame.size.height+11, 150, 15);
                        }
                        UILabel *alreadyname =[[UILabel alloc] initWithFrame:CGRectMake(15, orderlasttime.frame.origin.y+orderlasttime.frame.size.height+11, 150, 15)];
                        if ([newsecondorder.originalOrderFee doubleValue]!=[newsecondorder.phaseOrderFee doubleValue]||[neworder.originalOrderFee doubleValue]!=[neworder.phaseOrderFee doubleValue]){
                            alreadyname.frame =CGRectMake(15, totalFeeRealPay.frame.origin.y+totalFeeRealPay.frame.size.height+11, 150, 15);
                        }
                        alreadyname.font =[UIFont systemFontOfSize:15];
                        alreadyname.tag =116;
                        alreadyname.textColor =[UIColor colorWithHexString:@"#ef6562"];
                        [contentbackView addSubview:alreadyname];
                    }
                    UIButton *firstBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    firstBtn.tag =112;
                    firstBtn.frame =CGRectMake(68*kMainScreenWidth/375, contentbackView.frame.size.height-45, 79*kMainScreenWidth/375, 30);
                    [firstBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                    [firstBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                    firstBtn.titleLabel.font =[UIFont systemFontOfSize:15];
                    firstBtn.hidden =YES;
                    [contentbackView addSubview:firstBtn];
                    
                    UIButton *secondBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    secondBtn.tag =113;
                    [secondBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                    [secondBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                    secondBtn.titleLabel.font =[UIFont systemFontOfSize:15];
                    secondBtn.frame =CGRectMake(161*kMainScreenWidth/375, contentbackView.frame.size.height-45, 79*kMainScreenWidth/375, 30);
                    secondBtn.hidden =YES;
                    [contentbackView addSubview:secondBtn];
                    
                    UIButton *thirdBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    thirdBtn.tag =114;
                    thirdBtn.frame =CGRectMake(255*kMainScreenWidth/375, contentbackView.frame.size.height-45, 79*kMainScreenWidth/375, 30);
                    [thirdBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                    [thirdBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                    thirdBtn.titleLabel.font =[UIFont systemFontOfSize:15];
                     thirdBtn.hidden =YES;
                    [contentbackView addSubview:thirdBtn];
//                    cell.backgroundColor =[UIColor orangeColor];
                }else{
                    NewOrderObject *neworder =[newcontract.phaseOrders objectAtIndex:0];
                    
                    UIView *contentbackView =[[UIView alloc] initWithFrame:CGRectMake(15, contractFee.frame.origin.y+contractFee.frame.size.height+24, kMainScreenWidth-30, 170)];
                    if (newcontract.isChangeAttchment ==1) {
                        contentbackView.frame =CGRectMake(15, ischangeAttchment.frame.origin.y+ischangeAttchment.frame.size.height+24, kMainScreenWidth-30, 170);
                    }
                    if (neworder.phaseOrderState ==36) {
                        contentbackView.frame = CGRectMake(15, contentbackView.frame.origin.y, kMainScreenWidth-30, 210);
                    }
                    if (neworder.phaseOrderState ==35&&neworder.makeUpState ==5) {
                        contentbackView.frame = CGRectMake(15, contentbackView.frame.origin.y, kMainScreenWidth-30, 190);
                    }
                    contentbackView.backgroundColor =[UIColor whiteColor];
                    contentbackView.layer.masksToBounds = YES;
                    contentbackView.layer.cornerRadius = 10;
                    contentbackView.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
                    contentbackView.layer.borderWidth = 1;
                    contentbackView.tag =1005;
                    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrderAction:)];
                    [contentbackView addGestureRecognizer:tap];
                    [cell addSubview:contentbackView];
                    
                    UILabel *ordername =[[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 15)];
                    ordername.font =[UIFont systemFontOfSize:15];
                    ordername.tag =100;
                    ordername.textColor =[UIColor colorWithHexString:@"#575757"];
                    [contentbackView addSubview:ordername];
                    
                    UILabel *orderstate =[[UILabel alloc] initWithFrame:CGRectMake(contentbackView.frame.size.width-93, 10, 80, 15)];
                    orderstate.font =[UIFont systemFontOfSize:15];
                    orderstate.tag =102;
                    orderstate.textAlignment =NSTextAlignmentRight;
                    orderstate.textColor =[UIColor colorWithHexString:@"#ef6562"];
                    [contentbackView addSubview:orderstate];
                    
                    UIImageView *contenttopline =[[UIImageView alloc] initWithFrame:CGRectMake(15, ordername.frame.origin.y+ordername.frame.size.height+8, contentbackView.frame.size.width-30, 1)];
                    contenttopline.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                    [contentbackView addSubview:contenttopline];
                    
                    UILabel *orderCode =[[UILabel alloc] initWithFrame:CGRectMake(15, contenttopline.frame.size.height+contenttopline.frame.origin.y+11, kMainScreenWidth-60, 15)];
                    orderCode.font =[UIFont systemFontOfSize:15];
                    orderCode.tag =103;
                    orderCode.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    [contentbackView addSubview:orderCode];
                    
                    UILabel *orderfee =[[UILabel alloc] initWithFrame:CGRectMake(15, orderCode.frame.size.height+orderCode.frame.origin.y+11, kMainScreenWidth-30, 15)];
                    orderfee.font =[UIFont systemFontOfSize:15];
                    orderfee.tag =104;
                    orderfee.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    [contentbackView addSubview:orderfee];
                    
                    UILabel *realpay;
                    if ([neworder.originalOrderFee doubleValue]!=[neworder.phaseOrderFee doubleValue]) {
                        realpay =[[UILabel alloc] initWithFrame:CGRectMake(15, orderfee.frame.size.height+orderfee.frame.origin.y+11, kMainScreenWidth-30, 15)];
                        realpay.font =[UIFont systemFontOfSize:15];
                        realpay.tag =120;
                        realpay.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        [contentbackView addSubview:realpay];
                        contentbackView.frame =CGRectMake(contentbackView.frame.origin.x, contentbackView.frame.origin.y, contentbackView.frame.size.width, contentbackView.frame.size.height+26);
                    }
                    
                    UILabel *orderlasttime =[[UILabel alloc] initWithFrame:CGRectMake(15, orderfee.frame.size.height+orderfee.frame.origin.y+11, kMainScreenWidth-30, 15)];
                    if ([neworder.originalOrderFee doubleValue]!=[neworder.phaseOrderFee doubleValue]) {
                        orderlasttime.frame =CGRectMake(15, realpay.frame.size.height+realpay.frame.origin.y+11,kMainScreenWidth-30, 15);
                    }
                    orderlasttime.font =[UIFont systemFontOfSize:15];
                    orderlasttime.tag =105;
                    orderlasttime.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    [contentbackView addSubview:orderlasttime];
                    
                    if (neworder.phaseOrderState ==36) {
                        UILabel *alreadyname =[[UILabel alloc] initWithFrame:CGRectMake(15, orderlasttime.frame.origin.y+orderlasttime.frame.size.height+11, 150, 15)];
                        alreadyname.font =[UIFont systemFontOfSize:15];
                        alreadyname.tag =115;
                        alreadyname.textColor =[UIColor colorWithHexString:@"#ef6562"];
                        [contentbackView addSubview:alreadyname];
                        
                        UILabel *nevername =[[UILabel alloc] initWithFrame:CGRectMake(15, alreadyname.frame.origin.y+alreadyname.frame.size.height+11, 150, 15)];
                        nevername.font =[UIFont systemFontOfSize:15];
                        nevername.tag =116;
                        nevername.textColor =[UIColor colorWithHexString:@"#ef6562"];
                        [contentbackView addSubview:nevername];
                    }
                    if (neworder.phaseOrderState ==35&&neworder.makeUpState ==5) {
                        UILabel *alreadyname =[[UILabel alloc] initWithFrame:CGRectMake(15, orderlasttime.frame.origin.y+orderlasttime.frame.size.height+11, 150, 15)];
                        alreadyname.font =[UIFont systemFontOfSize:15];
                        alreadyname.tag =116;
                        alreadyname.textColor =[UIColor colorWithHexString:@"#ef6562"];
                        [contentbackView addSubview:alreadyname];
                    }
                    
                    UIButton *firstBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    firstBtn.tag =112;
                    firstBtn.frame =CGRectMake(68*kMainScreenWidth/375, contentbackView.frame.size.height-45, 79*kMainScreenWidth/375, 30);
                    [firstBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                    [firstBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                    firstBtn.titleLabel.font =[UIFont systemFontOfSize:15];
                    firstBtn.hidden =YES;
                    [contentbackView addSubview:firstBtn];
                    
                    UIButton *secondBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    secondBtn.tag =113;
                    secondBtn.frame =CGRectMake(161*kMainScreenWidth/375, contentbackView.frame.size.height-45, 79*kMainScreenWidth/375, 30);
                    [secondBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                    [secondBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                    secondBtn.titleLabel.font =[UIFont systemFontOfSize:15];
                    secondBtn.hidden =YES;
                    [contentbackView addSubview:secondBtn];
                    
                    UIButton *thirdBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    thirdBtn.tag =114;
                    thirdBtn.frame =CGRectMake(255*kMainScreenWidth/375, contentbackView.frame.size.height-45, 79*kMainScreenWidth/375, 30);
                    [thirdBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                    [thirdBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                    thirdBtn.titleLabel.font =[UIFont systemFontOfSize:15];
                    thirdBtn.hidden =YES;
                    [contentbackView addSubview:thirdBtn];
//                    cell.backgroundColor =[UIColor blueColor];
                    
                }
            }
            
        }else{
            NewOrderObject *neworder;
            if (newcontract.phaseOrders.count-1>=indexPath.row) {
                neworder =[newcontract.phaseOrders objectAtIndex:indexPath.row];
            }
            UIView *contentbackView =[[UIView alloc] initWithFrame:CGRectMake(15, 10, kMainScreenWidth-30, 170)];
            if (neworder.phaseOrderState ==36) {
                contentbackView.frame = CGRectMake(15, 10, kMainScreenWidth-30, 210);
            }
            if (neworder.phaseOrderState ==35&&neworder.makeUpState ==5) {
                contentbackView.frame = CGRectMake(15, 10, kMainScreenWidth-30, 190);
            }
            contentbackView.backgroundColor =[UIColor whiteColor];
            contentbackView.layer.masksToBounds = YES;
            contentbackView.layer.cornerRadius = 10;
            contentbackView.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
            contentbackView.layer.borderWidth = 1;
            contentbackView.tag =1005;
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrderAction:)];
            [contentbackView addGestureRecognizer:tap];
            [cell addSubview:contentbackView];
            
            UILabel *ordername =[[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 15)];
            ordername.font =[UIFont systemFontOfSize:15];
            ordername.tag =100;
            ordername.textColor =[UIColor colorWithHexString:@"#575757"];
            [contentbackView addSubview:ordername];
            
            UILabel *orderstate =[[UILabel alloc] initWithFrame:CGRectMake(contentbackView.frame.size.width-93, 10, 80, 15)];
            orderstate.font =[UIFont systemFontOfSize:15];
            orderstate.tag =102;
            orderstate.textAlignment =NSTextAlignmentRight;
            orderstate.textColor =[UIColor colorWithHexString:@"#ef6562"];
            [contentbackView addSubview:orderstate];
            
            UIImageView *contenttopline =[[UIImageView alloc] initWithFrame:CGRectMake(15, ordername.frame.origin.y+ordername.frame.size.height+8, contentbackView.frame.size.width-30, 1)];
            contenttopline.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
            [contentbackView addSubview:contenttopline];
            
            UILabel *orderCode =[[UILabel alloc] initWithFrame:CGRectMake(15, contenttopline.frame.size.height+contenttopline.frame.origin.y+11, kMainScreenWidth-60, 15)];
            orderCode.font =[UIFont systemFontOfSize:15];
            orderCode.tag =103;
            orderCode.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            [contentbackView addSubview:orderCode];
            
            UILabel *orderfee =[[UILabel alloc] initWithFrame:CGRectMake(15, orderCode.frame.size.height+orderCode.frame.origin.y+11, kMainScreenWidth-30, 15)];
            orderfee.font =[UIFont systemFontOfSize:15];
            orderfee.tag =104;
            orderfee.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            [contentbackView addSubview:orderfee];
            
            UILabel *realpay;
            if ([neworder.originalOrderFee doubleValue]!=[neworder.phaseOrderFee doubleValue]) {
                realpay =[[UILabel alloc] initWithFrame:CGRectMake(15, orderfee.frame.size.height+orderfee.frame.origin.y+11, kMainScreenWidth-30, 15)];
                realpay.font =[UIFont systemFontOfSize:15];
                realpay.tag =120;
                realpay.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                [contentbackView addSubview:realpay];
                contentbackView.frame =CGRectMake(contentbackView.frame.origin.x, contentbackView.frame.origin.y, contentbackView.frame.size.width, contentbackView.frame.size.height+26);
            }
            
            UILabel *orderlasttime =[[UILabel alloc] initWithFrame:CGRectMake(15, orderfee.frame.size.height+orderfee.frame.origin.y+11, kMainScreenWidth-30, 15)];
            if ([neworder.originalOrderFee doubleValue]!=[neworder.phaseOrderFee doubleValue]) {
                orderlasttime.frame =CGRectMake(15, realpay.frame.size.height+realpay.frame.origin.y+11,kMainScreenWidth-30, 15);
            }
            orderlasttime.font =[UIFont systemFontOfSize:15];
            orderlasttime.tag =105;
            orderlasttime.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            [contentbackView addSubview:orderlasttime];
            if (neworder.phaseOrderState ==36) {
                UILabel *alreadyname =[[UILabel alloc] initWithFrame:CGRectMake(15, orderlasttime.frame.origin.y+orderlasttime.frame.size.height+11, 150, 15)];
                alreadyname.font =[UIFont systemFontOfSize:15];
                alreadyname.tag =115;
                alreadyname.textColor =[UIColor colorWithHexString:@"#ef6562"];
                [contentbackView addSubview:alreadyname];
                
                UILabel *nevername =[[UILabel alloc] initWithFrame:CGRectMake(15, alreadyname.frame.origin.y+alreadyname.frame.size.height+11, 150, 15)];
                nevername.font =[UIFont systemFontOfSize:15];
                nevername.tag =116;
                nevername.textColor =[UIColor colorWithHexString:@"#ef6562"];
                [contentbackView addSubview:nevername];
            }
            if (neworder.phaseOrderState ==35&&neworder.makeUpState ==5) {
                UILabel *alreadyname =[[UILabel alloc] initWithFrame:CGRectMake(15, orderlasttime.frame.origin.y+orderlasttime.frame.size.height+11, 150, 15)];
                alreadyname.font =[UIFont systemFontOfSize:15];
                alreadyname.tag =116;
                alreadyname.textColor =[UIColor colorWithHexString:@"#ef6562"];
                [contentbackView addSubview:alreadyname];
            }
            UIButton *firstBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            firstBtn.tag =112;
            firstBtn.frame =CGRectMake(68*kMainScreenWidth/375, contentbackView.frame.size.height-45, 79*kMainScreenWidth/375, 30);
            [firstBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
            [firstBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
            firstBtn.titleLabel.font =[UIFont systemFontOfSize:15];
            firstBtn.hidden =YES;
            [contentbackView addSubview:firstBtn];
            
            UIButton *secondBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            secondBtn.tag =113;
            [secondBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
            [secondBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
            secondBtn.frame =CGRectMake(161*kMainScreenWidth/375, contentbackView.frame.size.height-45, 79*kMainScreenWidth/375, 30);
            secondBtn.titleLabel.font =[UIFont systemFontOfSize:15];
            secondBtn.hidden =YES;
            [contentbackView addSubview:secondBtn];
            
            UIButton *thirdBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            thirdBtn.tag =114;
            [thirdBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
            [thirdBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
            thirdBtn.titleLabel.font =[UIFont systemFontOfSize:15];
            thirdBtn.frame =CGRectMake(255*kMainScreenWidth/375, contentbackView.frame.size.height-45, 79*kMainScreenWidth/375, 30);
            thirdBtn.hidden =YES;
            [contentbackView addSubview:thirdBtn];
//            cell.backgroundColor =[UIColor greenColor];
        }
    
    if (newcontract.orderState==1||newcontract.orderState==3) {
        UIButton *firstBtn = (UIButton *)[cell viewWithTag:114];
        firstBtn.layer.masksToBounds = YES;
        firstBtn.layer.cornerRadius = 3;
        firstBtn.layer.borderColor = kThemeColor.CGColor;
        firstBtn.layer.borderWidth = 1;
        firstBtn.hidden = YES;
        if (newcontract.orderState == 1) {
            firstBtn.hidden = NO;
            [firstBtn setTitle:@"确认合同" forState:UIControlStateNormal];
            [firstBtn addTarget:self action:@selector(requestConfirmOrder:) forControlEvents:UIControlEventTouchUpInside];
        }
        UIButton *secondBtn = (UIButton *)[cell viewWithTag:113];
        secondBtn.layer.masksToBounds = YES;
        secondBtn.layer.cornerRadius = 3;
        secondBtn.layer.borderColor = kThemeColor.CGColor;
        secondBtn.layer.borderWidth = 1;
        
        secondBtn.hidden = YES;
        if (newcontract.orderState == 1) {
            secondBtn.hidden = NO;
            [secondBtn setTitle:@"取消合同" forState:UIControlStateNormal];
            [secondBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        }
        UIButton *thirdBtn = (UIButton *)[cell viewWithTag:112];
        thirdBtn.layer.masksToBounds = YES;
        thirdBtn.layer.cornerRadius = 3;
        thirdBtn.layer.borderColor = kThemeColor.CGColor;
        thirdBtn.layer.borderWidth = 1;
        thirdBtn.hidden = YES;
    }else{
        NewOrderObject *neworder =[newcontract.phaseOrders objectAtIndex:0];
        NewOrderObject *secondorder =[[NewOrderObject alloc] init];
        if (newcontract.phaseOrders.count>2) {
            secondorder =[newcontract.phaseOrders objectAtIndex:1];
        }
        if (neworder.phaseOrderState==33&&secondorder.phaseOrderState==2) {
            self.ismerge =1;
        }else{
            self.ismerge =0;
        }
        NewOrderObject *orderObject;
        if (newcontract.phaseOrders.count-1>=indexPath.row+self.ismerge) {
            orderObject =[newcontract.phaseOrders objectAtIndex:indexPath.row+self.ismerge];
        }
        UIButton *firstBtn = (UIButton *)[cell viewWithTag:114];
        firstBtn.layer.masksToBounds = YES;
        firstBtn.layer.cornerRadius = 3;
        firstBtn.layer.borderColor = kThemeColor.CGColor;
        firstBtn.layer.borderWidth = 1;
        firstBtn.hidden = YES;
        
        //配置按钮左
        if (orderObject.phaseOrderState == 1) {
            firstBtn.hidden = NO;
            [firstBtn setTitle:@"确认订单" forState:UIControlStateNormal];
            [firstBtn addTarget:self action:@selector(requestConfirmOrder:) forControlEvents:UIControlEventTouchUpInside];
        } else if ( orderObject.phaseOrderState == 3  || orderObject.phaseOrderState == 8 ||  orderObject.phaseOrderState == 12 || orderObject.phaseOrderState == 14 || orderObject.phaseOrderState == 16 || orderObject.phaseOrderState == 23) {
            firstBtn.hidden =YES;
        } else if (orderObject.phaseOrderState == 7) {
            
//            }else{
                firstBtn.hidden = NO;
                [firstBtn setTitle:@"确认付款" forState:UIControlStateNormal];
                [firstBtn addTarget:self action:@selector(requestConfirmOrderOrConfirmPaying:) forControlEvents:UIControlEventTouchUpInside];
//            }
            
        } else if (orderObject.phaseOrderState == 17) {
            if (![[orderObject.phaseOrderCode substringToIndex:1] isEqualToString:@"G"]) {
                firstBtn.hidden = NO;
                [firstBtn setTitle:@"申请售后" forState:UIControlStateNormal];
                [firstBtn addTarget:self action:@selector(gotoAfterSaleVC:) forControlEvents:UIControlEventTouchUpInside];
            }
            
//            firstBtn.hidden = NO;
//            [firstBtn setTitle:@"评论" forState:UIControlStateNormal];
//            [firstBtn addTarget:self action:@selector(myappraise:) forControlEvents:UIControlEventTouchUpInside];
        }else if (orderObject.phaseOrderState == 2){
            firstBtn.hidden = NO;
            [firstBtn setTitle:@"立即托管" forState:UIControlStateNormal];
            [firstBtn addTarget:self action:@selector(gotoPayingConfirmPage:) forControlEvents:UIControlEventTouchUpInside];
        }else if (orderObject.phaseOrderState ==10){
//            firstBtn.hidden = NO;
//            [firstBtn setTitle:@"服务评审" forState:UIControlStateNormal];
//            [firstBtn addTarget:self action:@selector(gotoServiceReview:) forControlEvents:UIControlEventTouchUpInside];
        }else if (orderObject.phaseOrderState == 17) {
            firstBtn.hidden = NO;
            [firstBtn setTitle:@"申请售后" forState:UIControlStateNormal];
            [firstBtn addTarget:self action:@selector(gotoAfterSaleVC:) forControlEvents:UIControlEventTouchUpInside];
        }else if (orderObject.phaseOrderState ==33||orderObject.phaseOrderState==36){
            firstBtn.hidden = NO;
            [firstBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            [firstBtn addTarget:self action:@selector(gotoPayingConfirmPage:) forControlEvents:UIControlEventTouchUpInside];
        }else if (orderObject.phaseOrderState ==35){
            if (orderObject.makeUpState ==5) {
                firstBtn.hidden = NO;
                [firstBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                [firstBtn addTarget:self action:@selector(gotoPayingConfirmPage:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                firstBtn.hidden = NO;
                [firstBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                [firstBtn addTarget:self action:@selector(requestConfirmOrderOrConfirmPaying:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }else if (orderObject.phaseOrderState == 4|| orderObject.phaseOrderState == 6||orderObject.phaseOrderState == 9){
            firstBtn.hidden = NO;
            [firstBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            [firstBtn addTarget:self action:@selector(gotoRefundVC:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIButton *secondBtn = (UIButton *)[cell viewWithTag:113];
        secondBtn.layer.masksToBounds = YES;
        secondBtn.layer.cornerRadius = 3;
        secondBtn.layer.borderColor = kThemeColor.CGColor;
        secondBtn.layer.borderWidth = 1;
        
        secondBtn.hidden = YES;
        
        //配置按钮右
        if (orderObject.phaseOrderState == 1) {
//            secondBtn.hidden = NO;
//            [secondBtn setTitle:@"取消订单" forState:UIControlStateNormal];
//            [secondBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        } else if ( orderObject.phaseOrderState == 16) {
            secondBtn.hidden = NO;
            [secondBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            [secondBtn addTarget:self action:@selector(gotoRefundVC:) forControlEvents:UIControlEventTouchUpInside];
        } else if (orderObject.phaseOrderState == 7||orderObject.phaseOrderState == 35) {
            secondBtn.hidden = NO;
            [secondBtn setTitle:@"拒绝付款" forState:UIControlStateNormal];
            if (orderObject.phaseOrderState==35) {
                [secondBtn setTitle:@"拒绝支付" forState:UIControlStateNormal];
            }
            [secondBtn addTarget:self action:@selector(requestRefusePaying:) forControlEvents:UIControlEventTouchUpInside];
            if (orderObject.makeUpState ==3) {
                [secondBtn removeTarget:self action:@selector(requestRefusePaying:) forControlEvents:UIControlEventTouchUpInside];
                [secondBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                [secondBtn addTarget:self action:@selector(gotoRefundVC:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            if (orderObject.makeUpState ==5) {
                secondBtn.hidden =YES;
            }
        } else if (orderObject.phaseOrderState == 3 || orderObject.phaseOrderState == 8 || orderObject.phaseOrderState == 23) {
            secondBtn.hidden = YES;
        } else if (orderObject.phaseOrderState == 12 || orderObject.phaseOrderState == 14) {
//            secondBtn.hidden = NO;
//            [secondBtn setTitle:@"取消退款" forState:UIControlStateNormal];
//            [secondBtn addTarget:self action:@selector(requestCancelRefund:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIButton *thirdBtn = (UIButton *)[cell viewWithTag:112];
        thirdBtn.layer.masksToBounds = YES;
        thirdBtn.layer.cornerRadius = 3;
        thirdBtn.layer.borderColor = kThemeColor.CGColor;
        thirdBtn.layer.borderWidth = 1;
        thirdBtn.hidden = YES;
        
        //配置按钮三
        if (orderObject.phaseOrderState == 7||orderObject.phaseOrderState == 35) {
            thirdBtn.hidden = NO;
            [thirdBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            [thirdBtn addTarget:self action:@selector(gotoRefundVC:) forControlEvents:UIControlEventTouchUpInside];
            if (orderObject.makeUpState ==3||orderObject.makeUpState==5) {
                thirdBtn.hidden = YES;
            }
        }
        if (firstBtn.hidden ==YES&&secondBtn.hidden ==YES&&thirdBtn.hidden ==YES) {
            UIView *contentbackView =[cell viewWithTag:1005];
            contentbackView.frame =CGRectMake(contentbackView.frame.origin.x, contentbackView.frame.origin.y, contentbackView.frame.size.width, contentbackView.frame.size.height-30);
        }
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        UIImageView *headimage =(UIImageView *)[cell viewWithTag:999];
        [headimage sd_setImageWithURL:[NSURL URLWithString:newcontract.userLogo] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk.png"]];
        UIButton *commentbtn =(UIButton *)[cell viewWithTag:998];
        if (newcontract.orderState ==4) {
            commentbtn.hidden =NO;
        }
        NewOrderObject *orderObject =[[NewOrderObject alloc] init];
        if (newcontract.orderState ==1||newcontract.orderState==3) {
            UILabel *orderstate =[cell viewWithTag:102];
            orderstate.text =newcontract.orderStateName;
        }else{
            orderObject =[newcontract.phaseOrders objectAtIndex:indexPath.row];
        }
        UILabel *servanName =(UILabel *)[cell viewWithTag:1000];
        servanName.text =newcontract.nickName;
        UILabel *contractCode =(UILabel *)[cell viewWithTag:1001];
        contractCode.text =[NSString stringWithFormat:@"合同编号：%@",newcontract.orderCode];
        UILabel *contractType =(UILabel *)[cell viewWithTag:1002];
        switch (newcontract.orderType) {
            case 1:
                contractType.text =@"合同类型：设计服务";
                break;
            case 2:
                contractType.text =@"合同类型：购买产品";
                break;
            case 3:
                contractType.text =@"合同类型：小工服务";
                break;
            case 4:
                contractType.text =@"合同类型：施工服务";
                break;
            case 6:
                contractType.text =@"合同类型：监理服务";
                break;
            default:
                break;
        }
        UILabel *contractFee =(UILabel *)[cell viewWithTag:1004];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合同金额：¥ %.2f",[newcontract.orderFee doubleValue]]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,5)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str.length-5)];
        contractFee.attributedText = str;
        if (newcontract.isChangeAttchment ==1) {
            UIImageView *exclamationimg =[cell viewWithTag:1007];
            exclamationimg.hidden =NO;
            UILabel *ischangeAttchment =[cell viewWithTag:1006];
            ischangeAttchment.text =@"合同附件已变更，请进入查看";
        }else{
            UIImageView *exclamationimg =[cell viewWithTag:1007];
            exclamationimg.hidden =YES;
        }
        if (newcontract.orderState ==1||newcontract.orderState==3) {
            return cell;
        }else{
            if (newcontract.orderType ==4){
                UIView *contentbackView =[cell viewWithTag:1005];
                UILabel *ordername =[contentbackView viewWithTag:100];
                ordername.text =orderObject.phaseOrderName;
                
                UILabel *orderstate =[contentbackView viewWithTag:102];
                orderstate.text =orderObject.phaseOrderStateName;
                
                UILabel *orderCode =[contentbackView viewWithTag:103];
                orderCode.text =[NSString stringWithFormat:@"订单编号：%@",orderObject.phaseOrderCode];
                
                UILabel *orderfee =[contentbackView viewWithTag:104];
                NSMutableAttributedString *str;
                if ([orderObject.makeUpFee doubleValue]!=0) {
                    str =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"结算金额：¥ %.2f",[orderObject.originalOrderFee doubleValue]+[orderObject.makeUpFee doubleValue]]];
                    
                }else{
                    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单金额：¥ %.2f",[orderObject.originalOrderFee doubleValue]]];
                }
                
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,5)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str.length-5)];
                orderfee.attributedText =str;
                
                UILabel *realpay =[contentbackView viewWithTag:120];
                if (realpay) {
                    if ([orderObject.makeUpFee doubleValue]!=0) {
                        str =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付金额：¥ %.2f",[orderObject.phaseOrderFee doubleValue]+[orderObject.makeUpFee doubleValue]]];
                        
                    }else{
                        str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付金额：¥ %.2f",[orderObject.phaseOrderFee doubleValue]]];
                    }
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,5)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str.length-5)];
                    realpay.attributedText =str;
                    orderfee.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                }
                
                UILabel *orderlasttime =[contentbackView viewWithTag:105];
                NSDate *orderdate = [NSDate dateWithTimeIntervalSince1970:[orderObject.phaseOrderLastDate doubleValue]/1000];
                NSDateFormatter *df = [[NSDateFormatter alloc] init ];
                df.dateFormat = @"yyyy.MM.dd  HH:mm";
                NSString *dateStr = [df stringFromDate:orderdate];
                orderlasttime.text =[NSString stringWithFormat:@"更新时间:  %@",dateStr];
                NewOrderObject *secondorderObject  =[[NewOrderObject alloc] init];
                if (indexPath.row+1<newcontract.phaseOrders.count) {
                    secondorderObject =[newcontract.phaseOrders objectAtIndex:indexPath.row+1];
                }

                if (orderObject.phaseOrderState==33&&secondorderObject.phaseOrderState==2) {
                    
                }else{
                    if (orderObject.phaseOrderState ==36) {
                        UILabel *alreadyname =[contentbackView viewWithTag:115];
                        alreadyname.text =[NSString stringWithFormat:@"已  支  付:  ¥ %.2f",[orderObject.phaseOrderFee doubleValue]-[orderObject.waitePayment doubleValue]];
                        
                        UILabel *nevername =[contentbackView viewWithTag:116];
                        nevername.text =[NSString stringWithFormat:@"待  支  付:  ¥ %.2f",[orderObject.waitePayment doubleValue]];
                    }
                    if (orderObject.phaseOrderState ==35&&orderObject.makeUpState==5) {
                        UILabel *nevername =[contentbackView viewWithTag:116];
                        nevername.text =[NSString stringWithFormat:@"待  支  付:  ¥ %.2f",[orderObject.waitePayment doubleValue]+[orderObject.mkWaitePayment doubleValue]];
                    }
                    return cell;
                }
                self.ismerge =1;
//                self.oldsection =indexPath.section;
                UILabel *ordersecondname =[contentbackView viewWithTag:106];
                ordersecondname.text =secondorderObject.phaseOrderName;
                
                UILabel *ordersecondstate =[contentbackView viewWithTag:107];
                ordersecondstate.text =secondorderObject.phaseOrderStateName;
                
                UILabel *ordersecondCode =[contentbackView viewWithTag:108];
                ordersecondCode.text =[NSString stringWithFormat:@"订单编号：%@",secondorderObject.phaseOrderCode];
                
                UILabel *ordersecondfee =[contentbackView viewWithTag:109];
                NSMutableAttributedString *str1;
                if ([orderObject.makeUpFee doubleValue]!=0) {
                    str1 =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"结算金额：¥ %.2f",[secondorderObject.originalOrderFee doubleValue]+[secondorderObject.makeUpFee doubleValue]]];
                }else{
                    str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单金额：¥ %.2f",[secondorderObject.originalOrderFee doubleValue]]];
                }
//                NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单金额：¥%@",secondorderObject.phaseOrderFee]];
                [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,5)];
                [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str1.length-5)];
                ordersecondfee.attributedText =str1;
                
                UILabel *secondrealpay =[contentbackView viewWithTag:121];
                if (secondrealpay) {
                    if ([orderObject.makeUpFee doubleValue]!=0) {
                        str1 =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付金额：¥ %.2f",[secondorderObject.phaseOrderFee doubleValue]+[secondorderObject.makeUpFee doubleValue]]];
                    }else{
                        str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付金额：¥ %.2f",[secondorderObject.phaseOrderFee doubleValue]]];
                    }
                    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,5)];
                    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str1.length-5)];
                    secondrealpay.attributedText =str1;
                    ordersecondfee.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                }
                
                UILabel *ordersecondlasttime =[contentbackView viewWithTag:110];
                NSDate *orderdate1 = [NSDate dateWithTimeIntervalSince1970:[secondorderObject.phaseOrderLastDate doubleValue]/1000];
                NSDateFormatter *df1 = [[NSDateFormatter alloc] init ];
                df1.dateFormat = @"yyyy.MM.dd HH:mm";
                NSString *dateStr1 = [df1 stringFromDate:orderdate1];
                ordersecondlasttime.text =[NSString stringWithFormat:@"更新时间:  %@",dateStr1];
                
                UILabel *totalFee =[contentbackView viewWithTag:111];
                double totalFeecount =[secondorderObject.originalOrderFee doubleValue]+[orderObject.originalOrderFee doubleValue];
                NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计金额：¥ %.2f",totalFeecount]];
                [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,5)];
                [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str2.length-5)];
                totalFee.attributedText =str2;
                
                UILabel *totalFeeRealPay =[contentbackView viewWithTag:122];
                if (totalFeeRealPay) {
                    totalFeecount =[secondorderObject.phaseOrderFee doubleValue]+[orderObject.phaseOrderFee doubleValue];
                    str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付金额：¥ %.2f",totalFeecount]];
                    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,5)];
                    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str2.length-5)];
                    totalFeeRealPay.attributedText =str2;
                    totalFee.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                }
            }else{
                NewOrderObject *orderObject =[newcontract.phaseOrders objectAtIndex:indexPath.row+self.ismerge];
                UIView *contentbackView =[cell viewWithTag:1005];
                UILabel *ordername =[contentbackView viewWithTag:100];
                ordername.text =orderObject.phaseOrderName;
                
                UILabel *orderstate =[contentbackView viewWithTag:102];
                orderstate.text =orderObject.phaseOrderStateName;
                
                UILabel *orderCode =[contentbackView viewWithTag:103];
                orderCode.text =[NSString stringWithFormat:@"订单编号：%@",orderObject.phaseOrderCode];
                
                UILabel *orderfee =[contentbackView viewWithTag:104];
                 NSMutableAttributedString *str;
                if ([orderObject.makeUpFee doubleValue]!=0) {
                    str =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"结算金额：¥ %.2f",[orderObject.phaseOrderFee doubleValue]+[orderObject.makeUpFee doubleValue]]];
                }else{
                    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单金额：¥ %.2f",[orderObject.originalOrderFee doubleValue]]];
                }
                
                
//                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单金额：¥%@",orderObject.phaseOrderFee]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,5)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str.length-5)];
                orderfee.attributedText =str;
                
                UILabel *realpay =[contentbackView viewWithTag:120];
                if (realpay) {
                    if ([orderObject.makeUpFee doubleValue]!=0) {
                        str =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付金额：¥ %.2f",[orderObject.phaseOrderFee doubleValue]+[orderObject.makeUpFee doubleValue]]];
                        
                    }else{
                        str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付金额：¥ %.2f",[orderObject.phaseOrderFee doubleValue]]];
                    }
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,5)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str.length-5)];
                    realpay.attributedText =str;
                    orderfee.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                }
                
                UILabel *orderlasttime =[contentbackView viewWithTag:105];
                NSDate *orderdate = [NSDate dateWithTimeIntervalSince1970:[orderObject.phaseOrderLastDate doubleValue]/1000];
                NSDateFormatter *df = [[NSDateFormatter alloc] init ];
                df.dateFormat = @"yyyy.MM.dd HH:mm";
                NSString *dateStr = [df stringFromDate:orderdate];
                orderlasttime.text =[NSString stringWithFormat:@"更新时间： %@",dateStr];
                if (orderObject.phaseOrderState ==36) {
                    UILabel *alreadyname =[contentbackView viewWithTag:115];
                    alreadyname.text =[NSString stringWithFormat:@"已  支  付:  ¥ %.2f",[orderObject.phaseOrderFee doubleValue]-[orderObject.waitePayment doubleValue]];
                    
                    UILabel *nevername =[contentbackView viewWithTag:116];
                    nevername.text =[NSString stringWithFormat:@"待  支  付:  ¥ %.2f",[orderObject.waitePayment doubleValue]];
                }
                if (orderObject.phaseOrderState ==35&&orderObject.makeUpState==5) {
                    UILabel *nevername =[contentbackView viewWithTag:116];
                    nevername.text =[NSString stringWithFormat:@"待  支  付:  ¥ %.2f",[orderObject.waitePayment doubleValue]+[orderObject.mkWaitePayment doubleValue]];
                }
            }
        }
    }else{
        NewOrderObject *orderObject;
        if (newcontract.phaseOrders.count-1>=indexPath.row+self.ismerge) {
            orderObject =[newcontract.phaseOrders objectAtIndex:indexPath.row+self.ismerge];
        }
        UIView *contentbackView =[cell viewWithTag:1005];
        UILabel *ordername =[contentbackView viewWithTag:100];
        ordername.text =orderObject.phaseOrderName;
        
        UILabel *orderstate =[contentbackView viewWithTag:102];
        orderstate.text =orderObject.phaseOrderStateName;
        
        UILabel *orderCode =[contentbackView viewWithTag:103];
        orderCode.text =[NSString stringWithFormat:@"订单编号：%@",orderObject.phaseOrderCode];
        
        UILabel *orderfee =[contentbackView viewWithTag:104];
        NSMutableAttributedString *str;
        if ([orderObject.makeUpFee doubleValue]!=0) {
            str =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"结算金额：¥ %.2f",[orderObject.originalOrderFee doubleValue]+[orderObject.makeUpFee doubleValue]]];
        }else{
            str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单金额：¥ %.2f",[orderObject.originalOrderFee doubleValue]]];
        }
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单金额：¥%@",orderObject.phaseOrderFee]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,5)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str.length-5)];
        orderfee.attributedText =str;
        
        UILabel *realpay =[contentbackView viewWithTag:120];
        if (realpay) {
            if ([orderObject.makeUpFee doubleValue]!=0) {
                str =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付金额：¥ %.2f",[orderObject.phaseOrderFee doubleValue]+[orderObject.makeUpFee doubleValue]]];
                
            }else{
                str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付金额：¥ %.2f",[orderObject.phaseOrderFee doubleValue]]];
            }
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,5)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str.length-5)];
            realpay.attributedText =str;
            orderfee.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
        }
        
        UILabel *orderlasttime =[contentbackView viewWithTag:105];
        NSDate *orderdate = [NSDate dateWithTimeIntervalSince1970:[orderObject.phaseOrderLastDate doubleValue]/1000];
        NSDateFormatter *df = [[NSDateFormatter alloc] init ];
        df.dateFormat = @"yyyy.MM.dd   HH:mm";
        NSString *dateStr = [df stringFromDate:orderdate];
        orderlasttime.text =[NSString stringWithFormat:@"更新时间:  %@",dateStr];
        if (orderObject.phaseOrderState ==36) {
            UILabel *alreadyname =[contentbackView viewWithTag:115];
            alreadyname.text =[NSString stringWithFormat:@"已  支  付:  ¥ %.2f",[orderObject.phaseOrderFee doubleValue]-[orderObject.waitePayment doubleValue]];
            
            UILabel *nevername =[contentbackView viewWithTag:116];
            nevername.text =[NSString stringWithFormat:@"待  支  付:  ¥ %.2f",[orderObject.waitePayment doubleValue]];
        }
        if (orderObject.phaseOrderState ==35&&orderObject.makeUpState==5) {
            UILabel *nevername =[contentbackView viewWithTag:116];
            nevername.text =[NSString stringWithFormat:@"待  支  付:  ¥ %.2f",[orderObject.waitePayment doubleValue]+[orderObject.mkWaitePayment doubleValue]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
        NewContractObject *contraObject =[self.dataArray objectAtIndex:indexPath.section];
        IDIAI3ContractDetailViewController *contract =[[IDIAI3ContractDetailViewController alloc] init];
        contract.title =@"合同详情";
        contract.orderCode =contraObject.orderCode;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.isRefresh =NO;
        [delegate.nav pushViewController:contract animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
//    [self.navigationController pushViewController:contract animated:YES];
}
#pragma mark - 取消退款
-(void)requestCancelRefund:(UIButton *)sender {
    [self startRequestWithString:@"加载中..."];
    UITableViewCell *cell = (UITableViewCell *)[[sender superview]superview];
    UIView *contentbackView =[cell viewWithTag:1005];
    UILabel *orderCode =[contentbackView viewWithTag:103];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSString *string_token;
        NSString *string_userid;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        else{
            string_token=@"";
            string_userid=@"";
        }
        
        
        NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
        [headerDict setObject:@"ID0316" forKey:@"cmdID"];
        [headerDict setObject:string_token forKey:@"token"];
        [headerDict setObject:string_userid forKey:@"userID"];
        [headerDict setObject:@"ios" forKey:@"deviceType"];
        [headerDict setObject:kCityCode forKey:@"cityCode"];
        NSString *string=[headerDict JSONString];
        
        NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
        [bodyDict setObject:[orderCode.text substringFromIndex:5] forKey:@"phaseOrderCode"];
        NSString *string02=[bodyDict JSONString];
        
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:string forKey:@"header"];
        [post setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setTimeOutSeconds:15];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"取消退款返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 103161) {
                        [self stopRequest];
//                        [self requestRefundDetail];
//                        if([self.delegate respondsToSelector:@selector(stateBtnDidClick:)])
//                            [self.delegate stateBtnDidClick:nil];
                        [TLToast showWithText:@"取消退款成功"];
                    } else if (kResCode == 103169) {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"取消退款失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"取消退款失败"];
                    }
                    else{
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"取消退款失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"取消退款失败"];
                    }
                    
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                  customPromp.contenttxt =@"操作失败";
                                  UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                  [customPromp addGestureRecognizer:tap];
                                  [customPromp show];
//                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:post];
    });
    
}

#pragma mark - 申请退款
- (void)gotoRefundVC:(id)sender {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
        UITableViewCell *cell = (UITableViewCell *)[[sender superview]superview];
        NSIndexPath *path =[self.mtableview indexPathForCell:cell];
        UIView *contentbackView =[cell viewWithTag:1005];
        UILabel *orderCode =[contentbackView viewWithTag:103];
        UILabel *realpay =[contentbackView viewWithTag:120];
        NewContractObject *newcontract =[self.dataArray objectAtIndex:path.section];
        NewOrderObject *neworder =[newcontract.phaseOrders objectAtIndex:path.row];
        
        RefundViewController *refundVC = [[RefundViewController alloc]initWithNibName:@"RefundViewController" bundle:nil];
        refundVC.orderIDStr = [orderCode.text substringFromIndex:5];
        if (neworder.makeUpState==3) {
            refundVC.moneyFloat = [neworder.phaseOrderFee integerValue] +[neworder.makeUpFee integerValue];
        }else{
            refundVC.moneyFloat =[neworder.phaseOrderFee floatValue];
        }
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.isRefresh =NO;
        [delegate.nav pushViewController:refundVC animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
    
}
- (void)gotoAfterSaleVC:(id)sender {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]) {
        UITableViewCell *cell = (UITableViewCell *)[[sender superview]superview];
        UIView *contentbackView =[cell viewWithTag:1005];
        UILabel *orderCode =[contentbackView viewWithTag:103];
        //    MyOrderModel *myOrderModel = [dataArray objectAtIndex:indexPath.row];
        
        AfterSaleViewController *afterSaleVC = [[AfterSaleViewController alloc]initWithNibName:@"AfterSaleViewController" bundle:nil];
        afterSaleVC.orderIDStr = [orderCode.text substringFromIndex:5];
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.isRefresh =NO;
        [delegate.nav pushViewController:afterSaleVC animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
    
}
-(void)cancelOrder:(id)sender{
    UIView *cellView;
    if ([[UIDevice currentDevice].systemVersion floatValue]>8.0) {
        cellView =[sender superview];
    }else{
        cellView =[[sender superview] superview];
    }
    if ([cellView isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)cellView;
        NSIndexPath *indexPath = [self.mtableview indexPathForCell:cell];
        NewContractObject *contract = [self.dataArray objectAtIndex:indexPath.section];
        if (contract.orderState ==1) {
            [self startRequestWithString:@"加载中..."];
            dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(parsingQueue, ^{
                NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
                
                NSString *string_token;
                NSString *string_userid;
                if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
                    string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
                    string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
                }
                else{
                    string_token=@"";
                    string_userid=@"";
                }
                
                
                NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
                [postDict setObject:@"ID0355" forKey:@"cmdID"];
                [postDict setObject:string_token forKey:@"token"];
                [postDict setObject:string_userid forKey:@"userID"];
                [postDict setObject:@"ios" forKey:@"deviceType"];
                [postDict setObject:kCityCode forKey:@"cityCode"];
                
                NSString *string=[postDict JSONString];
                NSDictionary *bodyDic = @{@"orderCode":contract.orderCode,@"actionType":@0};
                NSString *string02=[bodyDic JSONString];
                NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
                [post setObject:string forKey:@"header"];
                [post setObject:string02 forKey:@"body"];
                
                NetworkRequest *req = [[NetworkRequest alloc] init];
                [req setHttpMethod:PostMethod];
                
                [req sendToServerInBackground:^{
                    dispatch_async(parsingQueue, ^{
                        ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                        [request setTimeOutSeconds:15];
                        [request setResponseEncoding:NSUTF8StringEncoding];
                        NSString *respString = [request responseString];
                        NSDictionary *jsonDict = [respString objectFromJSONString];
                        // NSLog(@"login返回信息：%@",jsonDict);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            //token为空或验证未通过处理 huangrun
                            if (kResCode == 10002 || kResCode == 10003) {
                                self.view.tag = 1002;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                                    login.delegate=self;
                                    [login show];
                                    
                                });
                                
                                return;
                            }
                            if (kResCode == 103551) {
                                //                        [self.mtableview launchRefreshing];
                                [self.mtableview launchRefreshing];
                                
                                [TLToast showWithText:@"合同取消成功"];
                               
                            } else if (kResCode == 103559) {
                                customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                customPromp.contenttxt =@"合同取消失败";
                                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                [customPromp addGestureRecognizer:tap];
                                [customPromp show];
                                //                        [TLToast showWithText:@"合同确认失败"];
                            } else if (kResCode == 103552) {
                                customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                customPromp.contenttxt =@"该合同已经被拒绝";
                                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                [customPromp addGestureRecognizer:tap];
                                [customPromp show];
                                //                        [TLToast showWithText:@"该合同已被拒绝"];
                            }else if (kResCode == 103553){
                                customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                customPromp.contenttxt =@"该合同已经被拒绝";
                                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                [customPromp addGestureRecognizer:tap];
                                [customPromp show];
                            }else if (kResCode == 103554){
                                customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                customPromp.contenttxt =@"没有相关的城市阶段配置";
                                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                [customPromp addGestureRecognizer:tap];
                                [customPromp show];
                            }
                            //                            }else if (kResCode == 11305) {
                            //                                [TLToast showWithText:@"支付密码不正确"];
                            //                            }else{
                            //                                [TLToast showWithText:@"订单确认失败"];
                            //                            }
                        });
                    });
                }
                                  failedBlock:^{
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self stopRequest];
                                          customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                          customPromp.contenttxt =@"操作失败";
                                          UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                          [customPromp addGestureRecognizer:tap];
                                          [customPromp show];
//                                          [TLToast showWithText:@"操作失败"];
                                      });
                                  }
                                       method:url postDict:post];
            });
        }
    }
}
- (void)gotoPayingConfirmPage:(id)sender {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
        [savelogObj saveLog:@"立即托管" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:61];
        UITableViewCell *cell;
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0){
            cell = (UITableViewCell *)[[sender superview]superview];
        }else{
            cell = (UITableViewCell *)[[[sender superview]superview] superview];
        }
        NSIndexPath *path =[self.mtableview indexPathForCell:cell];
        NewContractObject *newcontract =[self.dataArray objectAtIndex:path.section];
        NewOrderObject *orderObject;
//        if (newcontract.superviorId==0) {
//            [TLToast showWithText:@"还未分配监理，请分配监理后再操作"];
//            return;
//        }
        if (newcontract.phaseOrders.count-1>=path.row) {
            orderObject =[newcontract.phaseOrders objectAtIndex:path.row];
        }
        NSString *  str=@"";
        BOOL   isSupervisorServiceChargeExist = NO;//监理服务费是否存在
        BOOL    isSupervisorServicePaymentFinished = NO;
        for (int i=0;i<newcontract.phaseOrders.count;i++) {
            NewOrderObject *orderObject = newcontract.phaseOrders[i];
            if ([orderObject.phaseOrderStateName isEqualToString:@"待托管"]||[orderObject.phaseOrderStateName isEqualToString:@"部分支付"]) {
                str=orderObject.phaseOrderName;
                break ;
            }
            if ([orderObject.phaseOrderName isEqualToString:@"监理服务费"]) {
                isSupervisorServiceChargeExist=YES;
                if ([orderObject.phaseOrderStateName isEqualToString:@"已完成"]) {
                    isSupervisorServicePaymentFinished = YES;
                }
            }
        }
        
        NSLog(@"indexPath.row===========%ld",(long)path.row);
        if (path.row!=0) {
            NewOrderObject *  lastOrderObject;
            if (isSupervisorServiceChargeExist==YES&&self.typeInteger!=2&&isSupervisorServicePaymentFinished==NO) {
                lastOrderObject= [newcontract.phaseOrders objectAtIndex:path.row];
            }else{
                lastOrderObject = [newcontract.phaseOrders objectAtIndex:path.row-1];
            }
            
            if ([lastOrderObject.phaseOrderStateName isEqualToString:@"待托管"]||[lastOrderObject.phaseOrderStateName isEqualToString:@"部分支付"]) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[ NSString stringWithFormat:@"请先完成【%@】，按施工步骤进行哦！",str] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil ];
                [alert show];
                NSLog(@"alert===========%@",alert);
                return;
            }
        }
    
        self.selectContract =newcontract;
        UIView *contentbackView =[cell viewWithTag:1005];
        UILabel *ordername =[contentbackView viewWithTag:100];
        UILabel *orderCode =[contentbackView viewWithTag:103];
        UILabel *orderfee =[contentbackView viewWithTag:120];
        if (!orderfee) {
            orderfee =[contentbackView viewWithTag:104];
        }
        UILabel *ordersecondname =[contentbackView viewWithTag:106];
        UILabel *ordersecondCode =[contentbackView viewWithTag:108];
        UILabel *ordersecondfee =[contentbackView viewWithTag:121];
        if (!ordersecondfee) {
            ordersecondfee =[contentbackView viewWithTag:109];
        }
        UILabel *nevername =[contentbackView viewWithTag:116];
        NSString *orderPhraseName =[NSString string];
        if (ordersecondname.text.length>0) {
            orderPhraseName =[NSString stringWithFormat:@"%@+%@",ordername.text,ordersecondname.text];
        }else{
            orderPhraseName =ordername.text;
        }
        if (orderObject.phaseOrderState==35&&orderObject.makeUpState==5) {
            orderPhraseName =@"找补单";
        }
        NSString *orderCodePhase =[NSString string];
        if (ordersecondCode.text.length>0) {
            orderCodePhase =[NSString stringWithFormat:@"%@,%@",[orderCode.text substringFromIndex:5],[ordersecondCode.text substringFromIndex:5]];
        }else{
            orderCodePhase =[orderCode.text substringFromIndex:5];
        }
        if (orderObject.phaseOrderState==35&&orderObject.makeUpState==5) {
            orderCodePhase =orderObject.frOrderCode;
        }
        double orderPhraseFee =[[orderfee.text substringFromIndex:7] doubleValue]+[[ordersecondfee.text substringFromIndex:7] doubleValue];
        if (nevername!=nil) {
            orderPhraseFee =[[nevername.text substringFromIndex:12] doubleValue];
        }
        if (orderPhraseFee==0) {
            dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(parsingQueue, ^{
                
                NSString *string_token;
                NSString *string_userid;
                if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
                    string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
                    string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
                }
                else{
                    string_token=@"";
                    string_userid=@"";
                }
                NSString *url =[NSString string];
                url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0091\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"orderCode\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],orderCodePhase];
                
                NetworkRequest *req = [[NetworkRequest alloc] init];
                req.isCacheRequest=YES;
                [req setHttpMethod:GetMethod];
                
                [req sendToServerInBackground:^{
                    dispatch_async(parsingQueue, ^{
                        ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                        [request setResponseEncoding:NSUTF8StringEncoding];
                        NSString *respString = [request responseString];
                        NSDictionary *jsonDict = [respString objectFromJSONString];
                        NSLog(@"为0支付返回信息：%@",jsonDict);
                        NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                        if (kResCode == 10002 || kResCode == 10003) {
                            [self stopRequest];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                                //                        login.delegate=self;
                                //                        [login show];
                                [self performSelector:@selector(DisPlayLoginView) withObject:nil afterDelay:0.5f];
                            });
                        }
                        if (code==100911) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self stopRequest];
                                [self.mtableview launchRefreshing];
                                [TLToast showWithText:@"托管成功"];
                            });
                        }
                        else if (code==100919) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self stopRequest];
                                [TLToast showWithText:@"托管失败"];
                            });
                        }
                    });
                }
                                  failedBlock:^{
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self stopRequest];
                                          [TLToast showWithText:@"托管失败"];
                                      });
                                  }
                                       method:url postDict:nil];
            });
        }else{
            dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(parsingQueue, ^{
                
                NSString *string_token;
                NSString *string_userid;
                if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
                    string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
                    string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
                }
                else{
                    string_token=@"";
                    string_userid=@"";
                }
                NSString *url =[NSString string];
                url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0273\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"mobile\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],[[NSUserDefaults standardUserDefaults] objectForKey:User_Mobile]];
                
                NetworkRequest *req = [[NetworkRequest alloc] init];
                req.isCacheRequest=YES;
                [req setHttpMethod:GetMethod];
                
                [req sendToServerInBackground:^{
                    dispatch_async(parsingQueue, ^{
                        ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                        [request setResponseEncoding:NSUTF8StringEncoding];
                        NSString *respString = [request responseString];
                        NSDictionary *jsonDict = [respString objectFromJSONString];
                        NSLog(@"日记列表返回信息：%@",jsonDict);
                        NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                        if (kResCode == 10002 || kResCode == 10003) {
                            [self stopRequest];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                                //                        login.delegate=self;
                                //                        [login show];
                                [self performSelector:@selector(DisPlayLoginView) withObject:nil afterDelay:0.5f];
                            });
                        }
                        if (code==102731) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self stopRequest];
                                if ([[jsonDict objectForKey:@"walletAssets"] doubleValue]<=0&&[[jsonDict objectForKey:@"decorationLoanAssets"] doubleValue]<=0) {
                                    OnlinePayViewController *onlinepay =[[OnlinePayViewController alloc] init];
                                    onlinepay.serviceNameStr =orderPhraseName;
                                    onlinepay.remaining =orderPhraseFee;
                                    onlinepay.typeStr =@"";
                                    onlinepay.orderNo =orderCodePhase;
                                    onlinepay.fromStr=@"orderDetailOfGoodsVC";
                                    NSString *amounts =[NSString string];
                                    if (ordersecondfee.text.length>0) {
                                        amounts =[NSString stringWithFormat:@"%@,%@",[orderfee.text substringFromIndex:7],[ordersecondfee.text substringFromIndex:7]];
                                    }else{
                                        amounts =[orderfee.text substringFromIndex:7];
                                    }
                                    if (orderObject.phaseOrderState==35&&orderObject.makeUpState==5) {
                                        amounts =orderObject.makeUpFee;
                                        self.isMakeUp =YES;
                                        self.selectOrder =orderObject;
                                    }else{
                                        self.isMakeUp =NO;
                                    }
                                    onlinepay.amounts =amounts;
                                    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                                    onlinepay.hidesBottomBarWhenPushed =YES;
                                    [delegate.nav pushViewController:onlinepay animated:YES];
                                }else{
                                    PayingConfirmViewController *payingConfirmVC = [[PayingConfirmViewController alloc]init];
                                    payingConfirmVC.serviceNameStr = orderPhraseName;
                                    payingConfirmVC.moneyFloat = orderPhraseFee;
                                    payingConfirmVC.orderNo = orderCodePhase;
                                    NSString *amounts =[NSString string];
                                    self.isRefresh =NO;
                                    if (ordersecondfee.text.length>0) {
                                        amounts =[NSString stringWithFormat:@"%@,%@",[orderfee.text substringFromIndex:7],[ordersecondfee.text substringFromIndex:7]];
                                    }else{
                                        amounts =[orderfee.text substringFromIndex:7];
                                    }
                                    if (orderObject.phaseOrderState==35&&orderObject.makeUpState==5) {
                                        amounts =orderObject.makeUpFee;
                                        self.isMakeUp =YES;
                                        self.selectOrder =orderObject;
                                    }else{
                                        self.isMakeUp =NO;
                                    }
                                    payingConfirmVC.amounts =amounts;
                                    payingConfirmVC.fromStr=@"orderDetailOfGoodsVC";
                                    payingConfirmVC.fromController =@"contract";
                                    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                                    payingConfirmVC.hidesBottomBarWhenPushed =YES;
                                    [delegate.nav pushViewController:payingConfirmVC animated:YES];
                                }
                            });
                        }
                        else if (code==102732) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self stopRequest];
                                [TLToast showWithText:@"获取账户信息失败"];
                            });
                        }
                        else if (code==102729){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self stopRequest];
                                [TLToast showWithText:@"获取账户信息失败"];
                            });
                        }
                    });
                }
                                  failedBlock:^{
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self stopRequest];
                                          [TLToast showWithText:@"获取账户信息失败"];
                                      });
                                  }
                                       method:url postDict:nil];
            });
        }
        
        
        
        
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
    
}
-(void)DisPlayLoginView{
    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
    login.delegate=self;
    [login show];
    return;
}
-(void)requestConfirmOrderOrConfirmPaying:(UIButton *)sender{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
        UITableViewCell *cell;
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
            cell =(UITableViewCell *)sender.superview.superview;
        else
            cell =(UITableViewCell *)sender.superview.superview.superview;
        
        NSIndexPath *indexPath = [self.mtableview indexPathForCell:cell];
        NewContractObject *contract =[self.dataArray objectAtIndex:indexPath.section];
        NewOrderObject *order =[contract.phaseOrders objectAtIndex:indexPath.row];
        self.selectContract =contract;
        if (order.phaseOrderState ==35) {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"您的交易订单金额¥ %.2f，结算款超支请补款：¥ %.2f！［如有疑问请与服务方沟通］",[order.phaseOrderFee floatValue],[order.makeUpFee floatValue]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即补差", nil];
            alert.tag =1000;
            self.selectOrder =order;
            self.isMakeUp =YES;
            [alert show];
            return;
        }else{
            self.selectOrder =order;
            if ([order.makeUpFee floatValue]<0) {
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"您的交易订单金额¥ %.2f，结算有找零¥ %.2f，交易完成后，找零金额会在7～15天退回您的账户！［如有疑问请与服务方沟通］",[order.phaseOrderFee floatValue],-[order.makeUpFee floatValue]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.tag=1001;
                [alert show];
                return;
            }
            
        }
        IDIAI3ConfirmPaymentViewController *confirmPay =[[IDIAI3ConfirmPaymentViewController alloc] init];
        confirmPay.orderType =contract.orderType;
        
        float orderPhraseFee =[order.phaseOrderFee floatValue]+[order.makeUpFee floatValue];
        confirmPay.payforMoney =orderPhraseFee;
        confirmPay.orderCode =order.phaseOrderCode;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        confirmPay.fromStr =@"contract";
        self.isRefresh =NO;
        [delegate.nav pushViewController:confirmPay animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
    
    
}
-(void)requestRefusePaying:(UIButton *)sender{
    UITableViewCell *cell;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        cell =(UITableViewCell *)sender.superview.superview;
    else
        cell =(UITableViewCell *)sender.superview.superview.superview;
    UIView *contentbackView =[cell viewWithTag:1005];
    NSIndexPath *indexPath = [self.mtableview indexPathForCell:cell];
    UILabel *orderCode =[contentbackView viewWithTag:103];
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSString *string_token;
        NSString *string_userid;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        else{
            string_token=@"";
            string_userid=@"";
        }
        
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0326" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"phaseOrderCode":[orderCode.text substringFromIndex:5]};
        NSString *string02=[bodyDic JSONString];
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:string forKey:@"header"];
        [post setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setTimeOutSeconds:15];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                // NSLog(@"login返回信息：%@",jsonDict);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopRequest];
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        self.view.tag = 1002;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            login.delegate=self;
                            [login show];
                        });
                        
                        return;
                    }
                    
                    if (kResCode == 103261) {
                        NewContractObject *contract =[self.dataArray objectAtIndex:indexPath.section];
                        NewOrderObject *order =[contract.phaseOrders objectAtIndex:indexPath.row];
                        order.phaseOrderState =[[jsonDict objectForKey:@"stateId"] intValue];
                        order.phaseOrderStateName =[jsonDict objectForKey:@"stateName"];
                        [self.mtableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                        [TLToast showWithText:@"拒绝付款成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else if (kResCode == 103269) {
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"拒绝付款失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"拒绝付款失败"];
                    } else if (kResCode == 103262) {
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"订单状态不对";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"订单状态不对"];
                    }else if (kResCode == 103264) {
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"订单不存在";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"订单不存在"];
                    }
                    //                            }else if (kResCode == 11305) {
                    //                                [TLToast showWithText:@"支付密码不正确"];
                    //                            }else{
                    //                                [TLToast showWithText:@"订单确认失败"];
                    //                            }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  //                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:post];
    });
}
#pragma mark - 评论
-(void)myappraise:(UIButton *)sender {
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]){
        //        [self.view becomeFirstResponder];
        
        UITableViewCell *cell;
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
            cell= (UITableViewCell *)sender.superview;
        else
            cell= (UITableViewCell *)sender.superview.superview;
        
        NSIndexPath *indexPath =[self.mtableview indexPathForCell:cell];
        NewContractObject *contraObject =[self.dataArray objectAtIndex:indexPath.section];
        self.selectContract =contraObject;
        NSArray *arr_;
        if(contraObject.orderType==1) arr_=@[@"服务态度",@"设计水平",@"沟通能力"];
        else if(contraObject.orderType==4) arr_=@[@"服务态度",@"施工质量",@"进度控制"];
        else if(contraObject.orderType==6) arr_=@[@"服务态度",@"专业技能",@"沟通能力"];
        float height =0;
        if (kMainScreenHeight<=480) {
            height =-25;
        }
//        comment=[[CommentViewForGJS alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 245+height) title:arr_];
//        comment.delegate=self;
//        [UIView animateWithDuration:.25 animations:^{
//            comment.frame=CGRectMake(0, kMainScreenHeight-260-245-height, kMainScreenWidth, 245+height);
//        } completion:^(BOOL finished) {
//            if (finished) {
//                
//            }
//        }];
//        [comment show];
        IDIAI3CommentViewController *commentController =[[IDIAI3CommentViewController alloc] init];
        commentController.orderType =contraObject.orderType;
        commentController.servantId =contraObject.servantId;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.isRefresh =NO;
        [delegate.nav pushViewController:commentController animated:YES];
    }
    else{
        self.view.tag = 1001;
        dispatch_async(dispatch_get_main_queue(), ^{
            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
            login.delegate=self;
            [login show];
            
        });
        
    }
    
}
-(void)showOrderAction:(UIGestureRecognizer *)sender{
    NSLog(@"显示订单");
    UIView *cellView;
    if ([[UIDevice currentDevice].systemVersion floatValue]>8.0) {
        cellView =[sender.view superview];
    }else{
        cellView =[[sender.view superview] superview];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
        UITableViewCell *tableCell =(UITableViewCell *)cellView;
        NSIndexPath *indexPath =[self.mtableview indexPathForCell:tableCell];
        NewContractObject *contraObject =[self.dataArray objectAtIndex:indexPath.section];
        if (indexPath.row==0) {
            if (contraObject.orderType ==4) {
                NewOrderObject *neworder =[contraObject.phaseOrders objectAtIndex:0];
                NewOrderObject *secondorder;
                if (contraObject.phaseOrders.count>2) {
                   secondorder =[contraObject.phaseOrders objectAtIndex:1];
                }
                
                IDIAI3OrderDetailViewController *orderdetail =[[IDIAI3OrderDetailViewController alloc] init];
                orderdetail.orderPhone =contraObject.userMobile;
                if (neworder.phaseOrderState==33&&secondorder.phaseOrderState==2) {
                    orderdetail.phaseOrderCode =neworder.phaseOrderCode;
                    orderdetail.secondOrderCode =secondorder.phaseOrderCode;
                }else{
                    if (indexPath.row==0) {
                        orderdetail.phaseOrderCode =neworder.phaseOrderCode;
                    }else{
                        orderdetail.phaseOrderCode =secondorder.phaseOrderCode;
                    }
                }
                IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                self.isRefresh =NO;
                [delegate.nav setNavigationBarHidden:NO animated:YES];
                [delegate.nav pushViewController:orderdetail animated:YES];
            }else{
                NewOrderObject *neworder =[contraObject.phaseOrders objectAtIndex:0];
                IDIAI3OrderDetailViewController *orderdetail =[[IDIAI3OrderDetailViewController alloc] init];
                orderdetail.phaseOrderCode =neworder.phaseOrderCode;
                orderdetail.phaseOrderCode =neworder.phaseOrderCode;
                IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                self.isRefresh =NO;
                [delegate.nav setNavigationBarHidden:NO animated:YES];
                [delegate.nav pushViewController:orderdetail animated:YES];
            }
        }else{
            int ismeg=0;
            if (contraObject.orderType ==4) {//工长
                NewOrderObject *neworder =[contraObject.phaseOrders objectAtIndex:0];
                NewOrderObject *secondorder;
                if (contraObject.phaseOrders.count>2) {
                    secondorder =[contraObject.phaseOrders objectAtIndex:1];
                }
                if (neworder.phaseOrderState==33&&secondorder.phaseOrderState==2){
                    ismeg =1;
                }
            }
            NewOrderObject *neworder =[contraObject.phaseOrders objectAtIndex:indexPath.row+ismeg];
            if (neworder.phaseOrderState ==35) {
                self.selectOrder =neworder;
                self.isMakeUp =YES;
            }
            
           
            IDIAI3OrderDetailViewController *orderdetail =[[IDIAI3OrderDetailViewController alloc] init];
            orderdetail.phaseOrderCode =neworder.phaseOrderCode;
                   IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
            self.isRefresh =NO;
            [delegate.nav setNavigationBarHidden:NO animated:YES];
            [delegate.nav pushViewController:orderdetail animated:YES];
        }

    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
}
//请求订单列表
-(void)requestContractlist{
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token;
        NSString *string_userid;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        else{
            string_token=@"";
            string_userid=@"";
        }
        NSString *url =[NSString string];
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0305\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"orderType\":%d,\"requestRow\":15,\"currentPage\":%ld}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(int)self.typeInteger,(long)self.currentPage];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"合同列表列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (kResCode == 10002 || kResCode == 10003) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                    login.delegate=self;
                    [login show];
                    return;
                    });
                }
                if (code==103051) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if(self.refreshing==YES && [self.dataArray count]) [self.dataArray removeAllObjects];
                        NSArray *arr_=[jsonDict objectForKey:@"orderInfoList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSDictionary *dict in arr_){
//                                NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary:dict];
//                                NSMutableArray *phaseArray =[NSMutableArray array];
//                                for (NSDictionary *phasedic in [dic objectForKey:@"phaseOrders"]) {
//                                    NSMutableDictionary *phase =[NSMutableDictionary dictionaryWithDictionary:phasedic];
//                                    [phase removeObjectForKey:@"orderCode_"];
//                                    [phaseArray addObject:phase];
//                                }
//                                [dic setObject:phaseArray forKey:@"phaseOrders"];
                                DCParserConfiguration *config = [DCParserConfiguration configuration];
                                DCArrayMapping *arrayMapping = [DCArrayMapping mapperForClassElements:[NewOrderObject class] forAttribute:@"phaseOrders" onClass:[NewContractObject class]];
                                [config addArrayMapper:arrayMapping];
                                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[NewContractObject class] andConfiguration:config];
                                NewContractObject *contract =[parser parseDictionary:dict];
                                NSLog(@"contract================%@",contract);
                                [self.dataArray addObject:contract];
                                
                            }
                        }
                        if([self.dataArray count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [self.mtableview tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [self.mtableview tableViewDidFinishedLoading];
                        }
                        [self.mtableview reloadData];
                        //                        self.isrequst =NO;
                    });
                }
                else if (code==102753) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [self.mtableview tableViewDidFinishedLoading];
                        if(![self.dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [self.mtableview reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [self.mtableview tableViewDidFinishedLoading];
                        if(![self.dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [self.mtableview reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [self.mtableview tableViewDidFinishedLoading];
                                  if(![self.dataArray count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [self.mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=1;
        [self requestContractlist];
    }
    else {
        if(self.totalPages>self.currentPage){
            self.currentPage +=1;
            [self requestContractlist];
        }
        else{
            
            [self.mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
            self.mtableview.reachedTheEnd = YES;  //是否加载到底了
        }
    }
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=YES;
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    //NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    //创建一个NSDataFormatter显示刷新时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

//上拉加载  Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    if(isFirstInt==YES){
        self.refreshing=NO;
        [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
    }
    else {
        [self.mtableview tableViewDidFinishedLoading];
        isFirstInt=!isFirstInt;
    }
}
#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.mtableview.contentOffset.y<-30) {
        self.mtableview.reachedTheEnd = NO;  //是否加载到底了
    }
    //手指开始拖动方法
    [self.mtableview tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.mtableview tableViewDidEndDragging:scrollView];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1000) {
        if (buttonIndex ==0) {
            NSLog(@"1");
        }
        if (buttonIndex==1) {
            self.isMakeUp =YES;
            PayingConfirmViewController *payingConfirmVC = [[PayingConfirmViewController alloc]init];
            payingConfirmVC.serviceNameStr = @"找补单";
            payingConfirmVC.moneyFloat = [self.selectOrder.makeUpFee floatValue];
            payingConfirmVC.orderNo = self.selectOrder.frOrderCode;
            payingConfirmVC.amounts =self.selectOrder.makeUpFee;
            payingConfirmVC.fromStr=@"contract";
            payingConfirmVC.fromController =@"contract";
            self.isRefresh =NO;
            IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate.nav pushViewController:payingConfirmVC animated:YES];
            [delegate.nav setNavigationBarHidden:NO animated:YES];
            payingConfirmVC.hidesBottomBarWhenPushed =YES;
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
    }else{
        if (buttonIndex ==0) {
            IDIAI3ConfirmPaymentViewController *confirmPay =[[IDIAI3ConfirmPaymentViewController alloc] init];
            confirmPay.orderType =self.selectContract.orderType;

            float orderPhraseFee =[self.selectOrder.phaseOrderFee floatValue]+[self.selectOrder.makeUpFee floatValue];
            confirmPay.payforMoney =orderPhraseFee;
            self.isRefresh =NO;
            confirmPay.orderCode =self.selectOrder.phaseOrderCode;
            IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate.nav setNavigationBarHidden:NO animated:YES];
            self.hidesBottomBarWhenPushed =YES;
            [delegate.nav pushViewController:confirmPay animated:YES];
        }
    }
    
}
#pragma mark -
#pragma mark - comments

-(void)didFinishedComments:(NSString *)comment_title star:(NSArray *)star_arr{
    
    [UIView animateWithDuration:.35 animations:^{
        comment.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 245);
    } completion:^(BOOL finished) {
        if (finished) {
            [comment dismiss];
        }
    }];
    
    [self requestEvaluationOfStar:comment_title star:star_arr];
}

//评价
-(void)requestEvaluationOfStar:(NSString *)title star:(NSArray *)star_arr{
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token;
        NSString *string_userid;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        else{
            string_token=@"";
            string_userid=@"";
        }
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSMutableDictionary *postDict01 = [[NSMutableDictionary alloc] init];
        [postDict01 setObject:@"ID0004" forKey:@"cmdID"];
        [postDict01 setObject:string_token forKey:@"token"];
        [postDict01 setObject:string_userid forKey:@"userID"];
        [postDict01 setObject:@"ios" forKey:@"deviceType"];
        [postDict01 setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
        NSString *string01=[postDict01 JSONString];
        
        
        NSString *orderTypeStr = [NSString stringWithFormat:@"%ld",(long)self.selectContract.orderType];
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:[NSString stringWithFormat:@"%d",self.selectContract.servantId] forKey:@"objectId"];
        [postDict02 setObject:title forKey:@"objectString"];
        [postDict02 setObject:orderTypeStr forKey:@"objectTypeId"];
        NSInteger firstStar=[star_arr[0] integerValue];
        if(firstStar%2==0)
            [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)firstStar/2] forKey:@"objectLevel"];
        else
            [postDict02 setObject:[NSString stringWithFormat:@"%0.1f",firstStar/2+0.5] forKey:@"objectLevel"];
        NSInteger secondStar=[star_arr[1] integerValue];
        if(secondStar%2==0)
            [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)secondStar/2] forKey:@"professionalLevel"];
        else
            [postDict02 setObject:[NSString stringWithFormat:@"%0.1f",secondStar/2+0.5] forKey:@"professionalLevel"];
        NSInteger thirdStar=[star_arr[2] integerValue];
        if(thirdStar%2==0)
            [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)thirdStar/2] forKey:@"customerServiceLevel"];
        else
            [postDict02 setObject:[NSString stringWithFormat:@"%0.1f",thirdStar/2+0.5] forKey:@"customerServiceLevel"];
        NSString *string02=[postDict02 JSONString];
        
        NSMutableDictionary *req_dict= [[NSMutableDictionary alloc] init];
        [req_dict setObject:string01 forKey:@"header"];
        [req_dict setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"评星：返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10041) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [comment dismiss];
                        [TLToast showWithText:@"评价成功，感谢您的支持" bottomOffset:220.0f duration:1.0];
                        [self.mtableview launchRefreshing];
                    });
                }
                else if (code==10042) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"亲，不符合评价的规则" bottomOffset:220.0f duration:1.0];
                    });
                }
                else if (code==10043) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"亲，评价的内容过长" bottomOffset:220.0f duration:1.0];
                        
                    });
                }
                
                else if (code==10049) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
                              });
                          }
                               method:url postDict:req_dict];
    });
    
    
}
-(void)hideAction:(id)sender{
    [customPromp dismiss];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
