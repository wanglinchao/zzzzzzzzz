//
//  RefundListOfGoodsViewController.m
//  IDIAI
//
//  Created by Ricky on 15/5/27.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "AfterSaleListOfGoodsViewController.h"
#import "AfterSaleListOfGoodsModel.h"
#import "UIImageView+WebCache.h"
#import "LoginView.h"
#import "TLToast.h"
#import "IDIAIAppDelegate.h"
#import "AfterSaleDetailOfGoodsViewController.h"
#import "savelogObj.h"
#import "util.h"
#import "RefundAfterListCell.h"

@interface AfterSaleListOfGoodsViewController ()<LoginViewDelegate> {

}

@end

@implementation AfterSaleListOfGoodsViewController

@synthesize selected_mark;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    //    [mtableview launchRefreshing];
    //    [mtableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [savelogObj saveLog:@"查看商品售后详情" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:91];
    
    self.navigationController.navigationBar.hidden = YES;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    dataArray =[[NSMutableArray alloc]initWithCapacity:0];
    self.currentPage=0;
    
    //    if(selected_mark==1) self.mark_string=@"-1";
    //    else if(selected_mark==2) self.mark_string=@"1";
    //    else if(selected_mark==3) self.mark_string=@"2";
    //    else self.mark_string=@"3";
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-40) style:UITableViewStyleGrouped];
    mtableview.pullingDelegate=self;
    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[mtableview setHeaderOnly:YES];          //只有下拉刷新
    //[mtableview setFooterOnly:YES];         //只有上拉加载
    [mtableview launchRefreshing];
    [self.view addSubview:mtableview];
    
    [self loadImageviewBG];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([dataArray count]){
        AfterSaleListOfGoodsModel *afterSaleListOfGoodsModel=[dataArray objectAtIndex:indexPath.section];
        float height=57;
        for (int i=0;i<afterSaleListOfGoodsModel.shopGoodsBuyersVersionVoes.count;i++) {
            NSDictionary *dict=[afterSaleListOfGoodsModel.shopGoodsBuyersVersionVoes objectAtIndex:i];
            NSString *str=[dict objectForKey:@"goodsName"];
            CGSize size=[util calHeightForLabel:str width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:14]];
            if(size.height<20) size.height=20;
            height+=size.height;
            height+=48;
        }
        height+=70;
        return height;
    }
    else return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"RefundAfterListCell_";
    RefundAfterListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"RefundAfterListCell" owner:nil options:nil] lastObject];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if([dataArray count]){
        AfterSaleListOfGoodsModel *afterSaleListOfGoodsModel = [dataArray objectAtIndex:indexPath.section];
        
        UIImageView *image_icon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        image_icon.layer.cornerRadius=15;
        image_icon.layer.masksToBounds=YES;
        image_icon.contentMode=UIViewContentModeScaleAspectFill;
        image_icon.clipsToBounds=YES;
        [cell addSubview:image_icon];
        NSString *imgUrlStr = afterSaleListOfGoodsModel.shopLogoPath;
        [image_icon sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]];
        
        UILabel *lab_name=[[UILabel alloc]initWithFrame:CGRectMake(50, 14, kMainScreenWidth-120, 20)];
        lab_name.textColor=[UIColor darkGrayColor];
        lab_name.textAlignment=NSTextAlignmentLeft;
        lab_name.font=[UIFont systemFontOfSize:15];
        lab_name.text=afterSaleListOfGoodsModel.shopName;
        [cell addSubview:lab_name];
        
        UILabel *lab_State=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-30-110, 14, 100, 20)];
        lab_State.textColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
        lab_State.textAlignment=NSTextAlignmentRight;
        lab_State.font=[UIFont systemFontOfSize:15];
        lab_State.text=afterSaleListOfGoodsModel.stateName;
        [cell addSubview:lab_State];
        
        if(afterSaleListOfGoodsModel.shopGoodsBuyersVersionVoes.count){
            UIView *line_one=[[UIView alloc]initWithFrame:CGRectMake(10, 45, kMainScreenWidth-30-20, 0.5)];
            line_one.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
            [cell addSubview:line_one];
        }
        
        float height=57;
        for (int i=0;i<afterSaleListOfGoodsModel.shopGoodsBuyersVersionVoes.count;i++) {
            NSDictionary *dict=[afterSaleListOfGoodsModel.shopGoodsBuyersVersionVoes objectAtIndex:i];
            
            UIImageView *goods_icon=[[UIImageView alloc]initWithFrame:CGRectMake(10, height-2, 60, 60)];
            goods_icon.contentMode=UIViewContentModeScaleAspectFill;
            goods_icon.clipsToBounds=YES;
            [goods_icon sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"goodsPicUrl"]] placeholderImage:[UIImage imageNamed:@"bg_morentu_tuku_1"]];
            [cell addSubview:goods_icon];
            
            NSString *str=[dict objectForKey:@"goodsName"];
            CGSize size=[util calHeightForLabel:str width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:14]];
            if(size.height<20) size.height=20;
            UILabel *goods_name=[[UILabel alloc]initWithFrame:CGRectMake(80, height-2, kMainScreenWidth-120, size.height)];
            goods_name.textColor=[UIColor darkGrayColor];
            goods_name.textAlignment=NSTextAlignmentLeft;
            goods_name.font=[UIFont systemFontOfSize:14];
            goods_name.numberOfLines=0;
            goods_name.text=str;
            [cell addSubview:goods_name];
            
            height+=size.height;
            
            if([[dict objectForKey:@"goodsColor"] length]>=1){
                UILabel *goods_color=[[UILabel alloc]initWithFrame:CGRectMake(80, height+10, (kMainScreenWidth-130)/2, 20)];
                goods_color.textColor=[UIColor darkGrayColor];
                goods_color.textAlignment=NSTextAlignmentLeft;
                goods_color.font=[UIFont systemFontOfSize:12];
                goods_color.text=[NSString stringWithFormat:@"颜色：%@",[dict objectForKey:@"goodsColor"]];
                [cell addSubview:goods_color];
                
                if([[dict objectForKey:@"goodsModel"] length]>=1){
                    UILabel *goods_size=[[UILabel alloc]initWithFrame:CGRectMake(90+(kMainScreenWidth-130)/2, height+10, (kMainScreenWidth-130)/2, 20)];
                    goods_size.textColor=[UIColor darkGrayColor];
                    goods_size.textAlignment=NSTextAlignmentRight;
                    goods_size.font=[UIFont systemFontOfSize:12];
                    goods_size.text=[NSString stringWithFormat:@"规格：%@",[dict objectForKey:@"goodsModel"]];
                    [cell addSubview:goods_size];
                }
                
                height+=18;
            }
            else{
                if([[dict objectForKey:@"goodsModel"] length]>=1){
                    UILabel *goods_size=[[UILabel alloc]initWithFrame:CGRectMake(80, height+10, (kMainScreenWidth-130)/2, 20)];
                    goods_size.textColor=[UIColor darkGrayColor];
                    goods_size.textAlignment=NSTextAlignmentLeft;
                    goods_size.font=[UIFont systemFontOfSize:12];
                    goods_size.text=[NSString stringWithFormat:@"规格：%@",[dict objectForKey:@"goodsModel"]];
                    [cell addSubview:goods_size];
                    
                    height+=18;
                }
                else height+=18;
            }
            
            height+=30;
        }
        
        UIView *line_second=[[UIView alloc]initWithFrame:CGRectMake(10, height-0.7, kMainScreenWidth-30-20, 0.5)];
        line_second.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
        [cell addSubview:line_second];
        
        height+=10;
        
        UILabel *orderTotalMoneyTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, height, 70, 20)];
        orderTotalMoneyTitle.textColor=[UIColor darkGrayColor];
        orderTotalMoneyTitle.textAlignment=NSTextAlignmentLeft;
        orderTotalMoneyTitle.font=[UIFont systemFontOfSize:12];
        orderTotalMoneyTitle.text=@"交易金额：";
        [cell addSubview:orderTotalMoneyTitle];
        
        UILabel *orderTotalMoney=[[UILabel alloc]initWithFrame:CGRectMake(65, height, kMainScreenWidth-105, 20)];
        orderTotalMoney.textColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
        orderTotalMoney.textAlignment=NSTextAlignmentLeft;
        orderTotalMoney.font=[UIFont systemFontOfSize:15];
        orderTotalMoney.text=[NSString stringWithFormat:@"￥%.2f",afterSaleListOfGoodsModel.totalMoney];
        [cell addSubview:orderTotalMoney];
        
        height+=30;
        
        UILabel *Updatedate=[[UILabel alloc]initWithFrame:CGRectMake(10, height, kMainScreenWidth-50, 20)];
        Updatedate.textColor=[UIColor grayColor];
        Updatedate.textAlignment=NSTextAlignmentLeft;
        Updatedate.font=[UIFont systemFontOfSize:12];
        Updatedate.text=[NSString stringWithFormat:@"更新日期：%@",afterSaleListOfGoodsModel.updateTime];
        [cell addSubview:Updatedate];
        
        height+=30;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    RefundListModel *refundListModel = [dataArray objectAtIndex:indexPath.row];
//    
//    RefundDetailViewController *refundDetailVC = [[RefundDetailViewController alloc]init];
//    refundDetailVC.refundIDStr = refundListModel.refundId;
//    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [delegate.nav pushViewController:refundDetailVC animated:YES];
    
    AfterSaleListOfGoodsModel *afterSaleListOfGoodsModel = [dataArray objectAtIndex:indexPath.section];
    AfterSaleDetailOfGoodsViewController *afterSaleDetailOfGoodsVC = [[AfterSaleDetailOfGoodsViewController alloc]init];
    afterSaleDetailOfGoodsVC.afterSaleIdStr = [NSString stringWithFormat:@"%ld",(long)afterSaleListOfGoodsModel.afterSaleId];
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.nav pushViewController:afterSaleDetailOfGoodsVC animated:YES];
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=0;
        [self requestAfterSaleList];
    }
    else {
        if(self.totalPages>self.currentPage){
            [self requestAfterSaleList];
        }
        else{
            
            [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
            mtableview.reachedTheEnd = YES;  //是否加载到底了
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
    self.refreshing=NO;
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

-(void)DisPlayLoginView{
    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
    login.delegate=self;
    [login show];
    return;
}

#pragma mark - 请求商品售后列表
-(void)requestAfterSaleList{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0211\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"10\",\"currentPage\":\"%d\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"], self.currentPage+1];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"订单列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
                //token为空或验证未通过处理 huangrun
                if (code == 10002 || code == 10003) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview tableViewDidFinishedLoading];
                        [self performSelector:@selector(DisPlayLoginView) withObject:nil afterDelay:0.5];
                    });
                }
                else if (code==102111) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *arr_=[jsonDict objectForKey:@"afterSaleList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            if(self.refreshing==YES) [dataArray removeAllObjects];
                            for(NSDictionary *dict in arr_){
                                //                                [dataArray addObject:[DesignerInfoObj objWithDict:dict]];
                                [dataArray addObject:[AfterSaleListOfGoodsModel objectWithKeyValues:dict]];
                            }
                        }
                        if([dataArray count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [mtableview tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [mtableview tableViewDidFinishedLoading];
                        }
                        
                        [mtableview reloadData];
                        
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview tableViewDidFinishedLoading];
                        [TLToast showWithText:@"查询错误"];
                        if(![dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [mtableview reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [mtableview tableViewDidFinishedLoading];
                                  if(![dataArray count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}



- (void)gotoRefundVC:(id)sender {
//    UITableViewCell *cell = (UITableViewCell *)[[[sender superview]superview]superview];
//    NSIndexPath *indexPath = [mtableview indexPathForCell:cell];
//    RefundListModel *refundListModel = [dataArray objectAtIndex:indexPath.row];
//    
//    RefundViewController *refundVC = [[RefundViewController alloc]initWithNibName:@"RefundViewController" bundle:nil];
//    refundVC.orderIDStr = refundListModel.orderCode;
//    refundVC.moneyFloat = refundListModel.refundFee;
//    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [delegate.nav pushViewController:refundVC animated:YES];
}

#pragma mark -
#pragma mark - LoginDelegate
//-(void)logged:(NSDictionary *)dict{
//    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.nav dismissViewControllerAnimated:YES completion:^{
//        [self requestRefundList];
//    }];
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav dismissViewControllerAnimated:YES completion:^{
        [self requestAfterSaleList];
    }];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
