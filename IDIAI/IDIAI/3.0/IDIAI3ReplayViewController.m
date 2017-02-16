//
//  IDIAI3ReplayViewController.m
//  IDIAI
//
//  Created by Ricky on 15/11/25.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3ReplayViewController.h"
#import "LoginView.h"
#import "DiaryReplyObject.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "DiaryReplayCell.h"
#import "IDIAI3DiaryDetaileViewController.h"
#import "TLToast.h"
@interface IDIAI3ReplayViewController ()<LoginViewDelegate,DiaryReplayCellDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL isempty;
@end

@implementation IDIAI3ReplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    self.view.backgroundColor =[UIColor whiteColor];
    self.currentPage=0;
    self.isempty =YES;
    self.type =7;
    self.dataArray =[NSMutableArray array];
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) pullingDelegate:self];
    self.mtableview.backgroundColor=[UIColor colorWithHexString:@"#efeff4"];
    self.mtableview.dataSource=self;
    self.mtableview.delegate=self;
    self.mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[mtableview setHeaderOnly:YES];          //只有下拉刷新
    //[mtableview setFooterOnly:YES];         //只有上拉加载
    [self.mtableview launchRefreshing];
    [self.view addSubview:self.mtableview];
//    [self requestDiarylist];
    // Do any additional setup after loading the view.
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton  *emptyBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    emptyBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [emptyBtn setTitle:@"清空" forState:UIControlStateNormal];
    [emptyBtn setTitle:@"清空" forState:UIControlStateSelected];
    [emptyBtn setTitleColor:[UIColor colorWithHexString:@"#575757"] forState:UIControlStateNormal];
    [emptyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [emptyBtn addTarget:self action:@selector(emptyAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:emptyBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
}
-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requseempty{
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
        [postDict setObject:@"ID0287" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"roleId":[NSNumber numberWithInt:7]};
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
                    
                    if (kResCode == 102871) {
                        [self stopRequest];
                        self.isempty =YES;
//                        [self requestDiarylist];
                        [self.navigationController popViewControllerAnimated:YES];
                        [TLToast showWithText:@"清空成功"];
                    } else {
                        [self stopRequest];
                        [TLToast showWithText:@"清空失败"];
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
-(void)emptyAction:(UIButton *)sender{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"" message:@"确定要清空历史回复吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)requestDiarylist{
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
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0284\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"10\",\"currentPage\":\"%ld\",\"roleId\":\%ld}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)self.currentPage,(long)self.type];
        
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
                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                    login.delegate=self;
                    [login show];
                    return;
                    });
                }
                if (code==102841) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if(self.refreshing==YES && [self.dataArray count]) [self.dataArray removeAllObjects];
                        if (self.isempty ==YES)[self.dataArray removeAllObjects];
                        NSArray *arr_=[jsonDict objectForKey:@"diaryComments"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                        }
                        for(NSDictionary *dict in arr_){
                            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[DiaryReplyObject class]];
                            DiaryReplyObject *item = [parser parseDictionary:dict];
                            [self.dataArray addObject:item];
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
//                        self.isrequst =YES;
                        self.isempty =NO;
                        [self.mtableview reloadData];
                        //                        self.isrequst =NO;
                    });
                }
                else if (code==102809) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [self.mtableview tableViewDidFinishedLoading];
                        if(![self.dataArray count]) {
//                            imageview_bg.hidden=NO;
//                            label_bg.hidden = NO;
                        }
                        [self.mtableview reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [self.mtableview tableViewDidFinishedLoading];
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
                                  [self.mtableview tableViewDidFinishedLoading];
                                  if(![self.dataArray count]) {
//                                      imageview_bg.hidden=NO;
//                                      label_bg.hidden = NO;
                                  }
                                  [self.mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}
#pragma mark-UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *const cellidentifier = [NSString stringWithFormat:@"tvcRemindItem%d",(int)indexPath.row];
    DiaryReplayCell *cell = (DiaryReplayCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[DiaryReplayCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
    }
    cell.reply =[self.dataArray objectAtIndex:indexPath.row];
    return [cell getCellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *const cellidentifier = [NSString stringWithFormat:@"tvcRemindItem%d",(int)indexPath.row];
    DiaryReplayCell *cell = (DiaryReplayCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[DiaryReplayCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
    }
    cell.delegate=self;
    cell.reply =[self.dataArray objectAtIndex:indexPath.row];
    [cell getCellHeight];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DiaryReplyObject *object =[self.dataArray objectAtIndex:indexPath.row];
    IDIAI3DiaryDetaileViewController *detail =[[IDIAI3DiaryDetaileViewController alloc] init];
    detail.title =@"帖子详情";
    detail.diaryId =[NSString stringWithFormat:@"%d",(int)object.diaryId];
    detail.type =7;
    if (object.commentType!=2) {
        detail.iscomment =YES;
        if (object.userId==[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]) {
            detail.iscomment =NO;
        }
    }
    detail.ismyDiary =self.ismyDiary;
    if (object.commentType!=3) {
        detail.tonickName =object.nickName;
        detail.commentId =object.commentId;
        detail.roleId =object.roleId;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
#pragma mark - DiaryReplayCellDelegate
-(void)touchHead:(DiaryReplyObject *)object{
    IDIAI3DiaryDetaileViewController *detail =[[IDIAI3DiaryDetaileViewController alloc] init];
    detail.title =@"帖子详情";
    detail.diaryId =[NSString stringWithFormat:@"%d",(int)object.diaryId];
    detail.type =7;
    if (object.commentType!=2) {
        detail.iscomment =YES;
        if (object.userId==[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]) {
            detail.iscomment =NO;
        }
    }
    detail.ismyDiary =self.ismyDiary;
    if (object.commentType!=3) {
        [self.navigationController pushViewController:detail animated:YES];
    }
}
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=1;
        [self requestDiarylist];
    }
    else {
        if(self.totalPages>self.currentPage){
            self.currentPage +=1;
            [self requestDiarylist];
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
//    imageview_bg.hidden=YES;
//    label_bg.hidden = YES;
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
    if (buttonIndex==1) {
        [self requseempty];
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
