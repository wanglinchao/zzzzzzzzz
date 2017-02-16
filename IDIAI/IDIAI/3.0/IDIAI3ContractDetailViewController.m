//
//  IDIAI3ContractDetailViewController.m
//  IDIAI
//
//  Created by Ricky on 15/12/24.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3ContractDetailViewController.h"
#import "LoginView.h"
#import "NewContractDetailObject.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "NewContractObject.h"
#import "ContractDetailCell.h"
#import "IDIAIAppDelegate.h"
#import "ManageFeeCell.h"
#import "PhaseOrderCell.h"
#import "TLToast.h"
#import "CommentViewForGJS.h"
#import "IDIAI3CommentViewController.h"
#import "CustomPromptView.h"
#import "CouponMainViewController.h"
#import "PreferentialObject.h"
#import "DemandViewController.h"
#import "util.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "RefusedViewController.h"
@interface IDIAI3ContractDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ContractDetailCellDelegate,CommentsViewDelegate>{
    CommentViewForGJS *comment;
    CustomPromptView *customPromp;
}
@property(nonatomic,strong)NewContractDetailObject *contractDetail;
@property(nonatomic,strong)NSMutableArray *phaseOrders;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,assign)NSInteger ismanager;
@property(nonatomic,strong)NSMutableDictionary *isOpenIndex;
@property(nonatomic,strong)UIView *isfootView;
@property(nonatomic,assign)int couponNum; //可用的优惠卷数量
@property(nonatomic,assign)int noCouponNum; //不可用的优惠卷数量
@property(nonatomic,strong)PreferentialObject *preferential;
@property(nonatomic,strong)NSMutableArray *budgetArray;
@property(nonatomic,strong)NSMutableArray *clarificaitonArray;
@property(nonatomic,strong)NSMutableArray *attachmentArray;
@property(nonatomic,strong)NSMutableArray *otherArray;
@end

@implementation IDIAI3ContractDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    self.view.backgroundColor =[UIColor whiteColor];
    self.budgetArray =[NSMutableArray array];
    self.clarificaitonArray =[NSMutableArray array];
    self.attachmentArray =[NSMutableArray array];
    self.otherArray =[NSMutableArray array];
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.isOpenIndex =[NSMutableDictionary dictionary];
    self.table =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    self.table.delegate =self;
    self.table.dataSource =self;
    self.table.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    
    self.isfootView =[[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-64-44, kMainScreenWidth, 44)];
    self.isfootView.backgroundColor =[UIColor whiteColor];
    self.isfootView.hidden =YES;
    [self.view addSubview:self.isfootView];
    
    UIImageView *lineimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    lineimage.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [self.isfootView addSubview:lineimage];
    
    UIButton *canclebtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [canclebtn setTitle:@"取消合同" forState:UIControlStateNormal];
    [canclebtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
    canclebtn.layer.masksToBounds = YES;
    canclebtn.layer.cornerRadius = 5;
    canclebtn.layer.borderColor =[UIColor colorWithHexString:@"#ef6562"].CGColor;
    canclebtn.layer.borderWidth = 1;
    canclebtn.titleLabel.font =[UIFont systemFontOfSize:14.0];
    canclebtn.frame =CGRectMake(25, 8, 90, 30);
    canclebtn.tag =100;
    [canclebtn addTarget:self action:@selector(canclebtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.isfootView addSubview:canclebtn];
    
    UIButton *confirmbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [confirmbtn setTitle:@"确认合同" forState:UIControlStateNormal];
    [confirmbtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
    confirmbtn.layer.masksToBounds = YES;
    confirmbtn.layer.cornerRadius = 5;
    confirmbtn.layer.borderColor =[UIColor colorWithHexString:@"#ef6562"].CGColor;
    confirmbtn.layer.borderWidth = 1;
    confirmbtn.titleLabel.font =[UIFont systemFontOfSize:14.0];
    confirmbtn.frame =CGRectMake(kMainScreenWidth-25-90, 8, 90, 30);
    confirmbtn.tag =101;
    [confirmbtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.isfootView addSubview:confirmbtn];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(5, 5, 75, 75)];
    //    [rightButton setImage:[UIImage imageNamed:@"ic_xieriji.png"] forState:UIControlStateNormal];
    //    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    [rightButton setTitle:@"装修需求表" forState:UIControlStateNormal];
    [rightButton setTitle:@"装修需求表" forState:UIControlStateHighlighted];
    rightButton.titleLabel.font =[UIFont systemFontOfSize:15.0];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self
                    action:@selector(PressBarItemRight)
          forControlEvents:UIControlEventTouchUpInside];
    //        rightButton.backgroundColor =[UIColor redColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    backView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.table.tableHeaderView =backView;
    UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 15)];
    footView.backgroundColor =[UIColor whiteColor];
    self.table.tableFooterView =footView;
    self.contractDetail =[[NewContractDetailObject alloc] init];
    self.phaseOrders =[NSMutableArray array];
    [self requestContractDetail];
    // Do any additional setup after loading the view.
}
-(void)PressBarItemRight{
    DemandViewController *demandView =[[DemandViewController alloc] init];
    demandView.title =@"装修需求表";
    [self.navigationController pushViewController:demandView animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //    [self customizeNavigationBar];
}
-(void)canclebtnAction:(id)sender{
    if ([self.contractDetail.state integerValue] ==1) {
        [self startRequestWithString:@"提交中..."];
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
            NSDictionary *bodyDic = @{@"orderCode":self.orderCode,@"actionType":@0};
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
                                [self stopRequest];
                                LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                                login.delegate=self;
                                
                                [login show];
                                
                            });
                            
                            return;
                        }
                        
                        if (kResCode == 103551) {
                            //                        [self.mtableview launchRefreshing];
                            [self.budgetArray removeAllObjects];
                            [self.clarificaitonArray removeAllObjects];
                            [self.attachmentArray removeAllObjects];
                            [self.otherArray removeAllObjects];
                            [self requestContractDetail];
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
                        }                        //                            }else if (kResCode == 11305) {
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
                                      //                                  [TLToast showWithText:@"操作失败"];
                                  });
                              }
                                   method:url postDict:post];
        });
    }else{
        RefusedViewController *refused =[[RefusedViewController alloc] init];
        refused.contractId =self.contractDetail.contractId;
        refused.backDone =^(BOOL issuccess){
            if (issuccess ==YES) {
                [self.budgetArray removeAllObjects];
                [self.clarificaitonArray removeAllObjects];
                [self.attachmentArray removeAllObjects];
                [self.otherArray removeAllObjects];
                [self requestContractDetail];
            }
        };
        [self.navigationController pushViewController:refused animated:YES];
    }
    
}
#pragma mark - 评论
-(void)myappraise:(UIButton *)sender {
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]){
//        [self.view becomeFirstResponder];
//        
//        UITableViewCell *cell;
//        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
//            cell= (UITableViewCell *)sender.superview;
//        else
//            cell= (UITableViewCell *)sender.superview.superview;
//        
//
//        NSArray *arr_;
//        if(self.contractDetail.contractType==1) arr_=@[@"服务态度",@"设计水平",@"沟通能力"];
//        else if(self.contractDetail.contractType==4) arr_=@[@"服务态度",@"施工质量",@"进度控制"];
//        else if(self.contractDetail.contractType==6) arr_=@[@"服务态度",@"专业技能",@"沟通能力"];
//        float height =0;
//        if (kMainScreenHeight<=480) {
//            height =-25;
//        }
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
        commentController.orderType =self.contractDetail.contractType;
        commentController.servantId =self.contractDetail.servantId;
        [self.navigationController pushViewController:commentController animated:YES];
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
-(void)confirmAction:(id)sender{
    if ([self.contractDetail.state integerValue]==1) {
        [self startRequestWithString:@"提交中..."];
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
            int sucId =0;
            if (self.preferential) {
                sucId =self.preferential.sucId;
            }
            NSDictionary *bodyDic = @{@"orderCode":self.orderCode,@"actionType":@1,@"sucId":[NSNumber numberWithInt:sucId]};
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
                            [self.budgetArray removeAllObjects];
                            [self.clarificaitonArray removeAllObjects];
                            [self.attachmentArray removeAllObjects];
                            [self.otherArray removeAllObjects];
                            [self requestContractDetail];
                            [TLToast showWithText:@"合同确认成功"];
                        } else if (kResCode == 103559) {
                            customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                            customPromp.contenttxt =@"合同确认失败";
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
                                      [TLToast showWithText:@"操作失败"];
                                  });
                              }
                                   method:url postDict:post];
        });
    }else{
        [self startRequestWithString:@"提交中..."];
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
            [postDict setObject:@"ID0356" forKey:@"cmdID"];
            [postDict setObject:string_token forKey:@"token"];
            [postDict setObject:string_userid forKey:@"userID"];
            [postDict setObject:@"ios" forKey:@"deviceType"];
            [postDict setObject:kCityCode forKey:@"cityCode"];
            
            NSString *string=[postDict JSONString];
            NSDictionary *bodyDic = @{@"contractId":[NSNumber numberWithInt:self.contractDetail.contractId],@"actionType":@1,@"refuseReason":@""};
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
                                [self stopRequest];
                                LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                                login.delegate=self;
                                
                                [login show];
                                
                            });
                            
                            return;
                        }
                        
                        if (kResCode == 103561) {
                            [self stopRequest];
                            [self.budgetArray removeAllObjects];
                            [self.clarificaitonArray removeAllObjects];
                            [self.attachmentArray removeAllObjects];
                            [self.otherArray removeAllObjects];
                            [self requestContractDetail];
                            [TLToast showWithText:@"同意变更成功"];
                        } else if (kResCode == 103569) {
                            [self stopRequest];
                            customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                            customPromp.contenttxt =@"同意变更失败";
                            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                            [customPromp addGestureRecognizer:tap];
                            [customPromp show];
                            //                        [TLToast showWithText:@"合同取消失败"];
                        } else {
                            [self stopRequest];
                            customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                            customPromp.contenttxt =@"同意变更被拒绝";
                            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                            [customPromp addGestureRecognizer:tap];
                            [customPromp show];
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
    
}


-(void)requestContractDetail{
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
        [postDict setObject:@"ID0308" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"orderCode":self.orderCode};
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
                    self.isfootView.hidden =NO;
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        self.view.tag = 1002;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            login.delegate=self;
                            [self.isfootView removeFromSuperview];
                            [login show];
                        });
                        
                        return;
                    }
                    
                    if (kResCode == 103081) {
                        DCParserConfiguration *config = [DCParserConfiguration configuration];
                        DCArrayMapping *arrayMapping = [DCArrayMapping mapperForClassElements:[ContractAttchmentObject class] forAttribute:@"attactmentsPaths" onClass:[NewContractDetailObject class]];
                        [config addArrayMapper:arrayMapping];
                        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[NewContractDetailObject class] andConfiguration:config];
                        self.contractDetail =[parser parseDictionary:[jsonDict objectForKey:@"contractInfo"]];
                        self.couponNum =[[jsonDict objectForKey:@"couponNum"] intValue];
                        self.noCouponNum =[[jsonDict objectForKey:@"noCouponNum"] intValue];
                        [self.phaseOrders removeAllObjects];
                            for (NSDictionary *phasedic in [jsonDict objectForKey:@"phaseOrders"]) {
                                NSMutableDictionary *phase =[NSMutableDictionary dictionaryWithDictionary:phasedic];
                                [phase removeObjectForKey:@"orderCode_"];
                                DCKeyValueObjectMapping *parser1 = [DCKeyValueObjectMapping mapperForClass:[NewOrderObject class]];
                                NewOrderObject *orderobject =[parser1 parseDictionary:phase];
                                [self.phaseOrders addObject:orderobject];
                            }
                        if ([self.contractDetail.state integerValue]==1) {
                            self.table.frame =CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-44);
                        }else{
                            
                            if (self.contractDetail.attChangeState ==1) {
                                self.table.frame =CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-44);
                                UIButton *canclebtn =[self.isfootView viewWithTag:100];
                                [canclebtn setTitle:@"拒绝变更" forState:UIControlStateNormal];
                                UIButton *confirmbtn =[self.isfootView viewWithTag:101];
                                [confirmbtn setTitle:@"同意变更" forState:UIControlStateNormal];
                                self.isfootView.hidden =NO;
                            }else{
                                self.table.frame =CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64);
                                self.isfootView.hidden =YES;
                            }
                            
                        }
                        [self.view addSubview:self.table];
                        if (self.contractDetail.servantPhoneNo.length>0) {
                            [self createPhone];
                        }
                        for (ContractAttchmentObject *attchment in self.contractDetail.attactmentsPaths) {
                            if (attchment.attchmentType ==1&&attchment.attchmnetPath.length>0) {
                                [self.budgetArray addObject:attchment];
                            }else if (attchment.attchmentType ==2&&attchment.attchmnetPath.length>0){
                                [self.clarificaitonArray addObject:attchment];
                            }else if (attchment.attchmentType ==3&&attchment.attchmnetPath.length>0){
                                [self.attachmentArray addObject:attchment];
                            }else if (attchment.attchmentType ==4&&attchment.attchmnetPath.length>0){
                                [self.otherArray addObject:attchment];
                            }
                        }
                        self.preferential =nil;
                        [self.table reloadData];
                        
//                        [self.mtableview launchRefreshing];
//                        [TLToast showWithText:@"合同确认成功"];
                    } else if (kResCode == 103089) {
                        [TLToast showWithText:@"合同获取失败"];
                    } else if (kResCode == 103082) {
                        [TLToast showWithText:@"合同订单号不存在"];
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return 0;
    }
    return 0;
}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
//    backView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
//    return backView;
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int sectioncount =0;
    if (self.contractDetail.remark.length>0||self.contractDetail.attactmentsPaths.count>0) {
        sectioncount +=1;
    }
    
    if (self.phaseOrders!=nil) {
        if (self.phaseOrders.count>0) {
            NewOrderObject *orderObject =[self.phaseOrders objectAtIndex:0];
            if (orderObject.phaseOrderCode.length>0) {
                if ([[orderObject.phaseOrderCode substringToIndex:1] isEqualToString:@"G"]) {
                    self.ismanager =1;
                    return 3+sectioncount;
                }else{
                    return 2+sectioncount;
                }
            }else{
                if ([orderObject.phaseOrderName isEqualToString:@"监理服务费"]) {
                    self.ismanager =1;
                    return 3+sectioncount;
                }
                return 2+sectioncount;
            }
        }
        return 1+sectioncount;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.phaseOrders!=nil){
        if (self.phaseOrders.count>0) {
            NewOrderObject *orderObject =[self.phaseOrders objectAtIndex:0];
            if (orderObject.phaseOrderCode.length>0){
                if ([[orderObject.phaseOrderCode substringToIndex:1] isEqualToString:@"G"]) {
                    self.ismanager =1;
                    if (section==0) {
                        return 1;
                    }else if (section==1){
                        return 1;
                    }else if (section==2){
                        return self.phaseOrders.count-1;
                    }else{
                        return 1;
                    }
                }else{
                    if (section==0) {
                        return 1;
                    }else if (section==1){
                        return self.phaseOrders.count;
                    }else{
                        return 1;
                    }
                }
            }else{
                if ([orderObject.phaseOrderName isEqualToString:@"监理服务费"]) {
                    self.ismanager =1;
                    if (section==0) {
                        return 1;
                    }else if (section==1){
                        return 1;
                    }else if (section==2){
                        return self.phaseOrders.count-1;
                    }else{
                        return 1;
                    }
                }
                if (section==0) {
                    return 1;
                }else if (section==1){
                    return self.phaseOrders.count;
                }else{
                    return 1;
                }
            }
            
        }
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        NSString *const cellidentifier = [NSString stringWithFormat:@"ContractDetailCell%d",(int)indexPath.row];
        ContractDetailCell *cell = (ContractDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (!cell) {
            cell = [[ContractDetailCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
        }
        cell.orderCode =self.orderCode;
        cell.couponNum =self.couponNum;
        if (self.preferential!=nil) {
            cell.preferential =self.preferential;
        }
        cell.contractDetail =self.contractDetail;
        return [cell getCellHeight];
    }else if (indexPath.section ==1){
        NewOrderObject *orderObject;
        if (self.phaseOrders.count>0) {
            orderObject =[self.phaseOrders objectAtIndex:0];
            if (orderObject.phaseOrderCode.length>0) {
                if ([[orderObject.phaseOrderCode substringToIndex:1] isEqualToString:@"G"]){
                    NSString *const cellidentifier = [NSString stringWithFormat:@"ManageFeeCell%d",(int)indexPath.row];
                    ManageFeeCell *cell = (ManageFeeCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
                    if (!cell) {
                        cell = [[ManageFeeCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
                    }
                    cell.contractTotalFee =self.contractDetail.contractTotalFee;
                    cell.productProFee =self.contractDetail.productProFee;
                    cell.ppDiscount =self.contractDetail.ppDiscount;
                    cell.prefertial =self.preferential;
                    cell.platformSuperFee =self.contractDetail.platformSuperFee;
                    cell.psDiscount =self.contractDetail.psDiscount;
                    cell.type =self.contractDetail.contractType;
                    cell.orderObject =orderObject;
                    
                    return [cell getCellHeight];
                }else{
                    
                    NewOrderObject *orderObject =[self.phaseOrders objectAtIndex:indexPath.row+self.ismanager];
                    NSString *const CustomCellIdentifier = [NSString stringWithFormat:@"CustomCellIdentifier%d%d",(int)indexPath.section,(int)indexPath.row];
                    PhaseOrderCell *cell = (PhaseOrderCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
                    if (!cell) {
                        cell = [[PhaseOrderCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CustomCellIdentifier];
                    }
                    cell.orderObject =orderObject;
                    cell.contractTotalFee =self.contractDetail.contractTotalFee;
                    cell.preferential =self.preferential;
                    cell.isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
                    if (indexPath.row==0) {
                        cell.isfirst =YES;
                    }else{
                        cell.isfirst =NO;
                    }
                    return [cell getCellHeight];
                }
            }else{
                if ([orderObject.phaseOrderName isEqualToString:@"监理服务费"]) {
                    NSString *const cellidentifier = [NSString stringWithFormat:@"ManageFeeCell%d",(int)indexPath.row];
                    ManageFeeCell *cell = (ManageFeeCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
                    if (!cell) {
                        cell = [[ManageFeeCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
                    }
                    cell.contractTotalFee =self.contractDetail.contractTotalFee;
                    cell.productProFee =self.contractDetail.productProFee;
                    cell.ppDiscount =self.contractDetail.ppDiscount;
                    cell.prefertial =self.preferential;
                    cell.platformSuperFee =self.contractDetail.platformSuperFee;
                    cell.psDiscount =self.contractDetail.psDiscount;
                    cell.type =self.contractDetail.contractType;
                    cell.orderObject =orderObject;
                    
                    return [cell getCellHeight];
                }
            }
            NewOrderObject *orderObject;
            if (self.phaseOrders.count>indexPath.row+self.ismanager) {
                orderObject =[self.phaseOrders objectAtIndex:indexPath.row+self.ismanager];
            }
            
            NSString *const CustomCellIdentifier = [NSString stringWithFormat:@"CustomCellIdentifier%d%d",(int)indexPath.section,(int)indexPath.row];
            PhaseOrderCell *cell = (PhaseOrderCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
            if (!cell) {
                cell = [[PhaseOrderCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CustomCellIdentifier];
            }
            cell.contractTotalFee =self.contractDetail.contractTotalFee;
            cell.engineering =self.contractDetail.orderFee;
            cell.preferential =self.preferential;
            cell.isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
            cell.orderObject =orderObject;
            
            if (indexPath.row==0) {
                cell.isfirst =YES;
            }else{
                cell.isfirst =NO;
            }
            return [cell getCellHeight];
        }else{
            CGFloat height=95;
            if (self.contractDetail.remark.length>0) {
                CGSize labelsize1 = [util calHeightForLabel:self.contractDetail.remark width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:15]];
                height+=labelsize1.height;
            }
            if (self.contractDetail.attactmentsPaths.count>0) {
//                @property(nonatomic,strong)NSMutableArray *budgetArray;
//                @property(nonatomic,strong)NSMutableArray *clarificaitonArray;
//                @property(nonatomic,strong)NSMutableArray *attachmentArray;
//                @property(nonatomic,strong)NSMutableArray *otherArray;
                int count=0;
                if (self.budgetArray.count>0) {
                    count++;
                }
                if (self.clarificaitonArray.count>0) {
                    count++;
                }
                if (self.attachmentArray.count>0) {
                    count++;
                }
                if (self.otherArray.count>0) {
                    count++;
                }
                height+=((kMainScreenWidth-30)*5/9+30)*count;
                if (self.contractDetail.changeReason.length>0) {
                    CGSize labelsize =[util calHeightForLabel:self.contractDetail.changeReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                    height+=20+17+labelsize.height;
                }
                if (self.contractDetail.refuseReason.length>0) {
                    CGSize labelsize =[util calHeightForLabel:self.contractDetail.refuseReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                    height+=20+17+labelsize.height;
                }
            }
            return height;
        }
    }else if (indexPath.section==2){
        NewOrderObject *orderObject;
        if (self.phaseOrders.count>0) {
            orderObject =[self.phaseOrders objectAtIndex:0];
        }
        if (orderObject.phaseOrderCode.length>0) {
            if ([[orderObject.phaseOrderCode substringToIndex:1] isEqualToString:@"G"]) {
                NewOrderObject *orderObject =[self.phaseOrders objectAtIndex:indexPath.row+self.ismanager];
                NSString *const CustomCellIdentifier = [NSString stringWithFormat:@"CustomCellIdentifier%d%d",(int)indexPath.section,(int)indexPath.row];
                PhaseOrderCell *cell = (PhaseOrderCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
                if (!cell) {
                    cell = [[PhaseOrderCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CustomCellIdentifier];
                }
                cell.contractTotalFee =self.contractDetail.contractTotalFee;
                cell.engineering =self.contractDetail.orderFee;
                cell.preferential =self.preferential;
                cell.isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
                cell.orderObject =orderObject;
                
                if (indexPath.row==0) {
                    cell.isfirst =YES;
                }else{
                    cell.isfirst =NO;
                }
                return [cell getCellHeight];
            }else{
                if ([orderObject.phaseOrderName isEqualToString:@"监理服务费"]) {
                    NewOrderObject *orderObject =[self.phaseOrders objectAtIndex:indexPath.row+self.ismanager];
                    NSString *const CustomCellIdentifier = [NSString stringWithFormat:@"CustomCellIdentifier%d%d",(int)indexPath.section,(int)indexPath.row];
                    PhaseOrderCell *cell = (PhaseOrderCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
                    if (!cell) {
                        cell = [[PhaseOrderCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CustomCellIdentifier];
                    }
                    cell.contractTotalFee =self.contractDetail.contractTotalFee;
                    cell.engineering =self.contractDetail.orderFee;
                    cell.preferential =self.preferential;
                    cell.isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
                    cell.orderObject =orderObject;
                    
                    if (indexPath.row==0) {
                        cell.isfirst =YES;
                    }else{
                        cell.isfirst =NO;
                    }
                    return [cell getCellHeight];
                }else{
                    CGFloat height=85;
                    if (self.contractDetail.remark.length>0) {
                        CGSize labelsize1 = [util calHeightForLabel:self.contractDetail.remark width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:15]];
                        height+=labelsize1.height;
                    }
                    if (self.contractDetail.attactmentsPaths.count>0) {
                        int count=0;
                        if (self.budgetArray.count>0) {
                            count++;
                        }
                        if (self.clarificaitonArray.count>0) {
                            count++;
                        }
                        if (self.attachmentArray.count>0) {
                            count++;
                        }
                        if (self.otherArray.count>0) {
                            count++;
                        }
                        height+=((kMainScreenWidth-30)*5/9+30+17)*count;
                        if (self.contractDetail.changeReason.length>0) {
                            CGSize labelsize =[util calHeightForLabel:self.contractDetail.changeReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                            height+=20+17+labelsize.height;
                        }
                        if (self.contractDetail.refuseReason.length>0) {
                            CGSize labelsize =[util calHeightForLabel:self.contractDetail.refuseReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                            height+=20+17+labelsize.height;
                        }
                    }
                    return height;
                }
            }
        }else{
            if ([orderObject.phaseOrderName isEqualToString:@"监理服务费"]) {
                NewOrderObject *orderObject =[self.phaseOrders objectAtIndex:indexPath.row+self.ismanager];
                NSString *const CustomCellIdentifier = [NSString stringWithFormat:@"CustomCellIdentifier%d%d",(int)indexPath.section,(int)indexPath.row];
                PhaseOrderCell *cell = (PhaseOrderCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
                if (!cell) {
                    cell = [[PhaseOrderCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CustomCellIdentifier];
                }
                cell.contractTotalFee =self.contractDetail.contractTotalFee;
                cell.engineering =self.contractDetail.orderFee;
                cell.preferential =self.preferential;
                cell.isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
                cell.orderObject =orderObject;
                
                if (indexPath.row==0) {
                    cell.isfirst =YES;
                }else{
                    cell.isfirst =NO;
                }
                return [cell getCellHeight];
            }else{
                CGFloat height=95;
                if (self.contractDetail.remark.length>0) {
                    CGSize labelsize1 = [util calHeightForLabel:self.contractDetail.remark width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:15]];
                    height+=labelsize1.height;
                }
                if (self.contractDetail.attactmentsPaths.count>0) {
                    int count=0;
                    if (self.budgetArray.count>0) {
                        count++;
                    }
                    if (self.clarificaitonArray.count>0) {
                        count++;
                    }
                    if (self.attachmentArray.count>0) {
                        count++;
                    }
                    if (self.otherArray.count>0) {
                        count++;
                    }
                    height+=((kMainScreenWidth-30)*5/9+30+17)*count;
                    if (self.contractDetail.changeReason.length>0) {
                        CGSize labelsize =[util calHeightForLabel:self.contractDetail.changeReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                        height+=20+17+labelsize.height;
                    }
                    if (self.contractDetail.refuseReason.length>0) {
                        CGSize labelsize =[util calHeightForLabel:self.contractDetail.refuseReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                        height+=20+17+labelsize.height;
                    }
                }
                return height;
            }

        }
        
        
    }else{
        CGFloat height=95;
        if (self.contractDetail.remark.length>0) {
            CGSize labelsize1 = [util calHeightForLabel:self.contractDetail.remark width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:15]];
            height+=labelsize1.height;
        }
        if (self.contractDetail.attactmentsPaths.count>0) {
            int count=0;
            if (self.budgetArray.count>0) {
                count++;
            }
            if (self.clarificaitonArray.count>0) {
                count++;
            }
            if (self.attachmentArray.count>0) {
                count++;
            }
            if (self.otherArray.count>0) {
                count++;
            }
            height+=((kMainScreenWidth-30)*5/9+25+17)*count;
            if (self.contractDetail.changeReason.length>0) {
                CGSize labelsize =[util calHeightForLabel:self.contractDetail.changeReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                height+=20+17+labelsize.height;
            }
            if (self.contractDetail.refuseReason.length>0) {
                CGSize labelsize =[util calHeightForLabel:self.contractDetail.refuseReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                height+=20+17+labelsize.height;
            }
        }
        return height;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        NSString *const cellidentifier = [NSString stringWithFormat:@"ContractDetailCell%d",(int)indexPath.row];
        ContractDetailCell *cell = (ContractDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (!cell) {
            cell = [[ContractDetailCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
            cell.orderCode =self.orderCode;
            cell.couponNum =self.couponNum;
            if (self.preferential!=nil) {
                cell.preferential =self.preferential;
            }
            cell.contractDetail =self.contractDetail;
            cell.delegate =self;
            [cell getCellHeight];
        }else{
            cell.orderCode =self.orderCode;
            cell.couponNum =self.couponNum;
            if (self.preferential!=nil) {
                cell.preferential =self.preferential;
            }
            cell.contractDetail =self.contractDetail;
            [cell getCellHeight];
        }
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section ==1){
        NewOrderObject *orderObject;
        if (self.phaseOrders.count>0) {
            orderObject =[self.phaseOrders objectAtIndex:0];
            if (orderObject.phaseOrderCode.length>0) {
                NSString *const cellidentifier = [NSString stringWithFormat:@"ManageFeeCell%d",(int)indexPath.row];
                ManageFeeCell *cell = (ManageFeeCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
                if ([[orderObject.phaseOrderCode substringToIndex:1] isEqualToString:@"G"]){
                    if (!cell) {
                        cell = [[ManageFeeCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
                        cell.contractTotalFee =self.contractDetail.contractTotalFee;
                        cell.productProFee =self.contractDetail.productProFee;
                        cell.ppDiscount =self.contractDetail.ppDiscount;
                        cell.platformSuperFee =self.contractDetail.platformSuperFee;
                        cell.psDiscount =self.contractDetail.psDiscount;
                        cell.type =self.contractDetail.contractType;
                        cell.prefertial =self.preferential;
                        cell.orderObject =orderObject;
                        [cell getCellHeight];
                    }else{
                        cell.contractTotalFee =self.contractDetail.contractTotalFee;
                        cell.prefertial =self.preferential;
                        cell.orderObject =orderObject;
                        [cell getCellHeight];
                    }
                }else{
                    NewOrderObject *orderObject;
                    if (self.phaseOrders.count>indexPath.row+self.ismanager) {
                        orderObject =[self.phaseOrders objectAtIndex:indexPath.row+self.ismanager];
                    }
                    NSString *const CustomCellIdentifier = [NSString stringWithFormat:@"CustomCellIdentifier%d%d",(int)indexPath.section,(int)indexPath.row];
                    PhaseOrderCell *cell = (PhaseOrderCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
                    //            PhaseOrderCell *cell = (PhaseOrderCell*)[tableView cellForRowAtIndexPath:indexPath];
                    if (!cell) {
                        cell = [[PhaseOrderCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CustomCellIdentifier];
                        cell.engineering =self.contractDetail.orderFee;
                        if (indexPath.row==0) {
                            cell.isfirst =YES;
                            
                            cell.contractType =self.contractDetail.contractType;
                        }
                        cell.contractTotalFee =self.contractDetail.contractTotalFee;
                        cell.preferential =self.preferential;
                        cell.isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
                        cell.orderObject =orderObject;
                        [cell getCellHeight];
                    }else{
                        cell.contractTotalFee =self.contractDetail.contractTotalFee;
                        cell.engineering =self.contractDetail.orderFee;
                        if (indexPath.row==0) {
                            cell.isfirst =YES;
                        }
                        cell.contractType =self.contractDetail.contractType;
                        cell.preferential =self.preferential;
                        cell.isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
                        cell.orderObject =orderObject;
                        [cell getCellHeight];
                    }
                    cell.selectionStyle =UITableViewCellSelectionStyleNone;
                    return cell;
                }
                cell.selectionStyle =UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                if ([orderObject.phaseOrderName isEqualToString:@"监理服务费"]) {
                    NSString *const cellidentifier = [NSString stringWithFormat:@"ManageFeeCell%d",(int)indexPath.row];
                    ManageFeeCell *cell = (ManageFeeCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
                    if (!cell) {
                        cell = [[ManageFeeCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
                        cell.contractTotalFee =self.contractDetail.contractTotalFee;
                        cell.productProFee =self.contractDetail.productProFee;
                        cell.ppDiscount =self.contractDetail.ppDiscount;
                        cell.prefertial =self.preferential;
                        cell.platformSuperFee =self.contractDetail.platformSuperFee;
                        cell.psDiscount =self.contractDetail.psDiscount;
                        cell.type =self.contractDetail.contractType;
                        cell.orderObject =orderObject;
                        [cell getCellHeight];
                    }else{
                        cell.contractTotalFee =self.contractDetail.contractTotalFee;
                        cell.prefertial =self.preferential;
                        cell.orderObject =orderObject;
                        [cell getCellHeight];
                    }
                    cell.selectionStyle =UITableViewCellSelectionStyleNone;
                    return cell;
                }
                NewOrderObject *orderObject;
                if (self.phaseOrders.count>0) {
                    orderObject =[self.phaseOrders objectAtIndex:indexPath.row+self.ismanager];
                }
                NSString *const CustomCellIdentifier = [NSString stringWithFormat:@"CustomCellIdentifier%d%d",(int)indexPath.section,(int)indexPath.row];
                PhaseOrderCell *cell = (PhaseOrderCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
                //            PhaseOrderCell *cell = (PhaseOrderCell*)[tableView cellForRowAtIndexPath:indexPath];
                if (!cell) {
                    cell = [[PhaseOrderCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CustomCellIdentifier];
                    cell.orderObject =orderObject;
                    if (indexPath.row==0) {
                        cell.isfirst =YES;
                    }
                    cell.engineering =self.contractDetail.orderFee;
                    cell.contractType =self.contractDetail.contractType;
                    cell.preferential =self.preferential;
                    cell.contractTotalFee =self.contractDetail.contractTotalFee;
                    cell.isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
                    [cell getCellHeight];
                }else{
                    if (indexPath.row==0) {
                        cell.isfirst =YES;
                    }
                    cell.engineering =self.contractDetail.orderFee;
                    cell.contractType =self.contractDetail.contractType;
                    cell.preferential =self.preferential;
                    cell.orderObject =orderObject;
                    cell.contractTotalFee =self.contractDetail.contractTotalFee;
                    cell.isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
                    [cell getCellHeight];
                }
                cell.selectionStyle =UITableViewCellSelectionStyleNone;
                return cell;
            }
        }else{
            NSString *cellid=[NSString stringWithFormat:@"orderDetail_%d_%d",(int)indexPath.section,(int)indexPath.row];
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
            if (cell==nil) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
                UILabel *remarktitle =[[UILabel alloc] initWithFrame:CGRectZero];
                remarktitle.font =[UIFont systemFontOfSize:20.0];
                remarktitle.textColor =[UIColor colorWithHexString:@"#575757"];
                remarktitle.tag =100;
                [cell addSubview:remarktitle];
                
                UILabel *remark =[[UILabel alloc] initWithFrame:CGRectZero];
                remark.font =[UIFont systemFontOfSize:15.0];
                remark.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                remark.tag =101;
                remark.numberOfLines =0;
                [cell addSubview:remark];
                
                if (self.budgetArray.count>0) {
                    UILabel *budgettitle =[[UILabel alloc] initWithFrame:CGRectZero];
                    budgettitle.font =[UIFont systemFontOfSize:20.0];
                    budgettitle.textColor =[UIColor colorWithHexString:@"#575757"];
                    budgettitle.tag =102;
                    [cell addSubview:budgettitle];
                    
                    
                    UIImageView *budgetimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                    budgetimage.tag =103;
                    [cell addSubview:budgetimage];
                    budgetimage.userInteractionEnabled =YES;
                    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                    [budgetimage addGestureRecognizer:tap];
                    
                    UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                    backView.backgroundColor =[UIColor blackColor];
                    backView.alpha =0.5;
                    backView.tag =104;
                    backView.layer.masksToBounds = YES;
                    backView.layer.cornerRadius = 5;
                    [budgetimage addSubview:backView];
                    
                    UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                    imagecount.textColor =[UIColor whiteColor];
                    imagecount.font =[UIFont systemFontOfSize:12];
                    imagecount.tag =105;
                    imagecount.textAlignment =NSTextAlignmentCenter;
                    [backView addSubview:imagecount];
                    
                    UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                    pointimage.layer.cornerRadius=8;
                    pointimage.clipsToBounds=YES;
                    pointimage.tag =122;
                    [cell addSubview:pointimage];
                }
                if (self.clarificaitonArray.count>0) {
                    UILabel *clarificaitontitle =[[UILabel alloc] initWithFrame:CGRectZero];
                    clarificaitontitle.font =[UIFont systemFontOfSize:20.0];
                    clarificaitontitle.textColor =[UIColor colorWithHexString:@"#575757"];
                    clarificaitontitle.tag =106;
                    [cell addSubview:clarificaitontitle];
                    
                    
                    UIImageView *clarificaitonimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                    clarificaitonimage.tag =107;
                    [cell addSubview:clarificaitonimage];
                    clarificaitonimage.userInteractionEnabled =YES;
                    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                    [clarificaitonimage addGestureRecognizer:tap];
                    
                    UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                    backView.backgroundColor =[UIColor blackColor];
                    backView.alpha =0.5;
                    backView.tag =108;
                    backView.layer.masksToBounds = YES;
                    backView.layer.cornerRadius = 5;
                    [clarificaitonimage addSubview:backView];
                    
                    UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                    imagecount.textColor =[UIColor whiteColor];
                    imagecount.font =[UIFont systemFontOfSize:12];
                    imagecount.tag =109;
                    imagecount.textAlignment =NSTextAlignmentCenter;
                    [backView addSubview:imagecount];
                    
                    UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                    pointimage.layer.cornerRadius=8;
                    pointimage.clipsToBounds=YES;
                    pointimage.tag =123;
                    [cell addSubview:pointimage];
                }
                if (self.attachmentArray.count>0) {
                    UILabel *attachmenttitle =[[UILabel alloc] initWithFrame:CGRectZero];
                    attachmenttitle.font =[UIFont systemFontOfSize:20.0];
                    attachmenttitle.textColor =[UIColor colorWithHexString:@"#575757"];
                    attachmenttitle.tag =110;
                    [cell addSubview:attachmenttitle];
                    
                    
                    UIImageView *attachmentimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                    attachmentimage.tag =111;
                    [cell addSubview:attachmentimage];
                    attachmentimage.userInteractionEnabled =YES;
                    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                    [attachmentimage addGestureRecognizer:tap];
                    
                    UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                    backView.backgroundColor =[UIColor blackColor];
                    backView.alpha =0.5;
                    backView.tag =112;
                    backView.layer.masksToBounds = YES;
                    backView.layer.cornerRadius = 5;
                    [attachmentimage addSubview:backView];
                    
                    UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                    imagecount.textColor =[UIColor whiteColor];
                    imagecount.font =[UIFont systemFontOfSize:12];
                    imagecount.tag =113;
                    imagecount.textAlignment =NSTextAlignmentCenter;
                    [backView addSubview:imagecount];
                    
                    UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                    pointimage.layer.cornerRadius=8;
                    pointimage.clipsToBounds=YES;
                    pointimage.tag =124;
                    [cell addSubview:pointimage];
                }
                if (self.otherArray.count>0) {
                    UILabel *othertitle =[[UILabel alloc] initWithFrame:CGRectZero];
                    othertitle.font =[UIFont systemFontOfSize:20.0];
                    othertitle.textColor =[UIColor colorWithHexString:@"#575757"];
                    othertitle.tag =114;
                    [cell addSubview:othertitle];
                    
                    
                    UIImageView *otherimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                    otherimage.tag =115;
                    [cell addSubview:otherimage];
                    otherimage.userInteractionEnabled =YES;
                    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                    [otherimage addGestureRecognizer:tap];
                    
                    UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                    backView.backgroundColor =[UIColor blackColor];
                    backView.alpha =0.5;
                    backView.tag =116;
                    backView.layer.masksToBounds = YES;
                    backView.layer.cornerRadius = 5;
                    [otherimage addSubview:backView];
                    
                    UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                    imagecount.textColor =[UIColor whiteColor];
                    imagecount.font =[UIFont systemFontOfSize:12];
                    imagecount.tag =117;
                    imagecount.textAlignment =NSTextAlignmentCenter;
                    [backView addSubview:imagecount];
                    
                    UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                    pointimage.layer.cornerRadius=8;
                    pointimage.clipsToBounds=YES;
                    pointimage.tag =125;
                    [cell addSubview:pointimage];
                }
                if (self.contractDetail.changeReason.length>0) {
                    UILabel *changeReasontitle =[[UILabel alloc] initWithFrame:CGRectZero];
                    changeReasontitle.font =[UIFont systemFontOfSize:20.0];
                    changeReasontitle.textColor =[UIColor colorWithHexString:@"#575757"];
                    changeReasontitle.tag =118;
                    changeReasontitle.numberOfLines =0;
                    [cell addSubview:changeReasontitle];
                    
                    UILabel *changeReasonlbl =[[UILabel alloc] initWithFrame:CGRectZero];
                    changeReasonlbl.font =[UIFont systemFontOfSize:16];
                    changeReasonlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    changeReasonlbl.tag =119;
                    changeReasonlbl.numberOfLines =0;
                    [cell addSubview:changeReasonlbl];
                }
                
                if (self.contractDetail.refuseReason.length>0) {
                    UILabel *refuseResontitle =[[UILabel alloc] initWithFrame:CGRectZero];
                    refuseResontitle.font =[UIFont systemFontOfSize:20.0];
                    refuseResontitle.textColor =[UIColor colorWithHexString:@"#575757"];
                    refuseResontitle.tag =120;
                    refuseResontitle.numberOfLines =0;
                    [cell addSubview:refuseResontitle];
                    
                    UILabel *refuseResonlbl =[[UILabel alloc] initWithFrame:CGRectZero];
                    refuseResonlbl.font =[UIFont systemFontOfSize:16];
                    refuseResonlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    refuseResonlbl.tag =121;
                    refuseResonlbl.numberOfLines =0;
                    [cell addSubview:refuseResonlbl];
                }
            }
            CGFloat height=10;
            if (self.contractDetail.remark.length>0) {
                UILabel *remarktitle =(UILabel *)[cell viewWithTag:100];
                remarktitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                remarktitle.text =@"合同备注";
                height+=20;
                
                height+=15;
                CGSize labelsize1 = [util calHeightForLabel:self.contractDetail.remark width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:15]];
                UILabel *remark =(UILabel *)[cell viewWithTag:101];
                remark.frame =CGRectMake(15, height, labelsize1.width, labelsize1.height);
                remark.text =self.contractDetail.remark;
                height+=labelsize1.height;
                
                height+=15;
            }
            if (self.contractDetail.attactmentsPaths.count>0) {
                
                if (self.budgetArray.count>0) {
                    height+=17;
                    UILabel *budgettitle =(UILabel *)[cell viewWithTag:102];
                    UIImageView *budgetimage =(UIImageView *)[cell viewWithTag:103];
                    UIView *budgetbackView =[budgetimage viewWithTag:104];
                    UILabel *budgetimagecount =[budgetbackView viewWithTag:105];
                    
                    UIImageView *pointimage =(UIImageView *)[cell viewWithTag:122];
                    pointimage.backgroundColor =[UIColor redColor];
                    pointimage.frame =CGRectMake(15+60, height+3, 15, 15);
                    
                    
                    
                    budgettitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                    if (self.contractDetail.contractType ==4) {
                        budgettitle.text =@"预算单";
                    }else{
                        budgettitle.text =@"合同附件";
                        pointimage.frame =CGRectMake(15+80, height+3, 15, 15);
                    }
                    
                    height+=20;
                    
                    height+=15;
                    
                    budgetbackView.backgroundColor =[UIColor blackColor];
                    
                    budgetimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                    ContractAttchmentObject *attchment =[self.budgetArray objectAtIndex:0];
                    [budgetimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                    budgetimage.contentMode=UIViewContentModeScaleAspectFill;
                    budgetimage.clipsToBounds=YES;
                    
                    
                    BOOL ishide =YES;
                    for (ContractAttchmentObject *attchment1 in self.budgetArray) {
                        if (attchment1.state ==1) {
                            ishide =NO;
                        }
                    }
                    pointimage.hidden =ishide;

                    CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.budgetArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                    budgetbackView.frame =CGRectMake(budgetimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                    budgetimagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                    budgetimagecount.text =[NSString stringWithFormat:@"%d张",(int)self.budgetArray.count];
                    height+=(kMainScreenWidth-30)*5/9;
                }else{
                    UILabel *budgettitle =(UILabel *)[cell viewWithTag:102];
                    UIImageView *budgetimage =(UIImageView *)[cell viewWithTag:103];
                    UIView *budgetbackView =[budgetimage viewWithTag:104];
                    UILabel *budgetimagecount =[budgetbackView viewWithTag:105];
                    UIImageView *pointimage =(UIImageView *)[cell viewWithTag:122];
                    pointimage.hidden =YES;
                    budgettitle.text=@"";
                    budgetimage.image =nil;
                    budgetimagecount.text =@"";
                    budgetbackView.backgroundColor =[UIColor clearColor];
                }
                if (self.clarificaitonArray.count>0) {
                    height+=17;
                    UILabel *clarificaitontitle =(UILabel *)[cell viewWithTag:106];
                    UIImageView *clarificaitonimage =(UIImageView *)[cell viewWithTag:107];
                    UIView *clarificaitonbackView =[clarificaitonimage viewWithTag:108];
                    UILabel *clarificaitonimagecount =[clarificaitonbackView viewWithTag:109];
                    
                    clarificaitonbackView.backgroundColor =[UIColor blackColor];
                    
                    UIImageView *pointimage =(UIImageView *)[cell viewWithTag:123];
                    pointimage.backgroundColor =[UIColor redColor];
                    pointimage.frame =CGRectMake(15+60, height+3, 15, 15);
                    
                    clarificaitontitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                    clarificaitontitle.text =@"交底单";
                    height+=20;
                    
                    height+=15;
                    
                    
                    clarificaitonimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                    ContractAttchmentObject *attchment =[self.clarificaitonArray objectAtIndex:0];
                    [clarificaitonimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                    clarificaitonimage.contentMode=UIViewContentModeScaleAspectFill;
                    clarificaitonimage.clipsToBounds=YES;
                    
                    
                    BOOL ishide =YES;
                    for (ContractAttchmentObject *attchment1 in self.clarificaitonArray) {
                        if (attchment1.state ==1) {
                            ishide =NO;
                        }
                    }
                    pointimage.hidden =ishide;
                    
                    CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.clarificaitonArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                    clarificaitonbackView.frame =CGRectMake(clarificaitonimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                    clarificaitonimagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                    clarificaitonimagecount.text =[NSString stringWithFormat:@"%d张",(int)self.clarificaitonArray.count];
                    height+=(kMainScreenWidth-30)*5/9;
                }else{
                    UILabel *clarificaitontitle =(UILabel *)[cell viewWithTag:106];
                    UIImageView *clarificaitonimage =(UIImageView *)[cell viewWithTag:107];
                    UIView *clarificaitonbackView =[clarificaitonimage viewWithTag:108];
                    UILabel *clarificaitonimagecount =[clarificaitonbackView viewWithTag:109];
                    UIImageView *pointimage =(UIImageView *)[cell viewWithTag:123];
                    pointimage.hidden =YES;
                    clarificaitontitle.text=@"";
                    clarificaitonimage.image =nil;
                    clarificaitonimagecount.text =@"";
                    clarificaitonbackView.backgroundColor =[UIColor clearColor];
                }
                if (self.attachmentArray.count>0) {
                    height+=17;
                    UILabel *attachmenttitle =(UILabel *)[cell viewWithTag:110];
                    UIImageView *pointimage =(UIImageView *)[cell viewWithTag:124];
                    pointimage.backgroundColor =[UIColor redColor];
                    pointimage.frame =CGRectMake(15+80, height+3, 15, 15);
                    
                    
                    
                    attachmenttitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                    attachmenttitle.text =@"线下合同";
                    height+=20;
                    
                    height+=15;
                    
                    
                    UIImageView *attachmentimage =(UIImageView *)[cell viewWithTag:111];
                    attachmentimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                    ContractAttchmentObject *attchment =[self.attachmentArray objectAtIndex:0];
                    [attachmentimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                    attachmentimage.contentMode=UIViewContentModeScaleAspectFill;
                    attachmentimage.clipsToBounds=YES;
                    
                    
                    BOOL ishide =YES;
                    for (ContractAttchmentObject *attchment1 in self.attachmentArray) {
                        if (attchment1.state ==1) {
                            ishide =NO;
                        }
                    }
                    pointimage.hidden =ishide;
                    
                    UIView *backView =[attachmentimage viewWithTag:112];
                    backView.backgroundColor =[UIColor clearColor];
                    UILabel *imagecount =[backView viewWithTag:113];
                    CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.attachmentArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                    backView.frame =CGRectMake(attachmentimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                    imagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                    imagecount.text =[NSString stringWithFormat:@"%d张",(int)self.attachmentArray.count];
                    height+=(kMainScreenWidth-30)*5/9;
                }else{
                    UILabel *attachmenttitle =(UILabel *)[cell viewWithTag:110];
                    UIImageView *attachmentimage =(UIImageView *)[cell viewWithTag:111];
                    UIView *backView =[attachmentimage viewWithTag:112];
                    UILabel *imagecount =[backView viewWithTag:113];
                    UIImageView *pointimage =(UIImageView *)[cell viewWithTag:124];
                    pointimage.hidden =YES;
                    attachmenttitle.text=@"";
                    attachmentimage.image =nil;
                    imagecount.text =@"";
                    backView.backgroundColor =[UIColor clearColor];
                }
                if (self.otherArray.count>0) {
                    UILabel *othertitle =(UILabel *)[cell viewWithTag:114];
                    UIImageView *otherimage =(UIImageView *)[cell viewWithTag:115];
                    UIView *otherbackView =[otherimage viewWithTag:116];
                    height+=17;
                    UIImageView *pointimage =(UIImageView *)[cell viewWithTag:125];
                    pointimage.backgroundColor =[UIColor redColor];
                    pointimage.frame =CGRectMake(15+40, height+3, 15, 15);
                    
                    UILabel *otherimagecount =[otherbackView viewWithTag:117];
                    othertitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                    othertitle.text =@"其他";
                    otherbackView.backgroundColor =[UIColor blackColor];
                    height+=20;
                    
                    height+=15;
                    
                    
                    otherimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                    ContractAttchmentObject *attchment =[self.otherArray objectAtIndex:0];
                    [otherimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                    otherimage.contentMode=UIViewContentModeScaleAspectFill;
                    otherimage.clipsToBounds=YES;
                    
                    
                    BOOL ishide =YES;
                    for (ContractAttchmentObject *attchment1 in self.otherArray) {
                        if (attchment1.state ==1) {
                            ishide =NO;
                        }
                    }
                    pointimage.hidden =ishide;
                    
                    CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.otherArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                    otherbackView.frame =CGRectMake(otherimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                    otherimagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                    otherimagecount.text =[NSString stringWithFormat:@"%d张",(int)self.otherArray.count];
                    height+=(kMainScreenWidth-30)*5/9;
                }else{
                    UILabel *othertitle =(UILabel *)[cell viewWithTag:114];
                    UIImageView *otherimage =(UIImageView *)[cell viewWithTag:115];
                    UIView *otherbackView =[otherimage viewWithTag:116];
                    UILabel *otherimagecount =[otherbackView viewWithTag:117];
                    UIImageView *pointimage =(UIImageView *)[cell viewWithTag:125];
                    pointimage.hidden =YES;
                    othertitle.text=@"";
                    otherimage.image =nil;
                    otherimagecount.text =@"";
                    otherbackView.backgroundColor =[UIColor clearColor];
                }
                if (self.contractDetail.changeReason.length>0) {
                    height+=17;
                    UILabel *changeReasontitle =[cell viewWithTag:118];
                    changeReasontitle.text =@"附件变更理由";
                    changeReasontitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                    
                    height+=20;
                    
                    UILabel *changeReasonlbl =[cell viewWithTag:119];
                    CGSize labelsize =[util calHeightForLabel:self.contractDetail.changeReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                    changeReasonlbl.frame =CGRectMake(15, height, labelsize.width, labelsize.height);
                    changeReasonlbl.text =self.contractDetail.changeReason;
                    height+=labelsize.height;
                }else{
                    UILabel *changeReasontitle =[cell viewWithTag:118];
                    changeReasontitle.text =@"";
                    UILabel *changeReasonlbl =[cell viewWithTag:119];
                    changeReasonlbl.text =@"";
                }
                
                if (self.contractDetail.refuseReason.length>0) {
                    height+=17;
                    UILabel *refuseResontitle =[cell viewWithTag:120];
                    refuseResontitle.text =@"拒绝附件变更理由";
                    refuseResontitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                    
                    height+=20;
                    
                    UILabel *refuseResonlbl =[cell viewWithTag:121];
                    CGSize labelsize =[util calHeightForLabel:self.contractDetail.refuseReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                    refuseResonlbl.frame =CGRectMake(15, height, labelsize.width, labelsize.height);
                    refuseResonlbl.text =self.contractDetail.refuseReason;
                    height+=labelsize.height;
                }else{
                    UILabel *refuseResontitle =[cell viewWithTag:120];
                    refuseResontitle.text =@"";
                    UILabel *refuseResonlbl =[cell viewWithTag:121];
                    refuseResonlbl.text =@"";
                }
            }
            
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if (indexPath.section ==2){
        NewOrderObject *orderObject;
        if (self.phaseOrders.count>0) {
            orderObject =[self.phaseOrders objectAtIndex:0];
        }
        if (orderObject.phaseOrderCode.length>0) {
            if ([[orderObject.phaseOrderCode substringToIndex:1] isEqualToString:@"G"]) {
                NewOrderObject *orderObject =[self.phaseOrders objectAtIndex:indexPath.row+self.ismanager];
                NSString *const CustomCellIdentifier = [NSString stringWithFormat:@"CustomCellIdentifier%d%d",(int)indexPath.section,(int)indexPath.row];
                PhaseOrderCell *cell = (PhaseOrderCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
                //        PhaseOrderCell *cell = (PhaseOrderCell*)[tableView cellForRowAtIndexPath:indexPath];
                if (!cell) {
                    cell = [[PhaseOrderCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CustomCellIdentifier];
                    cell.orderObject =orderObject;
                    cell.contractTotalFee =self.contractDetail.contractTotalFee;
                    cell.preferential =self.preferential;
                    if (indexPath.row==0) {
                        cell.isfirst =YES;
                    }else{
                        cell.isfirst =NO;
                    }
                    cell.engineering =self.contractDetail.orderFee;
                    cell.contractType =self.contractDetail.contractType;
                    cell.isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
                    [cell getCellHeight];
                }else{
                    if (indexPath.row==0) {
                        cell.isfirst =YES;
                    }else{
                        cell.isfirst =NO;
                    }
                    cell.engineering =self.contractDetail.orderFee;
                    cell.contractType =self.contractDetail.contractType;
                    cell.contractTotalFee =self.contractDetail.contractTotalFee;
                    cell.preferential =self.preferential;
                    cell.orderObject =orderObject;
                    
                    cell.isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
                    [cell getCellHeight];
                }
                cell.selectionStyle =UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                NSString *cellid=[NSString stringWithFormat:@"orderDetail_%d_%d",(int)indexPath.section,(int)indexPath.row];
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
                if (cell==nil) {
                    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
                    UILabel *remarktitle =[[UILabel alloc] initWithFrame:CGRectZero];
                    remarktitle.font =[UIFont systemFontOfSize:20.0];
                    remarktitle.textColor =[UIColor colorWithHexString:@"#575757"];
                    remarktitle.tag =100;
                    [cell addSubview:remarktitle];
                    
                    UILabel *remark =[[UILabel alloc] initWithFrame:CGRectZero];
                    remark.font =[UIFont systemFontOfSize:15.0];
                    remark.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    remark.tag =101;
                    [cell addSubview:remark];
                    
                    if (self.budgetArray.count>0) {
                        UILabel *budgettitle =[[UILabel alloc] initWithFrame:CGRectZero];
                        budgettitle.font =[UIFont systemFontOfSize:20.0];
                        budgettitle.textColor =[UIColor colorWithHexString:@"#575757"];
                        budgettitle.tag =102;
                        [cell addSubview:budgettitle];
                        
                        
                        UIImageView *budgetimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        budgetimage.tag =103;
                        [cell addSubview:budgetimage];
                        budgetimage.userInteractionEnabled =YES;
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                        [budgetimage addGestureRecognizer:tap];
                        
                        UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                        backView.backgroundColor =[UIColor blackColor];
                        backView.alpha =0.5;
                        backView.tag =104;
                        backView.layer.masksToBounds = YES;
                        backView.layer.cornerRadius = 5;
                        [budgetimage addSubview:backView];
                        
                        UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                        imagecount.textColor =[UIColor whiteColor];
                        imagecount.font =[UIFont systemFontOfSize:12];
                        imagecount.tag =105;
                        imagecount.textAlignment =NSTextAlignmentCenter;
                        [backView addSubview:imagecount];
                        
                        UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        pointimage.layer.cornerRadius=8;
                        pointimage.clipsToBounds=YES;
                        pointimage.tag =122;
                        [cell addSubview:pointimage];
                    }
                    if (self.clarificaitonArray.count>0) {
                        UILabel *clarificaitontitle =[[UILabel alloc] initWithFrame:CGRectZero];
                        clarificaitontitle.font =[UIFont systemFontOfSize:20.0];
                        clarificaitontitle.textColor =[UIColor colorWithHexString:@"#575757"];
                        clarificaitontitle.tag =106;
                        [cell addSubview:clarificaitontitle];
                        
                        
                        UIImageView *clarificaitonimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        clarificaitonimage.tag =107;
                        [cell addSubview:clarificaitonimage];
                        clarificaitonimage.userInteractionEnabled =YES;
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                        [clarificaitonimage addGestureRecognizer:tap];
                        
                        UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                        backView.backgroundColor =[UIColor blackColor];
                        backView.alpha =0.5;
                        backView.tag =108;
                        backView.layer.masksToBounds = YES;
                        backView.layer.cornerRadius = 5;
                        [clarificaitonimage addSubview:backView];
                        
                        UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                        imagecount.textColor =[UIColor whiteColor];
                        imagecount.font =[UIFont systemFontOfSize:12];
                        imagecount.tag =109;
                        imagecount.textAlignment =NSTextAlignmentCenter;
                        [backView addSubview:imagecount];
                        
                        UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        pointimage.layer.cornerRadius=8;
                        pointimage.clipsToBounds=YES;
                        pointimage.tag =123;
                        [cell addSubview:pointimage];
                    }
                    if (self.attachmentArray.count>0) {
                        UILabel *attachmenttitle =[[UILabel alloc] initWithFrame:CGRectZero];
                        attachmenttitle.font =[UIFont systemFontOfSize:20.0];
                        attachmenttitle.textColor =[UIColor colorWithHexString:@"#575757"];
                        attachmenttitle.tag =110;
                        [cell addSubview:attachmenttitle];
                        
                        
                        UIImageView *attachmentimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        attachmentimage.tag =111;
                        [cell addSubview:attachmentimage];
                        attachmentimage.userInteractionEnabled =YES;
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                        [attachmentimage addGestureRecognizer:tap];
                        
                        UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                        backView.backgroundColor =[UIColor blackColor];
                        backView.alpha =0.5;
                        backView.tag =112;
                        backView.layer.masksToBounds = YES;
                        backView.layer.cornerRadius = 5;
                        [attachmentimage addSubview:backView];
                        
                        UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                        imagecount.textColor =[UIColor whiteColor];
                        imagecount.font =[UIFont systemFontOfSize:12];
                        imagecount.tag =113;
                        imagecount.textAlignment =NSTextAlignmentCenter;
                        [backView addSubview:imagecount];
                        
                        UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        pointimage.layer.cornerRadius=8;
                        pointimage.clipsToBounds=YES;
                        pointimage.tag =124;
                        [cell addSubview:pointimage];
                    }
                    if (self.otherArray.count>0) {
                        UILabel *othertitle =[[UILabel alloc] initWithFrame:CGRectZero];
                        othertitle.font =[UIFont systemFontOfSize:20.0];
                        othertitle.textColor =[UIColor colorWithHexString:@"#575757"];
                        othertitle.tag =114;
                        [cell addSubview:othertitle];
                        
                        
                        UIImageView *otherimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        otherimage.tag =115;
                        [cell addSubview:otherimage];
                        otherimage.userInteractionEnabled =YES;
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                        [otherimage addGestureRecognizer:tap];
                        
                        UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                        backView.backgroundColor =[UIColor blackColor];
                        backView.alpha =0.5;
                        backView.tag =116;
                        backView.layer.masksToBounds = YES;
                        backView.layer.cornerRadius = 5;
                        [otherimage addSubview:backView];
                        
                        UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                        imagecount.textColor =[UIColor whiteColor];
                        imagecount.font =[UIFont systemFontOfSize:12];
                        imagecount.tag =117;
                        imagecount.textAlignment =NSTextAlignmentCenter;
                        [backView addSubview:imagecount];
                        
                        UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        pointimage.layer.cornerRadius=8;
                        pointimage.clipsToBounds=YES;
                        pointimage.tag =125;
                        [cell addSubview:pointimage];
                    }
                    if (self.contractDetail.changeReason.length>0) {
                        UILabel *changeReasontitle =[[UILabel alloc] initWithFrame:CGRectZero];
                        changeReasontitle.font =[UIFont systemFontOfSize:20.0];
                        changeReasontitle.textColor =[UIColor colorWithHexString:@"#575757"];
                        changeReasontitle.tag =118;
                        changeReasontitle.numberOfLines =0;
                        [cell addSubview:changeReasontitle];
                        
                        UILabel *changeReasonlbl =[[UILabel alloc] initWithFrame:CGRectZero];
                        changeReasonlbl.font =[UIFont systemFontOfSize:16];
                        changeReasonlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        changeReasonlbl.tag =119;
                        changeReasonlbl.numberOfLines =0;
                        [cell addSubview:changeReasonlbl];
                    }
                    
                    if (self.contractDetail.refuseReason.length>0) {
                        UILabel *refuseResontitle =[[UILabel alloc] initWithFrame:CGRectZero];
                        refuseResontitle.font =[UIFont systemFontOfSize:20.0];
                        refuseResontitle.textColor =[UIColor colorWithHexString:@"#575757"];
                        refuseResontitle.tag =120;
                        refuseResontitle.numberOfLines =0;
                        [cell addSubview:refuseResontitle];
                        
                        UILabel *refuseResonlbl =[[UILabel alloc] initWithFrame:CGRectZero];
                        refuseResonlbl.font =[UIFont systemFontOfSize:16];
                        refuseResonlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        refuseResonlbl.tag =121;
                        refuseResonlbl.numberOfLines =0;
                        [cell addSubview:refuseResonlbl];
                    }
//                    UILabel *attachmenttitle =[[UILabel alloc] initWithFrame:CGRectZero];
//                    attachmenttitle.font =[UIFont systemFontOfSize:20.0];
//                    attachmenttitle.textColor =[UIColor colorWithHexString:@"#575757"];
//                    attachmenttitle.tag =102;
//                    [cell addSubview:attachmenttitle];
//                    
//                    
//                    UIImageView *attachmentimage =[[UIImageView alloc] initWithFrame:CGRectZero];
//                    attachmentimage.tag =103;
//                    [cell addSubview:attachmentimage];
//                    attachmentimage.userInteractionEnabled =YES;
//                    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//                    [attachmentimage addGestureRecognizer:tap];
                }
                CGFloat height=10;
                if (self.contractDetail.remark.length>0) {
                    UILabel *remarktitle =(UILabel *)[cell viewWithTag:100];
                    remarktitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                    remarktitle.text =@"合同备注";
                    height+=20;
                    
                    height+=15;
                    CGSize labelsize1 = [util calHeightForLabel:self.contractDetail.remark width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:15]];
                    UILabel *remark =(UILabel *)[cell viewWithTag:101];
                    remark.frame =CGRectMake(15, height, labelsize1.width, labelsize1.height);
                    remark.text =self.contractDetail.remark;
                    height+=labelsize1.height;
                    
                    height+=15;
                }
                if (self.contractDetail.attactmentsPaths.count>0) {
                    if (self.budgetArray.count>0) {
                        height+=17;
                        UILabel *budgettitle =(UILabel *)[cell viewWithTag:102];
                        UIImageView *budgetimage =(UIImageView *)[cell viewWithTag:103];
                        UIView *budgetbackView =[budgetimage viewWithTag:104];
                        UILabel *budgetimagecount =[budgetbackView viewWithTag:105];
                        
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:122];
                        pointimage.backgroundColor =[UIColor redColor];
                        pointimage.frame =CGRectMake(15+60, height+3, 15, 15);
                        
                        
                        
                        budgettitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                        if (self.contractDetail.contractType ==4) {
                            budgettitle.text =@"预算单";
                        }else{
                            budgettitle.text =@"合同附件";
                            pointimage.frame =CGRectMake(15+80, height+3, 15, 15);
                        }
                        
                        height+=20;
                        
                        height+=15;
                        
                        budgetbackView.backgroundColor =[UIColor blackColor];
                        
                        budgetimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                        ContractAttchmentObject *attchment =[self.budgetArray objectAtIndex:0];
                        [budgetimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                        budgetimage.contentMode=UIViewContentModeScaleAspectFill;
                        budgetimage.clipsToBounds=YES;
                        
                        
                        BOOL ishide =YES;
                        for (ContractAttchmentObject *attchment1 in self.budgetArray) {
                            if (attchment1.state ==1) {
                                ishide =NO;
                            }
                        }
                        pointimage.hidden =ishide;
                        
                        CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.budgetArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                        budgetbackView.frame =CGRectMake(budgetimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                        budgetimagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                        budgetimagecount.text =[NSString stringWithFormat:@"%d张",(int)self.budgetArray.count];
                        height+=(kMainScreenWidth-30)*5/9;
                    }else{
                        UILabel *budgettitle =(UILabel *)[cell viewWithTag:102];
                        UIImageView *budgetimage =(UIImageView *)[cell viewWithTag:103];
                        UIView *budgetbackView =[budgetimage viewWithTag:104];
                        UILabel *budgetimagecount =[budgetbackView viewWithTag:105];
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:122];
                        pointimage.hidden =YES;
                        budgettitle.text=@"";
                        budgetimage.image =nil;
                        budgetimagecount.text =@"";
                        budgetbackView.backgroundColor =[UIColor clearColor];
                    }
                    if (self.clarificaitonArray.count>0) {
                        height+=17;
                        UILabel *clarificaitontitle =(UILabel *)[cell viewWithTag:106];
                        UIImageView *clarificaitonimage =(UIImageView *)[cell viewWithTag:107];
                        UIView *clarificaitonbackView =[clarificaitonimage viewWithTag:108];
                        UILabel *clarificaitonimagecount =[clarificaitonbackView viewWithTag:109];
                        
                        clarificaitonbackView.backgroundColor =[UIColor blackColor];
                        
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:123];
                        pointimage.backgroundColor =[UIColor redColor];
                        pointimage.frame =CGRectMake(15+60, height+3, 15, 15);
                        
                        clarificaitontitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                        clarificaitontitle.text =@"交底单";
                        height+=20;
                        
                        height+=15;
                        
                        
                        clarificaitonimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                        ContractAttchmentObject *attchment =[self.clarificaitonArray objectAtIndex:0];
                        [clarificaitonimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                        clarificaitonimage.contentMode=UIViewContentModeScaleAspectFill;
                        clarificaitonimage.clipsToBounds=YES;
                        
                        
                        BOOL ishide =YES;
                        for (ContractAttchmentObject *attchment1 in self.clarificaitonArray) {
                            if (attchment1.state ==1) {
                                ishide =NO;
                            }
                        }
                        pointimage.hidden =ishide;
                        
                        CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.clarificaitonArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                        clarificaitonbackView.frame =CGRectMake(clarificaitonimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                        clarificaitonimagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                        clarificaitonimagecount.text =[NSString stringWithFormat:@"%d张",(int)self.clarificaitonArray.count];
                        height+=(kMainScreenWidth-30)*5/9;
                    }else{
                        UILabel *clarificaitontitle =(UILabel *)[cell viewWithTag:106];
                        UIImageView *clarificaitonimage =(UIImageView *)[cell viewWithTag:107];
                        UIView *clarificaitonbackView =[clarificaitonimage viewWithTag:108];
                        UILabel *clarificaitonimagecount =[clarificaitonbackView viewWithTag:109];
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:123];
                        pointimage.hidden =YES;
                        clarificaitontitle.text=@"";
                        clarificaitonimage.image =nil;
                        clarificaitonimagecount.text =@"";
                        clarificaitonbackView.backgroundColor =[UIColor clearColor];
                    }
                    if (self.attachmentArray.count>0) {
                        height+=17;
                        UILabel *attachmenttitle =(UILabel *)[cell viewWithTag:110];
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:124];
                        pointimage.backgroundColor =[UIColor redColor];
                        pointimage.frame =CGRectMake(15+80, height+3, 15, 15);
                        
                        
                        
                        attachmenttitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                        attachmenttitle.text =@"线下合同";
                        height+=20;
                        
                        height+=15;
                        
                        
                        UIImageView *attachmentimage =(UIImageView *)[cell viewWithTag:111];
                        attachmentimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                        ContractAttchmentObject *attchment =[self.attachmentArray objectAtIndex:0];
                        [attachmentimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                        attachmentimage.contentMode=UIViewContentModeScaleAspectFill;
                        attachmentimage.clipsToBounds=YES;
                        
                        
                        BOOL ishide =YES;
                        for (ContractAttchmentObject *attchment1 in self.attachmentArray) {
                            if (attchment1.state ==1) {
                                ishide =NO;
                            }
                        }
                        pointimage.hidden =ishide;
                        
                        UIView *backView =[attachmentimage viewWithTag:112];
                        backView.backgroundColor =[UIColor clearColor];
                        UILabel *imagecount =[backView viewWithTag:113];
                        CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.attachmentArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                        backView.frame =CGRectMake(attachmentimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                        imagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                        imagecount.text =[NSString stringWithFormat:@"%d张",(int)self.attachmentArray.count];
                        height+=(kMainScreenWidth-30)*5/9;
                    }else{
                        UILabel *attachmenttitle =(UILabel *)[cell viewWithTag:110];
                        UIImageView *attachmentimage =(UIImageView *)[cell viewWithTag:111];
                        UIView *backView =[attachmentimage viewWithTag:112];
                        UILabel *imagecount =[backView viewWithTag:113];
                        
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:124];
                        pointimage.hidden =YES;
                        attachmenttitle.text=@"";
                        attachmentimage.image =nil;
                        imagecount.text =@"";
                        backView.backgroundColor =[UIColor clearColor];
                    }
                    if (self.otherArray.count>0) {
                        UILabel *othertitle =(UILabel *)[cell viewWithTag:114];
                        UIImageView *otherimage =(UIImageView *)[cell viewWithTag:115];
                        UIView *otherbackView =[otherimage viewWithTag:116];
                        height+=17;
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:125];
                        pointimage.backgroundColor =[UIColor redColor];
                        pointimage.frame =CGRectMake(15+40, height+3, 15, 15);
                        
                        UILabel *otherimagecount =[otherbackView viewWithTag:117];
                        othertitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                        othertitle.text =@"其他";
                        otherbackView.backgroundColor =[UIColor blackColor];
                        height+=20;
                        
                        height+=15;
                        
                        
                        otherimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                        ContractAttchmentObject *attchment =[self.otherArray objectAtIndex:0];
                        [otherimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                        otherimage.contentMode=UIViewContentModeScaleAspectFill;
                        otherimage.clipsToBounds=YES;
                        
                        
                        BOOL ishide =YES;
                        for (ContractAttchmentObject *attchment1 in self.otherArray) {
                            if (attchment1.state ==1) {
                                ishide =NO;
                            }
                        }
                        pointimage.hidden =ishide;
                        
                        CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.otherArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                        otherbackView.frame =CGRectMake(otherimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                        otherimagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                        otherimagecount.text =[NSString stringWithFormat:@"%d张",(int)self.otherArray.count];
                        height+=(kMainScreenWidth-30)*5/9;
                    }else{
                        UILabel *othertitle =(UILabel *)[cell viewWithTag:114];
                        UIImageView *otherimage =(UIImageView *)[cell viewWithTag:115];
                        UIView *otherbackView =[otherimage viewWithTag:116];
                        UILabel *otherimagecount =[otherbackView viewWithTag:117];
                        
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:125];
                        pointimage.hidden =YES;
                        othertitle.text=@"";
                        otherimage.image =nil;
                        otherimagecount.text =@"";
                        otherbackView.backgroundColor =[UIColor clearColor];
                    }
                    if (self.contractDetail.changeReason.length>0) {
                        height+=17;
                        UILabel *changeReasontitle =[cell viewWithTag:118];
                        changeReasontitle.text =@"附件变更理由";
                        changeReasontitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                        
                        height+=20;
                        
                        UILabel *changeReasonlbl =[cell viewWithTag:119];
                        CGSize labelsize =[util calHeightForLabel:self.contractDetail.changeReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                        changeReasonlbl.frame =CGRectMake(15, height, labelsize.width, labelsize.height);
                        changeReasonlbl.text =self.contractDetail.changeReason;
                        height+=labelsize.height;
                    }else{
                        UILabel *changeReasontitle =[cell viewWithTag:118];
                        changeReasontitle.text =@"";
                        UILabel *changeReasonlbl =[cell viewWithTag:119];
                        changeReasonlbl.text =@"";
                    }
                    
                    if (self.contractDetail.refuseReason.length>0) {
                        height+=17;
                        UILabel *refuseResontitle =[cell viewWithTag:120];
                        refuseResontitle.text =@"拒绝附件变更理由";
                        refuseResontitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                        
                        height+=20;
                        
                        UILabel *refuseResonlbl =[cell viewWithTag:121];
                        CGSize labelsize =[util calHeightForLabel:self.contractDetail.refuseReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                        refuseResonlbl.frame =CGRectMake(15, height, labelsize.width, labelsize.height);
                        refuseResonlbl.text =self.contractDetail.refuseReason;
                        height+=labelsize.height;
                    }else{
                        UILabel *refuseResontitle =[cell viewWithTag:120];
                        refuseResontitle.text =@"";
                        UILabel *refuseResonlbl =[cell viewWithTag:121];
                        refuseResonlbl.text =@"";
                    }
                }
                cell.selectionStyle =UITableViewCellSelectionStyleNone;
                return cell;
            }
        
            
        }else{
            if ([orderObject.phaseOrderName isEqualToString:@"监理服务费"]){
                NewOrderObject *orderObject =[self.phaseOrders objectAtIndex:indexPath.row+self.ismanager];
                NSString *const CustomCellIdentifier = [NSString stringWithFormat:@"CustomCellIdentifier%d%d",(int)indexPath.section,(int)indexPath.row];
                PhaseOrderCell *cell = (PhaseOrderCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
                //        PhaseOrderCell *cell = (PhaseOrderCell*)[tableView cellForRowAtIndexPath:indexPath];
                if (!cell) {
                    cell = [[PhaseOrderCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CustomCellIdentifier];
                    cell.orderObject =orderObject;
                    cell.contractTotalFee =self.contractDetail.contractTotalFee;
                    cell.preferential =self.preferential;
                    if (indexPath.row==0) {
                        cell.isfirst =YES;
                    }else{
                        cell.isfirst =NO;
                    }
                    cell.engineering =self.contractDetail.orderFee;
                    cell.contractType =self.contractDetail.contractType;
                    cell.isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
                    [cell getCellHeight];
                }else{
                    if (indexPath.row==0) {
                        cell.isfirst =YES;
                    }else{
                        cell.isfirst =NO;
                    }
                    cell.engineering =self.contractDetail.orderFee;
                    cell.contractType =self.contractDetail.contractType;
                    cell.contractTotalFee =self.contractDetail.contractTotalFee;
                    cell.preferential =self.preferential;
                    cell.orderObject =orderObject;
                    
                    cell.isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
                    [cell getCellHeight];
                }
                cell.selectionStyle =UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                NSString *cellid=[NSString stringWithFormat:@"orderDetail_%d_%d",(int)indexPath.section,(int)indexPath.row];
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
                if (cell==nil) {
                    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
                    UILabel *remarktitle =[[UILabel alloc] initWithFrame:CGRectZero];
                    remarktitle.font =[UIFont systemFontOfSize:20.0];
                    remarktitle.textColor =[UIColor colorWithHexString:@"#575757"];
                    remarktitle.tag =100;
                    [cell addSubview:remarktitle];
                    
                    UILabel *remark =[[UILabel alloc] initWithFrame:CGRectZero];
                    remark.font =[UIFont systemFontOfSize:15.0];
                    remark.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    remark.tag =101;
                    remark.numberOfLines =0;
                    [cell addSubview:remark];
                    
                    
//                    UILabel *attachmenttitle =[[UILabel alloc] initWithFrame:CGRectZero];
//                    attachmenttitle.font =[UIFont systemFontOfSize:20.0];
//                    attachmenttitle.textColor =[UIColor colorWithHexString:@"#575757"];
//                    attachmenttitle.tag =102;
//                    [cell addSubview:attachmenttitle];
                    
                    if (self.budgetArray.count>0) {
                        UILabel *budgettitle =[[UILabel alloc] initWithFrame:CGRectZero];
                        budgettitle.font =[UIFont systemFontOfSize:20.0];
                        budgettitle.textColor =[UIColor colorWithHexString:@"#575757"];
                        budgettitle.tag =102;
                        [cell addSubview:budgettitle];
                        
                        
                        UIImageView *budgetimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        budgetimage.tag =103;
                        [cell addSubview:budgetimage];
                        budgetimage.userInteractionEnabled =YES;
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                        [budgetimage addGestureRecognizer:tap];
                        
                        UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                        backView.backgroundColor =[UIColor blackColor];
                        backView.alpha =0.5;
                        backView.tag =104;
                        backView.layer.masksToBounds = YES;
                        backView.layer.cornerRadius = 5;
                        [budgetimage addSubview:backView];
                        
                        UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                        imagecount.textColor =[UIColor whiteColor];
                        imagecount.font =[UIFont systemFontOfSize:12];
                        imagecount.tag =105;
                        imagecount.textAlignment =NSTextAlignmentCenter;
                        [backView addSubview:imagecount];
                        
                        UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        pointimage.layer.cornerRadius=8;
                        pointimage.clipsToBounds=YES;
                        pointimage.tag =122;
                        [cell addSubview:pointimage];
                    }
                    if (self.clarificaitonArray.count>0) {
                        UILabel *clarificaitontitle =[[UILabel alloc] initWithFrame:CGRectZero];
                        clarificaitontitle.font =[UIFont systemFontOfSize:20.0];
                        clarificaitontitle.textColor =[UIColor colorWithHexString:@"#575757"];
                        clarificaitontitle.tag =106;
                        [cell addSubview:clarificaitontitle];
                        
                        
                        UIImageView *clarificaitonimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        clarificaitonimage.tag =107;
                        [cell addSubview:clarificaitonimage];
                        clarificaitonimage.userInteractionEnabled =YES;
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                        [clarificaitonimage addGestureRecognizer:tap];
                        
                        UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                        backView.backgroundColor =[UIColor blackColor];
                        backView.alpha =0.5;
                        backView.tag =108;
                        backView.layer.masksToBounds = YES;
                        backView.layer.cornerRadius = 5;
                        [clarificaitonimage addSubview:backView];
                        
                        UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                        imagecount.textColor =[UIColor whiteColor];
                        imagecount.font =[UIFont systemFontOfSize:12];
                        imagecount.tag =109;
                        imagecount.textAlignment =NSTextAlignmentCenter;
                        [backView addSubview:imagecount];
                        
                        UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        pointimage.layer.cornerRadius=8;
                        pointimage.clipsToBounds=YES;
                        pointimage.tag =123;
                        [cell addSubview:pointimage];
                    }
                    if (self.attachmentArray.count>0) {
                        UILabel *attachmenttitle =[[UILabel alloc] initWithFrame:CGRectZero];
                        attachmenttitle.font =[UIFont systemFontOfSize:20.0];
                        attachmenttitle.textColor =[UIColor colorWithHexString:@"#575757"];
                        attachmenttitle.tag =110;
                        [cell addSubview:attachmenttitle];
                        
                        
                        UIImageView *attachmentimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        attachmentimage.tag =111;
                        [cell addSubview:attachmentimage];
                        attachmentimage.userInteractionEnabled =YES;
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                        [attachmentimage addGestureRecognizer:tap];
                        
                        UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                        backView.backgroundColor =[UIColor blackColor];
                        backView.alpha =0.5;
                        backView.tag =112;
                        backView.layer.masksToBounds = YES;
                        backView.layer.cornerRadius = 5;
                        [attachmentimage addSubview:backView];
                        
                        UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                        imagecount.textColor =[UIColor whiteColor];
                        imagecount.font =[UIFont systemFontOfSize:12];
                        imagecount.tag =113;
                        imagecount.textAlignment =NSTextAlignmentCenter;
                        [backView addSubview:imagecount];
                        
                        UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        pointimage.layer.cornerRadius=8;
                        pointimage.clipsToBounds=YES;
                        pointimage.tag =124;
                        [cell addSubview:pointimage];
                    }
                    if (self.otherArray.count>0) {
                        UILabel *othertitle =[[UILabel alloc] initWithFrame:CGRectZero];
                        othertitle.font =[UIFont systemFontOfSize:20.0];
                        othertitle.textColor =[UIColor colorWithHexString:@"#575757"];
                        othertitle.tag =114;
                        [cell addSubview:othertitle];
                        
                        
                        UIImageView *otherimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        otherimage.tag =115;
                        [cell addSubview:otherimage];
                        otherimage.userInteractionEnabled =YES;
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                        [otherimage addGestureRecognizer:tap];
                        
                        UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                        backView.backgroundColor =[UIColor blackColor];
                        backView.alpha =0.5;
                        backView.tag =116;
                        backView.layer.masksToBounds = YES;
                        backView.layer.cornerRadius = 5;
                        [otherimage addSubview:backView];
                        
                        UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                        imagecount.textColor =[UIColor whiteColor];
                        imagecount.font =[UIFont systemFontOfSize:12];
                        imagecount.tag =117;
                        imagecount.textAlignment =NSTextAlignmentCenter;
                        [backView addSubview:imagecount];
                        
                        UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                        pointimage.layer.cornerRadius=8;
                        pointimage.clipsToBounds=YES;
                        pointimage.tag =125;
                        [cell addSubview:pointimage];
                    }
                    if (self.contractDetail.changeReason.length>0) {
                        UILabel *changeReasontitle =[[UILabel alloc] initWithFrame:CGRectZero];
                        changeReasontitle.font =[UIFont systemFontOfSize:20.0];
                        changeReasontitle.textColor =[UIColor colorWithHexString:@"#575757"];
                        changeReasontitle.tag =118;
                        changeReasontitle.numberOfLines =0;
                        [cell addSubview:changeReasontitle];
                        
                        UILabel *changeReasonlbl =[[UILabel alloc] initWithFrame:CGRectZero];
                        changeReasonlbl.font =[UIFont systemFontOfSize:16];
                        changeReasonlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        changeReasonlbl.tag =119;
                        changeReasonlbl.numberOfLines =0;
                        [cell addSubview:changeReasonlbl];
                    }
                    
                    if (self.contractDetail.refuseReason.length>0) {
                        UILabel *refuseResontitle =[[UILabel alloc] initWithFrame:CGRectZero];
                        refuseResontitle.font =[UIFont systemFontOfSize:20.0];
                        refuseResontitle.textColor =[UIColor colorWithHexString:@"#575757"];
                        refuseResontitle.tag =120;
                        refuseResontitle.numberOfLines =0;
                        [cell addSubview:refuseResontitle];
                        
                        UILabel *refuseResonlbl =[[UILabel alloc] initWithFrame:CGRectZero];
                        refuseResonlbl.font =[UIFont systemFontOfSize:16];
                        refuseResonlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        refuseResonlbl.tag =121;
                        refuseResonlbl.numberOfLines =0;
                        [cell addSubview:refuseResonlbl];
                    }
//                    UIImageView *attachmentimage =[[UIImageView alloc] initWithFrame:CGRectZero];
//                    attachmentimage.tag =103;
//                    [cell addSubview:attachmentimage];
//                    attachmentimage.userInteractionEnabled =YES;
//                    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//                    [attachmentimage addGestureRecognizer:tap];
//                    
//                    UIView *backView =[cell viewWithTag:104];
//                    UILabel *imagecount =[backView viewWithTag:105];
//                    CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.contractDetail.attactmentsPaths.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
//                    backView.frame =CGRectMake(attachmentimage.frame.size.width-labelsize2.width+10, 5, labelsize2.width+10, labelsize2.height+10);
//                    imagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
//                    imagecount.text =[NSString stringWithFormat:@"%d张",(int)self.contractDetail.attactmentsPaths.count];
                }
                CGFloat height=10;
                if (self.contractDetail.remark.length>0) {
                    UILabel *remarktitle =(UILabel *)[cell viewWithTag:100];
                    remarktitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                    remarktitle.text =@"合同备注";
                    height+=20;
                    
                    height+=15;
                    CGSize labelsize1 = [util calHeightForLabel:self.contractDetail.remark width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:15]];
                    UILabel *remark =(UILabel *)[cell viewWithTag:101];
                    remark.frame =CGRectMake(15, height, labelsize1.width, labelsize1.height);
                    remark.text =self.contractDetail.remark;
                    height+=labelsize1.height;
                    
                    height+=15;
                }
                if (self.contractDetail.attactmentsPaths.count>0) {
                    if (self.budgetArray.count>0) {
                        height+=17;
                        UILabel *budgettitle =(UILabel *)[cell viewWithTag:102];
                        UIImageView *budgetimage =(UIImageView *)[cell viewWithTag:103];
                        UIView *budgetbackView =[budgetimage viewWithTag:104];
                        UILabel *budgetimagecount =[budgetbackView viewWithTag:105];
                        
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:122];
                        pointimage.backgroundColor =[UIColor redColor];
                        pointimage.frame =CGRectMake(15+60, height+3, 15, 15);
                        
                        
                        
                        budgettitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                        if (self.contractDetail.contractType ==4) {
                            budgettitle.text =@"预算单";
                        }else{
                            budgettitle.text =@"合同附件";
                            pointimage.frame =CGRectMake(15+80, height+3, 15, 15);
                        }
                        
                        height+=20;
                        
                        height+=15;
                        
                        budgetbackView.backgroundColor =[UIColor blackColor];
                        
                        budgetimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                        ContractAttchmentObject *attchment =[self.budgetArray objectAtIndex:0];
                        [budgetimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                        budgetimage.contentMode=UIViewContentModeScaleAspectFill;
                        budgetimage.clipsToBounds=YES;
                        
                        
                        BOOL ishide =YES;
                        for (ContractAttchmentObject *attchment1 in self.budgetArray) {
                            if (attchment1.state ==1) {
                                ishide =NO;
                            }
                        }
                        pointimage.hidden =ishide;
                        
                        CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.budgetArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                        budgetbackView.frame =CGRectMake(budgetimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                        budgetimagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                        budgetimagecount.text =[NSString stringWithFormat:@"%d张",(int)self.budgetArray.count];
                        height+=(kMainScreenWidth-30)*5/9;
                    }else{
                        UILabel *budgettitle =(UILabel *)[cell viewWithTag:102];
                        UIImageView *budgetimage =(UIImageView *)[cell viewWithTag:103];
                        UIView *budgetbackView =[budgetimage viewWithTag:104];
                        UILabel *budgetimagecount =[budgetbackView viewWithTag:105];
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:122];
                        pointimage.hidden =YES;
                        budgettitle.text=@"";
                        budgetimage.image =nil;
                        budgetimagecount.text =@"";
                        budgetbackView.backgroundColor =[UIColor clearColor];
                    }
                    if (self.clarificaitonArray.count>0) {
                        height+=17;
                        UILabel *clarificaitontitle =(UILabel *)[cell viewWithTag:106];
                        UIImageView *clarificaitonimage =(UIImageView *)[cell viewWithTag:107];
                        UIView *clarificaitonbackView =[clarificaitonimage viewWithTag:108];
                        UILabel *clarificaitonimagecount =[clarificaitonbackView viewWithTag:109];
                        
                        clarificaitonbackView.backgroundColor =[UIColor blackColor];
                        
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:123];
                        pointimage.backgroundColor =[UIColor redColor];
                        pointimage.frame =CGRectMake(15+60, height+3, 15, 15);
                        
                        clarificaitontitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                        clarificaitontitle.text =@"交底单";
                        height+=20;
                        
                        height+=15;
                        
                        
                        clarificaitonimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                        ContractAttchmentObject *attchment =[self.clarificaitonArray objectAtIndex:0];
                        [clarificaitonimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                        clarificaitonimage.contentMode=UIViewContentModeScaleAspectFill;
                        clarificaitonimage.clipsToBounds=YES;
                        
                        
                        BOOL ishide =YES;
                        for (ContractAttchmentObject *attchment1 in self.clarificaitonArray) {
                            if (attchment1.state ==1) {
                                ishide =NO;
                            }
                        }
                        pointimage.hidden =ishide;
                        
                        CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.clarificaitonArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                        clarificaitonbackView.frame =CGRectMake(clarificaitonimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                        clarificaitonimagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                        clarificaitonimagecount.text =[NSString stringWithFormat:@"%d张",(int)self.clarificaitonArray.count];
                        height+=(kMainScreenWidth-30)*5/9;
                    }else{
                        UILabel *clarificaitontitle =(UILabel *)[cell viewWithTag:106];
                        UIImageView *clarificaitonimage =(UIImageView *)[cell viewWithTag:107];
                        UIView *clarificaitonbackView =[clarificaitonimage viewWithTag:108];
                        UILabel *clarificaitonimagecount =[clarificaitonbackView viewWithTag:109];
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:123];
                        pointimage.hidden =YES;
                        clarificaitontitle.text=@"";
                        clarificaitonimage.image =nil;
                        clarificaitonimagecount.text =@"";
                        clarificaitonbackView.backgroundColor =[UIColor clearColor];
                    }
                    if (self.attachmentArray.count>0) {
                        height+=17;
                        UILabel *attachmenttitle =(UILabel *)[cell viewWithTag:110];
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:124];
                        pointimage.backgroundColor =[UIColor redColor];
                        pointimage.frame =CGRectMake(15+80, height+3, 15, 15);
                        
                        
                        
                        attachmenttitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                        attachmenttitle.text =@"线下合同";
                        height+=20;
                        
                        height+=15;
                        
                        
                        UIImageView *attachmentimage =(UIImageView *)[cell viewWithTag:111];
                        attachmentimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                        ContractAttchmentObject *attchment =[self.attachmentArray objectAtIndex:0];
                        [attachmentimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                        attachmentimage.contentMode=UIViewContentModeScaleAspectFill;
                        attachmentimage.clipsToBounds=YES;
                        
                        
                        BOOL ishide =YES;
                        for (ContractAttchmentObject *attchment1 in self.attachmentArray) {
                            if (attchment1.state ==1) {
                                ishide =NO;
                            }
                        }
                        pointimage.hidden =ishide;
                        
                        UIView *backView =[attachmentimage viewWithTag:112];
                        backView.backgroundColor =[UIColor clearColor];
                        UILabel *imagecount =[backView viewWithTag:113];
                        CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.attachmentArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                        backView.frame =CGRectMake(attachmentimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                        imagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                        imagecount.text =[NSString stringWithFormat:@"%d张",(int)self.attachmentArray.count];
                        height+=(kMainScreenWidth-30)*5/9;
                    }else{
                        UILabel *attachmenttitle =(UILabel *)[cell viewWithTag:110];
                        UIImageView *attachmentimage =(UIImageView *)[cell viewWithTag:111];
                        UIView *backView =[attachmentimage viewWithTag:112];
                        UILabel *imagecount =[backView viewWithTag:113];
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:124];
                        pointimage.hidden =YES;
                        
                        attachmenttitle.text=@"";
                        attachmentimage.image =nil;
                        imagecount.text =@"";
                        backView.backgroundColor =[UIColor clearColor];
                    }
                    if (self.otherArray.count>0) {
                        UILabel *othertitle =(UILabel *)[cell viewWithTag:114];
                        UIImageView *otherimage =(UIImageView *)[cell viewWithTag:115];
                        UIView *otherbackView =[otherimage viewWithTag:116];
                        height+=17;
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:125];
                        pointimage.backgroundColor =[UIColor redColor];
                        pointimage.frame =CGRectMake(15+40, height+3, 15, 15);
                        
                        UILabel *otherimagecount =[otherbackView viewWithTag:117];
                        othertitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                        othertitle.text =@"其他";
                        otherbackView.backgroundColor =[UIColor blackColor];
                        height+=20;
                        
                        height+=15;
                        
                        
                        otherimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                        ContractAttchmentObject *attchment =[self.otherArray objectAtIndex:0];
                        [otherimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                        otherimage.contentMode=UIViewContentModeScaleAspectFill;
                        otherimage.clipsToBounds=YES;
                        
                        
                        BOOL ishide =YES;
                        for (ContractAttchmentObject *attchment1 in self.otherArray) {
                            if (attchment1.state ==1) {
                                ishide =NO;
                            }
                        }
                        pointimage.hidden =ishide;
                        
                        CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.otherArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                        otherbackView.frame =CGRectMake(otherimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                        otherimagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                        otherimagecount.text =[NSString stringWithFormat:@"%d张",(int)self.otherArray.count];
                        height+=(kMainScreenWidth-30)*5/9;
                    }else{
                        UILabel *othertitle =(UILabel *)[cell viewWithTag:114];
                        UIImageView *otherimage =(UIImageView *)[cell viewWithTag:115];
                        UIView *otherbackView =[otherimage viewWithTag:116];
                        UILabel *otherimagecount =[otherbackView viewWithTag:117];
                        
                        UIImageView *pointimage =(UIImageView *)[cell viewWithTag:125];
                        pointimage.hidden =YES;
                        
                        othertitle.text=@"";
                        otherimage.image =nil;
                        otherimagecount.text =@"";
                        otherbackView.backgroundColor =[UIColor clearColor];
                    }
                    if (self.contractDetail.changeReason.length>0) {
                        height+=17;
                        UILabel *changeReasontitle =[cell viewWithTag:118];
                        changeReasontitle.text =@"附件变更理由";
                        changeReasontitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                        
                        height+=20;
                        
                        UILabel *changeReasonlbl =[cell viewWithTag:119];
                        CGSize labelsize =[util calHeightForLabel:self.contractDetail.changeReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                        changeReasonlbl.frame =CGRectMake(15, height, labelsize.width, labelsize.height);
                        changeReasonlbl.text =self.contractDetail.changeReason;
                        height+=labelsize.height;
                    }else{
                        UILabel *changeReasontitle =[cell viewWithTag:118];
                        changeReasontitle.text =@"";
                        UILabel *changeReasonlbl =[cell viewWithTag:119];
                        changeReasonlbl.text =@"";
                    }
                    
                    if (self.contractDetail.refuseReason.length>0) {
                        height+=17;
                        UILabel *refuseResontitle =[cell viewWithTag:120];
                        refuseResontitle.text =@"拒绝附件变更理由";
                        refuseResontitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                        
                        height+=20;
                        
                        UILabel *refuseResonlbl =[cell viewWithTag:121];
                        CGSize labelsize =[util calHeightForLabel:self.contractDetail.refuseReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                        refuseResonlbl.frame =CGRectMake(15, height, labelsize.width, labelsize.height);
                        refuseResonlbl.text =self.contractDetail.refuseReason;
                        height+=labelsize.height;
                    }else{
                        UILabel *refuseResontitle =[cell viewWithTag:120];
                        refuseResontitle.text =@"";
                        UILabel *refuseResonlbl =[cell viewWithTag:121];
                        refuseResonlbl.text =@"";
                    }
                }
                cell.selectionStyle =UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        
    }else{
        NSString *cellid=[NSString stringWithFormat:@"orderDetail_%d_%d",(int)indexPath.section,(int)indexPath.row];
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
            UILabel *remarktitle =[[UILabel alloc] initWithFrame:CGRectZero];
            remarktitle.font =[UIFont systemFontOfSize:20.0];
            remarktitle.textColor =[UIColor colorWithHexString:@"#575757"];
            remarktitle.tag =100;
            [cell addSubview:remarktitle];
            
            UILabel *remark =[[UILabel alloc] initWithFrame:CGRectZero];
            remark.font =[UIFont systemFontOfSize:15.0];
            remark.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            remark.tag =101;
            remark.numberOfLines =0;
            [cell addSubview:remark];
            
            if (self.budgetArray.count>0) {
                UILabel *budgettitle =[[UILabel alloc] initWithFrame:CGRectZero];
                budgettitle.font =[UIFont systemFontOfSize:20.0];
                budgettitle.textColor =[UIColor colorWithHexString:@"#575757"];
                budgettitle.tag =102;
                [cell addSubview:budgettitle];
                
                
                UIImageView *budgetimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                budgetimage.tag =103;
                [cell addSubview:budgetimage];
                budgetimage.userInteractionEnabled =YES;
                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                [budgetimage addGestureRecognizer:tap];
                
                UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                backView.backgroundColor =[UIColor blackColor];
                backView.alpha =0.5;
                backView.tag =104;
                backView.layer.masksToBounds = YES;
                backView.layer.cornerRadius = 5;
                [budgetimage addSubview:backView];
                
                UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                imagecount.textColor =[UIColor whiteColor];
                imagecount.font =[UIFont systemFontOfSize:12];
                imagecount.tag =105;
                imagecount.textAlignment =NSTextAlignmentCenter;
                [backView addSubview:imagecount];
                
                UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                pointimage.layer.cornerRadius=8;
                pointimage.clipsToBounds=YES;
                pointimage.tag =122;
                [cell addSubview:pointimage];
            }
            if (self.clarificaitonArray.count>0) {
                UILabel *clarificaitontitle =[[UILabel alloc] initWithFrame:CGRectZero];
                clarificaitontitle.font =[UIFont systemFontOfSize:20.0];
                clarificaitontitle.textColor =[UIColor colorWithHexString:@"#575757"];
                clarificaitontitle.tag =106;
                [cell addSubview:clarificaitontitle];
                
                
                UIImageView *clarificaitonimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                clarificaitonimage.tag =107;
                [cell addSubview:clarificaitonimage];
                clarificaitonimage.userInteractionEnabled =YES;
                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                [clarificaitonimage addGestureRecognizer:tap];
                
                UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                backView.backgroundColor =[UIColor blackColor];
                backView.alpha =0.5;
                backView.tag =108;
                backView.layer.masksToBounds = YES;
                backView.layer.cornerRadius = 5;
                [clarificaitonimage addSubview:backView];
                
                UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                imagecount.textColor =[UIColor whiteColor];
                imagecount.font =[UIFont systemFontOfSize:12];
                imagecount.tag =109;
                imagecount.textAlignment =NSTextAlignmentCenter;
                [backView addSubview:imagecount];
                
                UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                pointimage.layer.cornerRadius=8;
                pointimage.clipsToBounds=YES;
                pointimage.tag =123;
                [cell addSubview:pointimage];
            }
            if (self.attachmentArray.count>0) {
                UILabel *attachmenttitle =[[UILabel alloc] initWithFrame:CGRectZero];
                attachmenttitle.font =[UIFont systemFontOfSize:20.0];
                attachmenttitle.textColor =[UIColor colorWithHexString:@"#575757"];
                attachmenttitle.tag =110;
                [cell addSubview:attachmenttitle];
                
                
                UIImageView *attachmentimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                attachmentimage.tag =111;
                [cell addSubview:attachmentimage];
                attachmentimage.userInteractionEnabled =YES;
                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                [attachmentimage addGestureRecognizer:tap];
                
                UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                backView.backgroundColor =[UIColor blackColor];
                backView.alpha =0.5;
                backView.tag =112;
                backView.layer.masksToBounds = YES;
                backView.layer.cornerRadius = 5;
                [attachmentimage addSubview:backView];
                
                UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                imagecount.textColor =[UIColor whiteColor];
                imagecount.font =[UIFont systemFontOfSize:12];
                imagecount.tag =113;
                imagecount.textAlignment =NSTextAlignmentCenter;
                [backView addSubview:imagecount];
                
                UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                pointimage.layer.cornerRadius=8;
                pointimage.clipsToBounds=YES;
                pointimage.tag =124;
                [cell addSubview:pointimage];
            }
            if (self.otherArray.count>0) {
                UILabel *othertitle =[[UILabel alloc] initWithFrame:CGRectZero];
                othertitle.font =[UIFont systemFontOfSize:20.0];
                othertitle.textColor =[UIColor colorWithHexString:@"#575757"];
                othertitle.tag =114;
                [cell addSubview:othertitle];
                
                
                UIImageView *otherimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                otherimage.tag =115;
                [cell addSubview:otherimage];
                otherimage.userInteractionEnabled =YES;
                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                [otherimage addGestureRecognizer:tap];
                
                UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
                backView.backgroundColor =[UIColor blackColor];
                backView.alpha =0.5;
                backView.tag =116;
                backView.layer.masksToBounds = YES;
                backView.layer.cornerRadius = 5;
                [otherimage addSubview:backView];
                
                UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
                imagecount.textColor =[UIColor whiteColor];
                imagecount.font =[UIFont systemFontOfSize:12];
                imagecount.tag =117;
                imagecount.textAlignment =NSTextAlignmentCenter;
                [backView addSubview:imagecount];
                
                UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
                pointimage.layer.cornerRadius=8;
                pointimage.clipsToBounds=YES;
                pointimage.tag =125;
                [cell addSubview:pointimage];
            }
            if (self.contractDetail.changeReason.length>0) {
                UILabel *changeReasontitle =[[UILabel alloc] initWithFrame:CGRectZero];
                changeReasontitle.font =[UIFont systemFontOfSize:20.0];
                changeReasontitle.textColor =[UIColor colorWithHexString:@"#575757"];
                changeReasontitle.tag =118;
                changeReasontitle.numberOfLines =0;
                [cell addSubview:changeReasontitle];
                
                UILabel *changeReasonlbl =[[UILabel alloc] initWithFrame:CGRectZero];
                changeReasonlbl.font =[UIFont systemFontOfSize:16];
                changeReasonlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                changeReasonlbl.tag =119;
                changeReasonlbl.numberOfLines =0;
                [cell addSubview:changeReasonlbl];
            }
            
            if (self.contractDetail.refuseReason.length>0) {
                UILabel *refuseResontitle =[[UILabel alloc] initWithFrame:CGRectZero];
                refuseResontitle.font =[UIFont systemFontOfSize:20.0];
                refuseResontitle.textColor =[UIColor colorWithHexString:@"#575757"];
                refuseResontitle.tag =120;
                refuseResontitle.numberOfLines =0;
                [cell addSubview:refuseResontitle];
                
                UILabel *refuseResonlbl =[[UILabel alloc] initWithFrame:CGRectZero];
                refuseResonlbl.font =[UIFont systemFontOfSize:16];
                refuseResonlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                refuseResonlbl.tag =121;
                refuseResonlbl.numberOfLines =0;
                [cell addSubview:refuseResonlbl];
            }
            
//            UILabel *attachmenttitle =[[UILabel alloc] initWithFrame:CGRectZero];
//            attachmenttitle.font =[UIFont systemFontOfSize:20.0];
//            attachmenttitle.textColor =[UIColor colorWithHexString:@"#575757"];
//            attachmenttitle.tag =102;
//            [cell addSubview:attachmenttitle];
//
//            UIImageView *attachmentimage =[[UIImageView alloc] initWithFrame:CGRectZero];
//            attachmentimage.tag =103;
//            [cell addSubview:attachmentimage];
//            attachmentimage.userInteractionEnabled =YES;
//            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//            [attachmentimage addGestureRecognizer:tap];
//
//            UIView *backView =[[UIView alloc] initWithFrame:CGRectZero];
//            backView.backgroundColor =[UIColor blackColor];
//            backView.alpha =0.5;
//            backView.tag =104;
//            backView.layer.masksToBounds = YES;
//            backView.layer.cornerRadius = 5;
//            [attachmentimage addSubview:backView];
//            
//            UILabel *imagecount =[[UILabel alloc] initWithFrame:CGRectZero];
//            imagecount.textColor =[UIColor whiteColor];
//            imagecount.font =[UIFont systemFontOfSize:12];
//            imagecount.tag =105;
//            imagecount.textAlignment =NSTextAlignmentCenter;
//            [backView addSubview:imagecount];
        }
        CGFloat height=10;
        if (self.contractDetail.remark.length>0) {
            UILabel *remarktitle =(UILabel *)[cell viewWithTag:100];
            remarktitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
            remarktitle.text =@"合同备注";
            height+=20;
            
            height+=15;
            CGSize labelsize1 = [util calHeightForLabel:self.contractDetail.remark width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:15]];
            UILabel *remark =(UILabel *)[cell viewWithTag:101];
            remark.frame =CGRectMake(15, height, labelsize1.width, labelsize1.height);
            remark.text =self.contractDetail.remark;
            height+=labelsize1.height;
            
            height+=15;
        }
        if (self.contractDetail.attactmentsPaths.count>0) {
            if (self.budgetArray.count>0) {
                height+=17;
                UILabel *budgettitle =(UILabel *)[cell viewWithTag:102];
                UIImageView *budgetimage =(UIImageView *)[cell viewWithTag:103];
                UIView *budgetbackView =[budgetimage viewWithTag:104];
                UILabel *budgetimagecount =[budgetbackView viewWithTag:105];
                
                UIImageView *pointimage =(UIImageView *)[cell viewWithTag:122];
                pointimage.backgroundColor =[UIColor redColor];
                pointimage.frame =CGRectMake(15+60, height+3, 15, 15);
                
                
                
                budgettitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                if (self.contractDetail.contractType ==4) {
                    budgettitle.text =@"预算单";
                }else{
                    budgettitle.text =@"合同附件";
                    pointimage.frame =CGRectMake(15+80, height+3, 15, 15);
                }
                
                height+=20;
                
                height+=15;
                
                budgetbackView.backgroundColor =[UIColor blackColor];
                
                budgetimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                ContractAttchmentObject *attchment =[self.budgetArray objectAtIndex:0];
                [budgetimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                budgetimage.contentMode=UIViewContentModeScaleAspectFill;
                budgetimage.clipsToBounds=YES;
                
                
                BOOL ishide =YES;
                for (ContractAttchmentObject *attchment1 in self.budgetArray) {
                    if (attchment1.state ==1) {
                        ishide =NO;
                    }
                }
                pointimage.hidden =ishide;
                
                CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.budgetArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                budgetbackView.frame =CGRectMake(budgetimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                budgetimagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                budgetimagecount.text =[NSString stringWithFormat:@"%d张",(int)self.budgetArray.count];
                height+=(kMainScreenWidth-30)*5/9;
            }else{
                UILabel *budgettitle =(UILabel *)[cell viewWithTag:102];
                UIImageView *budgetimage =(UIImageView *)[cell viewWithTag:103];
                UIView *budgetbackView =[budgetimage viewWithTag:104];
                UILabel *budgetimagecount =[budgetbackView viewWithTag:105];
                UIImageView *pointimage =(UIImageView *)[cell viewWithTag:122];
                pointimage.hidden =YES;
                budgettitle.text=@"";
                budgetimage.image =nil;
                budgetimagecount.text =@"";
                budgetbackView.backgroundColor =[UIColor clearColor];
            }
            if (self.clarificaitonArray.count>0) {
                height+=17;
                UILabel *clarificaitontitle =(UILabel *)[cell viewWithTag:106];
                UIImageView *clarificaitonimage =(UIImageView *)[cell viewWithTag:107];
                UIView *clarificaitonbackView =[clarificaitonimage viewWithTag:108];
                UILabel *clarificaitonimagecount =[clarificaitonbackView viewWithTag:109];
                
                clarificaitonbackView.backgroundColor =[UIColor blackColor];
                
                UIImageView *pointimage =(UIImageView *)[cell viewWithTag:123];
                pointimage.backgroundColor =[UIColor redColor];
                pointimage.frame =CGRectMake(15+60, height+3, 15, 15);
                
                clarificaitontitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                clarificaitontitle.text =@"交底单";
                height+=20;
                
                height+=15;
                
                
                clarificaitonimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                ContractAttchmentObject *attchment =[self.clarificaitonArray objectAtIndex:0];
                [clarificaitonimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                clarificaitonimage.contentMode=UIViewContentModeScaleAspectFill;
                clarificaitonimage.clipsToBounds=YES;
                
                
                BOOL ishide =YES;
                for (ContractAttchmentObject *attchment1 in self.clarificaitonArray) {
                    if (attchment1.state ==1) {
                        ishide =NO;
                    }
                }
                pointimage.hidden =ishide;
                
                CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.clarificaitonArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                clarificaitonbackView.frame =CGRectMake(clarificaitonimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                clarificaitonimagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                clarificaitonimagecount.text =[NSString stringWithFormat:@"%d张",(int)self.clarificaitonArray.count];
                height+=(kMainScreenWidth-30)*5/9;
            }else{
                UILabel *clarificaitontitle =(UILabel *)[cell viewWithTag:106];
                UIImageView *clarificaitonimage =(UIImageView *)[cell viewWithTag:107];
                UIView *clarificaitonbackView =[clarificaitonimage viewWithTag:108];
                UILabel *clarificaitonimagecount =[clarificaitonbackView viewWithTag:109];
                UIImageView *pointimage =(UIImageView *)[cell viewWithTag:123];
                pointimage.hidden =YES;
                clarificaitontitle.text=@"";
                clarificaitonimage.image =nil;
                clarificaitonimagecount.text =@"";
                clarificaitonbackView.backgroundColor =[UIColor clearColor];
            }
            if (self.attachmentArray.count>0) {
                height+=17;
                UILabel *attachmenttitle =(UILabel *)[cell viewWithTag:110];
                UIImageView *pointimage =(UIImageView *)[cell viewWithTag:124];
                pointimage.backgroundColor =[UIColor redColor];
                pointimage.frame =CGRectMake(15+80, height+3, 15, 15);
                
                
                
                attachmenttitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                attachmenttitle.text =@"线下合同";
                height+=20;
                
                height+=15;
                
                
                UIImageView *attachmentimage =(UIImageView *)[cell viewWithTag:111];
                attachmentimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                ContractAttchmentObject *attchment =[self.attachmentArray objectAtIndex:0];
                [attachmentimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                attachmentimage.contentMode=UIViewContentModeScaleAspectFill;
                attachmentimage.clipsToBounds=YES;
                
                
                BOOL ishide =YES;
                for (ContractAttchmentObject *attchment1 in self.attachmentArray) {
                    if (attchment1.state ==1) {
                        ishide =NO;
                    }
                }
                pointimage.hidden =ishide;
                
                UIView *backView =[attachmentimage viewWithTag:112];
                backView.backgroundColor =[UIColor clearColor];
                UILabel *imagecount =[backView viewWithTag:113];
                CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.attachmentArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                backView.frame =CGRectMake(attachmentimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                imagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                imagecount.text =[NSString stringWithFormat:@"%d张",(int)self.attachmentArray.count];
                height+=(kMainScreenWidth-30)*5/9;
            }else{
                UILabel *attachmenttitle =(UILabel *)[cell viewWithTag:110];
                UIImageView *attachmentimage =(UIImageView *)[cell viewWithTag:111];
                UIView *backView =[attachmentimage viewWithTag:112];
                UILabel *imagecount =[backView viewWithTag:113];
                
                UIImageView *pointimage =(UIImageView *)[cell viewWithTag:124];
                pointimage.hidden =YES;
                
                attachmenttitle.text=@"";
                attachmentimage.image =nil;
                imagecount.text =@"";
                backView.backgroundColor =[UIColor clearColor];
            }
            if (self.otherArray.count>0) {
                UILabel *othertitle =(UILabel *)[cell viewWithTag:114];
                UIImageView *otherimage =(UIImageView *)[cell viewWithTag:115];
                UIView *otherbackView =[otherimage viewWithTag:116];
                height+=17;
                UIImageView *pointimage =(UIImageView *)[cell viewWithTag:125];
                pointimage.backgroundColor =[UIColor redColor];
                pointimage.frame =CGRectMake(15+40, height+3, 15, 15);
                
                UILabel *otherimagecount =[otherbackView viewWithTag:117];
                othertitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                othertitle.text =@"其他";
                otherbackView.backgroundColor =[UIColor blackColor];
                height+=20;
                
                height+=15;
                
                
                otherimage.frame =CGRectMake(15, height, kMainScreenWidth-30, (kMainScreenWidth-30)*5/9);
                ContractAttchmentObject *attchment =[self.otherArray objectAtIndex:0];
                [otherimage sd_setImageWithURL:[NSURL URLWithString:attchment.attchmnetPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                otherimage.contentMode=UIViewContentModeScaleAspectFill;
                otherimage.clipsToBounds=YES;
                
                
                BOOL ishide =YES;
                for (ContractAttchmentObject *attchment1 in self.otherArray) {
                    if (attchment1.state ==1) {
                        ishide =NO;
                    }
                }
                pointimage.hidden =ishide;
                
                CGSize labelsize2 = [util calHeightForLabel:[NSString stringWithFormat:@"%d张",(int)self.otherArray.count] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:12]];
                otherbackView.frame =CGRectMake(otherimage.frame.size.width-labelsize2.width-10, 5, labelsize2.width+10, labelsize2.height+10);
                otherimagecount.frame =CGRectMake(5, 5, labelsize2.width, labelsize2.height);
                otherimagecount.text =[NSString stringWithFormat:@"%d张",(int)self.otherArray.count];
                height+=(kMainScreenWidth-30)*5/9;
            }else{
                UILabel *othertitle =(UILabel *)[cell viewWithTag:114];
                UIImageView *otherimage =(UIImageView *)[cell viewWithTag:115];
                UIView *otherbackView =[otherimage viewWithTag:116];
                UILabel *otherimagecount =[otherbackView viewWithTag:117];
                
                UIImageView *pointimage =(UIImageView *)[cell viewWithTag:125];
                pointimage.hidden =YES;
                
                othertitle.text=@"";
                otherimage.image =nil;
                otherimagecount.text =@"";
                otherbackView.backgroundColor =[UIColor clearColor];
            }
            if (self.contractDetail.changeReason.length>0) {
                height+=17;
                UILabel *changeReasontitle =[cell viewWithTag:118];
                changeReasontitle.text =@"附件变更理由";
                changeReasontitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                
                height+=20;
                
                UILabel *changeReasonlbl =[cell viewWithTag:119];
                CGSize labelsize =[util calHeightForLabel:self.contractDetail.changeReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                changeReasonlbl.frame =CGRectMake(15, height, labelsize.width, labelsize.height);
                changeReasonlbl.text =self.contractDetail.changeReason;
                height+=labelsize.height;
            }else{
                UILabel *changeReasontitle =[cell viewWithTag:118];
                changeReasontitle.text =@"";
                UILabel *changeReasonlbl =[cell viewWithTag:119];
                changeReasonlbl.text =@"";
            }
            
            if (self.contractDetail.refuseReason.length>0) {
                height+=17;
                UILabel *refuseResontitle =[cell viewWithTag:120];
                refuseResontitle.text =@"拒绝附件变更理由";
                refuseResontitle.frame =CGRectMake(15, height, kMainScreenWidth-30, 20);
                
                height+=20;
                
                UILabel *refuseResonlbl =[cell viewWithTag:121];
                CGSize labelsize =[util calHeightForLabel:self.contractDetail.refuseReason width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:16]];
                refuseResonlbl.frame =CGRectMake(15, height, labelsize.width, labelsize.height);
                refuseResonlbl.text =self.contractDetail.refuseReason;
                height+=labelsize.height;
            }else{
                UILabel *refuseResontitle =[cell viewWithTag:120];
                refuseResontitle.text =@"";
                UILabel *refuseResonlbl =[cell viewWithTag:121];
                refuseResonlbl.text =@"";
            }
            
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)tapAction:(UIGestureRecognizer *)sender{
    NSMutableArray *photosArray = [NSMutableArray array];
    if (sender.view.tag ==103) {
        photosArray =[NSMutableArray arrayWithCapacity:self.budgetArray.count];
        
        for (int i = 0; i<self.budgetArray.count; i++) {
            // 替换为中等尺寸图片
            ContractAttchmentObject *attchment =[self.budgetArray objectAtIndex:i];
            NSString *url = attchment.attchmnetPath;
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url]; // 图片路径
            photo.srcImageView = (UIImageView *)sender.view; // 来源于哪个UIImageView
            [photosArray addObject:photo];
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
        browser.photos = photosArray; // 设置所有的图片
        //    browser.describe =selectpic.phasePicDescription;
        [browser show];
    }else if (sender.view.tag ==107){
        photosArray =[NSMutableArray arrayWithCapacity:self.clarificaitonArray.count];
        
        for (int i = 0; i<self.clarificaitonArray.count; i++) {
            // 替换为中等尺寸图片
            ContractAttchmentObject *attchment =[self.clarificaitonArray objectAtIndex:i];
            NSString *url = attchment.attchmnetPath;
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url]; // 图片路径
            photo.srcImageView = (UIImageView *)sender.view; // 来源于哪个UIImageView
            [photosArray addObject:photo];
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
        browser.photos = photosArray; // 设置所有的图片
        //    browser.describe =selectpic.phasePicDescription;
        [browser show];
    }else if (sender.view.tag ==111){
        photosArray =[NSMutableArray arrayWithCapacity:self.attachmentArray.count];
        
        for (int i = 0; i<self.attachmentArray.count; i++) {
            // 替换为中等尺寸图片
            ContractAttchmentObject *attchment =[self.attachmentArray objectAtIndex:i];
            NSString *url = attchment.attchmnetPath;
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url]; // 图片路径
            photo.srcImageView = (UIImageView *)sender.view; // 来源于哪个UIImageView
            [photosArray addObject:photo];
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
        browser.photos = photosArray; // 设置所有的图片
        //    browser.describe =selectpic.phasePicDescription;
        [browser show];
    }else if (sender.view.tag ==115){
        photosArray =[NSMutableArray arrayWithCapacity:self.otherArray.count];
        
        for (int i = 0; i<self.otherArray.count; i++) {
            // 替换为中等尺寸图片
            ContractAttchmentObject *attchment =[self.otherArray objectAtIndex:i];
            NSString *url = attchment.attchmnetPath;
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url]; // 图片路径
            photo.srcImageView = (UIImageView *)sender.view; // 来源于哪个UIImageView
            [photosArray addObject:photo];
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
        browser.photos = photosArray; // 设置所有的图片
        //    browser.describe =selectpic.phasePicDescription;
        [browser show];
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewOrderObject *orderObject;
    if (self.phaseOrders.count>0) {
        orderObject =[self.phaseOrders objectAtIndex:0];
    }
//    if (orderObject.phaseOrderCode.length>0) {
//        if ((indexPath.section ==1&&![[orderObject.phaseOrderCode substringToIndex:1] isEqualToString:@"G"])) {
//            PhaseOrderCell *cell = (PhaseOrderCell*)[tableView cellForRowAtIndexPath:indexPath];
//            if (!cell) {
//                NSLog(@"没有该cell");
//            }else{
//                cell.isOpen =!cell.isOpen;
//            }
//            [self.isOpenIndex setObject:[NSNumber numberWithBool:cell.isOpen] forKey:indexPath];
//            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]  withRowAnimation:UITableViewRowAnimationFade];
//            return;
//        }else{
//            PhaseOrderCell *cell = (PhaseOrderCell*)[tableView cellForRowAtIndexPath:indexPath];
//            if (!cell) {
//                NSLog(@"没有该cell");
//            }else{
//                cell.isOpen =!cell.isOpen;
//            }
//            [self.isOpenIndex setObject:[NSNumber numberWithBool:cell.isOpen] forKey:indexPath];
//            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]  withRowAnimation:UITableViewRowAnimationFade];
//            return;
//        }
//    }else{
//        if (indexPath.section==1) {
//            PhaseOrderCell *cell = (PhaseOrderCell*)[tableView cellForRowAtIndexPath:indexPath];
//            if (!cell) {
//                NSLog(@"没有该cell");
//            }else{
//                cell.isOpen =!cell.isOpen;
//            }
//            [self.isOpenIndex setObject:[NSNumber numberWithBool:cell.isOpen] forKey:indexPath];
//            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]  withRowAnimation:UITableViewRowAnimationFade];
//            return;
//        }
//    }
    if (self.contractDetail.contractType==4) {
        if (indexPath.section ==2){
            PhaseOrderCell *cell = (PhaseOrderCell*)[tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                NSLog(@"没有该cell");
            }else{
                cell.isOpen =!cell.isOpen;
            }
            [self.isOpenIndex setObject:[NSNumber numberWithBool:cell.isOpen] forKey:indexPath];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]  withRowAnimation:UITableViewRowAnimationFade];
            return;
        }
    }else{
        if (indexPath.section ==1){
            PhaseOrderCell *cell = (PhaseOrderCell*)[tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                NSLog(@"没有该cell");
            }else{
                cell.isOpen =!cell.isOpen;
            }
            [self.isOpenIndex setObject:[NSNumber numberWithBool:cell.isOpen] forKey:indexPath];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]  withRowAnimation:UITableViewRowAnimationFade];
            return;
        }
    }
    
}
-(void)touchComment{
    [self myappraise:nil];
}
-(void)touchButton:(UIButton *)button{
    CouponMainViewController *couponmain =[[CouponMainViewController alloc] init];
    couponmain.contract=self.contractDetail;
    couponmain.orderCode =self.orderCode;
    couponmain.couponNum =self.couponNum;
    couponmain.noCouponNum =self.noCouponNum;
    if (self.preferential) {
        couponmain.selectcouponId =self.preferential.sucId;
    }
    couponmain.selectDone =^(PreferentialObject *prefrential){
        self.preferential =prefrential;
        [self.table reloadData];
    };
    [self.navigationController pushViewController:couponmain animated:YES];
}
-(void)createPhone{
    if(!self.btn_phone) {
        self.btn_phone = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_phone.frame=CGRectMake(kMainScreenWidth-50, kMainScreenHeight-250, 50, 50);
    }
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_ddh_mor.png"] forState:UIControlStateNormal];
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_ddh.png"] forState:UIControlStateHighlighted];
//    self.btn_phone.tag=1003;
    [self.btn_phone addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn_phone ];
    
    UIPanGestureRecognizer *pan_search = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragToSearch:)];
    [pan_search setMinimumNumberOfTouches:1];
    [pan_search setMaximumNumberOfTouches:1];
    [self.btn_phone addGestureRecognizer:pan_search];
}
- (void)dragToSearch:(UIPanGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gr locationInView:self.view];
        self.btn_phone.center = point;
        if (gr.state == UIGestureRecognizerStateEnded) {
            [UIView animateWithDuration:0.18 animations:^{
                if (point.x<(kMainScreenWidth/2)) self.btn_phone.frame=CGRectMake(0, point.y-25, 50, 50);
                else self.btn_phone.frame=CGRectMake(kMainScreenWidth-50, point.y-25, 50, 50);
                
                if(point.y<25){
                    if(point.x<50) self.btn_phone.frame=CGRectMake(0, 0, 50, 50);
                    else self.btn_phone.frame=CGRectMake(point.x-50, 0, 50, 50);
                }
            }];
        }
    }
}
- (void)pressbtn:(UIButton *)sender {
    NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",self.contractDetail.servantPhoneNo];
    UIWebView *callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
    [self.view addSubview:callWebview];
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
    [self startRequestWithString:@"评价中..."];
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
        
        
        NSString *orderTypeStr = [NSString stringWithFormat:@"%ld",(long)self.contractDetail.contractType];
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:[NSString stringWithFormat:@"%d",self.contractDetail.servantId] forKey:@"objectId"];
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
