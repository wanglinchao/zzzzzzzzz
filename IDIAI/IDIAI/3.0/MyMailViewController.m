//
//  MyMailViewController.m
//  IDIAI
//
//  Created by Ricky on 16/5/11.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyMailViewController.h"
#import "MyMailDetailViewController.h"
#import "IDIAIAppDelegate.h"
#import "LoginView.h"
#import "TLToast.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "MailListObject.h"
#import "UIImageView+OnlineImage.h"
#import "UIImageView+WebCache.h"
@interface MyMailViewController ()
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation MyMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.currentPage=0;
    
    self.dataArray =[NSMutableArray array];
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-44-64) pullingDelegate:self];
    self.mtableview.backgroundColor=[UIColor clearColor];
    self.mtableview.dataSource=self;
    self.mtableview.delegate=self;
    self.mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
//    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
//    backView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
//    self.mtableview.tableHeaderView =backView;
//    self.isRefresh =YES;
    [self.view addSubview:self.mtableview];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.mtableview launchRefreshing];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 27;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 27)];
    backView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    MailListObject *listobject =[self.dataArray objectAtIndex:section];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:listobject.sendDate/1000];
    UILabel *datelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 6, kMainScreenWidth-30, 15)];
    NSString *datestr =[self compareDate:confromTimesp];
    if (datestr.length >0) {
        datelbl.text =datestr;
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd"];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        datelbl.text =confromTimespStr;
    }
    datelbl.textColor =[UIColor colorWithHexString:@"#575757"];
    datelbl.font =[UIFont systemFontOfSize:15];
    [backView addSubview:datelbl];
    return backView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier1 = @"MyCellIdentifier";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    MailListObject *listobject =[self.dataArray objectAtIndex:indexPath.section];
    if (!cell1) {
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        
        UIImageView *photo=[[UIImageView alloc]initWithFrame:CGRectMake(18, 15, 30, 30)];
        //    photo.tag=KButtonTag_phone*2+indexPath.section;
        photo.layer.cornerRadius=15;
        photo.clipsToBounds=YES;
        photo.tag =999;
        photo.image =[UIImage imageNamed:@"ic_touxiang_tk"];

        [cell1.contentView addSubview:photo];
        
        UIImageView *redimage =[[UIImageView alloc] initWithFrame:CGRectMake(8, 22.5, 5, 5)];
        redimage.backgroundColor =[UIColor colorWithHexString:@"#ef6562"];
        redimage.layer.cornerRadius=3;
        redimage.clipsToBounds=YES;
        redimage.tag =1004;
        [cell1.contentView addSubview:redimage];
        
        
        UILabel *namelbl =[[UILabel alloc] initWithFrame:CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, 10, kMainScreenWidth-36-80-30, 18)];
//        namelbl.text =@"张三[工长]";
        namelbl.textColor =[UIColor colorWithHexString:@"#575757"];
        namelbl.font =[UIFont systemFontOfSize:18];
        namelbl.tag =1000;
        [cell1.contentView addSubview:namelbl];
        
        UILabel *datelbl =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-18-80, namelbl.frame.origin.y+2, 80, 14)];
        datelbl.tag =1001;
        datelbl.textColor =[UIColor colorWithHexString:@"#575757"];
        datelbl.font =[UIFont systemFontOfSize:14];
        datelbl.textAlignment =NSTextAlignmentRight;
        [cell1.contentView addSubview:datelbl];
        if (self.actionType ==1) {
            NSString *namecontentstr =@"收信人:";
            for (MailUserInfoObject *userinfo in listobject.recvUserInfos){
                if (userinfo.roleId ==1) {
                    namecontentstr =[NSString stringWithFormat:@"%@ %@[设计师]",namecontentstr,userinfo.userName];
                }else if (userinfo.roleId ==4){
                    namecontentstr =[NSString stringWithFormat:@"%@ %@[工长]",namecontentstr,userinfo.userName];
                }else if (userinfo.roleId ==6){
                    namecontentstr =[NSString stringWithFormat:@"%@ %@[第三方监理]",namecontentstr,userinfo.userName];
                }else if (userinfo.roleId ==7){
                    namecontentstr =[NSString stringWithFormat:@"%@ %@[业主]",namecontentstr,userinfo.userName];
                }else if (userinfo.roleId ==9){
                    namecontentstr =[NSString stringWithFormat:@"%@ %@[平台监理]",namecontentstr,userinfo.userName];
                }else{
                    namecontentstr =[NSString stringWithFormat:@"%@ %@",namecontentstr,userinfo.userName];
                }
                
            }
            
            CGSize labelsize1 = [util calHeightForLabel:namecontentstr width:kMainScreenWidth-36-30 font:[UIFont systemFontOfSize:14]];
            UILabel *receivinglbl =[[UILabel alloc] initWithFrame:CGRectMake(namelbl.frame.origin.x, namelbl.frame.origin.y+namelbl.frame.size.height+10, labelsize1.width, labelsize1.height)];
            receivinglbl.textColor =[UIColor colorWithHexString:@"#575757"];
            receivinglbl.font =[UIFont systemFontOfSize:14];
            receivinglbl.tag =1002;
            receivinglbl.numberOfLines =0;
            [cell1.contentView addSubview:receivinglbl];
            
            UILabel *statuslbl =[[UILabel alloc] initWithFrame:CGRectMake(namelbl.frame.origin.x, 91+labelsize1.height-10-14, kMainScreenWidth-36-30, 14)];
            statuslbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
            statuslbl.font =[UIFont systemFontOfSize:14];
            statuslbl.tag =1003;
            [cell1.contentView addSubview:statuslbl];
        }else{
            UIImageView *pointimage =[[UIImageView alloc] initWithFrame:CGRectZero];
            pointimage.image =[UIImage imageNamed:@"ico_gd_utop"];
            pointimage.tag =998;
//            pointimage.backgroundColor =[UIColor redColor];
            [cell1.contentView addSubview:pointimage];
        }
        
    }
    
    UILabel *namelbl =(UILabel *)[cell1.contentView viewWithTag:1000];
    namelbl.text =listobject.sendUserName;
    
    if (self.actionType!=1) {
        int count =0;
        int tagcount =0;
        for (UIView *view in [cell1.contentView subviews]) {
            if (view.tag>1003) {
                [view removeFromSuperview];
            }
        }
        for (MailUserInfoObject *userinfo in listobject.recvUserInfos) {
            UILabel *receivinglbl =[[UILabel alloc] initWithFrame:CGRectMake(namelbl.frame.origin.x, namelbl.frame.origin.y+namelbl.frame.size.height+10+19*count, kMainScreenWidth-36-30-52, 14)];
            receivinglbl.textColor =[UIColor colorWithHexString:@"#575757"];
            receivinglbl.font =[UIFont systemFontOfSize:14];
            receivinglbl.tag =1003+tagcount;
            [cell1.contentView addSubview:receivinglbl];
            tagcount++;
            
            UILabel *statuslbl =[[UILabel alloc] initWithFrame:CGRectMake(receivinglbl.frame.origin.x+receivinglbl.frame.size.width+10, receivinglbl.frame.origin.y, 42, 14)];
            statuslbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
            statuslbl.font =[UIFont systemFontOfSize:14];
            statuslbl.tag =1003+tagcount;
            [cell1.contentView addSubview:statuslbl];
            tagcount++;
            count++;
        }
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:listobject.sendDate/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    UILabel *datelbl =(UILabel *)[cell1.contentView viewWithTag:1001];
    datelbl.text =confromTimespStr;
    UIImageView *photo =[cell1.contentView viewWithTag:999];
    
    if (self.actionType ==1) {
        if (listobject.sendRoleId==7) {
            photo.image =[UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:[listobject.userLogo stringByReplacingOccurrencesOfString:@"\n" withString:@""]  options:NSDataBase64DecodingIgnoreUnknownCharacters]];
        }else{
            [photo setOnlineImage:listobject.userLogo placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
        }
        NSString *namecontentstr =@"收信人:";
        for (MailUserInfoObject *userinfo in listobject.recvUserInfos){
            if (userinfo.roleId ==1) {
                namecontentstr =[NSString stringWithFormat:@"%@ %@[设计师]",namecontentstr,userinfo.userName];
            }else if (userinfo.roleId ==4){
                namecontentstr =[NSString stringWithFormat:@"%@ %@[工长]",namecontentstr,userinfo.userName];
            }else if (userinfo.roleId ==6){
                namecontentstr =[NSString stringWithFormat:@"%@ %@[第三方监理]",namecontentstr,userinfo.userName];
            }else if (userinfo.roleId ==7){
                namecontentstr =[NSString stringWithFormat:@"%@ %@[业主]",namecontentstr,userinfo.userName];
            }else if (userinfo.roleId ==9){
                namecontentstr =[NSString stringWithFormat:@"%@ %@[平台监理]",namecontentstr,userinfo.userName];
            }else{
                namecontentstr =[NSString stringWithFormat:@"%@ %@",namecontentstr,userinfo.userName];
            }
        }
        UILabel *receivinglbl =(UILabel *)[cell1.contentView viewWithTag:1002];
        receivinglbl.text =namecontentstr;
        
        UILabel *statuslbl =(UILabel *)[cell1.contentView viewWithTag:1003];
        statuslbl.text =listobject.stateName;
        
        UIImageView *redimage =(UIImageView *)[cell1.contentView viewWithTag:1004];
        if (listobject.state ==1) {
            redimage.hidden =NO;
        }else{
            redimage.hidden =YES;
        }
    }else{
//        NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
//        UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
//        photo.image =imgFromUrl3;
        [photo sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:User_logo]] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
        int count =0;
        int tagcount =0;
        for (MailUserInfoObject *userinfo in listobject.recvUserInfos){
            UILabel *receivinglbl =(UILabel *)[cell1.contentView viewWithTag:1003+tagcount];
            tagcount++;
            if (count ==0) {
                if (userinfo.roleId ==1) {
                    receivinglbl.text =[NSString stringWithFormat:@"收信人:%@[设计师]",userinfo.userName];
                }else if (userinfo.roleId ==4){
                    receivinglbl.text =[NSString stringWithFormat:@"收信人:%@[工长]",userinfo.userName];
                }else if (userinfo.roleId ==6){
                    receivinglbl.text =[NSString stringWithFormat:@"收信人:%@[第三方监理]",userinfo.userName];
                }else if (userinfo.roleId ==7){
                    receivinglbl.text =[NSString stringWithFormat:@"收信人:%@[业主]",userinfo.userName];
                }else if (userinfo.roleId ==9){
                    receivinglbl.text =[NSString stringWithFormat:@"收信人:%@[平台监理]",userinfo.userName];
                }else{
                    receivinglbl.text =[NSString stringWithFormat:@"收信人:%@",userinfo.userName];
                }
                
            }else{
                if (userinfo.roleId ==1) {
                    receivinglbl.text =[NSString stringWithFormat:@"            %@[设计师]",userinfo.userName];
                }else if (userinfo.roleId ==4){
                    receivinglbl.text =[NSString stringWithFormat:@"            %@[工长]",userinfo.userName];
                }else if (userinfo.roleId ==6){
                    receivinglbl.text =[NSString stringWithFormat:@"            %@[第三方监理]",userinfo.userName];
                }else if (userinfo.roleId ==7){
                    receivinglbl.text =[NSString stringWithFormat:@"            %@[业主]",userinfo.userName];
                }else if (userinfo.roleId ==9){
                    receivinglbl.text =[NSString stringWithFormat:@"            %@[平台监理]",userinfo.userName];
                }else{
                    receivinglbl.text =[NSString stringWithFormat:@"            %@",userinfo.userName];
                }
            }
            UILabel *statuslbl =(UILabel *)[cell1.contentView viewWithTag:1003+tagcount];
            tagcount++;
            statuslbl.text =userinfo.stateName;
            count++;
        }
        UIImageView *pointimage =[cell1.contentView viewWithTag:998];
        pointimage.frame =CGRectMake(kMainScreenWidth-16.5-10, 105+(listobject.recvUserInfos.count-1)*19-10-1.5, 16.5, 3.5);
    }
    
//    if (tableCellBack) {
//        UIImageView *selectimage =(UIImageView *)[tableCellBack viewWithTag:1000];
//        selectimage.image =[UIImage imageNamed:@"ic_gouxian"];
//        
//        UILabel *contentlbl =(UILabel *)[tableCellBack viewWithTag:1001];
//        contentlbl.text =@"请准备电线";
//        
//        UILabel *datelbl =(UILabel *)[tableCellBack viewWithTag:1002];
//        datelbl.text =@"请一天完成";
//    }
    cell1.backgroundColor =[UIColor whiteColor];
    cell1.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MailListObject *listobject =[self.dataArray objectAtIndex:indexPath.section];
    if (self.actionType ==1) {
        NSString *namecontentstr =@"收信人:";
        for (MailUserInfoObject *userinfo in listobject.recvUserInfos){
            if (userinfo.roleId ==1) {
                namecontentstr =[NSString stringWithFormat:@"%@ %@[设计师]",namecontentstr,userinfo.userName];
            }else if (userinfo.roleId ==4){
                namecontentstr =[NSString stringWithFormat:@"%@ %@[工长]",namecontentstr,userinfo.userName];
            }else if (userinfo.roleId ==6){
                namecontentstr =[NSString stringWithFormat:@"%@ %@[第三方监理]",namecontentstr,userinfo.userName];
            }else if (userinfo.roleId ==7){
                namecontentstr =[NSString stringWithFormat:@"%@ %@[业主]",namecontentstr,userinfo.userName];
            }else{
                namecontentstr =[NSString stringWithFormat:@"%@ %@",namecontentstr,userinfo.userName];
            }
        }

        CGSize labelsize1 = [util calHeightForLabel:namecontentstr width:kMainScreenWidth-36-30 font:[UIFont systemFontOfSize:14]];
//        signCompany.text=@"© 2014 Trond  Technology (SiChuan) Co.,Ltd. All rights reserved.";
//        signCompany.frame =CGRectMake(signCompany.frame.origin.x, signCompany.frame.origin.y, labelsize1.width, labelsize1.height);
//        signCompany.numberOfLines =0;
        return 91+labelsize1.height;
    }else{
        return 105+(listobject.recvUserInfos.count-1)*19;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MailListObject *listobject =[self.dataArray objectAtIndex:indexPath.section];
    MyMailDetailViewController *mailDetail =[[MyMailDetailViewController alloc] init];
    mailDetail.actionType =self.actionType;
    mailDetail.mailid =listobject.sendMailId;
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
    [appDelegate.nav setNavigationBarHidden:NO animated:YES];
    [appDelegate.nav pushViewController:mailDetail animated:YES];
//     [self.navigationController pushViewController:mailDetail animated:YES];
}
#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=1;
        [self requestMaillBoxlist];
    }
    else {
        if(self.totalPages>self.currentPage){
            self.currentPage +=1;
            [self requestMaillBoxlist];
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
-(void)requestMaillBoxlist{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0363\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"roleId\":7,\"actionType\":%d,\"currentPage\":%d,\"requestRow\":10}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(int)self.actionType,(int)self.currentPage];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"信箱列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
                //token为空或验证未通过处理 huangrun
                if (code == 10002 || code == 10003) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                    });
                }
                else if (code==103631) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *arr_=[NSArray array];
                        if (self.actionType==1) {
                            arr_ =[jsonDict objectForKey:@"recvMaillInfos"];
                        }else{
                            arr_ =[jsonDict objectForKey:@"sendMaillInfos"];
                        }
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            if(self.refreshing==YES) [self.dataArray removeAllObjects];
                            for(NSDictionary *dict in arr_){
                                DCParserConfiguration *config = [DCParserConfiguration configuration];
                                DCArrayMapping *arrayMapping = [DCArrayMapping mapperForClassElements:[MailUserInfoObject class] forAttribute:@"recvUserInfos" onClass:[MailListObject class]];
                                [config addArrayMapper:arrayMapping];
                                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[MailListObject class] andConfiguration:config];
                                MailListObject *maillist =[parser parseDictionary:dict];
                                [self.dataArray addObject:maillist];
                            }
                        }
                        if([self.dataArray count]){
//                            imageview_bg.hidden=YES;
//                            label_bg.hidden = YES;
                            [self.mtableview tableViewDidFinishedLoading];
                        }
                        else{
//                            imageview_bg.hidden=NO;
//                            label_bg.hidden = NO;
                            [self.mtableview tableViewDidFinishedLoading];
                        }
                        
                        [self.mtableview reloadData];
                        
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [self.mtableview tableViewDidFinishedLoading];
                        [TLToast showWithText:@"获取失败"];
                        if(![self.dataArray count]) {
//                            imageview_bg.hidden=NO;
//                            label_bg.hidden = NO;
                        }
                        [self.mtableview reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                              });
                          }
                               method:url postDict:nil];
    });
}
-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
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
