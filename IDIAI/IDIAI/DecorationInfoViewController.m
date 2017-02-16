//
//  DecorationInfoViewController.m
//  IDIAI
//
//  Created by Ricky on 14-11-27.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DecorationInfoViewController.h"
#import "PullingRefreshTableView.h"
#import "TLToast.h"
#import "DecorationInfoModel.h"
#import "AutomaticLogin.h"
#import "util.h"
#import "LoginView.h"
#import "savelogObj.h"

@interface DecorationInfoViewController ()<LoginViewDelegate> {
    UILabel *_addressLabel;
    UILabel *_stateLabel;
    UILabel *_titleLabel;
    UILabel *_styleLabel;
    UILabel *_areaLabel;
    UILabel *_dateLabel;
    DecorationInfoModel *_diModel;
    UILabel *remark_why;
}

@end

@implementation DecorationInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [savelogObj saveLog:@"查看装修招标列表" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:39];
    
    if([self.fromType isEqualToString:@"MyZhaoBiao"]) self.title = @"我的招标";
    else self.title = @"全部招标";
    
        [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    self.dataArray = [NSMutableArray arrayWithCapacity:15];
    
    
    mtableview = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight) pullingDelegate:self];
    mtableview.dataSource = self;
    mtableview.delegate = self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [mtableview launchRefreshing];
    [self.view addSubview:mtableview];
    [self loadImageviewBG];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    NSString *context=[dic objectForKey:@"remarks"];
    if (context.length) {
        context = [NSString stringWithFormat:@"失败原因:%@",[dic objectForKey:@"remarks"]];
        CGSize labelsize = [util calHeightForLabel:context width:kMainScreenWidth-20 font:font];
        return 100+labelsize.height;
    }
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DecorationInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
     _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth-140, 20)];
    _addressLabel.font = [UIFont systemFontOfSize:15];
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-110, 10, 100, 20)];
    _stateLabel.font = [UIFont systemFontOfSize:15];
    _stateLabel.textColor=[UIColor redColor];
    _stateLabel.textAlignment=NSTextAlignmentRight;
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, kMainScreenWidth-20, 30)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _styleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, (kMainScreenWidth - 40)/3, 20)];
    _styleLabel.textColor = [UIColor lightGrayColor];
    _styleLabel.textAlignment=NSTextAlignmentLeft;
    _styleLabel.font = [UIFont systemFontOfSize:13];
    _areaLabel = [[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth - 40)/3+ 20, 60, (kMainScreenWidth - 40)/3, 20)];
    _areaLabel.font = [UIFont systemFontOfSize:13];
    _areaLabel.textAlignment=NSTextAlignmentCenter;
    _areaLabel.textColor = [UIColor lightGrayColor];
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth - 40)/3*2+30, 60, (kMainScreenWidth - 40)/3, 20)];
    _dateLabel.font = [UIFont systemFontOfSize:13];
    _dateLabel.textAlignment=NSTextAlignmentRight;
    _dateLabel.textColor = [UIColor lightGrayColor];
    
    remark_why = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, kMainScreenWidth-140, 20)];
    remark_why.font = [UIFont systemFontOfSize:15];
    remark_why.textColor=[UIColor redColor];
    remark_why.numberOfLines=0;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }

    [cell.contentView addSubview:_addressLabel];
    [cell.contentView addSubview:_stateLabel];
    [cell.contentView addSubview:_titleLabel];
    [cell.contentView addSubview:_styleLabel];
    [cell.contentView addSubview:_areaLabel];
    [cell.contentView addSubview:_dateLabel];
    [cell.contentView addSubview:remark_why];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];

    NSString *dateStr = [dic objectForKey:@"publishDate"];
    NSString *wantDateStr = [dateStr substringWithRange:NSMakeRange(0, 10)];
    _titleLabel.text = [dic objectForKey:@"biotopeName"];
    if ([[dic objectForKey:@"decorateLevel"]integerValue] == 0) {
        _styleLabel.text = @"经济适用";
    } else if ([[dic objectForKey:@"decorateLevel"]integerValue] == 1) {
        _styleLabel.text = @"中档装修";
    } else if ([[dic objectForKey:@"decorateLevel"]integerValue] == 2) {
        _styleLabel.text = @"高档装修";
    }
    _areaLabel.text = [NSString stringWithFormat:@"%@m²",[dic objectForKey:@"floorSpace"]];
    _dateLabel.text = wantDateStr;
    
   if([[dic objectForKey:@"provinceName"] isEqualToString:[dic objectForKey:@"cityName"]])
       _addressLabel.text = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"provinceName"],[dic objectForKey:@"decorateAreaName"]];
    else
        _addressLabel.text = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"provinceName"],[dic objectForKey:@"cityName"],[dic objectForKey:@"areaName"]];
    
    if([self.fromType isEqualToString:@"MyZhaoBiao"]) _stateLabel.text=[dic objectForKey:@"checkState"];
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    NSString *context =[NSString string];
    NSString *remarks =[dic objectForKey:@"remarks"];
    float height=0;
    if (remarks.length>0) {
        context=[NSString stringWithFormat:@"失败原因:%@",[dic objectForKey:@"remarks"]];
        CGSize labelsize = [util calHeightForLabel:context width:kMainScreenWidth-20 font:font];
        if ([dic objectForKey:@"remarks"]) {
            remark_why.frame =CGRectMake(remark_why.frame.origin.x, _styleLabel.frame.origin.y+_styleLabel.frame.size.height+10, labelsize.width, labelsize.height);
            remark_why.font =font;
            remark_why.text =context;
        }
        height =labelsize.height;
    }
    
    UIView *line=(UIView *)[cell viewWithTag:1000+indexPath.row];
    if(!line) line=[[UIView alloc]initWithFrame:CGRectMake(10, 100+height, kMainScreenWidth-20, 0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    line.tag=1000+indexPath.row;
    line.alpha=0.3;
    [cell addSubview:line];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.fromType isEqualToString:@"MyZhaoBiao"]){
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
    
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.fromType isEqualToString:@"MyZhaoBiao"]){
        return @"删除";
    }else{
        return nil;
    }
    
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSDictionary *dic =[self.dataArray objectAtIndex:indexPath.row];
        [self deleteMyZhaoBiaolist:[dic objectForKey:@"flowId"] tableIndexPath:indexPath];
    }
}
#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        [self.dataArray removeAllObjects];
        self.currentPage=0;
        if([self.fromType isEqualToString:@"MyZhaoBiao"]) [self requestMyZhaoBiaolist];
        else [self requestAllZhaoBiaolist];
    }
    else {
        if(self.totalPages>self.currentPage){
             if([self.fromType isEqualToString:@"MyZhaoBiao"]) [self requestMyZhaoBiaolist];
             else [self requestAllZhaoBiaolist];
        }
        else{
//            [phud hide:YES afterDelay:0.2];
            [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
            mtableview.reachedTheEnd = YES;  //是否加载到底了
            //[TLToast showWithText:@"亲，没有了哦" topOffset:350.0f duration:1.5];
        }
    }
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    
    self.refreshing=YES;
//    [self createProgressView];
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
    self.refreshing=NO;
//    [self createProgressView];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
    
}

#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (mtableview.contentOffset.y<-60) {
        mtableview.reachedTheEnd = NO;  //是否加载到底了
    }
    //手指开始拖动方法
    [mtableview tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [mtableview tableViewDidEndDragging:scrollView];
}

//查看全部装修招标信息
-(void)requestAllZhaoBiaolist{
    
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
        [postDict setObject:@"ID0045" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"iOS" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        
        NSDictionary *bodyDic = @{@"requestRow":@"15",
                                  @"currentPage":[NSString stringWithFormat:@"%d",self.currentPage + 1]
                                  };
        NSString *string02=[bodyDic JSONString];
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
                 NSLog(@"所有招标login返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 10451) {
                        [self stopRequest];
                        imageview_bg.hidden = YES;
                        label_bg.hidden = YES;
                        self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                        self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                        _diModel = [DecorationInfoModel objectWithKeyValues:jsonDict];
                        NSArray *arr_ = [NSMutableArray arrayWithArray:_diModel.consultantList];
                        if(self.refreshing==YES) [self.dataArray removeAllObjects];
                        for(NSDictionary *dict in arr_){
                            [self.dataArray addObject:dict];
                        }

                        [mtableview reloadData];
                        [mtableview tableViewDidFinishedLoading];
                    } else if (kResCode == 10459) {
//                        [TLToast showWithText:@"查询失败"];
                        imageview_bg.hidden = YES;
                        label_bg.hidden = YES;
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  imageview_bg.hidden = NO;
                                  label_bg.hidden = NO;
//                                  [TLToast showWithText:@"查询失败"];
                              });
                          }
                               method:url postDict:post];
    });

}

//查看我的装修招标信息
-(void)requestMyZhaoBiaolist{
    
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
        [postDict setObject:@"ID0250" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"iOS" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        
        NSDictionary *bodyDic = @{@"requestRow":@"15",
                                  @"currentPage":[NSString stringWithFormat:@"%d",self.currentPage + 1]
                                  };
        NSString *string02=[bodyDic JSONString];
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
                NSLog(@"我的招标login返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 102511) {
                        [self stopRequest];
//                        imageview_bg.hidden = YES;
//                        label_bg.hidden = YES;
                        self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                        self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                        _diModel = [DecorationInfoModel objectWithKeyValues:jsonDict];
                        NSArray *arr_ = [NSMutableArray arrayWithArray:_diModel.consultantList];
                        if(self.refreshing==YES) [self.dataArray removeAllObjects];
                        for(NSDictionary *dict in arr_){
                            [self.dataArray addObject:dict];
                        }
                        
                        [mtableview reloadData];
                        if([self.dataArray count]>0)
                            [mtableview tableViewDidFinishedLoading];
                        else{
                            imageview_bg.hidden = NO;
                            label_bg.hidden = NO;
                            [mtableview tableViewDidFinishedLoading];
                        }
                        
                    } else if (kResCode == 102519) {
                        //                        [TLToast showWithText:@"查询失败"];
                        imageview_bg.hidden = YES;
                        label_bg.hidden = YES;
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  imageview_bg.hidden = NO;
                                  label_bg.hidden = NO;
                                  //                                  [TLToast showWithText:@"查询失败"];
                              });
                          }
                               method:url postDict:post];
    });
    
}
//删除我的装修招标信息
-(void)deleteMyZhaoBiaolist:(NSString *)flowId tableIndexPath:(NSIndexPath *)index{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?",kDefaultUpdateVersionServerURL];
        
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
        [postDict setObject:@"ID0252" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"iOS" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        
        NSDictionary *bodyDic = @{
                                  @"flowsId":[NSString stringWithFormat:@"%@",flowId]
                                  };
        NSString *string02=[bodyDic JSONString];
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
                NSLog(@"删除我的招标信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (kResCode == 10002 || kResCode == 10003) {
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    if (kResCode == 102521) {
                        [self stopRequest];
                        [self.dataArray removeObjectAtIndex:[index row]];  //删除数组里的数据
                        [mtableview deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
                        [mtableview tableViewDidFinishedLoadingWithMessage:@"删除成功"];
                    }else if (kResCode ==102529){
                        [mtableview tableViewDidFinishedLoadingWithMessage:@"删除失败"];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [mtableview tableViewDidFinishedLoadingWithMessage:@"删除失败"];
                              });
                          }
                               method:url postDict:post];
    });
}

#pragma mark -
#pragma mark - LoginDelegate
//-(void)logged:(NSDictionary *)dict{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
