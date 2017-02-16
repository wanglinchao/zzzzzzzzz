//
//  UtopViewController.m
//  IDIAI
//
//  Created by Ricky on 15-1-13.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "UtopViewController.h"
#import "MySubscribeViewController.h"
#import "IDIAIAppDelegate.h"
#import "util.h"
#import "MyOrderMainViewController.h"
//#import "MyOrderDetailConfirmViewController.h"//测试用
#import "RefundAndAfterSaleMainViewController.h"
#import "MyOrderSpecifiedViewController.h"
#import "DynamicViewController.h"
#import "MyOrderModel.h"
#import "TLToast.h"
#import "MainMessageViewController.h"
//#import "LoginVC.h"
#import "LoginView.h"
#import "MessageListVC.h"
//#import "MyOrderContentViewController.h"
#import "DynamicViewController.h"
#import "savelogObj.h"
//#import "RefundDetailOfGoodsViewController.h" //测试用
#import "ShoppingCartViewController2.h"
#import "OrderOfGoodsMainViewController.h"
#import "RefundAndAfterSaleOfGoodsMainViewController.h"
#import "OrderOfGoodsContentViewController.h"
#import "MyToDoViewController.h"
#import "MyMailMainViewController.h"
#import "EmptyClearTableViewCell.h"
@interface UtopViewController () <LoginViewDelegate> {
    UITableView *_theTableView;
    UIButton *rightButton;
    
    NSArray *_hintDynamicArr;//首页展示的几条动态数据
//    NSString *_callNum;
    
}
@property(nonatomic,strong)NSString * goodsNumInShoppingCart;
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic, strong)NSString *mailBoxPrompNum;
@property (nonatomic,strong)NSString *toadyDaiBanPrompNum;
@end

@implementation UtopViewController

- (void)customizeNavigationBar {
    [self.tabBarController.navigationController setNavigationBarHidden:YES animated:NO];
    [self.tabBarController.navigationItem setLeftBarButtonItem:nil];
    [self.tabBarController.navigationItem setTitleView:nil];
    self.tabBarController.title = @"订单";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:[UIColor colorWithHexString:@"#E0E0E0" alpha:1.0]];
    
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
    [delegate.nav setNavigationBarHidden:YES animated:NO];
    
    self.navigationController.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);//修复点击其余选项卡导致关于cell不能点击的问题
    
    [self customizeNavigationBar];
    //修改navBar字体大小文字颜色
    NSDictionary *attris = @{ NSFontAttributeName:[UIFont systemFontOfSize:19],
                              NSForegroundColorAttributeName:[UIColor blackColor] };
    [delegate.nav.navigationBar setTitleTextAttributes:attris];
    
    //[self requestDynamiclist];
    [self requestNewMessage];
}
#pragma mark - 请求新消息列表
-(void)requestNewMessage{
//    [self startRequestWithString:@"加载中..."];
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0367\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"新消息列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==103671) {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self stopRequest];
                        self.mailBoxPrompNum =[jsonDict objectForKey:@"mailBoxPrompNum"];
                        self.toadyDaiBanPrompNum =[jsonDict objectForKey:@"toadyDaiBanPrompNum"];
                        [_theTableView reloadData];
                    });
                }
                else if (code==103679) {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self stopRequest];
                        self.mailBoxPrompNum =@"0";
                        self.toadyDaiBanPrompNum =@"0";
                        [_theTableView reloadData];
                    });
                }
                else if (code==101009){
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self stopRequest];
                        self.mailBoxPrompNum =@"0";
                        self.toadyDaiBanPrompNum =@"0";
                        [_theTableView reloadData];
                    });
                }else if (code ==10002){
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self stopRequest];
                        self.mailBoxPrompNum =@"0";
                        self.toadyDaiBanPrompNum =@"0";
                        [_theTableView reloadData];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  [self stopRequest];
                                  [TLToast showWithText:@"系统异常"];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}
- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"订单";
    self.navigationItem.title =@"订单中心";
    
    _theTableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)  style:UITableViewStyleGrouped];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_theTableView];
    
    //检查消息标识
    
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:Is_NewMessage]isEqualToString:@"yes"]){
        [self checkMessage];
    }
    else{
        self.timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(requestmessge_second) userInfo:nil repeats:YES];
    }
    [NSTimer scheduledTimerWithTimeInterval:1800.0 target:self selector:@selector(requestmessge) userInfo:nil repeats:YES];

//    [self requestCallNum];
    
    rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 90, 40)];
    [rightButton setImage:[UIImage imageNamed:@"btn_dianhua"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 25, 0, -5);
    [rightButton addTarget:self
                    action:@selector(PressBarItemRight)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
}
-(void)PressBarItemRight{
    NSString *serviceNumber = serviceNumber=[@"400-888-7372" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",serviceNumber]]]];
    webview.hidden = YES;
    // Assume we are in a view controller and have access to self.view
    [self.view addSubview:webview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section ==0) {
        return 48;
    }else if (indexPath.section ==1){
        return 48;
    }else{
        return 48;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section ==0) {
        return 1;
    }else if (section ==1){
        return 4;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellid1=[NSString stringWithFormat:@"mycellid_%d_%d_1",(int)indexPath.section,(int)indexPath.row];
    NSString *cellid2=[NSString stringWithFormat:@"mycellid_%d_%d_2",(int)indexPath.section,(int)indexPath.row];
    
    EmptyClearTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellid1];
    EmptyClearTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellid2];

    
    if (indexPath.section == 0) {
        if (cell1 == nil){
            cell1 = [[EmptyClearTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid1];
            UIButton *todobtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [todobtn setTitle:@"  待办" forState:UIControlStateNormal];
            [todobtn setTitle:@"  待办" forState:UIControlStateHighlighted];
            todobtn.titleLabel.font =[UIFont systemFontOfSize:15];
            [todobtn setTitleColor:[UIColor colorWithHexString:@"#575757"] forState:UIControlStateNormal];
            todobtn.frame=CGRectMake(0, 0, kMainScreenWidth/2, 44);
            [todobtn addTarget:self action:@selector(PressMyToDo) forControlEvents:UIControlEventTouchUpInside];
            [todobtn setImage:[UIImage imageNamed:@"ic_daiban"] forState:UIControlStateNormal];
            [todobtn setImage:[UIImage imageNamed:@"ic_daiban"] forState:UIControlStateHighlighted];
            [cell1.contentView addSubview:todobtn];
            
            UILabel *todonum =[[UILabel alloc] initWithFrame:CGRectMake(125*kMainScreenWidth/375, 5, 20, 20)];
            todonum.backgroundColor =[UIColor redColor];
            todonum.font =[UIFont systemFontOfSize:15];
            todonum.layer.cornerRadius=10;
            todonum.clipsToBounds=YES;
            todonum.tag =100;
            todonum.textColor =[UIColor whiteColor];
            todonum.textAlignment =NSTextAlignmentCenter;
            [cell1.contentView addSubview:todonum];
            
            UIButton *mailbtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [mailbtn setTitle:@"  信箱" forState:UIControlStateNormal];
            [mailbtn setTitle:@"  信箱" forState:UIControlStateHighlighted];
            [mailbtn setTitleColor:[UIColor colorWithHexString:@"#575757"] forState:UIControlStateNormal];
            mailbtn.frame=CGRectMake(kMainScreenWidth/2, 0, kMainScreenWidth/2, 44);
            mailbtn.titleLabel.font =[UIFont systemFontOfSize:14];
            [mailbtn setImage:[UIImage imageNamed:@"ic_xinxiang"] forState:UIControlStateNormal];
            [mailbtn setImage:[UIImage imageNamed:@"ic_xinxiang"] forState:UIControlStateHighlighted];
            [mailbtn addTarget:self action:@selector(PressMyMail) forControlEvents:UIControlEventTouchUpInside];
            [cell1.contentView addSubview:mailbtn];
            
            UILabel *mailnum =[[UILabel alloc] initWithFrame:CGRectMake(125*kMainScreenWidth/375+kMainScreenWidth/2, 5, 20, 20)];
            mailnum.backgroundColor =[UIColor redColor];
            mailnum.font =[UIFont systemFontOfSize:15];
            mailnum.layer.cornerRadius=10;
            mailnum.clipsToBounds=YES;
            mailnum.tag =101;
            mailnum.textColor =[UIColor whiteColor];
            mailnum.textAlignment =NSTextAlignmentCenter;
            [cell1.contentView addSubview:mailnum];
            
            cell1.accessoryType = UITableViewCellAccessoryNone;
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        // 消息标志红点
        UILabel *todonum =[cell1.contentView viewWithTag:100];
        if ([self.toadyDaiBanPrompNum integerValue]>0) {
            todonum.hidden =NO;
            if ([self.toadyDaiBanPrompNum integerValue]>99) {
                CGSize labelsize = [util calHeightForLabel:@"99+" width:40 font:[UIFont systemFontOfSize:15]];
                todonum.frame =CGRectMake(todonum.frame.origin.x, todonum.frame.origin.y, labelsize.width+13, 20);
                todonum.text =@"99+";
            }else{
                CGSize labelsize = [util calHeightForLabel:[NSString stringWithFormat:@"%@",self.toadyDaiBanPrompNum] width:40 font:[UIFont systemFontOfSize:15]];
                todonum.frame =CGRectMake(todonum.frame.origin.x, todonum.frame.origin.y, labelsize.width+13, 20);
                todonum.text =[NSString stringWithFormat:@"%@",self.toadyDaiBanPrompNum];
            }
        }else{
            todonum.hidden =YES;
        }
        
        UILabel *mailnum =[cell1.contentView viewWithTag:101];
        if ([self.mailBoxPrompNum integerValue]>0) {
            mailnum.hidden =NO;
            if ([self.mailBoxPrompNum integerValue]>99) {
                CGSize labelsize = [util calHeightForLabel:@"99+" width:40 font:[UIFont systemFontOfSize:15]];
                mailnum.frame =CGRectMake(mailnum.frame.origin.x, mailnum.frame.origin.y, labelsize.width+13, 20);
                mailnum.text =@"99+";
            }else{
                CGSize labelsize = [util calHeightForLabel:[NSString stringWithFormat:@"%@",self.mailBoxPrompNum] width:40 font:[UIFont systemFontOfSize:15]];
                mailnum.frame =CGRectMake(mailnum.frame.origin.x, mailnum.frame.origin.y, labelsize.width+13, 20);
                mailnum.text =[NSString stringWithFormat:@"%@",self.mailBoxPrompNum];
            }
        }else{
            mailnum.hidden =YES;
        }
        
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
    } else if (indexPath.section == 1) {
        if (cell2 == nil){
            cell2 = [[EmptyClearTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid2];
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetHeight(cell2.frame)+3, kMainScreenWidth-30, 1)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F4" alpha:1];
            [cell2 addSubview:lineView];
            if (indexPath.row == 0) {
                
                lineView.frame =CGRectMake(0, CGRectGetHeight(cell2.frame)+3, kMainScreenWidth, 1);
                
                UILabel *myseverlbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 40, 20)];
                myseverlbl.numberOfLines =0;
                myseverlbl.font=[UIFont systemFontOfSize:15];
//                myseverlbl.textAlignment=NSTextAlignmentCenter;
                myseverlbl.backgroundColor=[UIColor clearColor];
                myseverlbl.textColor=[UIColor colorWithHexString:@"#575757"];
//                CGSize labelsize1 = [util calHeightForLabel:@"服务" width:34 font:[UIFont systemFontOfSize:15]];
                myseverlbl.text=@"服务";
//                myseverlbl.frame =CGRectMake((64-labelsize1.width)/2, (64-labelsize1.height)/2, labelsize1.width, labelsize1.height);
                [cell2 addSubview:myseverlbl];
                
                cell2.accessoryType =UITableViewCellAccessoryNone;
                
            } else  {
                
                NSArray *cellImageArr = @[@"",@"ic_wodeyuyue_dingdan",@"ic_fuwudingdan_d",@"ic_tuikunshouhou_d"];//第一个空字符串请不要随意去掉，占位用，否则在后面的indexPath.row+1;
                NSArray *cellNameArr = @[@"",@"我的预约",@"服务订单",@"服务售后"];//同上
                cell2.imageView.image = [UIImage imageNamed:[cellImageArr objectAtIndex:indexPath.row]];
                cell2.textLabel.text = [cellNameArr objectAtIndex:indexPath.row];
                cell2.textLabel.font = [UIFont systemFontOfSize:14];
                cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
          
        }
       
    }else {
        if (cell2 == nil){
            cell2 = [[EmptyClearTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid2];
            
            
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetHeight(cell2.frame)+3, kMainScreenWidth-30, 1)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F4" alpha:1];
            [cell2 addSubview:lineView];
            if (indexPath.row == 0) {
                
                lineView.frame =CGRectMake(0, CGRectGetHeight(cell2.frame)+3, kMainScreenWidth, 1);
                UILabel *myseverlbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 40, 20)];
                myseverlbl.numberOfLines =0;
                myseverlbl.font=[UIFont systemFontOfSize:15];
//                myseverlbl.textAlignment=NSTextAlignmentCenter;
                myseverlbl.backgroundColor=[UIColor clearColor];
                myseverlbl.textColor=[UIColor colorWithHexString:@"#575757"];
//                CGSize labelsize1 = [util calHeightForLabel:@"商品" width:34 font:[UIFont systemFontOfSize:15]];
                myseverlbl.text=@"商品";
//                myseverlbl.frame =CGRectMake((64-labelsize1.width)/2, (64-labelsize1.height)/2, labelsize1.width, labelsize1.height);
                [cell2 addSubview:myseverlbl];
                cell2.accessoryType =UITableViewCellAccessoryNone;
            }else {
                
                NSArray *cellImageArr = @[@"",@"ic_gouwuche_d",@"ic_shangpindingdan_s",@"ic_tuikunshouhou_d"];//第一个空字符串请不要睡衣去掉，占位用，否则在后面的indexPath.row+1;
                NSArray *cellNameArr = @[@"",@"购物车",@"商品订单",@"商品售后"];
                cell2.imageView.image = [UIImage imageNamed:[cellImageArr objectAtIndex:indexPath.row]];//同上
                cell2.textLabel.text = [cellNameArr objectAtIndex:indexPath.row];
                cell2.textLabel.font = [UIFont systemFontOfSize:14];
                cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            }
            
        }
    
    }
     cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell2;
}

-(void)showSubscribe{
    NSString *token =[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
    if (token.length>0) {
        MySubscribeViewController *mySubcribeVC = [[MySubscribeViewController alloc]init];
        mySubcribeVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:mySubcribeVC animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
    
}
-(void)showSales{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
        RefundAndAfterSaleMainViewController *refundAndAfterSaleVC = [[RefundAndAfterSaleMainViewController alloc] init];
        refundAndAfterSaleVC = [[RefundAndAfterSaleMainViewController alloc]init];
        refundAndAfterSaleVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:refundAndAfterSaleVC animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
}
-(void)showOrderMain{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]) {
        MyOrderMainViewController *myOrderVC = [[MyOrderMainViewController alloc]init];
        myOrderVC.hidesBottomBarWhenPushed=YES;
        myOrderVC.fromIndex =1;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav setNavigationBarHidden:NO animated:YES];
        [delegate.nav pushViewController:myOrderVC animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
}
-(void)showShpingCar{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]) {
        ShoppingCartViewController2 *shoppingCartVC = [[ShoppingCartViewController2 alloc]init];
        shoppingCartVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shoppingCartVC animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
}
-(void)showGoodsOrder{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
        OrderOfGoodsMainViewController *orderOfGoodsMainVC = [[OrderOfGoodsMainViewController alloc]init];
        orderOfGoodsMainVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderOfGoodsMainVC animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
}
-(void)showGoodsSale{
    IDIAIAppDelegate *delegate;
    RefundAndAfterSaleOfGoodsMainViewController *refundAndAfterSaleMainVC;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
        [savelogObj saveLog:@"查看商品退款/售后列表" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:89];
            refundAndAfterSaleMainVC = [[RefundAndAfterSaleOfGoodsMainViewController alloc]init];
            refundAndAfterSaleMainVC.hidesBottomBarWhenPushed = YES;
            delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
            [self.navigationController pushViewController:refundAndAfterSaleMainVC animated:YES];
        }else{
            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                login.delegate=self;
                [login show];
        }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==1) {
            [self showSubscribe];
        }else if(indexPath.row==2){
        
            [self showOrderMain];
        }else{
         
            [self showSales];
        
        }
    }else if(indexPath.section==2){
        if (indexPath.row==1) {
            
            [self showShpingCar];
        }else if(indexPath.row ==2){
            
            [self showGoodsOrder];
        }else{
            [self showGoodsSale];
        
        }
        
    
    }
    
}
-(void)PressMyToDo{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:User_Token]) {
        MyToDoViewController *myToDoVC = [[MyToDoViewController alloc]init];
        myToDoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myToDoVC animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
}
-(void)PressMyMail{
    MyMailMainViewController *myOrderVC = [[MyMailMainViewController alloc]init];
    myOrderVC.hidesBottomBarWhenPushed=YES;
    //    myOrderVC.fromIndex =1;
    //    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    //    [delegate.nav setNavigationBarHidden:NO animated:YES];
    //    [delegate.nav pushViewController:myOrderVC animated:YES];
    [self.navigationController pushViewController:myOrderVC animated:YES];
    
}
- (void)clickStatusBtn:(UIButton *)btn {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
        MyOrderMainViewController *myOrderVC = [[MyOrderMainViewController alloc] init];
        RefundAndAfterSaleMainViewController *refundAndAfterSaleVC = [[RefundAndAfterSaleMainViewController alloc] init];
        
        switch (btn.tag) {
            case 100:{
                myOrderVC.fromIndex=1;
                myOrderVC.hidesBottomBarWhenPushed=YES;
                IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.nav setNavigationBarHidden:NO animated:YES];
                [delegate.nav pushViewController:myOrderVC animated:YES];
            }
                break;
            case 101:{
                myOrderVC.fromIndex=2;
                myOrderVC.hidesBottomBarWhenPushed=YES;
                IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.nav setNavigationBarHidden:NO animated:YES];
                [delegate.nav pushViewController:myOrderVC animated:YES];
            }
                break;
            case 102:{
                myOrderVC.fromIndex=0;
                myOrderVC.hidesBottomBarWhenPushed=YES;
                IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.nav setNavigationBarHidden:NO animated:YES];
                [delegate.nav pushViewController:myOrderVC animated:YES];
            }
                break;
            case 103:
                refundAndAfterSaleVC = [[RefundAndAfterSaleMainViewController alloc]init];
                refundAndAfterSaleVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:refundAndAfterSaleVC animated:YES];
                break;
            default:
                break;
        }
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
   
/*
    IDIAIAppDelegate *delegate;
//    RefundAndAfterSaleMainViewController *refundAndAfterSaleMainVC;
    MyOrderSpecifiedViewController *myOrderSpecifiedVC;
    MyOrderContentViewController *myOrderContentVC = [[MyOrderContentViewController alloc]init];
    DynamicViewController *dynamicVC = [[DynamicViewController alloc]init];
    RefundAndAfterSaleMainViewController *refundAndAfterSaleVC = [[RefundAndAfterSaleMainViewController alloc]init];
    
    switch (btn.tag) {
        case 100:
            myOrderContentVC.typeInteger = -1;
            myOrderContentVC.fromVcNameStr = @"utopVCStatusBtn";
            myOrderContentVC.hidesBottomBarWhenPushed=YES;
            delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.nav pushViewController:myOrderContentVC animated:YES];
            break;
            case 101:
            dynamicVC.fromVcNameStr = @"utopVCStatusBtn";
            dynamicVC.hidesBottomBarWhenPushed = YES;
            delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.nav pushViewController:dynamicVC animated:YES];
            break;
            case 102:
            myOrderSpecifiedVC = [[MyOrderSpecifiedViewController alloc]init];
            myOrderSpecifiedVC.fromVcNameStr = @"utopVCStatusBtn";
            myOrderSpecifiedVC.typeStr = @"4";
            myOrderSpecifiedVC.hidesBottomBarWhenPushed = YES;
            delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.nav pushViewController:myOrderSpecifiedVC animated:YES];
            break;
            case 103:
            refundAndAfterSaleVC = [[RefundAndAfterSaleMainViewController alloc]init];
            refundAndAfterSaleVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:refundAndAfterSaleVC animated:YES];
            break;
            
        default:
            break;
    }
*/      // by jiangt 注释
}

//-(void)PressBarItemRight{
//    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]){
//        //    MessageListVC *messagevc=[[MessageListVC alloc]init];
//        //    messagevc.hidesBottomBarWhenPushed=YES;
//        //    [self.navigationController pushViewController:messagevc animated:YES];
//        
//        MainMessageViewController *mainMsgVC = [[MainMessageViewController alloc]init];
//        mainMsgVC.hidesBottomBarWhenPushed = YES;
//        //        [self.navigationController pushViewController:mainMsgVC animated:YES];
//        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate.nav pushViewController:mainMsgVC animated:YES];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:Is_NewMessage];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
//    else{
//        self.view.tag=1;
//        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
//        login.delegate=self;
//        [login show];
//    }
//
//}

#pragma mark - 请求动态列表
-(void)requestDynamiclist{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0100\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"3\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"动态列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==101001) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *arr_=[jsonDict objectForKey:@"orderInfoList"];
                        _hintDynamicArr = [MyOrderModel objectArrayWithKeyValuesArray:arr_];
                        [_theTableView reloadData];
                        
                    });
                }
                else if (code==101002) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"订单类型错误"];
                 
                    });
                }
                else if (code==101009){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"系统异常"];
                    
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                         [TLToast showWithText:@"系统异常"];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

#pragma mark -
#pragma mark - LoginDelegate

//-(void)logged:(NSDictionary *)dict{
//    if(self.view.tag==1){
//        [self dismissViewControllerAnimated:YES completion:^{
//            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:Is_NewMessage];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//            [rightButton setImage:[UIImage imageNamed:@"ic_xiaoxi"] forState:UIControlStateNormal];
//            MessageListVC *messagevc=[[MessageListVC alloc]init];
//            messagevc.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:messagevc animated:YES];
//        }];
//    }
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
//    if(self.view.tag==1){
//        [self dismissViewControllerAnimated:YES completion:^{
//            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:Is_NewMessage];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//            [rightButton setImage:[UIImage imageNamed:@"ic_xiaoxi"] forState:UIControlStateNormal];
//            MessageListVC *messagevc=[[MessageListVC alloc]init];
//            messagevc.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:messagevc animated:YES];
//        }];
//    }
}

-(void)cancel{
    
}

#pragma mark -
#pragma mark - NSTimer

//检查消息标识(首次启动，当业务地址获得时以后会调用此函数)
-(void)requestmessge{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:Is_NewMessage]isEqualToString:@"yes"]){
        [self checkMessage];
    }
}

//检查消息标识(首次启动，当业务地址没有获得时调用此函数)
-(void)requestmessge_second{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:Is_NewMessage]isEqualToString:@"yes"]){
        [self.timer invalidate];
        self.timer=nil;
        [self checkMessage];
    }
}

//检查是否有新信息标识
-(void)checkMessage{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_date;
        if([[[NSUserDefaults standardUserDefaults] objectForKey:Message_date] length])
        {
            string_date = [[NSUserDefaults standardUserDefaults] objectForKey:Message_date];
        }
        else{
            string_date=@"";
        }
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0005\",\"deviceType\":\"ios\",\"token\":\"\",\"userID\":\"\",\"cityCode\":\"%@\"}&body={\"timeStamp\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],string_date];
        
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"消息标识返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (code==10051) {
//                        if([[jsonDict objectForKey:@"noticeSign"] integerValue]==1){
//                            [rightButton setImage:[UIImage imageNamed:@"ic_xiaoxi_dian"] forState:UIControlStateNormal];
//                            [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:Is_NewMessage];
//                            [[NSUserDefaults standardUserDefaults]synchronize];
//                        }
                    }
                    else if (code==10059) {
                    }
                });
                
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                              });
                          }
                               method:url postDict:nil];
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

- (void)clickStatusBtn2:(UIButton *)btn {
    IDIAIAppDelegate *delegate;
    //直接跳列表的需求 已变更
//    OrderOfGoodsContentViewController *orderOfGoodsContentVC = [[OrderOfGoodsContentViewController alloc]init];
//    orderOfGoodsContentVC.index = 1;
//    orderOfGoodsContentVC.fromVcNameStr = @"utopVCStatusBtn";
//    orderOfGoodsContentVC.hidesBottomBarWhenPushed = YES;
//    delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.nav pushViewController:orderOfGoodsContentVC animated:YES];
    
    OrderOfGoodsMainViewController *orderOfGoodsMainVC;
    RefundAndAfterSaleOfGoodsMainViewController *refundAndAfterSaleMainVC;
    
    switch (btn.tag) {
        case 400:{
            if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
                [savelogObj saveLog:@"查看全部商品订单" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:87];
                
                orderOfGoodsMainVC = [[OrderOfGoodsMainViewController alloc]init];
                orderOfGoodsMainVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:orderOfGoodsMainVC animated:YES];
            }else{
                LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                login.delegate=self;
                [login show];
            }
        }
            break;
        case 401:{
            if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
                [savelogObj saveLog:@"查看已完成商品订单" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:88];
                
                orderOfGoodsMainVC = [[OrderOfGoodsMainViewController alloc]init];
                orderOfGoodsMainVC.fromSecondTabStr = @"true";
                orderOfGoodsMainVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:orderOfGoodsMainVC animated:YES];
            }else{
                LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                login.delegate=self;
                [login show];
            }
        }
            break;
        case 402:{
            if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
                [savelogObj saveLog:@"查看商品退款/售后列表" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:89];
                
                refundAndAfterSaleMainVC = [[RefundAndAfterSaleOfGoodsMainViewController alloc]init];
                refundAndAfterSaleMainVC.hidesBottomBarWhenPushed = YES;
                delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
                [self.navigationController pushViewController:refundAndAfterSaleMainVC animated:YES];
            }else{
                LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                login.delegate=self;
                [login show];
            }
        }
            break;
            
        default:
            break;
    }

}


@end
