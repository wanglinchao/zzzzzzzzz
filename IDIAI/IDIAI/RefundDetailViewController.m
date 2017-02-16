//
//  RefundDetailViewController.m
//  IDIAI
//
//  Created by Ricky on 15-2-4.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "RefundDetailViewController.h"
#import "TLToast.h"
#import "RefundDetailModel.h"
#import "util.h"
#import "LoginView.h"
#import "AutomaticLogin.h"
#import "ImageZoomView.h"
#import "MyOrderDetailConfirmViewController.h"
#import "savelogObj.h"
#import "ShopClearblankCell.h"
#import "UIImageView+WebCache.h"
#import "IDIAI3ContractDetailViewController.h"
#define Kimageview_tag 100     //凭证图
#define Kuibutton_tag 1000   //凭证图

@interface RefundDetailViewController () <UITableViewDataSource, UITableViewDelegate,LoginViewDelegate> {
    UITableView *_theTableView;
    CGFloat _height;//第一部分cell高度
    RefundDetailModel *_refundDetailModel;
//    NSString *_callNum;
}

@end

@implementation RefundDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    //    [self customizeNavigationBar];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [savelogObj saveLog:@"查看服务退款详情" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:71];
    
    self.title = @"退款详情";
    //    self.navigationController.navigationBar.translucent = NO;
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    
    //导航右按钮
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 90, 40)];
    [rightButton setImage:[UIImage imageNamed:@"btn_dianhua"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 25, 0, -5);
    [rightButton addTarget:self
                    action:@selector(clickTelBtn:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setFrame:CGRectMake(5, 5, 40, 40)];
//    [rightButton setImage:[UIImage imageNamed:@"ico_kefu"] forState:UIControlStateNormal];
//    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [rightButton addTarget:self
//                    action:@selector(clickTelBtn:)
//          forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    _theTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _height = 445;
    [self requestRefundDetail];
//    [self requestCallNum];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        
   return _height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid=@"Mycellid";
    ShopClearblankCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ShopClearblankCell" owner:nil options:nil] lastObject];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    UIView *view_bg=[[UIView alloc]init];
    view_bg.layer.cornerRadius=5;
    view_bg.backgroundColor=[UIColor whiteColor];
    [cell addSubview:view_bg];
    
    float height=10;
    
    UILabel *lab_name=[[UILabel alloc]initWithFrame:CGRectMake(10, height+5, (kMainScreenWidth-60)/2, 20)];
    lab_name.textColor=[UIColor darkGrayColor];
    lab_name.textAlignment=NSTextAlignmentLeft;
    lab_name.font=[UIFont systemFontOfSize:17];
    lab_name.text=_refundDetailModel.userName;
    [view_bg addSubview:lab_name];
    
    UILabel *lab_State=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-10-(kMainScreenWidth-60)/2, height+5, (kMainScreenWidth-60)/2, 20)];
    lab_State.textColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    lab_State.textAlignment=NSTextAlignmentRight;
    lab_State.font=[UIFont systemFontOfSize:17];
    lab_State.text= _refundDetailModel.refundStateName;
    [view_bg addSubview:lab_State];
    
    height+=40;
    
    UIView *line_one=[[UIView alloc]initWithFrame:CGRectMake(10, height, kMainScreenWidth-20, 0.5)];
    line_one.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
    [view_bg addSubview:line_one];
    
    height+=12;
    
    UILabel *orderCode=[[UILabel alloc]initWithFrame:CGRectMake(10, height, kMainScreenWidth-50, 20)];
    orderCode.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
    orderCode.textAlignment=NSTextAlignmentLeft;
    orderCode.font=[UIFont systemFontOfSize:15];
    orderCode.text=[NSString stringWithFormat:@"退款编号: %@", _refundDetailModel.refundOrderCode];
    [view_bg addSubview:orderCode];
    
    height+=32;
    
    UILabel *orderDate=[[UILabel alloc]initWithFrame:CGRectMake(10, height, kMainScreenWidth-50, 20)];
    orderDate.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
    orderDate.textAlignment=NSTextAlignmentLeft;
    orderDate.font=[UIFont systemFontOfSize:16];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_refundDetailModel.createAt doubleValue]/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];

    orderDate.text=[NSString stringWithFormat:@"退款日期: %@", confromTimespStr];
    [view_bg addSubview:orderDate];
    
    height+=32;
    
    UILabel *orderTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, height, kMainScreenWidth-50, 20)];
    orderTypeLabel.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
    orderTypeLabel.textAlignment=NSTextAlignmentLeft;
    orderTypeLabel.font=[UIFont systemFontOfSize:16];
    orderTypeLabel.text =[NSString stringWithFormat:@"退款名称:%@",_refundDetailModel.phaseOrderName];
//    if (_refundDetailModel.servantRoleId == 1) {
//        orderTypeLabel.text = @"合同类型: 设计合同";
//    } else if (_refundDetailModel.servantRoleId == 4) {
//        orderTypeLabel.text = @"合同类型: 施工合同";
//    } else if (_refundDetailModel.servantRoleId == 6) {
//        orderTypeLabel.text = @"合同类型: 监理合同";
//    }
    [view_bg addSubview:orderTypeLabel];
    
    height+=32;
    
//    UILabel *villageName=[[UILabel alloc]initWithFrame:CGRectMake(10, height, kMainScreenWidth-50, 20)];
//    villageName.textColor=[UIColor darkGrayColor];
//    villageName.textAlignment=NSTextAlignmentLeft;
//    villageName.font=[UIFont systemFontOfSize:15];
//    villageName.text=[NSString stringWithFormat:@"小区名称: %@", _refundDetailModel.userCommunityName];
//    [view_bg addSubview:villageName];
//    
//    height+=25;
    UILabel *RefundReasonTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, height, 70, 20)];
    RefundReasonTitle.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
    RefundReasonTitle.textAlignment=NSTextAlignmentLeft;
    RefundReasonTitle.font=[UIFont systemFontOfSize:16];
    RefundReasonTitle.text=@"退款描述: ";
    [view_bg addSubview:RefundReasonTitle];
    
    NSString *str;
    if(_refundDetailModel.refundReason) str=_refundDetailModel.refundReason;
    else str=@"";
    CGSize sizeReason=[util calHeightForLabel:str width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:15]];
    UILabel *RefundReason=[[UILabel alloc]initWithFrame:CGRectMake(80, height+2, kMainScreenWidth-120, sizeReason.height)];
    RefundReason.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
    RefundReason.textAlignment=NSTextAlignmentLeft;
    RefundReason.font=[UIFont systemFontOfSize:16];
    RefundReason.numberOfLines=0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    RefundReason.attributedText=attributedString;
    [RefundReason sizeToFit];//必须
    [view_bg addSubview:RefundReason];
    
    height+=sizeReason.height+sizeReason.height/20*5+10;
    
    UILabel *refundMoneyTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, height, 70, 20)];
    refundMoneyTitle.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
    refundMoneyTitle.textAlignment=NSTextAlignmentLeft;
    refundMoneyTitle.font=[UIFont systemFontOfSize:16];
    refundMoneyTitle.text=@"退款金额: ";
    [view_bg addSubview:refundMoneyTitle];
    
    UILabel *refundMoney=[[UILabel alloc]initWithFrame:CGRectMake(80, height, kMainScreenWidth-130, 20)];
    refundMoney.textColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    refundMoney.textAlignment=NSTextAlignmentLeft;
    refundMoney.font=[UIFont systemFontOfSize:16];
    refundMoney.text=[NSString stringWithFormat:@"￥%.2f",_refundDetailModel.refundFee];
    [view_bg addSubview:refundMoney];
    
    height+=32;
    
//    UILabel *aplyDate=[[UILabel alloc]initWithFrame:CGRectMake(10, height, kMainScreenWidth-50, 20)];
//    aplyDate.textColor=[UIColor darkGrayColor];
//    aplyDate.textAlignment=NSTextAlignmentLeft;
//    aplyDate.font=[UIFont systemFontOfSize:15];
//    aplyDate.text=[NSString stringWithFormat:@"申请时间: %@",_refundDetailModel.createAt];
//    [view_bg addSubview:aplyDate];
//    
//    height+=25;
    NSArray *imageArray;
    if (_refundDetailModel.imagUrls.length>0) {
        imageArray=[_refundDetailModel.imagUrls componentsSeparatedByString:@","];
    }
    
    
    if(imageArray.count){
        UILabel *PictureTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, height, 85, 20)];
        PictureTitle.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
        PictureTitle.textAlignment=NSTextAlignmentLeft;
        PictureTitle.font=[UIFont systemFontOfSize:16];
        PictureTitle.text=@"凭证照片: ";
        [view_bg addSubview:PictureTitle];
        
        height+=30;
        
        for (int i=0; i<imageArray.count; i++) {
            UIImageView *photo_img=[[UIImageView alloc]initWithFrame:CGRectMake(10+i*50+(kMainScreenWidth-120)/3*i, height, (kMainScreenWidth-120)/3, (kMainScreenWidth-120)/3-10)];
            photo_img.tag=Kimageview_tag+i;
            photo_img.userInteractionEnabled=YES;
            photo_img.clipsToBounds=YES;
            photo_img.contentMode=UIViewContentModeScaleAspectFill;
            [photo_img sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"bg_morentu_tuku_1"]];
            [view_bg addSubview:photo_img];
            
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(20+i*50+(kMainScreenWidth-120)/3*i, height, (kMainScreenWidth-120)/3, (kMainScreenWidth-120)/3)];
            btn.tag=Kuibutton_tag+i;
            [btn addTarget:self action:@selector(tappress:) forControlEvents:UIControlEventTouchUpInside];
            [view_bg addSubview:btn];
        }
        
        height+=(kMainScreenWidth-120)/3+5;
    }
//    else height+=30;
    
    UIButton *btn_hetong=[[UIButton alloc]initWithFrame:CGRectMake(10, height+10, 80, 30)];
    [btn_hetong setTitle:@"查看合同 >" forState:UIControlStateNormal];
    [btn_hetong setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
    btn_hetong.titleLabel.font=[UIFont systemFontOfSize:15];
    [btn_hetong addTarget:self action:@selector(checkContract:) forControlEvents:UIControlEventTouchUpInside];
    [view_bg addSubview:btn_hetong];
    
    UIView *line_three=[[UIView alloc]initWithFrame:CGRectMake(10, height-0.7, kMainScreenWidth-20, 0.5)];
    line_three.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
    [view_bg addSubview:line_three];
    
    height+=10;
    
    UIButton *btn_xiugai = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_xiugai.frame = CGRectMake(kMainScreenWidth-90, height, 80, 25);
    btn_xiugai.titleLabel.font=[UIFont systemFontOfSize:13];
    [btn_xiugai setTitle:@"取消退款" forState:UIControlStateNormal];
    //给按钮加一个白色的板框
    btn_xiugai.layer.borderColor = [[UIColor colorWithHexString:@"#EF6562" alpha:1.0] CGColor];
    btn_xiugai.layer.borderWidth = 1;
    //给按钮设置弧度,这里将按钮变成了圆形
    btn_xiugai.layer.cornerRadius = 5.0f;
    btn_xiugai.layer.masksToBounds = YES;
    [btn_xiugai setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
    btn_xiugai.backgroundColor=[UIColor whiteColor];
    [btn_xiugai addTarget:self action:@selector(requestCancelRefund:) forControlEvents:UIControlEventTouchUpInside];
    [view_bg addSubview:btn_xiugai];
    if (_refundDetailModel.refundState == 27) {
        btn_xiugai.hidden=NO;
        line_three.hidden=NO;
//        height+=40;
    }
    else {
        btn_xiugai.hidden=YES;
        line_three.hidden=YES;
    }
    height+=40;
//    UIImageView *bottomImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, height-5, kMainScreenWidth-30, 15)];
//    bottomImage.image=[UIImage imageNamed:@"bg_dingdan"];
//    [view_bg addSubview:bottomImage];
    
    _height=height;
    view_bg.frame=CGRectMake(0, 20, kMainScreenWidth, _height);

    return cell;
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
    NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",_refundDetailModel.userMobile];
    UIWebView *callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
    [self.view addSubview:callWebview];
}
-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

//请求订单详情
-(void)requestRefundDetail{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0330\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"refundId\":%@}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.refundIDStr];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"发送收藏量返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
                //token为空或验证未通过处理 huangrun
                if (kResCode == 10002 || kResCode == 10003) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                    login.delegate=self;
                    [login show];
                    return;
                    });
                }
                
                if (code==103301) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSDictionary *resDic = [jsonDict objectForKey:@"refund"];
                        _refundDetailModel = [RefundDetailModel objectWithKeyValues:resDic];
                        [self.view addSubview:_theTableView];
                        if (_refundDetailModel.userMobile.length>0) {
                            [self createPhone];
                        }
                        [_theTableView reloadData];
                    });
                } else if (code == 0) {
                        [self stopRequest];
                    [TLToast showWithText:@"数据加载失败"];
                }
                
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self stopRequest];
                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:nil];
    });
    
}

- (void)clickTelBtn:(id)sender {
//    if (_callNum) {
        NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",callNumber];
        UIWebView *callWebview = [[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
        [self.view addSubview:callWebview];
//    } else {
//        [self requestCallNum];
//    }
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
        [bodyDict setObject:[NSNumber numberWithInt:_refundDetailModel.refundId] forKey:@"refundId"];
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
                        [self requestRefundDetail];
                        if([self.delegate respondsToSelector:@selector(stateBtnDidClick:)])
                           [self.delegate stateBtnDidClick:nil];
                        [TLToast showWithText:@"取消退款成功"];
                    } else if (kResCode == 103169) {
                        [self stopRequest];
                        [TLToast showWithText:@"取消退款失败"];
                    }
                    else{
                        [self stopRequest];
                        [TLToast showWithText:@"取消退款失败"];
                    }
                    
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
    
}

//#pragma mark - 获取电话号码
//- (void)requestCallNum {
//    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(parsingQueue, ^{
//        
//        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
//        
//        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
//        [postDict setObject:@"ID0036" forKey:@"cmdID"];
//        [postDict setObject:@"" forKey:@"token"];
//        [postDict setObject:@"" forKey:@"userID"];
//        [postDict setObject:@"iOS" forKey:@"deviceType"];
//        NSString *string=[postDict JSONString];
//        
//        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
//        [post setObject:string forKey:@"header"];
//        [post setObject:@"" forKey:@"body"];
//        
//        
//        NetworkRequest *req = [[NetworkRequest alloc] init];
//        [req setHttpMethod:PostMethod];
//        
//        [req sendToServerInBackground:^{
//            dispatch_async(parsingQueue, ^{
//                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
//                [request setResponseEncoding:NSUTF8StringEncoding];
//                NSString *respString = [request responseString];
//                NSDictionary *jsonDict = [respString objectFromJSONString];
//                //NSLog(@"返回信息：%@",jsonDict);
//                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10361) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        _callNum = [jsonDict objectForKey:@"fbPhoneNumber"];
//                        NSLog(@"获取电话成功");
//                    });
//                }
//                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10369){
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSLog(@"获取电话失败");
//                    });
//                } else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                    });
//                }
//            });
//        }
//                          failedBlock:^{
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  
//                              });
//                          }
//                               method:url postDict:post];
//    });
//    
//    
//}
//
-(void)tappress:(UIButton *)sender{
    UITableViewCell *cell=[_theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIImageView *imageview_big=(UIImageView *)[cell viewWithTag:sender.tag-Kuibutton_tag+Kimageview_tag];
    ImageZoomView *zoomView = [[ImageZoomView alloc] initWithView:self.view.window Images:imageview_big.image];
    [zoomView show];
}

#pragma mark -
#pragma mark - LoginDelegate
//-(void)logged:(NSDictionary *)dict{
//    [self stopRequest];
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self requestRefundDetail];
//    }];
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    [self stopRequest];
    [self dismissViewControllerAnimated:YES completion:^{
        [self requestRefundDetail];
    }];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 查看合同
- (void)checkContract:(id)sender {
    IDIAI3ContractDetailViewController *contract =[[IDIAI3ContractDetailViewController alloc] init];
    contract.title =@"合同详情";
    contract.orderCode =_refundDetailModel.orderCode;
    [self.navigationController pushViewController:contract animated:YES];
}

@end
