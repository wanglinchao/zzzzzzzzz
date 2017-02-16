//
//  AfterSaleDetailOfGoodsViewController.m
//  IDIAI
//
//  Created by Ricky on 15/5/6.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "AfterSaleDetailOfGoodsViewController.h"
#import "util.h"
#import "ImageZoomView.h"
#import "LoginView.h"
#import "AfterSaleDetailOfGoodsModel.h"
#import "TLToast.h"
#import "IDIAIAppDelegate.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ShopOfGoodsViewController.h"
#import "ShopClearblankCell.h"

#define Kimageview_tag 100     //凭证图
#define Kuibutton_tag 1000   //凭证图

@interface AfterSaleDetailOfGoodsViewController () <UITableViewDataSource, UITableViewDelegate,LoginViewDelegate> {
    UITableView *_theTableView;
    AfterSaleDetailOfGoodsModel *_afterSaleDetailOfGoodsModel;
//    NSString *_callNum;
}

@property (strong, nonatomic) UIButton *btn_phone;

@end

@implementation AfterSaleDetailOfGoodsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    self.title = @"售后详情";
    //导航右按钮
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 90, 40)];
    [rightButton setImage:[UIImage imageNamed:@"btn_dianhua"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 25, 0, -5);
    [rightButton addTarget:self
                    action:@selector(PressBarItemRight:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setFrame:CGRectMake(5, 5, 40, 40)];
//    [rightButton setImage:[UIImage imageNamed:@"ico_kefu"] forState:UIControlStateNormal];
//    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [rightButton addTarget:self
//                    action:@selector(PressBarItemRight:)
//          forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    _theTableView = [[UITableView alloc]initWithFrame:kTableViewFrame style:UITableViewStylePlain];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_theTableView];
    
    self.theBackButton = [[UIButton alloc] initWithFrame:[self BackButtonRect]];
    [self.theBackButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];
    //navigation item左移一点
    self.theBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.theBackButton];
    self.navigationItem.leftBarButtonItem = backBarBtn;
    
    [self requestAfterSaleDetailOfGoods];
    [self createPhone];
//    [self requestCallNum];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height=10;
    height+=55;
    NSString *str=_afterSaleDetailOfGoodsModel.goodsName;
    CGSize size=[util calHeightForLabel:str width:kMainScreenWidth-110 font:[UIFont systemFontOfSize:15]];
    if(size.height<20) size.height=20;
    height+=size.height+10;
    height+=90;
    
    NSString *strReason;
    if(_afterSaleDetailOfGoodsModel.reason) strReason=_afterSaleDetailOfGoodsModel.reason;
    else strReason=@"";
    CGSize sizeReason=[util calHeightForLabel:strReason width:kMainScreenWidth-100 font:[UIFont systemFontOfSize:15]];
    height+=sizeReason.height+sizeReason.height/20*5+5;
    
    if(_afterSaleDetailOfGoodsModel.evidenceImages.count){
        height+=30;
        height+=(kMainScreenWidth-120)/3+5;
    }
    else height+=5;
    
    height+=45;
    
    if(_afterSaleDetailOfGoodsModel.state ==1) height+=30;
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid=@"Mycellid";
    ShopClearblankCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ShopClearblankCell" owner:nil options:nil] lastObject];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    float height=10;
    
    UIImageView *image_icon=[[UIImageView alloc]initWithFrame:CGRectMake(20, height-2, 35, 35)];
    image_icon.layer.cornerRadius=17.5;
    image_icon.layer.masksToBounds=YES;
    image_icon.contentMode=UIViewContentModeScaleAspectFill;
    image_icon.clipsToBounds=YES;
    [cell addSubview:image_icon];
    [image_icon sd_setImageWithURL:[NSURL URLWithString:_afterSaleDetailOfGoodsModel.shopLogoPath] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]];
    
    UILabel *lab_name=[[UILabel alloc]initWithFrame:CGRectMake(65, height+5, kMainScreenWidth-195, 20)];
    lab_name.textColor=[UIColor darkGrayColor];
    lab_name.textAlignment=NSTextAlignmentLeft;
    lab_name.font=[UIFont systemFontOfSize:16];
    lab_name.text=_afterSaleDetailOfGoodsModel.shopName;
    [cell addSubview:lab_name];
    
    UILabel *lab_State=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-120, height+5, 100, 20)];
    lab_State.textColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    lab_State.textAlignment=NSTextAlignmentRight;
    lab_State.font=[UIFont systemFontOfSize:16];
    lab_State.text=_afterSaleDetailOfGoodsModel.stateName;
    [cell addSubview:lab_State];
    
    UIButton *btn_shop=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, kMainScreenWidth-40, 50)];
    [btn_shop addTarget:self action:@selector(Pressbtn_ShopInfo) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn_shop];
    
    height+=40;
    
    UIView *line_one=[[UIView alloc]initWithFrame:CGRectMake(20, height, kMainScreenWidth-40, 0.5)];
    line_one.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
    [cell addSubview:line_one];
    
    height+=12;
    
    int count=1;
    for (int i=0; i<count; i++) {
        UIImageView *goods_icon=[[UIImageView alloc]initWithFrame:CGRectMake(20, height+2, 60, 60)];
        goods_icon.userInteractionEnabled=YES;
        goods_icon.contentMode=UIViewContentModeScaleAspectFill;
        goods_icon.clipsToBounds=YES;
        [goods_icon sd_setImageWithURL:[NSURL URLWithString: _afterSaleDetailOfGoodsModel.goodsLogo] placeholderImage:[UIImage imageNamed:@"bg_morentu_tuku_1"]];
        [cell addSubview:goods_icon];

        NSString *str=_afterSaleDetailOfGoodsModel.goodsName;
        CGSize size=[util calHeightForLabel:str width:kMainScreenWidth-110 font:[UIFont systemFontOfSize:15]];
        if(size.height<20) size.height=20;
        UILabel *goods_name=[[UILabel alloc]initWithFrame:CGRectMake(90, height, kMainScreenWidth-110, size.height)];
        goods_name.textColor=[UIColor grayColor];
        goods_name.textAlignment=NSTextAlignmentLeft;
        goods_name.font=[UIFont systemFontOfSize:15];
        goods_name.numberOfLines=0;
        goods_name.text=str;
        [cell addSubview:goods_name];
        
        UIButton *btn_goods=[[UIButton alloc]initWithFrame:CGRectMake(0, height, kMainScreenWidth, size.height+30)];
       // [btn_goods addTarget:self action:@selector(Pressbtn_GoodsInfo:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn_goods];
        
        height+=size.height+10;
        
        
        if([_afterSaleDetailOfGoodsModel.goodsColor length]>=1){
            UILabel *goods_color=[[UILabel alloc]initWithFrame:CGRectMake(90, height, (kMainScreenWidth-130)/2, 20)];
            goods_color.textColor=[UIColor grayColor];
            goods_color.textAlignment=NSTextAlignmentLeft;
            goods_color.font=[UIFont systemFontOfSize:13];
            goods_color.text=[NSString stringWithFormat:@"颜色：%@",_afterSaleDetailOfGoodsModel.goodsColor];
            [cell addSubview:goods_color];
            
            if([_afterSaleDetailOfGoodsModel.goodsModel length]>=1){
                UILabel *goods_size=[[UILabel alloc]initWithFrame:CGRectMake(90+(kMainScreenWidth-130)/2, height, (kMainScreenWidth-130)/2, 20)];
                goods_size.textColor=[UIColor grayColor];
                goods_size.textAlignment=NSTextAlignmentLeft;
                goods_size.font=[UIFont systemFontOfSize:13];
                goods_size.text=[NSString stringWithFormat:@"规格：%@",_afterSaleDetailOfGoodsModel.goodsModel];
                [cell addSubview:goods_size];
            }
            
        }
        else{
            if([_afterSaleDetailOfGoodsModel.goodsModel length]>=1){
                UILabel *goods_size=[[UILabel alloc]initWithFrame:CGRectMake(90, height, (kMainScreenWidth-130)/2, 20)];
                goods_size.textColor=[UIColor grayColor];
                goods_size.textAlignment=NSTextAlignmentLeft;
                goods_size.font=[UIFont systemFontOfSize:13];
                goods_size.text=[NSString stringWithFormat:@"规格：%@",_afterSaleDetailOfGoodsModel.goodsModel];
                [cell addSubview:goods_size];
            }
        }
        
        height+=35;
    }
    
    height+=5;
    
    UILabel *RefundReasonTitle=[[UILabel alloc]initWithFrame:CGRectMake(20, height, 65, 20)];
    RefundReasonTitle.textColor=[UIColor darkGrayColor];
    RefundReasonTitle.textAlignment=NSTextAlignmentLeft;
    RefundReasonTitle.font=[UIFont systemFontOfSize:15];
    RefundReasonTitle.text=@"售后原因:";
    [cell addSubview:RefundReasonTitle];
    
    NSString *str;
    if(_afterSaleDetailOfGoodsModel.reason) str=_afterSaleDetailOfGoodsModel.reason;
    else str=@"";
    CGSize sizeReason=[util calHeightForLabel:str width:kMainScreenWidth-100 font:[UIFont systemFontOfSize:15]];
    UILabel *RefundReason=[[UILabel alloc]initWithFrame:CGRectMake(90, height+2, kMainScreenWidth-100, sizeReason.height)];
    RefundReason.textColor=[UIColor grayColor];
    RefundReason.textAlignment=NSTextAlignmentLeft;
    RefundReason.font=[UIFont systemFontOfSize:15];
    RefundReason.numberOfLines=0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    RefundReason.attributedText=attributedString;
    [RefundReason sizeToFit];//必须
    [cell addSubview:RefundReason];
    
    height+=sizeReason.height+sizeReason.height/20*5+5;
    
    UILabel *Refundamounttitle=[[UILabel alloc]initWithFrame:CGRectMake(20, height, 65, 20)];
    Refundamounttitle.textColor=[UIColor darkGrayColor];
    Refundamounttitle.textAlignment=NSTextAlignmentLeft;
    Refundamounttitle.font=[UIFont systemFontOfSize:15];
    Refundamounttitle.text=@"交易金额:";
    [cell addSubview:Refundamounttitle];
    
    UILabel *Refundamount=[[UILabel alloc]initWithFrame:CGRectMake(90, height, kMainScreenWidth-100, 20)];
    Refundamount.textColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    Refundamount.textAlignment=NSTextAlignmentLeft;
    Refundamount.font=[UIFont systemFontOfSize:15];
    Refundamount.text=[NSString stringWithFormat:@"￥%.2f",_afterSaleDetailOfGoodsModel.orderTotalMoney];
    [cell addSubview:Refundamount];
    
    height+=25;
    
    UILabel *aplyDateTitle=[[UILabel alloc]initWithFrame:CGRectMake(20, height, 65, 20)];
    aplyDateTitle.textColor=[UIColor darkGrayColor];
    aplyDateTitle.textAlignment=NSTextAlignmentLeft;
    aplyDateTitle.font=[UIFont systemFontOfSize:15];
    aplyDateTitle.text=@"申请日期:";
    [cell addSubview:aplyDateTitle];
    
    UILabel *aplyDate=[[UILabel alloc]initWithFrame:CGRectMake(90, height, kMainScreenWidth-100, 20)];
    aplyDate.textColor=[UIColor grayColor];
    aplyDate.textAlignment=NSTextAlignmentLeft;
    aplyDate.font=[UIFont systemFontOfSize:15];
    aplyDate.text=[NSString stringWithFormat:@"%@",_afterSaleDetailOfGoodsModel.updateDate];
    [cell addSubview:aplyDate];
    
    height+=25;
    
    if(_afterSaleDetailOfGoodsModel.evidenceImages.count){
        UILabel *PictureTitle=[[UILabel alloc]initWithFrame:CGRectMake(20, height, 85, 20)];
        PictureTitle.textColor=[UIColor darkGrayColor];
        PictureTitle.textAlignment=NSTextAlignmentLeft;
        PictureTitle.font=[UIFont systemFontOfSize:15];
        PictureTitle.text=@"凭证照片:";
        [cell addSubview:PictureTitle];
        
        height+=30;
        
        for (int i=0; i<_afterSaleDetailOfGoodsModel.evidenceImages.count; i++) {
            UIImageView *photo_img=[[UIImageView alloc]initWithFrame:CGRectMake(20+i*40+(kMainScreenWidth-120)/3*i, height, (kMainScreenWidth-120)/3, (kMainScreenWidth-120)/3-10)];
            photo_img.tag=Kimageview_tag+i;
            photo_img.userInteractionEnabled=YES;
            photo_img.clipsToBounds=YES;
            photo_img.contentMode=UIViewContentModeScaleAspectFill;
            [photo_img sd_setImageWithURL:[NSURL URLWithString:[_afterSaleDetailOfGoodsModel.evidenceImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"bg_morentu_tuku_1"]];
            [cell addSubview:photo_img];
            
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(20+i*40+(kMainScreenWidth-120)/3*i, height, (kMainScreenWidth-120)/3, (kMainScreenWidth-120)/3)];
            btn.tag=Kuibutton_tag+i;
            [btn addTarget:self action:@selector(tappress:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
        
        height+=(kMainScreenWidth-120)/3+5;
    }
    else height+=5;
    
    UIView *line_three=[[UIView alloc]initWithFrame:CGRectMake(20, height-0.7, kMainScreenWidth-40, 0.5)];
    line_three.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
    [cell addSubview:line_three];
    
    height+=15;
    
    UIButton *btn_closed = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_closed.frame = CGRectMake(kMainScreenWidth-90, height-1, 80, 25);
    // btn_closed.tag = KUIButton_Reject_TAG+indexPath.row;
    btn_closed.titleLabel.font=[UIFont systemFontOfSize:13];
    [btn_closed setTitle:@"取消售后" forState:UIControlStateNormal];
    //给按钮加一个白色的板框
    btn_closed.layer.borderColor = [[UIColor colorWithHexString:@"#EF6562" alpha:1.0] CGColor];
    btn_closed.layer.borderWidth = 0.5f;
    //给按钮设置弧度,这里将按钮变成了圆形
    btn_closed.layer.cornerRadius = 5.0f;
    btn_closed.layer.masksToBounds = YES;
    [btn_closed setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
    btn_closed.backgroundColor=[UIColor whiteColor];
    [btn_closed addTarget:self action:@selector(clickCancelAfterSaleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn_closed];
    if(_afterSaleDetailOfGoodsModel.state != 4) {
        btn_closed.hidden=NO;
        height+=30;
    }
    else btn_closed.hidden=YES;
    
    return cell;
}

-(void)tappress:(UIButton *) btn{
    UITableViewCell *cell=[_theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIImageView *imageview_big=(UIImageView *)[cell viewWithTag:btn.tag-Kuibutton_tag+Kimageview_tag];
    ImageZoomView *zoomView = [[ImageZoomView alloc] initWithView:self.view.window Images:imageview_big.image];
    [zoomView show];
}

//请求售后详情
-(void)requestAfterSaleDetailOfGoods {
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0213\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"afterSaleId\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.afterSaleIdStr];
        
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
                
                if (code==102131) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSDictionary *resDic = [jsonDict objectForKey:@"afterSaleDetails"];
                        _afterSaleDetailOfGoodsModel = [AfterSaleDetailOfGoodsModel objectWithKeyValues:resDic];
                        [_theTableView reloadData];
                    });
                } else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self stopRequest];
                        [TLToast showWithText:@"数据加载失败"];
                    });
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

- (void)clickCancelAfterSaleBtn:(UIButton *)btn {
    
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
        [postDict setObject:@"ID0215" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"afterSaleId":self.afterSaleIdStr};
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
                        dispatch_async(dispatch_get_main_queue(), ^{
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        
                        login.delegate=self;
                        [login show];
                        return;
                        });
                    }
                    
                    if (kResCode == 102151) {
                        [self stopRequest];
                        [TLToast showWithText:@"取消售后成功"];
                        [self requestAfterSaleDetailOfGoods];
                    } else {
                        [self stopRequest];
                        [TLToast showWithText:@"取消售后失败"];
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


-(void)createPhone{
    self.btn_phone = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_phone.frame=CGRectMake(kMainScreenWidth-50, kMainScreenHeight-250, 50, 50);
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_ddh_mor.png"] forState:UIControlStateNormal];
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_ddh.png"] forState:UIControlStateHighlighted];
    self.btn_phone.tag=1003;
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
    NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",_afterSaleDetailOfGoodsModel.shopPhone];
    UIWebView *callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
    [self.view addSubview:callWebview];
}

- (void)PressBarItemRight:(id)sender {
//    if (_callNum) {
        NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",callNumber];
        UIWebView *callWebview = [[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
        [self.view addSubview:callWebview];
//    } else {
//        [self requestCallNum];
//    }
}

//#pragma mark - 获取电话号码
//- (void)requestCallNum {
//    [self startRequestWithString:@"加载中..."];
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
//                        [self stopRequest];
//                        _callNum = [jsonDict objectForKey:@"fbPhoneNumber"];
//                        NSLog(@"获取电话成功");
//                    });
//                }
//                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10369){
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self stopRequest];
//                        NSLog(@"获取电话失败");
//                    });
//                } else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self stopRequest];
//                    });
//                }
//            });
//        }
//                          failedBlock:^{
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  [self stopRequest];
//                              });
//                          }
//                               method:url postDict:post];
//    });
//    
//    
//}


- (void)Pressbtn_ShopInfo {
    ShopOfGoodsViewController *shopOfGoodsVC = [[ShopOfGoodsViewController alloc]init];
    shopOfGoodsVC.shopIdStr = [NSString stringWithFormat:@"%ld",(long)_afterSaleDetailOfGoodsModel.shopId];
    [self.navigationController pushViewController:shopOfGoodsVC animated:YES];
}

@end
