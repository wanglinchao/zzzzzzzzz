//
//  GoodsDetailsViewController.m
//  IDIAI
//
//  Created by PM on 16/6/15.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "pointGoodsDetailsViewController.h"
#import "GoodDetailModel.h"
#import "TLToast.h"
#import "UIImageView+WebCache.h"

@interface pointGoodsDetailsViewController ()<UIAlertViewDelegate>
{

}
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UIView * firstPartView ;
@property(nonatomic,strong)UIImageView * goodsImageView;
@property(nonatomic,strong)UILabel * descrLabel;
@property(nonatomic,strong)UIImageView * pointImgView;
@property(nonatomic,strong)UILabel * needPointLabel;
@property(nonatomic,strong)UILabel * priceLable;
@property(nonatomic,strong)UIButton * exchangeBtn;
@property(nonatomic,strong)UIView * lineView;
@property(nonatomic,strong)UILabel * detailDescrLable;
@property(nonatomic,assign)NSInteger alertViewTag;//alertViewTag值
@property(nonatomic,assign)NSInteger needPoint;
@property(nonatomic,strong)UIWebView * webView;
@property(nonatomic,strong)UILabel * goodsStatusLab;//商品状态
@end

@implementation pointGoodsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self requestPointGoodsDetails];
}


-(void)initUI{
    self.title = @"商品详情";
    self.view.backgroundColor = disableTextColor;
    //背景滚动试图
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, kMainScreenWidth, kMainScreenHeight-74)];
    [self.view addSubview:_scrollView];
    _scrollView.showsVerticalScrollIndicator = NO;
    
    
    
    
    //第一部分UI
    self.firstPartView = [[UIView alloc]initWithFrame:CGRectMake(0,0,kMainScreenWidth,130)];
    [_scrollView addSubview:self.firstPartView];
    
    self.firstPartView.backgroundColor = [UIColor whiteColor];
    
    _goodsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,10,100,100)];
    [self.firstPartView addSubview:_goodsImageView];
    
    _descrLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_goodsImageView.frame)+20, CGRectGetMinY(_goodsImageView.frame), kMainScreenWidth-50-CGRectGetWidth(_goodsImageView.frame), 40)];
    [self.firstPartView addSubview:_descrLabel];
    _descrLabel.numberOfLines = 2;
    _descrLabel.textColor = subHeadingColor;
    _descrLabel.font = [UIFont systemFontOfSize:14];
    
    _pointImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_descrLabel.frame), CGRectGetMaxY(_descrLabel.frame)+20,20,20)];
   
    [self.firstPartView addSubview:_pointImgView];
    _pointImgView.image = [UIImage imageNamed:@"ic_jifen"];

     _needPointLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_pointImgView.frame)+5, CGRectGetMinY(_pointImgView.frame),40,CGRectGetHeight(_pointImgView.frame))];
    [self.firstPartView addSubview:_needPointLabel];
    _needPointLabel.textColor =emphasizeTextColor;
    _needPointLabel.font = [UIFont systemFontOfSize:14];
    
    _priceLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_needPointLabel.frame)+10, CGRectGetMinY(_needPointLabel.frame),60, CGRectGetHeight(_pointImgView.frame))];
    [self.firstPartView addSubview:_priceLable];
    _priceLable.textColor = disableTextColor;
    _priceLable.font = [UIFont systemFontOfSize:14];
    
    _exchangeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-90, CGRectGetMaxY(_priceLable.frame)+10,80,25)];
    _exchangeBtn.layer.cornerRadius = 3;
    _exchangeBtn.layer.masksToBounds = YES;
    [self.firstPartView addSubview:_exchangeBtn];

    [_exchangeBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [_exchangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_exchangeBtn setBackgroundColor:emphasizeTextColor];

    [_exchangeBtn addTarget:self action:@selector(pressExchange:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _goodsStatusLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_descrLabel.frame),CGRectGetMaxY(_pointImgView.frame)+10,120,20)];
    [self.firstPartView addSubview:_goodsStatusLab];
    _goodsStatusLab.numberOfLines =1;
    _goodsStatusLab.textColor = emphasizeTextColor;
    _goodsStatusLab.font = [UIFont systemFontOfSize:12];
   
    //第二部分UI
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.firstPartView.frame),kMainScreenWidth-40,1)];
    [_scrollView addSubview:_lineView];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    //第三部分
//    _detailDescrLable = [[UILabel alloc]initWithFrame:CGRectMake(1,CGRectGetMaxY(_lineView.frame),CGRectGetWidth(_lineView.frame),kMainScreenHeight-CGRectGetMaxY(_lineView.frame))];
//    [self.scrollView addSubview:_detailDescrLable];
//    
//    _detailDescrLable.textColor = subHeadingColor;
//    _detailDescrLable.font = [UIFont systemFontOfSize:14];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.firstPartView.frame),kMainScreenWidth-40,1)];
    [self.scrollView addSubview:self.webView];
    
   
    
}


-(void)pressExchange:(id)sender{
        UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"确认兑换" message:[NSString stringWithFormat:@"扣除积分%@?",_needPointLabel.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alerView show];
   
}
    

    



-(void)requestPointGoodsDetails{

    if(![util isConnectionAvailable]){
        [TLToast showWithText:@"无网络连接" topOffset:200.0f duration:1.0];
        return;
    }
    
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token;
        NSString *string_userid;
        NSString * string_cityCode;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];;
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
            string_cityCode = [[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"];
        }
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cityCode\":\"%@\",\"cmdID\":\"ID0372\",\"userID\":\"%@\",\"token\":\"%@\",\"deviceType\":\"ios\"}&body={\"pgId\":%ld}",kDefaultUpdateVersionServerURL,string_cityCode,string_userid,string_token,(long)self.pgId];
        NSLog(@"%@",url);
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"积分商品详情：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
                //未登录
                if (code == 10002) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"未登录"];
                      
                        
                    });
                }//操作成功
                else if (code==103721) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSDictionary * dict=[jsonDict objectForKey:@"pointsGoods"];
                        if ([dict count]) {
                            //该地区有商品时
                               self.goodsDetailModel = [GoodDetailModel objectWithKeyValues:dict];
                               [self addDataToUI];
                            
                            }else{
                            //该地区无商品时
                            [self loadImageviewBG];
                            label_bg.text = @"亲，该商品暂时没有详情";

                        }
                    });
                }//操作失败
                else if (code==103729) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        //                        [mtableview tableViewDidFinishedLoading];
                        [TLToast showWithText:@"操作失败"];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];//停止显示等待View
                                  [TLToast showWithText:@"请求失败"
                                               duration:1];
                              });   
                          }
                               method:url postDict:nil]; 
    });

}



-(void)addDataToUI{
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:_goodsDetailModel.pgImgPath] placeholderImage:[UIImage imageNamed:@"ic_morentu"]];
    _descrLabel.text =_goodsDetailModel.pgName;
    _needPointLabel.text = [NSString stringWithFormat:@"%ld",(long)_goodsDetailModel.pgNumber];
    NSMutableAttributedString  * attStr= [[NSMutableAttributedString  alloc]initWithString:[NSString stringWithFormat:@"¥%2.f",_goodsDetailModel.pgPrice] attributes:@{NSForegroundColorAttributeName:disableTextColor,NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger: NSUnderlineStyleSingle]}];
    _priceLable.attributedText =attStr;
    self.needPoint = _goodsDetailModel.pgNumber;
    
    if (_goodsDetailModel.pgStatus ==0) {
        _goodsStatusLab.text =@"已下架";
         _exchangeBtn.enabled = NO;
        [_exchangeBtn setBackgroundColor:disableTextColor];
    }else{
    
    }
   
    if (![_goodsDetailModel.cityCodes containsString:[[NSUserDefaults standardUserDefaults]objectForKey:User_CityCode]]) {
        _goodsStatusLab.text = @"暂不支持该地区的兑换";
        _exchangeBtn.enabled = NO;
        [_exchangeBtn setBackgroundColor:disableTextColor];

    }
    else{
        //不显示
    }
    
    
}

-(void)loadImageviewBG{
    UIImage *image_failed = [UIImage imageNamed:@"ic_moren"];
    if(!imageview_bg)
        imageview_bg=[[UIImageView alloc] initWithImage:image_failed];
    imageview_bg.frame=CGRectMake((kMainScreenWidth-image_failed.size.width)/2, (kMainScreenHeight-64-40-image_failed.size.height - 26)/2, image_failed.size.width, image_failed.size.height);
    imageview_bg.tag=111;
    imageview_bg.hidden=YES;
    [self.view addSubview:imageview_bg];
    if (!label_bg)
        label_bg = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview_bg.frame.origin.y + imageview_bg.frame.size.height + 5, kMainScreenWidth, 21)];
    label_bg.textAlignment = NSTextAlignmentCenter;
    label_bg.font = [UIFont systemFontOfSize:13];
    label_bg.textColor = [UIColor lightGrayColor];
    label_bg.hidden = YES;
        [self.view addSubview:label_bg];
}




-(void)pressExchangeGoods:(UIButton *)sender{
 
    UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"确认兑换" message:[NSString stringWithFormat:@"扣除积分%ld?",self.needPoint] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alerView show];
    self.alertViewTag = 0;
    
    
}




#pragma - mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (self.alertViewTag ==0) {
        if (buttonIndex==0) {
            //按取消键
        }else{
            [self checkWeatherCanExchange];
            
        }
        
    }else
        if(self.alertViewTag ==1){
            //商品抢光了
            
        }
        else if(self.alertViewTag ==2){
            //积分不足
            
            
            
        }
    
    
}

-(void)checkWeatherCanExchange{
    
    if(![util isConnectionAvailable]){
        [TLToast showWithText:@"无网络连接" topOffset:200.0f duration:1.0];
        return;
    }
    
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        NSString * string_userId =[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        NSString * string_userToken = [[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0369" forKey:@"cmdID"];
        [postDict setObject:string_userToken forKey:@"token"];
        [postDict setObject:string_userId forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
        NSString *string=[postDict JSONString];
        //        @"%@/dispatch/dispatch.action?body={\"pgId\":\%ld\}"
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:[NSString stringWithFormat:@"%ld",self.pgId] forKey:@"pgId"];
        
        NSString *string02=[postDict02 JSONString];
        
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
                NSLog(@"兑换积分商品返回信息：%@",jsonDict);
                NSInteger rescode =[[jsonDict objectForKey:@"resCode"] integerValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    　
                    if (rescode==103691) {
                        [TLToast showWithText:@"兑换成功" duration:2];
                    }
                    else
                        if(rescode==103699){
                            //                            [phud hide:YES];
                            [TLToast showWithText:@"操作失败" duration:1.0];
                            
                        }
                        else if(rescode==103692){
                            //                            [phud hide:YES];
                            UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"就在刚刚商品被抢光了" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"看看其他的",nil];
                            [alerView show];
                            self.alertViewTag = 1;
                            
                        }
                        else if(rescode==103693){
                            //                            [phud hide:YES];
                            UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"你的积分不注意兑换此商品" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"看看其他的",nil];
                            [alerView show];
                            self.alertViewTag = 2;
                        }
                        else if(rescode ==103694) {
                            //                            [phud hide:YES];
                            [TLToast showWithText:@"兑换已达到限制" duration:1];
                        }
                        else {
                            [TLToast showWithText:@"token验证失效" duration:1];
                            
                        }
                    
                });
                
            });
            
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  //                                      [phud hide:YES];
                                  [TLToast showWithText:@"登录失败" topOffset:220.0f duration:1.0];
                              });
                          }
                               method:url postDict:post];
    });
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
