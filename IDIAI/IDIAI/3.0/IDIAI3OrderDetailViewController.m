//
//  IDIAI3OrderDetailViewController.m
//  IDIAI
//
//  Created by Ricky on 15/12/28.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3OrderDetailViewController.h"
#import "IDIAIAppDelegate.h"
#import "LoginView.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "NewOrderDetailObject.h"
#import "PhaseOrderCell.h"
#import "IDIAI3ContractDetailViewController.h"
#import "savelogObj.h"
#import "PayingConfirmViewController.h"
#import "IDIAI3ConfirmPaymentViewController.h"
#import "AfterSaleViewController.h"
#import "RefundViewController.h"
#import "TLToast.h"
#import "util.h"
#import "CustomPromptView.h"
#import "OnlinePayViewController.h"
@interface IDIAI3OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,PhaseOrderCellDelegate,UIAlertViewDelegate>{
    CustomPromptView *customPromp;
}
@property(nonatomic,strong)NSMutableArray *contractProjects;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,assign)NSInteger ismanager;
@property(nonatomic,strong)NSMutableDictionary *isOpenIndex;
@property(nonatomic,strong)NewOrderDetailObject *contractObject;
@property(nonatomic,strong)NewOrderDetailObject *selectOrder;
@property(nonatomic,assign)BOOL isMakeUp;
@end

@implementation IDIAI3OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    self.title =@"订单详情";
    self.view.backgroundColor =[UIColor clearColor];
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:NO animated:YES];
    self.isOpenIndex =[NSMutableDictionary dictionary];
    self.table =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    self.table.delegate =self;
    self.table.dataSource =self;
    self.table.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    backView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.table.tableHeaderView =backView;
    UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 15)];
    footView.backgroundColor =[UIColor whiteColor];
    self.table.tableFooterView =footView;
    self.contractProjects =[NSMutableArray array];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self requestOrderDetail];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setOrderPhone:(NSString *)orderPhone{
    if (orderPhone.length>0) {
        _orderPhone =orderPhone;
        [self createPhone];
    }
}
-(void)createPhone{
    if(!self.btn_phone) {
        self.btn_phone = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_phone.frame=CGRectMake(kMainScreenWidth-50, kMainScreenHeight-250, 50, 50);
    }
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_ddh_mor.png"] forState:UIControlStateNormal];
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_ddh.png"] forState:UIControlStateHighlighted];
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
    NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",self.orderPhone];
    UIWebView *callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
    [self.view addSubview:callWebview];
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
        NSDictionary *bodyDic = @{@"phaseOrderCode":self.phaseOrderCode};
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
                    
                    if (kResCode == 103071) {
                        [self.contractProjects removeAllObjects];
                        for (NSDictionary *phasedic in [jsonDict objectForKey:@"contractProjects"]) {
                            NSMutableDictionary *phase =[NSMutableDictionary dictionaryWithDictionary:phasedic];
                            [phase removeObjectForKey:@"orderCode_"];
                            DCKeyValueObjectMapping *parser1 = [DCKeyValueObjectMapping mapperForClass:[NewOrderDetailObject class]];
                            NewOrderDetailObject *orderobject =[parser1 parseDictionary:phase];
                            
                            if (orderobject.phaseType==1) {
                                self.contractObject =orderobject;
                            }else{
                                [self.contractProjects addObject:orderobject];
                            }
                            NewOrderDetailObject *currentorder;
                            if ([self.phaseOrderCode isEqualToString:orderobject.phaseOrderCode]) {
                                currentorder =orderobject;
                            }
                            if (self.isMakeUp ==YES&&currentorder.phaseOrderState==7&&currentorder.makeUpState==3) {
                                IDIAI3ConfirmPaymentViewController *confirmPay =[[IDIAI3ConfirmPaymentViewController alloc] init];
                                confirmPay.orderType =4;
                                
                                float orderPhraseFee =orderobject.clearFee;
                                confirmPay.payforMoney =orderPhraseFee;
                                confirmPay.orderCode =orderobject.phaseOrderCode;
                                [self.navigationController pushViewController:confirmPay animated:YES];
                                self.isMakeUp =NO;
                            }
                        }
                        
                        [self.table reloadData];
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 0;
    }
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    backView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    return backView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.contractProjects.count>0){
        if (section==0) {
            if (self.secondOrderCode.length>0) {
                return 3;
            }else{
                return 2;
            }
        }else{
            return self.contractProjects.count;
        }
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.contractProjects.count>0) {
        if (indexPath.section ==0) {
            if (self.secondOrderCode.length>0) {
                NewOrderDetailObject *orderobject =[self.contractProjects objectAtIndex:indexPath.row];
                float realpay =0;
                if ([[orderobject.phaseOrderCode substringToIndex:1] isEqualToString:@"G"]) {
                    float height =0;
                    if (orderobject.phaseOrderState ==36) {
                        height =40;
                    }
                    if (orderobject.phaseOrderState==35&&orderobject.makeUpState==5) {
                        height =40;
                    }
                    CGSize labelsize1 = [util calHeightForLabel:orderobject.phaseOrderName width:(kMainScreenWidth-30)/1.25 font:[UIFont systemFontOfSize:17]];
                    if (labelsize1.height>17) {
                        height +=labelsize1.height-17;
                    }
                    if (indexPath.row==0) {
                        return 151+height;
                    }
                    if (orderobject.originalOrderFee!=orderobject.phaseOrderFee) {
                        realpay +=28;
                    }
                    if (indexPath.row ==2) {
                        return 151+realpay;
                    }
                    return 151;
                }else {
                    float realpay =0;
                    if (orderobject.originalOrderFee!=orderobject.phaseOrderFee) {
                        realpay +=28;
                    }
                    if (indexPath.row==1) {
                        CGSize labelsize1 = [util calHeightForLabel:orderobject.phaseOrderName width:(kMainScreenWidth-30)/1.25 font:[UIFont systemFontOfSize:17]];
                        if (labelsize1.height>17) {
                            return 117+labelsize1.height-17;
                        }else{
                            return 117;
                        }
                        
                    }else{
                        float height =0;
                        if (orderobject.phaseOrderState ==36) {
                            height =40;
                        }
                        if (orderobject.phaseOrderState==35&&orderobject.makeUpState==5) {
                            height =40;
                        }
                        CGSize labelsize1 = [util calHeightForLabel:orderobject.phaseOrderName width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:17]];
                        if (labelsize1.height>17) {
                            height +=labelsize1.height-17;
                        }
                        if (indexPath.row==0) {
                            return 82+height;
                        }
                        if (indexPath.row ==2) {
                            return 82+realpay;
                        }
                        return 82;
                    }
                }
            }else{
                NewOrderDetailObject *orderobject =[[NewOrderDetailObject alloc] init];
                for (NewOrderDetailObject *object in self.contractProjects) {
                    if ([self.phaseOrderCode isEqualToString:object.phaseOrderCode]) {
                        orderobject =object;
                    }
                }
                float realpay =0;
                if (orderobject.originalOrderFee!=orderobject.phaseOrderFee) {
                    realpay +=28;
                }
                if ([[orderobject.phaseOrderCode substringToIndex:1] isEqualToString:@"G"]) {
                    if (indexPath.row ==0) {
                        float height =0;
                        
                        if (orderobject.phaseOrderState ==36) {
                            height =40;
                        }
                        if (orderobject.phaseOrderState==35&&orderobject.makeUpState==5) {
                            height =40;
                        }
                        CGSize labelsize1 = [util calHeightForLabel:orderobject.phaseOrderName width:(kMainScreenWidth-30)/1.25 font:[UIFont systemFontOfSize:17]];
                        if (labelsize1.height>17) {
                            height +=labelsize1.height-17;
                        }
                        if (indexPath.row==0) {
                            return 151+height;
                        }
                        return 151;
                    }else{
                        float height =0;
                        if (orderobject.phaseOrderState ==36) {
                            height =40;
                        }
                        if (orderobject.phaseOrderState==35&&orderobject.makeUpState==5) {
                            height =40;
                        }
                        CGSize labelsize1 = [util calHeightForLabel:orderobject.phaseOrderName width:(kMainScreenWidth-30)/1.25 font:[UIFont systemFontOfSize:17]];
                        if (labelsize1.height>17) {
                            height +=labelsize1.height-17;
                        }
                        if (indexPath.row ==1) {
                            return 52+height+realpay;
                        }
                        return 52+height;
                    }
                    
                }else {
                    if (indexPath.row==0) {
                        float height =0;
                        if (orderobject.phaseOrderState ==36) {
                            height =40;
                        }
                        if (orderobject.phaseOrderState==35&&orderobject.makeUpState==5) {
                            height =40;
                        }
                        CGSize labelsize1 = [util calHeightForLabel:orderobject.phaseOrderName width:(kMainScreenWidth-30)/1.25 font:[UIFont systemFontOfSize:17]];
                        if (labelsize1.height>17) {
                            height +=labelsize1.height-17;
                        }
                        if (orderobject.makeUpFee!=0) {
                            UIFont *font = [UIFont fontWithName:@"Arial" size:15];
                            CGSize size = CGSizeMake(kMainScreenWidth-30,2000);
                            CGSize labelsize = [orderobject.makeUpReason sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
                            return 151+labelsize.height+30+height;
                        }
                        return 117+height;
                    }else{
                        if (indexPath.row ==1) {
                            return 82+realpay;
                        }
                        return 82;
                    }
                }
            }
        }else{
            NewOrderDetailObject *orderObject =[self.contractProjects objectAtIndex:indexPath.row];
            static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
            PhaseOrderCell *cell = (PhaseOrderCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
            if (!cell) {
                cell = [[PhaseOrderCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CustomCellIdentifier];
            }
            cell.orderdetail =orderObject;
            cell.contractTotalFee =self.contractObject.phaseOrderFee;
            if (indexPath.row==0) {
                cell.isfirst =YES;
            }else{
                cell.isfirst =NO;
            }
            return [cell getCellHeight];
        }
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        NSString *cellid=[NSString stringWithFormat:@"orderDetail_%d_%d",(int)indexPath.section,(int)indexPath.row];
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        NewOrderDetailObject *orderobject =[[NewOrderDetailObject alloc] init];
        NewOrderDetailObject *secondOrder =[[NewOrderDetailObject alloc] init];
        if (self.secondOrderCode.length>0) {
            for (NewOrderDetailObject *object in self.contractProjects) {
                if ([self.phaseOrderCode isEqualToString:object.phaseOrderCode]) {
                    orderobject =object;
                }
                if ([self.secondOrderCode isEqualToString:object.phaseOrderCode]) {
                    secondOrder =object;
                }
            }
        }else{
            for (NewOrderDetailObject *object in self.contractProjects) {
                if ([self.phaseOrderCode isEqualToString:object.phaseOrderCode]) {
                    orderobject =object;
                }
            }
        }
        
//        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UILabel *titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 12, (kMainScreenWidth-30)/1.25,17)];
            titlelbl.font =[UIFont systemFontOfSize:17.0];
            titlelbl.textColor =[UIColor colorWithHexString:@"#575757"];
//            titlelbl.backgroundColor =[UIColor redColor];
            titlelbl.tag =100;
            titlelbl.numberOfLines =0;
//        if (indexPath.row ==0) {
//            cell.backgroundColor =[UIColor redColor];
//        }
            if (self.secondOrderCode.length>0){
                if (indexPath.row ==0) {
                    CGSize labelsize1 = [util calHeightForLabel:orderobject.phaseOrderName width:(kMainScreenWidth-30)/1.25 font:[UIFont systemFontOfSize:17]];
                    titlelbl.frame =CGRectMake(15, 12, labelsize1.width,labelsize1.height);
                }else if (indexPath.row ==1){
                    CGSize labelsize1 = [util calHeightForLabel:secondOrder.phaseOrderName width:(kMainScreenWidth-30)/1.25 font:[UIFont systemFontOfSize:17]];
                    titlelbl.frame =CGRectMake(15, 12, labelsize1.width,labelsize1.height);
                }
            }else{
                if (indexPath.row ==0) {
                    CGSize labelsize1 = [util calHeightForLabel:orderobject.phaseOrderName width:(kMainScreenWidth-30)/1.25 font:[UIFont systemFontOfSize:17]];
                    titlelbl.frame =CGRectMake(15, 12, labelsize1.width,labelsize1.height);
                }
            }
//            [titlelbl sizeToFit];
            [cell addSubview:titlelbl];
            UILabel *orderStatelbl =[[UILabel alloc] initWithFrame:CGRectMake(15+(kMainScreenWidth-30)/1.25, 12, kMainScreenWidth-30-(kMainScreenWidth-30)/1.25,17)];
            orderStatelbl.font =[UIFont systemFontOfSize:17.0];
            orderStatelbl.textAlignment =NSTextAlignmentRight;
            orderStatelbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
            orderStatelbl.tag =101;
            [cell addSubview:orderStatelbl];
            if (self.secondOrderCode.length>0) {
                if (indexPath.row ==0) {
                    UILabel *orderCodelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, titlelbl.frame.origin.y+titlelbl.frame.size.height+20, kMainScreenWidth-30, 17)];
                    orderCodelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    orderCodelbl.font =[UIFont systemFontOfSize:15.0];
                    orderCodelbl.tag =102;
                    [cell addSubview:orderCodelbl];
                    
                    UILabel *productProFeelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, orderCodelbl.frame.origin.y+orderCodelbl.frame.size.height+15, kMainScreenWidth-30, 17)];
                    productProFeelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    productProFeelbl.font =[UIFont systemFontOfSize:17.0];
                    productProFeelbl.tag =103;
                    [cell addSubview:productProFeelbl];
                    
                    UIImageView *productProFee =[[UIImageView alloc] initWithFrame:CGRectMake(0, productProFeelbl.frame.origin.y, 41, 17)];
                    productProFee.image =[UIImage imageNamed:@"bg_biaoqian.png"];
                    productProFee.tag =105;
                    [cell addSubview:productProFee];
                    
                    UILabel *ppDiscountlbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 2, 33, 11)];
                    ppDiscountlbl.textColor =[UIColor whiteColor];
                    ppDiscountlbl.font =[UIFont systemFontOfSize:11.0];
                    ppDiscountlbl.tag =107;
                    [productProFee addSubview:ppDiscountlbl];
                    
                    
                    UILabel *platformSuperFeelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, productProFeelbl.frame.origin.y+productProFeelbl.frame.size.height+15, kMainScreenWidth-30, 17)];
                    platformSuperFeelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    platformSuperFeelbl.font =[UIFont systemFontOfSize:17.0];
                    platformSuperFeelbl.tag =104;
                    [cell addSubview:platformSuperFeelbl];
                    
                    UIImageView *platformSuperFee =[[UIImageView alloc] initWithFrame:CGRectMake(0, platformSuperFeelbl.frame.origin.y, 41, 15)];
                    platformSuperFee.image =[UIImage imageNamed:@"bg_biaoqian.png"];
                    platformSuperFee.tag =109;
                    [cell addSubview:platformSuperFee];
                    
                    UILabel *psDiscountlbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 2, 33, 11)];
                    psDiscountlbl.textColor =[UIColor whiteColor];
                    psDiscountlbl.font =[UIFont systemFontOfSize:11.0];
                    psDiscountlbl.tag =110;
                    [platformSuperFee addSubview:psDiscountlbl];
                    
                    
                    UIImageView *footline =[[UIImageView alloc] initWithFrame:CGRectMake(12, platformSuperFeelbl.frame.size.height+platformSuperFeelbl.frame.origin.y+15, kMainScreenWidth-24, 1)];
                    footline.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                    [cell addSubview:footline];
                }else if (indexPath.row ==1){
                    UILabel *orderCodelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, titlelbl.frame.origin.y+titlelbl.frame.size.height+12, kMainScreenWidth-30, 17)];
                    orderCodelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    orderCodelbl.font =[UIFont systemFontOfSize:15.0];
                    orderCodelbl.tag =102;
                    [cell addSubview:orderCodelbl];
                    
                    UILabel *phaseOrderFeelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, orderCodelbl.frame.origin.y+orderCodelbl.frame.size.height+15, kMainScreenWidth-30, 17)];
                    phaseOrderFeelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    phaseOrderFeelbl.font =[UIFont systemFontOfSize:17.0];
                    phaseOrderFeelbl.tag =103;
                    [cell addSubview:phaseOrderFeelbl];
                    
                    float height =phaseOrderFeelbl.frame.size.height+phaseOrderFeelbl.frame.origin.y+15;
                    if (orderobject.phaseOrderState ==36) {
                        UILabel *alreadyname =[[UILabel alloc] initWithFrame:CGRectMake(15, phaseOrderFeelbl.frame.origin.y+phaseOrderFeelbl.frame.size.height+8, kMainScreenWidth-30, 17)];
                        alreadyname.font =[UIFont systemFontOfSize:17];
                        alreadyname.tag =115;
                        alreadyname.textColor =[UIColor colorWithHexString:@"#ef6562"];
                        [cell addSubview:alreadyname];
                        
                        UILabel *nevername =[[UILabel alloc] initWithFrame:CGRectMake(15, alreadyname.frame.origin.y+alreadyname.frame.size.height+8, kMainScreenWidth-30, 17)];
                        nevername.font =[UIFont systemFontOfSize:17];
                        nevername.tag =116;
                        nevername.textColor =[UIColor colorWithHexString:@"#ef6562"];
                        [cell addSubview:nevername];
                        height =nevername.frame.size.height+nevername.frame.origin.y+15;
                    }
                    
                    UIImageView *footline =[[UIImageView alloc] initWithFrame:CGRectMake(12, height, kMainScreenWidth-24, 1)];
                    footline.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                    [cell addSubview:footline];
                }else{
                    UILabel *combinedlbl =[[UILabel alloc] initWithFrame:CGRectMake(80*kMainScreenWidth/375, 12, kMainScreenWidth-110, 17)];
                    combinedlbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
                    combinedlbl.font =[UIFont systemFontOfSize:17.0];
                    combinedlbl.tag =102;
                    [cell addSubview:combinedlbl];
                    UILabel *realpaylbl;
                    if (orderobject.originalOrderFee!=orderobject.phaseOrderFee||secondOrder.originalOrderFee!=secondOrder.phaseOrderFee) {
                        realpaylbl =[[UILabel alloc] initWithFrame:CGRectMake(15, combinedlbl.frame.origin.y+combinedlbl.frame.size.height+11, kMainScreenWidth-110, 17)];
                        realpaylbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
                        realpaylbl.font =[UIFont systemFontOfSize:17.0];
                        realpaylbl.tag =115;
                        [cell addSubview:realpaylbl];
                    }
                    
                    
                    UIButton *firstBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    firstBtn.tag =112;
                    firstBtn.frame =CGRectMake(kMainScreenWidth-15*kMainScreenWidth/375-79*kMainScreenWidth/375, combinedlbl.frame.origin.y+combinedlbl.frame.origin.y+11, 79*kMainScreenWidth/375, 30);
                    if (orderobject.originalOrderFee!=orderobject.phaseOrderFee||secondOrder.originalOrderFee!=secondOrder.phaseOrderFee) {
                        firstBtn.frame =CGRectMake(kMainScreenWidth-15*kMainScreenWidth/375-79*kMainScreenWidth/375, realpaylbl.frame.origin.y+realpaylbl.frame.size.height+11, 79*kMainScreenWidth/375, 30);
                    }
                    [firstBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                    [firstBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                    firstBtn.titleLabel.font =[UIFont systemFontOfSize:15];
//                    firstBtn.hidden =YES;
                    firstBtn.layer.masksToBounds = YES;
                    firstBtn.layer.cornerRadius = 3;
                    firstBtn.layer.borderColor = kThemeColor.CGColor;
                    firstBtn.layer.borderWidth = 1;
                    [firstBtn addTarget:self action:@selector(gotoPayingConfirmPage:) forControlEvents:UIControlEventTouchUpInside];
                    [firstBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                    [cell addSubview:firstBtn];
                }
                
            }else{
                if (indexPath.row==0) {
                    if ([[orderobject.phaseOrderCode substringToIndex:1] isEqualToString:@"G"]){
                        UILabel *orderCodelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, titlelbl.frame.origin.y+titlelbl.frame.size.height+20, kMainScreenWidth-30, 17)];
                        orderCodelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        orderCodelbl.font =[UIFont systemFontOfSize:15.0];
                        orderCodelbl.tag =102;
                        [cell addSubview:orderCodelbl];
                        
                        UILabel *productProFeelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, orderCodelbl.frame.origin.y+orderCodelbl.frame.size.height+15, kMainScreenWidth-30, 17)];
                        productProFeelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        productProFeelbl.font =[UIFont systemFontOfSize:17.0];
                        productProFeelbl.tag =103;
                        [cell addSubview:productProFeelbl];
                        
                        UIImageView *productProFee =[[UIImageView alloc] initWithFrame:CGRectMake(0, productProFeelbl.frame.origin.y, 41, 15)];
                        productProFee.image =[UIImage imageNamed:@"bg_biaoqian.png"];
                        productProFee.tag =105;
                        [cell addSubview:productProFee];
                        
                        UILabel *ppDiscountlbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 2, 33, 11)];
                        ppDiscountlbl.textColor =[UIColor whiteColor];
                        ppDiscountlbl.font =[UIFont systemFontOfSize:11.0];
                        ppDiscountlbl.tag =107;
                        [productProFee addSubview:ppDiscountlbl];
                        
                        UILabel *platformSuperFeelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, productProFeelbl.frame.origin.y+productProFeelbl.frame.size.height+15, kMainScreenWidth-30, 17)];
                        platformSuperFeelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        platformSuperFeelbl.font =[UIFont systemFontOfSize:17.0];
                        platformSuperFeelbl.tag =104;
                        [cell addSubview:platformSuperFeelbl];
                        
                        UIImageView *platformSuperFee =[[UIImageView alloc] initWithFrame:CGRectMake(0, platformSuperFeelbl.frame.origin.y, 41, 15)];
                        platformSuperFee.image =[UIImage imageNamed:@"bg_biaoqian.png"];
                        platformSuperFee.tag =109;
                        [cell addSubview:platformSuperFee];
                        
                        UILabel *psDiscountlbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 2, 33, 11)];
                        psDiscountlbl.textColor =[UIColor whiteColor];
                        psDiscountlbl.font =[UIFont systemFontOfSize:11.0];
                        psDiscountlbl.tag =110;
                        [platformSuperFee addSubview:psDiscountlbl];
                        int height =platformSuperFeelbl.frame.origin.y+platformSuperFeelbl.frame.size.height;
                        if (orderobject.phaseOrderState ==36) {
                            UILabel *alreadyname =[[UILabel alloc] initWithFrame:CGRectMake(15, platformSuperFeelbl.frame.origin.y+platformSuperFeelbl.frame.size.height+10, kMainScreenWidth-30, 17)];
                            alreadyname.font =[UIFont systemFontOfSize:17];
                            alreadyname.tag =115;
                            alreadyname.textColor =[UIColor colorWithHexString:@"#ef6562"];
                            //                                alreadyname.backgroundColor =[UIColor orangeColor];
                            [cell addSubview:alreadyname];
                            
                            UILabel *nevername =[[UILabel alloc] initWithFrame:CGRectMake(15, alreadyname.frame.origin.y+alreadyname.frame.size.height+8, kMainScreenWidth-30, 17)];
                            nevername.font =[UIFont systemFontOfSize:17];
                            nevername.tag =116;
                            nevername.textColor =[UIColor colorWithHexString:@"#ef6562"];
                            //                                nevername.backgroundColor =[UIColor orangeColor];
                            height =nevername.frame.size.height+nevername.frame.origin.y-2;
                            [cell addSubview:nevername];
                        }
                        UIImageView *footline =[[UIImageView alloc] initWithFrame:CGRectMake(12, height+10, kMainScreenWidth-24, 1)];
                        footline.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                        [cell addSubview:footline];
//                        cell.backgroundColor =[UIColor blueColor];
                    }else{
                        UILabel *orderCodelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, titlelbl.frame.origin.y+titlelbl.frame.size.height+20, kMainScreenWidth-30, 17)];
                        orderCodelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        orderCodelbl.font =[UIFont systemFontOfSize:15.0];
                        orderCodelbl.tag =102;
//                        cell.backgroundColor =[UIColor blueColor];
                        [cell addSubview:orderCodelbl];
                        
                        UILabel *phaseOrderFeelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, orderCodelbl.frame.origin.y+orderCodelbl.frame.size.height+15, kMainScreenWidth-30, 17)];
                        phaseOrderFeelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        phaseOrderFeelbl.font =[UIFont systemFontOfSize:17.0];
                        phaseOrderFeelbl.tag =103;
                        [cell addSubview:phaseOrderFeelbl];
                        int height =phaseOrderFeelbl.frame.origin.y+phaseOrderFeelbl.frame.size.height;
                        if (orderobject.makeUpFee!=0) {
                            UILabel *makeUpFee =[[UILabel alloc] initWithFrame:CGRectMake(15, phaseOrderFeelbl.frame.origin.y+phaseOrderFeelbl.frame.size.height+15, kMainScreenWidth-30, 17)];
                            makeUpFee.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                            makeUpFee.font =[UIFont systemFontOfSize:17.0];
                            makeUpFee.tag =104;
                            [cell addSubview:makeUpFee];
                            height =makeUpFee.frame.origin.y+makeUpFee.frame.size.height;
                            if (orderobject.phaseOrderState ==35&&orderobject.makeUpState==5) {
                                UILabel *alreadyname =[[UILabel alloc] initWithFrame:CGRectMake(15, makeUpFee.frame.origin.y+makeUpFee.frame.size.height+15, kMainScreenWidth-30, 17)];
                                alreadyname.font =[UIFont systemFontOfSize:17];
                                alreadyname.tag =115;
                                alreadyname.textColor =[UIColor colorWithHexString:@"#ef6562"];
//                                alreadyname.backgroundColor =[UIColor orangeColor];
                                [cell addSubview:alreadyname];
                                
                                UILabel *nevername =[[UILabel alloc] initWithFrame:CGRectMake(15, alreadyname.frame.origin.y+alreadyname.frame.size.height+8, kMainScreenWidth-30, 17)];
                                nevername.font =[UIFont systemFontOfSize:17];
                                nevername.tag =116;
                                nevername.textColor =[UIColor colorWithHexString:@"#ef6562"];
//                                nevername.backgroundColor =[UIColor orangeColor];
                                height =nevername.frame.size.height+nevername.frame.origin.y-7;
                                [cell addSubview:nevername];
                            }
                            UILabel *makeUpReason =[[UILabel alloc] initWithFrame:CGRectMake(15, height+15, kMainScreenWidth-30, 17)];
                            makeUpReason.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                            makeUpReason.font =[UIFont systemFontOfSize:17.0];
                            makeUpReason.tag =105;
                            [cell addSubview:makeUpReason];
                            
                            height =makeUpReason.frame.origin.y+makeUpReason.frame.size.height;
                        }
                        if (orderobject.phaseOrderState ==36) {
                            UILabel *alreadyname =[[UILabel alloc] initWithFrame:CGRectMake(15, phaseOrderFeelbl.frame.origin.y+phaseOrderFeelbl.frame.size.height+8, kMainScreenWidth-30, 17)];
                            alreadyname.font =[UIFont systemFontOfSize:17];
                            alreadyname.tag =115;
                            alreadyname.textColor =[UIColor colorWithHexString:@"#ef6562"];
//                            alreadyname.backgroundColor =[UIColor orangeColor];
                            [cell addSubview:alreadyname];
                            
                            UILabel *nevername =[[UILabel alloc] initWithFrame:CGRectMake(15, alreadyname.frame.origin.y+alreadyname.frame.size.height+8, kMainScreenWidth-30, 17)];
                            nevername.font =[UIFont systemFontOfSize:17];
                            nevername.tag =116;
                            nevername.textColor =[UIColor colorWithHexString:@"#ef6562"];
//                            nevername.backgroundColor =[UIColor orangeColor];
                            [cell addSubview:nevername];
                            height =nevername.frame.size.height+nevername.frame.origin.y;
                        }
//                        if (orderobject.makeUpFee!=0&&orderobject.phaseOrderState ==7&&orderobject.makeUpState==5) {
//                            UILabel *makeUpFee =[[UILabel alloc] initWithFrame:CGRectMake(15, phaseOrderFeelbl.frame.origin.y+phaseOrderFeelbl.frame.size.height+15, kMainScreenWidth-30, 17)];
//                            makeUpFee.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
//                            makeUpFee.font =[UIFont systemFontOfSize:17.0];
//                            makeUpFee.tag =104;
//                            [cell addSubview:makeUpFee];
//                            
//                            UILabel *alreadyname =[[UILabel alloc] initWithFrame:CGRectMake(15, makeUpFee.frame.origin.y+makeUpFee.frame.size.height+15, kMainScreenWidth-30, 17)];
//                            alreadyname.font =[UIFont systemFontOfSize:17];
//                            alreadyname.tag =115;
//                            alreadyname.textColor =[UIColor colorWithHexString:@"#ef6562"];
//                            //                            alreadyname.backgroundColor =[UIColor orangeColor];
//                            [cell addSubview:alreadyname];
//                            
//                            UILabel *nevername =[[UILabel alloc] initWithFrame:CGRectMake(15, alreadyname.frame.origin.y+alreadyname.frame.size.height+8, kMainScreenWidth-30, 17)];
//                            nevername.font =[UIFont systemFontOfSize:17];
//                            nevername.tag =116;
//                            nevername.textColor =[UIColor colorWithHexString:@"#ef6562"];
//                            //                            nevername.backgroundColor =[UIColor orangeColor];
//                            [cell addSubview:nevername];
//                            
//                            UILabel *makeUpReason =[[UILabel alloc] initWithFrame:CGRectMake(15, nevername.frame.origin.y+nevername.frame.size.height+8, kMainScreenWidth-30, 17)];
//                            makeUpReason.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
//                            makeUpReason.font =[UIFont systemFontOfSize:17.0];
//                            makeUpReason.tag =105;
//                            [cell addSubview:makeUpReason];
//                            
//                            height =makeUpReason.frame.origin.y+makeUpReason.frame.size.height;
//                        }
                        UIImageView *footline =[[UIImageView alloc] initWithFrame:CGRectMake(12, height+10, kMainScreenWidth-24, 1)];
                        footline.tag =106;
                        footline.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                        [cell addSubview:footline];
                    }
                    
                }else{
                    UILabel *combinedlbl =[[UILabel alloc] initWithFrame:CGRectMake(80*kMainScreenWidth/375, 12, kMainScreenWidth-80, 17)];
                    combinedlbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
                    combinedlbl.font =[UIFont systemFontOfSize:17.0];
                    combinedlbl.tag =102;
                    [cell addSubview:combinedlbl];
//                    cell.backgroundColor=[UIColor orangeColor];
//                    if (orderobject.phaseOrderState ==36) {
//                        UILabel *alreadyname =[[UILabel alloc] initWithFrame:CGRectMake(15, combinedlbl.frame.origin.y+combinedlbl.frame.size.height+8, 150, 15)];
//                        alreadyname.font =[UIFont systemFontOfSize:15];
//                        alreadyname.tag =115;
//                        alreadyname.textColor =[UIColor colorWithHexString:@"#ef6562"];
//                        [cell addSubview:alreadyname];
//                        
//                        UILabel *nevername =[[UILabel alloc] initWithFrame:CGRectMake(15, alreadyname.frame.origin.y+alreadyname.frame.size.height+8, 150, 15)];
//                        nevername.font =[UIFont systemFontOfSize:15];
//                        nevername.tag =116;
//                        nevername.textColor =[UIColor colorWithHexString:@"#ef6562"];
//                        [cell addSubview:nevername];
//                    }
                    UILabel *realpaylbl;
                    if (orderobject.originalOrderFee!=orderobject.phaseOrderFee) {
                        realpaylbl =[[UILabel alloc] initWithFrame:CGRectMake(15, combinedlbl.frame.origin.y+combinedlbl.frame.size.height+11, kMainScreenWidth-110, 17)];
                        realpaylbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
                        realpaylbl.font =[UIFont systemFontOfSize:17.0];
                        realpaylbl.tag =115;
                        [cell addSubview:realpaylbl];
                    }
                    UIButton *firstBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    firstBtn.tag =112;
                    firstBtn.frame =CGRectMake(95*kMainScreenWidth/375, combinedlbl.frame.origin.y+combinedlbl.frame.size.height+11, 79*kMainScreenWidth/375, 30);
                    if (orderobject.originalOrderFee!=orderobject.phaseOrderFee) {
                        firstBtn.frame =CGRectMake(95*kMainScreenWidth/375, realpaylbl.frame.origin.y+realpaylbl.frame.size.height+11, 79*kMainScreenWidth/375, 30);
                    }
                    [firstBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                    [firstBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                    firstBtn.titleLabel.font =[UIFont systemFontOfSize:15];
                    firstBtn.hidden =YES;
                    [cell addSubview:firstBtn];
                    
                    UIButton *secondBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    secondBtn.tag =113;
                    [secondBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                    [secondBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                    secondBtn.frame =CGRectMake(188*kMainScreenWidth/375, firstBtn.frame.origin.y, 79*kMainScreenWidth/375, 30);
                    secondBtn.titleLabel.font =[UIFont systemFontOfSize:15];
                    secondBtn.hidden =YES;
                    [cell addSubview:secondBtn];
                    
                    UIButton *thirdBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    thirdBtn.tag =114;
                    [thirdBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                    [thirdBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                    thirdBtn.titleLabel.font =[UIFont systemFontOfSize:15];
                    thirdBtn.frame =CGRectMake(282*kMainScreenWidth/375, firstBtn.frame.origin.y, 79*kMainScreenWidth/375, 30);
                    thirdBtn.hidden =YES;
                    [cell addSubview:thirdBtn];
                }
            }
//        }
//        UILabel *titlelbl =(UILabel *)[cell viewWithTag:100];
//        UILabel *orderStatelbl =(UILabel *)[cell viewWithTag:101];
        if (self.secondOrderCode.length>0) {
            if (indexPath.row==0) {
                CGSize labelsize ;
                UIFont *font = [UIFont fontWithName:@"Arial" size:17];
                titlelbl.text =orderobject.phaseOrderName;
                orderStatelbl.text =orderobject.phaseOrderStateName;
                UILabel *orderCodelbl =(UILabel *)[cell viewWithTag:102];
                orderCodelbl.text =[NSString stringWithFormat:@"订单编号: %@",orderobject.phaseOrderCode];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:orderCodelbl.text];
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:17.0] range:NSMakeRange(0,5)];
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:15.0] range:NSMakeRange(5,orderCodelbl.text.length-5)];
                orderCodelbl.attributedText = str;
                UILabel *productProFeelbl =(UILabel *)[cell viewWithTag:103];
                productProFeelbl.text =[NSString stringWithFormat:@"服务名称: 成品保护 ¥ %.2f",self.contractObject.productProFee];
                
                labelsize = [util calHeightForLabel:[NSString stringWithFormat:@"服务名称: 成品保护 ¥ %.2f",self.contractObject.productProFee] width:kMainScreenWidth-50 font:font];
                UIImageView *productProFee =(UIImageView *)[cell viewWithTag:105];
                productProFee.frame =CGRectMake(productProFeelbl.frame.origin.x+labelsize.width+5, productProFee.frame.origin.y, productProFee.frame.size.width, productProFee.frame.size.height);
                
                UILabel *ppDiscountlbl =(UILabel *)[productProFee viewWithTag:107];
                ppDiscountlbl.text =[NSString stringWithFormat:@"%.1f折",[self.contractObject.ppDiscount doubleValue]];
                
                if ([self.contractObject.ppDiscount doubleValue]<=0) {
                    productProFee.hidden =YES;
                }
                
                UILabel *platformSuperFeelbl =(UILabel *)[cell viewWithTag:104];
                platformSuperFeelbl.text =[NSString stringWithFormat:@"服务名称: 平台监理 ¥ %.2f",self.contractObject.platformSuperFee];
                
                labelsize = [util calHeightForLabel:[NSString stringWithFormat:@"服务名称: 平台监理 ¥ %.2f",self.contractObject.platformSuperFee] width:kMainScreenWidth-50 font:font];
                
                UIImageView *platformSuperFee =(UIImageView *)[cell viewWithTag:109];
                platformSuperFee.frame =CGRectMake(platformSuperFeelbl.frame.origin.x+labelsize.width+5, platformSuperFee.frame.origin.y, platformSuperFee.frame.size.width, platformSuperFee.frame.size.height);
                
                UILabel *psDiscountlbl =(UILabel *)[platformSuperFee viewWithTag:110];
                psDiscountlbl.text =[NSString stringWithFormat:@"%.1f折",[self.contractObject.psDiscount doubleValue]];
                
                if ([self.contractObject.psDiscount doubleValue]<=0) {
                    platformSuperFee.hidden =YES;
                }
            }
            if (indexPath.row ==1) {
                titlelbl.text =secondOrder.phaseOrderName;
                orderStatelbl.text =secondOrder.phaseOrderStateName;
                UILabel *orderCodelbl =(UILabel *)[cell viewWithTag:102];
                orderCodelbl.text =[NSString stringWithFormat:@"订单编号: %@",secondOrder.phaseOrderCode];
                UILabel *phaseOrderFeelbl =(UILabel *)[cell viewWithTag:103];
                phaseOrderFeelbl.text =[NSString stringWithFormat:@"订单金额: ¥ %.2f",secondOrder.phaseOrderFee];
                if (orderobject.phaseOrderState ==36) {
                    UILabel *alreadyname =[cell viewWithTag:115];
                    alreadyname.text =[NSString stringWithFormat:@"已  支  付: ¥ %.2f",orderobject.alreadyPayment];
                    UILabel *nevername =[cell viewWithTag:116];
                    nevername.text =[NSString stringWithFormat:@"待  支  付: ¥ %.2f",orderobject.waitePayment];
                }
                
            }
            if (indexPath.row==2) {
                titlelbl.text =@"合计金额:";
                orderStatelbl.hidden =YES;
                UILabel *combinedlbl =(UILabel *)[cell viewWithTag:102];
                combinedlbl.text =[NSString stringWithFormat:@"     ¥ %.2f",self.contractObject.productProFee+self.contractObject.platformSuperFee+secondOrder.originalOrderFee];
                UILabel *realpaylbl =(UILabel *)[cell viewWithTag:115];
                if (realpaylbl) {
                    titlelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    combinedlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付金额:   ¥ %.2f",self.contractObject.productProFee+self.contractObject.platformSuperFee+secondOrder.phaseOrderFee]];
                    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,5)];
                    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str2.length-5)];
                    realpaylbl.attributedText =str2;
                }
            }
        }else{
            if (indexPath.row ==0) {
                if ([[orderobject.phaseOrderCode substringToIndex:1] isEqualToString:@"G"]){
                    CGSize labelsize ;
                    UIFont *font = [UIFont fontWithName:@"Arial" size:17];
                    titlelbl.text =orderobject.phaseOrderName;
                    orderStatelbl.text =orderobject.phaseOrderStateName;
                    UILabel *orderCodelbl =(UILabel *)[cell viewWithTag:102];
                    orderCodelbl.text =[NSString stringWithFormat:@"订单编号: %@",orderobject.phaseOrderCode];
                    UILabel *productProFeelbl =(UILabel *)[cell viewWithTag:103];
                    labelsize = [util calHeightForLabel:[NSString stringWithFormat:@"服务名称: 成品保护 ¥ %.2f",self.contractObject.productProFee] width:kMainScreenWidth-50 font:font];
                    productProFeelbl.text =[NSString stringWithFormat:@"服务名称: 成品保护 ¥ %.2f",self.contractObject.productProFee];
                    
                    UIImageView *productProFee =(UIImageView *)[cell viewWithTag:105];
                    productProFee.frame =CGRectMake(productProFeelbl.frame.origin.x+labelsize.width+5, productProFee.frame.origin.y, productProFee.frame.size.width, productProFee.frame.size.height);
                    
                    UILabel *ppDiscountlbl =(UILabel *)[productProFee viewWithTag:107];
                    ppDiscountlbl.text =[NSString stringWithFormat:@"%@折",self.contractObject.ppDiscount];
                    if ([self.contractObject.ppDiscount doubleValue]<=0) {
                        productProFee.hidden =YES;
                    }
                    
                    UILabel *platformSuperFeelbl =(UILabel *)[cell viewWithTag:104];
                    platformSuperFeelbl.text =[NSString stringWithFormat:@"服务名称: 平台监理 ¥ %.2f",self.contractObject.platformSuperFee];
                    labelsize = [util calHeightForLabel:[NSString stringWithFormat:@"服务名称: 平台监理 ¥ %.2f",self.contractObject.platformSuperFee] width:kMainScreenWidth-50 font:font];
                    
                    UIImageView *platformSuperFee =(UIImageView *)[cell viewWithTag:109];
                    platformSuperFee.frame =CGRectMake(platformSuperFeelbl.frame.origin.x+labelsize.width+5, platformSuperFee.frame.origin.y, platformSuperFee.frame.size.width, platformSuperFee.frame.size.height);
                    
                    UILabel *psDiscountlbl =(UILabel *)[platformSuperFee viewWithTag:110];
                    psDiscountlbl.text =[NSString stringWithFormat:@"%@折",self.contractObject.psDiscount];
                    if ([self.contractObject.psDiscount doubleValue]<=0) {
                        platformSuperFee.hidden =YES;
                    }
                    if (orderobject.phaseOrderState ==36) {
                        UILabel *alreadyname =[cell viewWithTag:115];
                        alreadyname.text =[NSString stringWithFormat:@"已  支  付: ¥ %.2f",orderobject.alreadyPayment];
                        alreadyname.hidden =NO;
                        UILabel *nevername =[cell viewWithTag:116];
                        nevername.text =[NSString stringWithFormat:@"待  支  付: ¥ %.2f",orderobject.waitePayment];
                        nevername.hidden =NO;
                        UIImageView *footline =(UIImageView *)[cell viewWithTag:106];
                        footline.frame =CGRectMake(12, nevername.frame.origin.y+nevername.frame.size.height+10, kMainScreenWidth-24, 1);
                    }
                }else{
                    titlelbl.text =orderobject.phaseOrderName;
                    orderStatelbl.text =orderobject.phaseOrderStateName;
                    UILabel *orderCodelbl =(UILabel *)[cell viewWithTag:102];
                    orderCodelbl.text =[NSString stringWithFormat:@"订单编号: %@",orderobject.phaseOrderCode];
                    UILabel *phaseOrderFeelbl =(UILabel *)[cell viewWithTag:103];
                    phaseOrderFeelbl.text =[NSString stringWithFormat:@"订单金额: ¥ %.2f",orderobject.originalOrderFee];
                    if (orderobject.makeUpFee!=0) {
                        UILabel *makeUpFee =(UILabel *)[cell viewWithTag:104];
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"找补金额: ¥ %.2f",orderobject.makeUpFee]];
                        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,5)];
                        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(5,str.length-5)];
                        makeUpFee.attributedText =str;
                        
                        UILabel *makeUpReson =(UILabel *)[cell viewWithTag:105];
                        UIFont *font = [UIFont fontWithName:@"Arial" size:17];
                        CGSize size = CGSizeMake(kMainScreenWidth-30,2000);
                        NSString *resonstr =[NSString stringWithFormat:@"找补理由: %@",orderobject.makeUpReason];
                        CGSize labelsize = [resonstr sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
                        makeUpReson.lineBreakMode = UILineBreakModeWordWrap;
                        makeUpReson.numberOfLines =0;
                        makeUpReson.text =resonstr;
                        makeUpReson.font =font;
                        makeUpReson.frame =CGRectMake(makeUpReson.frame.origin.x, makeUpReson.frame.origin.y, labelsize.width, labelsize.height);
                        UIImageView *footline =(UIImageView *)[cell viewWithTag:106];
                        footline.frame =CGRectMake(12, makeUpReson.frame.origin.y+makeUpReson.frame.size.height+10, kMainScreenWidth-24, 1);
                    }
                    if (orderobject.phaseOrderState ==36) {
                        UILabel *alreadyname =[cell viewWithTag:115];
                        alreadyname.text =[NSString stringWithFormat:@"已  支  付: ¥ %.2f",orderobject.alreadyPayment];
                        alreadyname.hidden =NO;
                        UILabel *nevername =[cell viewWithTag:116];
                        nevername.text =[NSString stringWithFormat:@"待  支  付: ¥ %.2f",orderobject.waitePayment];
                        nevername.hidden =NO;
                        UIImageView *footline =(UIImageView *)[cell viewWithTag:106];
                        footline.frame =CGRectMake(12, nevername.frame.origin.y+nevername.frame.size.height+10, kMainScreenWidth-24, 1);
                    }
                    if (orderobject.phaseOrderState ==35&&orderobject.makeUpState ==5) {
                        UILabel *alreadyname =[cell viewWithTag:115];
                        alreadyname.text =[NSString stringWithFormat:@"已  支  付: ¥ %.2f",orderobject.mkAlreadyPayment];
                        alreadyname.hidden =NO;
                        UILabel *nevername =[cell viewWithTag:116];
                        nevername.text =[NSString stringWithFormat:@"待  支  付: ¥ %.2f",orderobject.mkWaitePayment];
                        nevername.hidden =NO;
//                        UIImageView *footline =(UIImageView *)[cell viewWithTag:106];
//                        footline.frame =CGRectMake(12, nevername.frame.origin.y+nevername.frame.size.height+10, kMainScreenWidth-24, 1);
                    }
                    if (orderobject.phaseOrderState ==35&&orderobject.makeUpState !=5) {
                        UILabel *alreadyname =[cell viewWithTag:115];
                        alreadyname.hidden =YES;
                        UILabel *nevername =[cell viewWithTag:116];
                        nevername.hidden =YES;
                    }
                }
//                cell.backgroundColor =[UIColor orangeColor];
            }
            if (indexPath.row ==1) {
//                cell.backgroundColor =[UIColor blueColor];
                titlelbl.text =@"结算金额:";
                
                
                orderStatelbl.hidden =YES;
                UILabel *combinedlbl =(UILabel *)[cell viewWithTag:102];
                combinedlbl.text =[NSString stringWithFormat:@"      ¥ %.2f",orderobject.originalOrderFee+orderobject.makeUpFee];
                UILabel *realpaylbl =(UILabel *)[cell viewWithTag:115];
//                realpaylbl.backgroundColor =[UIColor purpleColor];
                if (realpaylbl) {
                    titlelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    combinedlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付金额:     ¥ %.2f",orderobject.clearFee]];
                    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,5)];
                    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str2.length-5)];
                    realpaylbl.attributedText =str2;
                }
//                if (orderobject.phaseOrderState ==36) {
//                    titlelbl.frame =CGRectMake(titlelbl.frame.origin.x, 52, titlelbl.frame.size.width, titlelbl.frame.size.height);
//                    combinedlbl.frame =CGRectMake(combinedlbl.frame.origin.x, 52, combinedlbl.frame.size.width, combinedlbl.frame.size.height);
//                }
                
                UIButton *firstBtn = (UIButton *)[cell viewWithTag:114];
                firstBtn.layer.masksToBounds = YES;
                firstBtn.layer.cornerRadius = 3;
                firstBtn.layer.borderColor = kThemeColor.CGColor;
                firstBtn.layer.borderWidth = 1;
                firstBtn.hidden = YES;
                
                //配置按钮左
                if (orderobject.phaseOrderState == 1) {
//                    firstBtn.hidden = NO;
//                    [firstBtn setTitle:@"确认订单" forState:UIControlStateNormal];
//                    [firstBtn addTarget:self action:@selector(requestConfirmOrder:) forControlEvents:UIControlEventTouchUpInside];
                } else if ( orderobject.phaseOrderState == 3  || orderobject.phaseOrderState == 8  || orderobject.phaseOrderState == 12 || orderobject.phaseOrderState == 14 || orderobject.phaseOrderState == 16 || orderobject.phaseOrderState == 23) {
                    NSLog(@"%d======无显示",(int)indexPath.row);
                    NSLog(@"%@",orderobject.phaseOrderName);
                    firstBtn.hidden =YES;
                } else if (orderobject.phaseOrderState == 7) {
                    
//                    }else{
                        firstBtn.hidden = NO;
                        [firstBtn setTitle:@"确认付款" forState:UIControlStateNormal];
                        [firstBtn addTarget:self action:@selector(requestConfirmOrderOrConfirmPaying:) forControlEvents:UIControlEventTouchUpInside];
//                    }
                } else if (orderobject.phaseOrderState == 17) {
                    if (![[orderobject.phaseOrderCode substringToIndex:1] isEqualToString:@"G"]) {
                        firstBtn.hidden = NO;
                        NSLog(@"%d=======售后",(int)indexPath.row);
                        NSLog(@"%@",orderobject.phaseOrderName);
                        [firstBtn setTitle:@"申请售后" forState:UIControlStateNormal];
                        [firstBtn addTarget:self action:@selector(gotoAfterSaleVC:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                    //            firstBtn.hidden = NO;
                    //            [firstBtn setTitle:@"评论" forState:UIControlStateNormal];
                    //            [firstBtn addTarget:self action:@selector(myappraise:) forControlEvents:UIControlEventTouchUpInside];
                }else if (orderobject.phaseOrderState == 2){
                    firstBtn.hidden = NO;
                    NSLog(@"%d=======托管",(int)indexPath.row);
                    NSLog(@"%@",orderobject.phaseOrderName);
                    [firstBtn setTitle:@"立即托管" forState:UIControlStateNormal];
                    [firstBtn addTarget:self action:@selector(gotoPayingConfirmPage:) forControlEvents:UIControlEventTouchUpInside];
                }else if (orderobject.phaseOrderState ==10){
                    //            firstBtn.hidden = NO;
                    //            [firstBtn setTitle:@"服务评审" forState:UIControlStateNormal];
                    //            [firstBtn addTarget:self action:@selector(gotoServiceReview:) forControlEvents:UIControlEventTouchUpInside];
                }else if (orderobject.phaseOrderState == 17) {
                    firstBtn.hidden = NO;
                    NSLog(@"%d=======售后",(int)indexPath.row);
                    NSLog(@"%@",orderobject.phaseOrderName);
                    [firstBtn setTitle:@"申请售后" forState:UIControlStateNormal];
                    [firstBtn addTarget:self action:@selector(gotoAfterSaleVC:) forControlEvents:UIControlEventTouchUpInside];
                }else if (orderobject.phaseOrderState ==33||orderobject.phaseOrderState ==36){
                    firstBtn.hidden = NO;
                    [firstBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                    [firstBtn addTarget:self action:@selector(gotoPayingConfirmPage:) forControlEvents:UIControlEventTouchUpInside];
                }else if (orderobject.phaseOrderState ==35){
                    if (orderobject.makeUpState==5) {
                        firstBtn.hidden = NO;
                        [firstBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                        [firstBtn addTarget:self action:@selector(gotoPayingConfirmPage:) forControlEvents:UIControlEventTouchUpInside];
                    }else{
                        firstBtn.hidden = NO;
                        [firstBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                        [firstBtn addTarget:self action:@selector(requestConfirmOrderOrConfirmPaying:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }else if (orderobject.phaseOrderState == 4|| orderobject.phaseOrderState == 6||orderobject.phaseOrderState == 9||orderobject.phaseOrderState == 16){
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
                if (orderobject.phaseOrderState == 1) {
                    //            secondBtn.hidden = NO;
                    //            [secondBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    //            [secondBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
                } else if ( orderobject.phaseOrderState == 9 || orderobject.phaseOrderState == 16) {
//                    secondBtn.hidden = NO;
//                    [secondBtn setTitle:@"申请退款" forState:UIControlStateNormal];
//                    [secondBtn addTarget:self action:@selector(gotoRefundVC:) forControlEvents:UIControlEventTouchUpInside];
                    
                } else if (orderobject.phaseOrderState == 7||orderobject.phaseOrderState == 35) {
                    secondBtn.hidden = NO;
                    [secondBtn setTitle:@"拒绝付款" forState:UIControlStateNormal];
                    [secondBtn addTarget:self action:@selector(requestRefusePaying:) forControlEvents:UIControlEventTouchUpInside];
                    if (orderobject.makeUpState ==3) {
                        [secondBtn removeTarget:self action:@selector(requestRefusePaying:) forControlEvents:UIControlEventTouchUpInside];
                        [secondBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                        [secondBtn addTarget:self action:@selector(gotoRefundVC:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    if (orderobject.makeUpState==5) {
                        secondBtn.hidden=YES;
                    }
                } else if (orderobject.phaseOrderState == 3 || orderobject.phaseOrderState == 8 || orderobject.phaseOrderState == 23) {
                    secondBtn.hidden = YES;
                } else if (orderobject.phaseOrderState == 12 || orderobject.phaseOrderState == 14) {
//                    secondBtn.hidden = NO;
//                    [secondBtn setTitle:@"取消退款" forState:UIControlStateNormal];
//                    [secondBtn addTarget:self action:@selector(requestCancelRefund:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                UIButton *thirdBtn = (UIButton *)[cell viewWithTag:112];
                thirdBtn.layer.masksToBounds = YES;
                thirdBtn.layer.cornerRadius = 3;
                thirdBtn.layer.borderColor = kThemeColor.CGColor;
                thirdBtn.layer.borderWidth = 1;
                thirdBtn.hidden = YES;
                
                //配置按钮三
                if (orderobject.phaseOrderState == 7||orderobject.phaseOrderState == 35) {
                    thirdBtn.hidden = NO;
                    [thirdBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                    [thirdBtn addTarget:self action:@selector(gotoRefundVC:) forControlEvents:UIControlEventTouchUpInside];
                    if (orderobject.makeUpState ==3||orderobject.makeUpState==5) {
                        thirdBtn.hidden = YES;
                    }
                }
            }
        }
        
        return cell;
    }else{
        NewOrderDetailObject *orderObject =[self.contractProjects objectAtIndex:indexPath.row];
        static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
        PhaseOrderCell *cell = (PhaseOrderCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        //        PhaseOrderCell *cell = (PhaseOrderCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[PhaseOrderCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CustomCellIdentifier];
            cell.orderdetail =orderObject;
            cell.contractTotalFee =self.contractObject.phaseOrderFee;
            if (indexPath.row==0) {
                cell.isfirst =YES;
            }else{
                cell.isfirst =NO;
            }
            cell.delegate =self;
            [cell getCellHeight];
        }else{
            cell.orderdetail =orderObject;
            cell.contractTotalFee =self.contractObject.phaseOrderFee;
            if (indexPath.row==0) {
                cell.isfirst =YES;
            }else{
                cell.isfirst =NO;
            }
            cell.delegate =self;
            [cell getCellHeight];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(void)touchContract{
    IDIAI3ContractDetailViewController *contract =[[IDIAI3ContractDetailViewController alloc] init];
    contract.title =@"订单合同";
    contract.orderCode =self.contractObject.phaseOrderCode;
    [self.navigationController pushViewController:contract animated:YES];
    //    [self.navigationController pushViewController:contract an
}
- (void)gotoPayingConfirmPage:(id)sender {
    NSString * str =@"";
    for (int i = 0 ; i<self.contractProjects.count; i++) {
        NewOrderDetailObject * newOrderDetailObj = self.contractProjects[i];
        if ([newOrderDetailObj.phaseOrderStateName isEqualToString:@"待托管"]||[newOrderDetailObj.phaseOrderStateName isEqualToString:@"部分支付"]) {
            str = newOrderDetailObj.phaseOrderName;
            break;
        }
    }
    
    NewOrderDetailObject * lastPhaseObj;
    int currentPhaseRanking ;
    for (int i=0; i<self.contractProjects.count; i++) {
        NewOrderDetailObject * newOrderDetailObj = self.contractProjects[i];
        if ([self.phaseOrderCode isEqualToString:newOrderDetailObj.phaseOrderCode]) {
            currentPhaseRanking=i ;
            break;
        }
    }

    if (currentPhaseRanking!=0) {
//        
        lastPhaseObj = self.contractProjects[currentPhaseRanking-1];
        if ([lastPhaseObj.phaseOrderStateName isEqualToString:@"待托管"]||[lastPhaseObj.phaseOrderStateName isEqualToString:@"部分支付"]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"请先完成【%@】，按施工步骤进行哦！",str] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return;

        }
       }
    
    
    [savelogObj saveLog:@"立即支付" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:61];
    NewOrderDetailObject *orderobject;
    NewOrderDetailObject *secondOrder;
    if (self.secondOrderCode.length>0) {
        for (NewOrderDetailObject *object in self.contractProjects) {
            if ([self.phaseOrderCode isEqualToString:object.phaseOrderCode]) {
                orderobject =object;
            }
            if ([self.secondOrderCode isEqualToString:object.phaseOrderCode]) {
                secondOrder =object;
            }
        }
    }else{
        for (NewOrderDetailObject *object in self.contractProjects) {
            if ([self.phaseOrderCode isEqualToString:object.phaseOrderCode]) {
                orderobject =object;
            }
        }
    }
    NSString *orderPhraseName =[NSString string];
    if (secondOrder.phaseOrderName.length>0) {
        orderPhraseName =[NSString stringWithFormat:@"%@+%@",orderobject.phaseOrderName,secondOrder.phaseOrderName];
    }else{
        orderPhraseName =orderobject.phaseOrderName;
    }
    NSString *orderCodePhase =[NSString string];
    if (secondOrder.phaseOrderCode.length>0) {
        orderCodePhase =[NSString stringWithFormat:@"%@,%@",orderobject.phaseOrderCode,secondOrder.phaseOrderCode];
    }else{
        orderCodePhase =orderobject.phaseOrderCode;
    }
    double orderPhraseFee =orderobject.phaseOrderFee+secondOrder.phaseOrderFee;
    if (orderobject.phaseOrderState ==36) {
        orderPhraseFee =orderobject.waitePayment;
    }
    if (orderobject.makeUpState==5) {
        orderPhraseName =@"找补单";
        orderCodePhase =orderobject.frOrderCode;
        orderPhraseFee =orderobject.mkWaitePayment;
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
                            [self requestOrderDetail];
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
                                if (secondOrder) {
                                    amounts =[NSString stringWithFormat:@"%f,%f",orderobject.phaseOrderFee,secondOrder.phaseOrderFee];
                                }else{
                                    amounts =[NSString stringWithFormat:@"%f",orderobject.phaseOrderFee];
                                }
                                if (orderobject.makeUpState==5) {
                                    amounts =[NSString stringWithFormat:@"%f",orderobject.makeUpFee];
                                }
                                self.selectOrder =orderobject;
                                onlinepay.amounts =amounts;
                                [self.navigationController pushViewController:onlinepay animated:YES];
                            }else{
                                
                                self.isMakeUp =YES;
                                self.selectOrder =orderobject;
                                PayingConfirmViewController *payingConfirmVC = [[PayingConfirmViewController alloc]init];
                                payingConfirmVC.serviceNameStr = orderPhraseName;
                                payingConfirmVC.moneyFloat = orderPhraseFee;
                                payingConfirmVC.orderNo = orderCodePhase;
                                NSString *amounts =[NSString string];
                                if (secondOrder) {
                                    amounts =[NSString stringWithFormat:@"%f,%f",orderobject.phaseOrderFee,secondOrder.phaseOrderFee];
                                }else{
                                    amounts =[NSString stringWithFormat:@"%f",orderobject.phaseOrderFee];
                                }
                                if (orderobject.makeUpState==5) {
                                    amounts =[NSString stringWithFormat:@"%f",orderobject.makeUpFee];
                                }
                                payingConfirmVC.amounts =amounts;
                                payingConfirmVC.fromStr=@"orderDetailOfGoodsVC";
                                payingConfirmVC.fromController =@"contract";
                                IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
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
    
    
    
}
-(void)DisPlayLoginView{
    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
    login.delegate=self;
    [login show];
    return;
}
-(void)requestConfirmOrderOrConfirmPaying:(UIButton *)sender{
    NewOrderDetailObject *orderobject;
    NewOrderDetailObject *secondOrder;
    if (self.secondOrderCode.length>0) {
        for (NewOrderDetailObject *object in self.contractProjects) {
            if ([self.phaseOrderCode isEqualToString:object.phaseOrderCode]) {
                orderobject =object;
            }
            if ([self.secondOrderCode isEqualToString:object.phaseOrderCode]) {
                secondOrder =object;
            }
        }
    }else{
        for (NewOrderDetailObject *object in self.contractProjects) {
            if ([self.phaseOrderCode isEqualToString:object.phaseOrderCode]) {
                orderobject =object;
            }
        }
    }
    if (orderobject.phaseOrderState ==35) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"您的交易订单金额¥ %.2f，结算款超支请补款：¥ %.2f！［如有疑问请与服务方沟通］",orderobject.phaseOrderFee ,orderobject.makeUpFee] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即补差", nil];
        alert.tag =1000;
        self.selectOrder =orderobject;
        self.isMakeUp =YES;
        [alert show];
        return;
    }else{
        self.selectOrder =orderobject;
        if (orderobject.makeUpFee<0) {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"您的交易订单金额¥ %.2f，结算有找零¥ %.2f，交易完成后，找零金额会在7～15天退回您的账户！［如有疑问请与服务方沟通］",orderobject.phaseOrderFee,-orderobject.makeUpFee] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag=1001;
            [alert show];
            return;
        }
    }
    IDIAI3ConfirmPaymentViewController *confirmPay =[[IDIAI3ConfirmPaymentViewController alloc] init];
    confirmPay.orderType =4;
    
    float orderPhraseFee =orderobject.clearFee;
    confirmPay.payforMoney =orderPhraseFee;
    confirmPay.orderCode =orderobject.phaseOrderCode;
    [self.navigationController pushViewController:confirmPay animated:YES];
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
            payingConfirmVC.moneyFloat = self.selectOrder.makeUpFee;
            payingConfirmVC.orderNo = self.selectOrder.frOrderCode;
            payingConfirmVC.amounts =[NSString stringWithFormat:@"%f",self.selectOrder.makeUpFee];
            payingConfirmVC.fromStr=@"orderDetailOfGoodsVC";
            payingConfirmVC.fromController =@"contract";
            IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate.nav pushViewController:payingConfirmVC animated:YES];
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
    }else{
        if (buttonIndex ==0) {
            IDIAI3ConfirmPaymentViewController *confirmPay =[[IDIAI3ConfirmPaymentViewController alloc] init];
            confirmPay.orderType =4;
            
            float orderPhraseFee =self.selectOrder.clearFee;
            confirmPay.payforMoney =orderPhraseFee;
            confirmPay.orderCode =self.selectOrder.phaseOrderCode;
            IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate.nav pushViewController:confirmPay animated:YES];
        }
    }
    
}
- (void)gotoAfterSaleVC:(id)sender {
    AfterSaleViewController *afterSaleVC = [[AfterSaleViewController alloc]initWithNibName:@"AfterSaleViewController" bundle:nil];
    afterSaleVC.orderIDStr = self.phaseOrderCode;
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.nav pushViewController:afterSaleVC animated:YES];
}
- (void)gotoRefundVC:(id)sender {
    NewOrderDetailObject *orderobject =[[NewOrderDetailObject alloc] init];
    for (NewOrderDetailObject *object in self.contractProjects) {
        if ([self.phaseOrderCode isEqualToString:object.phaseOrderCode]) {
            orderobject =object;
        }
    }
    RefundViewController *refundVC = [[RefundViewController alloc]initWithNibName:@"RefundViewController" bundle:nil];
    refundVC.orderIDStr = self.phaseOrderCode;
    if (orderobject.makeUpState==3) {
        refundVC.moneyFloat = orderobject.clearFee;
    }else{
        refundVC.moneyFloat = orderobject.phaseOrderFee;
    }
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.nav pushViewController:refundVC animated:YES];
}
-(void)requestRefusePaying:(UIButton *)sender{
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
        NSDictionary *bodyDic = @{@"phaseOrderCode":self.phaseOrderCode};
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
                    
                    if (kResCode == 103261) {
                        [self stopRequest];
                        [TLToast showWithText:@"拒绝付款成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else if (kResCode == 103269) {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"拒绝付款失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"拒绝付款失败"];
                    } else if (kResCode == 103262) {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"拒绝付款失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"订单状态不对"];
                    }else if (kResCode == 103264) {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"拒绝付款失败";
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
                                  customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                  customPromp.contenttxt =@"拒绝付款失败";
                                  UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                  [customPromp addGestureRecognizer:tap];
                                  [customPromp show];
                              });
                          }
                               method:url postDict:post];
    });
}
#pragma mark - 取消退款
-(void)requestCancelRefund:(UIButton *)sender {
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
        
        
        NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
        [headerDict setObject:@"ID0316" forKey:@"cmdID"];
        [headerDict setObject:string_token forKey:@"token"];
        [headerDict setObject:string_userid forKey:@"userID"];
        [headerDict setObject:@"ios" forKey:@"deviceType"];
        [headerDict setObject:kCityCode forKey:@"cityCode"];
        NSString *string=[headerDict JSONString];
        
        NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
        [bodyDict setObject:self.phaseOrderCode forKey:@"phaseOrderCode"];
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
