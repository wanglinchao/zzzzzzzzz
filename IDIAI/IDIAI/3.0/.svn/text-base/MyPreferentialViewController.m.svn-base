//
//  MyPreferentialViewController.m
//  IDIAI
//
//  Created by Ricky on 16/3/14.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyPreferentialViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginView.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "PreferentialObject.h"
#import "AddPreferentialCoderViewController.h"
#import "util.h"
#import "InstructViewController.h"
#import "TLToast.h"
#import "commentAfterServiceViewController.h"
@interface MyPreferentialViewController (){

}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)int giftsuId;
@end

@implementation MyPreferentialViewController



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.mtableview launchRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    self.currentPage=0;
    self.dataArray =[NSMutableArray array];
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    [leftButton addTarget:self
                       action:@selector(PressBarItemLeft)
             forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
        
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(5, 5, 75, 75)];
//    [rightButton setImage:[UIImage imageNamed:@"ic_xieriji.png"] forState:UIControlStateNormal];
//    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    [rightButton setTitle:@"添加优惠码" forState:UIControlStateNormal];
    [rightButton setTitle:@"添加优惠码" forState:UIControlStateHighlighted];
    rightButton.titleLabel.font =[UIFont systemFontOfSize:15.0];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self
                        action:@selector(PressBarItemRight)
              forControlEvents:UIControlEventTouchUpInside];
        //        rightButton.backgroundColor =[UIColor redColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem =rightItem;
    UIView *headView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 30)];
    headView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    
    UIButton *instructionbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    instructionbtn.frame =CGRectMake(kMainScreenWidth-107.5, 0, 100, 30);
    [instructionbtn setImage:[UIImage imageNamed:@"ic_shiyongshuoming.png"] forState:UIControlStateNormal];
    [instructionbtn setImage:[UIImage imageNamed:@"ic_shiyongshuoming.png"] forState:UIControlStateHighlighted];
    [instructionbtn setTitle:@"使用说明" forState:UIControlStateNormal];
    [instructionbtn setTitle:@"使用说明" forState:UIControlStateHighlighted];
    [instructionbtn setTitleColor:[UIColor colorWithHexString:@"#575757"] forState:UIControlStateNormal];
    [instructionbtn setTitleColor:[UIColor colorWithHexString:@"#575757"] forState:UIControlStateHighlighted];
    instructionbtn.titleLabel.font =[UIFont systemFontOfSize:15];
    [instructionbtn addTarget:self action:@selector(instructAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:instructionbtn];
        
    self.mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) pullingDelegate:self];
    self.mtableview.backgroundColor=[UIColor colorWithHexString:@"#efeff4"];
    self.mtableview.dataSource=self;
    self.mtableview.delegate=self;
    self.mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.mtableview.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.mtableview.tableHeaderView =headView;
    //[mtableview setHeaderOnly:YES];          //只有下拉刷新
    //[mtableview setFooterOnly:YES];         //只有上拉加载
    [self.mtableview launchRefreshing];
    [self.view addSubview:self.mtableview];
    
    [self loadImageviewBG];
    
    // Do any additional setup after loading the view.
}
-(void)instructAction:(id)sender{
    InstructViewController *instruct =[[InstructViewController alloc] init];
    instruct.title =@"兑换使用说明";
    [self.navigationController pushViewController:instruct animated:YES];
}
-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)PressBarItemRight{
    AddPreferentialCoderViewController *preferential =[[AddPreferentialCoderViewController alloc] init];
    preferential.title =@"兑换优惠";
    [self.navigationController pushViewController:preferential animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 99*kMainScreenWidth/320+10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *const CellIdentifier1 = [NSString stringWithFormat:@"designerDetailCell%d%d",(int)indexPath.section,(int)indexPath.row];
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (!cell1){
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        cell1.backgroundColor =[UIColor clearColor];
        
        UIImageView *backimage =[[UIImageView alloc] initWithFrame:CGRectMake(7.5, 0, kMainScreenWidth-15, 99*kMainScreenWidth/320)];
        backimage.userInteractionEnabled =YES;
        backimage.tag =1000;
        [cell1 addSubview:backimage];
        
        UILabel *couponsNamelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 15, (kMainScreenWidth-45)/3*2, 17)];
        couponsNamelbl.font =[UIFont systemFontOfSize:17.0];
        couponsNamelbl.tag =1001;
        couponsNamelbl.numberOfLines =0;
        [backimage addSubview:couponsNamelbl];
        
        UILabel *couponDesclbl =[[UILabel alloc] initWithFrame:CGRectMake(couponsNamelbl.frame.origin.x, couponsNamelbl.frame.origin.y+couponsNamelbl.frame.size.height+10, (kMainScreenWidth-45)/3*2, 45)];
        couponDesclbl.font =[UIFont systemFontOfSize:15.0];
        couponDesclbl.tag =1002;
        [backimage addSubview:couponDesclbl];
        
        UILabel *couponValuelbl =[[UILabel alloc] initWithFrame:CGRectMake(couponDesclbl.frame.origin.x+couponDesclbl.frame.size.width-(kMainScreenWidth-45)/2+(kMainScreenWidth-45)/3, ((99-27.5)*kMainScreenWidth/320-20)/2, (kMainScreenWidth-45)/2, 30)];
        couponValuelbl.font =[UIFont boldSystemFontOfSize:25.0];
        couponValuelbl.tag =1003;
        couponValuelbl.textAlignment =NSTextAlignmentRight;
        [backimage addSubview:couponValuelbl];
        
        UILabel *endDatelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 99*kMainScreenWidth/320-20, kMainScreenWidth-45, 15)];
        endDatelbl.font =[UIFont systemFontOfSize:11.0];
        endDatelbl.tag =1004;
        endDatelbl.textAlignment =NSTextAlignmentRight;
        [backimage addSubview:endDatelbl];
        
        UIImageView *stateImage =[[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-92.5, ((99-17.5)*kMainScreenWidth/320-70)/2, 70, 70)];
        stateImage.tag =1005;
        [backimage addSubview:stateImage];
        
        UIButton *receivebtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [receivebtn setTitle:@"立即使用" forState:UIControlStateNormal];
        [receivebtn setTitle:@"立即使用" forState:UIControlStateHighlighted];
        [receivebtn addTarget:self action:@selector(receiveAction:) forControlEvents:UIControlEventTouchUpInside];
        [receivebtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
        [receivebtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
        receivebtn.layer.borderColor = [UIColor colorWithHexString:@"#ef6562"].CGColor;
        receivebtn.layer.borderWidth = 1;
        receivebtn.layer.masksToBounds = YES;
        receivebtn.layer.cornerRadius = 5;
        receivebtn.titleLabel.font =[UIFont systemFontOfSize:15];
        receivebtn.frame =CGRectMake(kMainScreenWidth-92.5, ((99-17.5)*kMainScreenWidth/320-30)/2, 70, 30);
        receivebtn.tag =1006;
        [backimage addSubview:receivebtn];
        
        UIImageView *giftimg =[[UIImageView alloc] initWithFrame:CGRectMake(15, ((99-17.5)*kMainScreenWidth/320-37)/2, 37, 37)];
        giftimg.image =[UIImage imageNamed:@"ic_lipin.png"];
        giftimg.tag =1007;
        [backimage addSubview:giftimg];
        
    }
    PreferentialObject *preferential =[self.dataArray objectAtIndex:indexPath.row];
    UIImageView *backimage =(UIImageView *)[cell1 viewWithTag:1000];
    if (preferential.couponState==1) {
        backimage.image =[UIImage imageNamed:@"bg_youhuiquan.png"];
    }else{
        backimage.image =[UIImage imageNamed:@"bg_youhuiquan_n.png"];
    }
    UILabel *couponsNamelbl =(UILabel *)[backimage viewWithTag:1001];
    if (preferential.couponState==1) {
        couponsNamelbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
    }else{
        couponsNamelbl.textColor =[UIColor colorWithHexString:@"#cccccc"];
    }
    couponsNamelbl.text =preferential.couponsName;
//    couponsNamelbl.backgroundColor =[UIColor redColor];
    
    UILabel *couponDesclbl =(UILabel *)[backimage viewWithTag:1002];
    CGSize labelsize1 = [util calHeightForLabel:preferential.couponDesc width:(kMainScreenWidth-45)/3*2 font:[UIFont systemFontOfSize:15]];
    if (preferential.couponState==1) {
        couponDesclbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    }else{
        couponDesclbl.textColor =[UIColor colorWithHexString:@"#cccccc"];
    }
    couponDesclbl.frame =CGRectMake(couponDesclbl.frame.origin.x, couponDesclbl.frame.origin.y, labelsize1.width, labelsize1.height);
    couponDesclbl.text =preferential.couponDesc;
    couponDesclbl.numberOfLines =3;
    
    UILabel *couponValuelbl =(UILabel *)[backimage viewWithTag:1003];
    UIButton *receivebtn =(UIButton *)[backimage viewWithTag:1006];
    UIImageView *giftimg =(UIImageView *)[backimage viewWithTag:1007];
    if (preferential.couponType==0) {
//        couponValuelbl.text =[NSString stringWithFormat:@"%@",];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",preferential.couponValue]];

        [str addAttribute:NSFontAttributeName
                    value:[UIFont boldSystemFontOfSize:15]
                    range:NSMakeRange(0, 1)];
        [str addAttribute:NSFontAttributeName
                    value:[UIFont boldSystemFontOfSize:32]
                    range:NSMakeRange(1, str.length-1)];
        couponValuelbl.attributedText = str;
        CGSize labelsize = [util calHeightForLabel:preferential.couponsName width:(kMainScreenWidth-45)/3.5*2 font:[UIFont systemFontOfSize:17.0]];
        float height=0;
        if (labelsize.height-17>0) {
            height =labelsize.height-17;
        }
        couponsNamelbl.frame =CGRectMake(15, 15-height/2, labelsize.width, labelsize.height);
        
        couponDesclbl.frame =CGRectMake(couponsNamelbl.frame.origin.x, couponsNamelbl.frame.origin.y+couponsNamelbl.frame.size.height+10, labelsize1.width, labelsize1.height);
        receivebtn.hidden =YES;
        giftimg.hidden =YES;
    }else if (preferential.couponType ==1){
//        couponValuelbl.text =[NSString stringWithFormat:@"%@折",preferential.couponValue];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@折",preferential.couponValue]];
        [str addAttribute:NSFontAttributeName
                    value:[UIFont boldSystemFontOfSize:32]
                    range:NSMakeRange(0, str.length-1)];
        [str addAttribute:NSFontAttributeName
                    value:[UIFont boldSystemFontOfSize:15]
                    range:NSMakeRange(str.length-1, 1)];
        couponValuelbl.attributedText = str;
        CGSize labelsize = [util calHeightForLabel:preferential.couponsName width:(kMainScreenWidth-45)/3.5*2 font:[UIFont systemFontOfSize:17.0]];
        float height=0;
        if (labelsize.height-17>0) {
            height =labelsize.height-17;
        }
        couponsNamelbl.frame =CGRectMake(15, 15-height/2, labelsize.width, labelsize.height);
        couponDesclbl.frame =CGRectMake(couponsNamelbl.frame.origin.x, couponsNamelbl.frame.origin.y+couponsNamelbl.frame.size.height+10, labelsize1.width, labelsize1.height);
        receivebtn.hidden =YES;
        giftimg.hidden =YES;
    }else{
        couponValuelbl.text =@"";
        if (preferential.couponState ==1) {
            receivebtn.hidden =NO;
        }else{
            receivebtn.hidden =YES;
        }
        giftimg.hidden=NO;
        if (labelsize1.height>18) {
            CGSize labelsize = [util calHeightForLabel:preferential.couponsName width:(kMainScreenWidth-45)/3.5*2 font:[UIFont systemFontOfSize:17.0]];
            float height=0;
            if (labelsize.height-17>0) {
                height =labelsize.height-17;
            }
            couponsNamelbl.frame =CGRectMake(67, 15-height/2, labelsize.width, labelsize.height);
            //            couponsNamelbl.frame =CGRectMake(67, 15, (kMainScreenWidth-26)/3*2, 17);
            couponDesclbl.frame =CGRectMake(couponsNamelbl.frame.origin.x, couponsNamelbl.frame.origin.y+couponsNamelbl.frame.size.height+10, labelsize1.width, labelsize1.height);
        }else{
            CGSize labelsize = [util calHeightForLabel:preferential.couponsName width:(kMainScreenWidth-45)/3.5*2 font:[UIFont systemFontOfSize:17.0]];
            float height=0;
            if (labelsize.height-17>0) {
                height =labelsize.height-17;
            }
            couponsNamelbl.frame =CGRectMake(67, 15-height/2, labelsize.width, labelsize.height);
            //            couponsNamelbl.frame =CGRectMake(67, 30, (kMainScreenWidth-26)/3*2, 17);
            couponDesclbl.frame =CGRectMake(couponsNamelbl.frame.origin.x, couponsNamelbl.frame.origin.y+couponsNamelbl.frame.size.height+5, labelsize1.width, labelsize1.height);;
        }
        
        
    }
    if (preferential.couponState ==1) {
        couponValuelbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
        giftimg.image =[UIImage imageNamed:@"ic_lipin.png"];
    }else{
        couponValuelbl.textColor =[UIColor colorWithHexString:@"#cccccc"];
        giftimg.image =[UIImage imageNamed:@"ic_lipin_n.png"];
    }
    UILabel *endDatelbl =(UILabel *)[backimage viewWithTag:1004];
    if (preferential.couponState ==1) {
        endDatelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    }else{
        endDatelbl.textColor =[UIColor whiteColor];
    }
    NSDate *endate = [NSDate dateWithTimeIntervalSince1970:[preferential.endDate doubleValue]/1000];
    NSDate *begindate = [NSDate dateWithTimeIntervalSince1970:[preferential.beginDate doubleValue]/1000];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *enddatestr = [formatter stringFromDate:endate];
    NSString *begindatestr =[formatter stringFromDate:begindate];
    endDatelbl.text =[NSString stringWithFormat:@"有效期%@-%@",begindatestr,enddatestr];
    
    UIImageView *stateImage =(UIImageView *)[backimage viewWithTag:1005];
    if (preferential.couponState ==1) {
        stateImage.image =nil;
    }else if (preferential.couponState ==2){
        stateImage.image =[UIImage imageNamed:@"ic_yishiyong.png"];
    }else if (preferential.couponState ==3){
        stateImage.image =[UIImage imageNamed:@"ic_yiguoqi.png"];
    }
    cell1.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell1;
}
-(void)receiveAction:(UIButton *)sender{
    UITableViewCell *cell = (UITableViewCell *)[[sender superview]superview];
    NSIndexPath *index =[self.mtableview indexPathForCell:cell];
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"请商家点击" message:@"完成礼品兑换!\n如未兑换请勿  误操作." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    alert.delegate =self;
    [alert show];
    PreferentialObject *prefertial =[self.dataArray objectAtIndex:index.row];
    self.giftsuId =prefertial.sucId;
}
#pragma mark -查询优惠券列表
-(void)requestMyPreferential{
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

        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0346\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":10,\"currentPage\":%d}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(int)self.currentPage];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"我的优惠列表返回信息：%@",jsonDict);
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
                if (code==103461) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if(self.refreshing==YES && [self.dataArray count]) [self.dataArray removeAllObjects];
                        if (self.currentPage ==1) {
                            [self.dataArray removeAllObjects];
                        }
                        NSArray *arr_=[jsonDict objectForKey:@"coupons"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSDictionary *dict in arr_){
                                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[PreferentialObject class]];
                                PreferentialObject *item = [parser parseDictionary:dict];
                                [self.dataArray addObject:item];
                            }
                            
                        }
//                        if (self.dataArray.count==0) {
//                            for (int i=0;i<5;i++) {
//                                PreferentialObject *preferential =[[PreferentialObject alloc] init];
//                                
//                                
//                                //                                @property(nonatomic,assign)int couponState;//状态；1 可用 2 已使用 3-已过期
//                                //                                @property(nonatomic,assign)int couponType;//券类型：0：优惠券；1：折扣券；2：礼品券
//                                preferential.couponsName =@"315特惠卷";
//                                preferential.endDate =@"2016.03.02-2016.03.10";
//                                
//                                preferential.couponDesc =@"满10000抵100限装修使用";
//                                if (i==0) {
//                                    preferential.couponValue=@"100";
//                                    preferential.couponState =1;
//                                    preferential.couponType = 0;
//                                }else if (i==1){
//                                    preferential.couponValue=@"6.5";
//                                    preferential.couponState =1;
//                                    preferential.couponType = 1;
//                                }else if (i==2){
//                                    preferential.couponValue=@"6.5";
//                                    preferential.couponState =1;
//                                    preferential.couponType = 2;
//                                    preferential.couponsName =@"礼品卷";
//                                }else if (i==3){
//                                    preferential.couponValue=@"100";
//                                    preferential.couponState =1;
//                                    preferential.couponType = 2;
//                                    preferential.couponDesc =@"满10000抵100限装修使用满10000抵100限装修使用";
//                                }else if (i==4){
//                                    preferential.couponValue=@"100";
//                                    preferential.couponState =3;
//                                    preferential.couponType = 0;
//                                }
//                                [self.dataArray addObject:preferential];
//                            }
//                            
//                        }
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
                else if (code==103469) {
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
#pragma mark -领取礼品券
-(void)requsetReceiveGifts:(int)sucId{
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
        [postDict setObject:@"ID0347" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"sucId":[NSNumber numberWithInt:sucId]};
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
                    
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 103471) {
                        [self stopRequest];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [TLToast showWithText:@"兑换成功"];
                        
                    } else if (kResCode == 103472) {
                        [self stopRequest];
                        [TLToast showWithText:@"该券不是礼品券"];
                    }else if (kResCode == 103473){
                        [self stopRequest];
                        [TLToast showWithText:@"该礼品券已过期"];
                    }else if (kResCode == 103474){
                        [self stopRequest];
                        [TLToast showWithText:@"该礼品券已被使用"];
                    }else if (kResCode == 103479){
                        [self stopRequest];
                        [TLToast showWithText:@"领取礼品券失败"];
                    }else if (kResCode == 103475){
                        [self stopRequest];
                        [TLToast showWithText:@"礼品尚未开始发放，请耐心等待!"];
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
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=1;
        [self requestMyPreferential];
    }
    else {
        if(self.totalPages>self.currentPage){
            self.currentPage +=1;
            [self requestMyPreferential];
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
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
    }else{
        [self requsetReceiveGifts:self.giftsuId];
    }
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
