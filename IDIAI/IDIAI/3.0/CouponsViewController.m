//
//  CouponsViewController.m
//  IDIAI
//
//  Created by Ricky on 16/3/16.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CouponsViewController.h"

#import "util.h"
#import "LoginView.h"
#import "CustomPromptView.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "util.h"
@interface CouponsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CustomPromptView *customPromp;
}
@property(nonatomic,strong)UITableView *mtable;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation CouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    self.dataArray =[NSMutableArray array];
    self.view.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    self.mtable =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.frame.size.height-104)];
    self.mtable.backgroundColor =[UIColor clearColor];
    self.mtable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mtable.delegate=self;
    self.mtable.dataSource =self;
    self.mtable.tableHeaderView =headerView;
    [self.view addSubview:self.mtable];
    [self requestMyPreferential];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    PreferentialObject *preferential =[self.dataArray objectAtIndex:indexPath.row];
    if (!cell1){
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        cell1.backgroundColor =[UIColor clearColor];
        
        UIImageView *backimage =[[UIImageView alloc] initWithFrame:CGRectMake(7.5, 0, kMainScreenWidth-15, 99*kMainScreenWidth/320)];
        backimage.tag =1000;
        [cell1 addSubview:backimage];
        
        
        UILabel *couponsNamelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 15, (kMainScreenWidth-45)/3*2, 17)];
        couponsNamelbl.font =[UIFont systemFontOfSize:17.0];
        couponsNamelbl.tag =1001;
        couponsNamelbl.numberOfLines =0;
//        couponsNamelbl.backgroundColor =[UIColor purpleColor];
        [backimage addSubview:couponsNamelbl];
        
        UILabel *couponDesclbl =[[UILabel alloc] initWithFrame:CGRectMake(couponsNamelbl.frame.origin.x, couponsNamelbl.frame.origin.y+couponsNamelbl.frame.size.height+10, (kMainScreenWidth-45)/3*2, 45)];
        couponDesclbl.font =[UIFont systemFontOfSize:15.0];
        couponDesclbl.tag =1002;
//        couponDesclbl.backgroundColor =[UIColor purpleColor];
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
        
        UIImageView *giftimg =[[UIImageView alloc] initWithFrame:CGRectMake(15, ((99-17.5)*kMainScreenWidth/320-18)/2, 18, 18)];
        if (preferential.sucId ==self.selectcouponId) {
            giftimg.image =[UIImage imageNamed:@"ic_xuanze.png"];
        }else{
            giftimg.image =[UIImage imageNamed:@"ic_xuanze_nor.png"];
        }
        giftimg.tag =1007;
        [backimage addSubview:giftimg];
        
    }
    
    
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
    CGSize labelsize = [util calHeightForLabel:preferential.couponsName width:(kMainScreenWidth-45)/3.5*2 font:[UIFont systemFontOfSize:17.0]];
    float height=0;
    if (labelsize.height-17>0) {
        height =labelsize.height-17;
    }
    couponsNamelbl.frame =CGRectMake(couponsNamelbl.frame.origin.x, couponsNamelbl.frame.origin.y, labelsize.width, labelsize.height);
    couponsNamelbl.text =preferential.couponsName;
    //    couponsNamelbl.backgroundColor =[UIColor redColor];
    
    UILabel *couponDesclbl =(UILabel *)[backimage viewWithTag:1002];
    CGSize labelsize1 = [util calHeightForLabel:preferential.couponDesc width:(kMainScreenWidth-60)/2 font:[UIFont systemFontOfSize:15]];
    if (preferential.couponState==1) {
        couponDesclbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    }else{
        couponDesclbl.textColor =[UIColor colorWithHexString:@"#cccccc"];
    }
    couponDesclbl.frame =CGRectMake(couponDesclbl.frame.origin.x, couponDesclbl.frame.origin.y, labelsize1.width, labelsize1.height);
    couponDesclbl.text =preferential.couponDesc;
    couponDesclbl.numberOfLines =3;
    
    UILabel *couponValuelbl =(UILabel *)[backimage viewWithTag:1003];
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
        giftimg.hidden =YES;
    }else{
        couponValuelbl.text =@"";
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
            couponDesclbl.frame =CGRectMake(couponsNamelbl.frame.origin.x, couponsNamelbl.frame.origin.y+couponsNamelbl.frame.size.height+5, labelsize1.width, labelsize1.height);
        }
        
        
    }
    
    if (preferential.couponState ==1) {
        giftimg.hidden=NO;
        if (labelsize1.height>18) {
            CGSize labelsize = [util calHeightForLabel:preferential.couponsName width:(kMainScreenWidth-45)/3*2 font:[UIFont systemFontOfSize:17.0]];
            float height=0;
            if (labelsize.height-17>0) {
                height =labelsize.height-17;
            }
            couponsNamelbl.frame =CGRectMake(67, 15-height/2, labelsize.width, labelsize.height);
//            couponsNamelbl.frame =CGRectMake(67, 15, (kMainScreenWidth-45)/3*2, 17);
            couponDesclbl.frame =CGRectMake(couponsNamelbl.frame.origin.x, couponsNamelbl.frame.origin.y+couponsNamelbl.frame.size.height+10, labelsize1.width, labelsize1.height);
        }else{
            CGSize labelsize = [util calHeightForLabel:preferential.couponsName width:(kMainScreenWidth-45)/3.5*2 font:[UIFont systemFontOfSize:17.0]];
            float height=0;
            if (labelsize.height-17>0) {
                height =labelsize.height-17;
            }
            couponsNamelbl.frame =CGRectMake(67, 15-height/2, labelsize.width, labelsize.height);
//            couponsNamelbl.frame =CGRectMake(67, 30, (kMainScreenWidth-45)/3*2, 17);
            couponDesclbl.frame =CGRectMake(couponsNamelbl.frame.origin.x, couponsNamelbl.frame.origin.y+couponsNamelbl.frame.size.height+5, labelsize1.width, labelsize1.height);
        }
        couponValuelbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
    }else{
        couponValuelbl.textColor =[UIColor colorWithHexString:@"#cccccc"];
//        couponsNamelbl.frame =CGRectMake(15, 15, (kMainScreenWidth-45)/3*2, 17);
        float height=0;
        if (labelsize.height-17>0) {
            height =labelsize.height-17;
        }
        couponsNamelbl.frame =CGRectMake(15, 15-height/2, labelsize.width, labelsize.height);
        couponDesclbl.frame =CGRectMake(couponsNamelbl.frame.origin.x, couponsNamelbl.frame.origin.y+couponsNamelbl.frame.size.height+10, labelsize1.width, labelsize1.height);
        couponDesclbl.frame =CGRectMake(couponsNamelbl.frame.origin.x, couponsNamelbl.frame.origin.y+couponsNamelbl.frame.size.height+10, labelsize1.width, labelsize1.height);
        giftimg.hidden =YES;
    }
    if ([self.type intValue]==0) {
        giftimg.hidden =YES;
    }else{
        giftimg.hidden =NO;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type intValue] ==1) {
        UITableViewCell *cell =[self.mtable cellForRowAtIndexPath:indexPath];
        UIImageView *backimage =(UIImageView *)[cell viewWithTag:1000];
        UIImageView *giftimg =(UIImageView *)[backimage viewWithTag:1007];
        giftimg.image =[UIImage imageNamed:@"ic_xuanze.png"];
        PreferentialObject *preferential =[self.dataArray objectAtIndex:indexPath.row];
        if (self.selectcouponId ==preferential.sucId) {
            giftimg.image =[UIImage imageNamed:@"ic_xuanze_nor.png"];
            [self.navigationController popViewControllerAnimated:YES];
            self.selectDone(nil);
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            self.selectDone(preferential);
        }
        
    }
}
#pragma mark -查询可用优惠券列表
-(void)requestMyPreferential{
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *string_token;
        NSString *string_userid;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
                string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
                string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
            }else{
                string_token=@"";
                string_userid=@"";
            }
            NSString *url =[NSString string];
        if (self.contract) {
            url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0349\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"isAvailable\":%@,\"orderType\":%d,\"objIds\":\"%d\",\"orderCode\":\"%@\",\"totalFee\":\"\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.type,self.contract.contractType,self.contract.servantId,self.orderCode];
        }else{
            url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0349\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"isAvailable\":%@,\"orderType\":%d,\"objIds\":\"%@\",\"orderCode\":\"\",\"totalFee\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.type,self.orderType,self.objIds,self.totalFee];
        }
        
                
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
//                                if(self.refreshing==YES && [self.dataArray count]) [self.dataArray removeAllObjects];
//                                if (self.currentPage ==1) {
//                                    [self.dataArray removeAllObjects];
//                                }
                                NSArray *arr_=[jsonDict objectForKey:@"coupons"];
                                if ([arr_ count]) {
//                                    self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
//                                    self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                                    for(NSDictionary *dict in arr_){
                                        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[PreferentialObject class]];
                                        PreferentialObject *item = [parser parseDictionary:dict];
                                        [self.dataArray addObject:item];
                                    }
                                    
                                }

                                if([self.dataArray count]){
//                                    imageview_bg.hidden=YES;
//                                    label_bg.hidden = YES;
//                                    [self.mtableview tableViewDidFinishedLoading];
                                }
                                else{
//                                    imageview_bg.hidden=NO;
//                                    label_bg.hidden = NO;
//                                    [self.mtableview tableViewDidFinishedLoading];
                                }
                                [self.mtable reloadData];
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
                                [self.mtable reloadData];
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
