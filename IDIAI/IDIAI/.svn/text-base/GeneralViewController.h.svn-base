//
//  GeneralViewController.h
//  chronic
//
//  Created by 黄润 on 13-8-12.
//  Copyright (c) 2013年 chenhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "WDActivityIndicator.h"
#import "LoginView.h"
#import "EnterMobileNumView.h"
@interface GeneralViewController : UIViewController <MBProgressHUDDelegate,registerDelegate,LoginViewDelegate>
{
    MBProgressHUD *theHUD;
    NSOperationQueue* theOperationQueue;
    BOOL _isDidPop;
    UIImageView *imageview_bg;//zl
    UILabel *label_bg;//zl

} 

@property (nonatomic, copy) dispatch_block_t              theStopRequestBlock; //停止请求回调block
@property (nonatomic, copy) dispatch_block_t              theStartRequestBlock;//开始请求回调block
@property (strong, nonatomic) WDActivityIndicator *activityIndicator;//活动指示器
@property (nonatomic,copy)NSString *  stringJSSDK;//JSSDK
@property (nonatomic,copy)NSString * fromWhere;//推出该活动指示器的


- (void)startRequestWithString:(NSString*)str;//开始请求With提示语
- (void)stopRequest;//停止请求
- (void)changeMBHUDYOffset:(int)yOffset;//改变提示横幅的内容
- (CGRect)BackButtonRect;//改变返回按钮的位置
- (CGRect)rightButtonRect;//改变右边按钮的位置
- (CGRect)BottomViewRect;//


/*************** 提示部分**********/
- (void)stopRequestWithBlock:(dispatch_block_t)block; //停止请求withBlock
- (void)startRequestWithCustomIndicator;//停止请求with自定义指示器
- (void)showWithCustomView:(id)sender msg:(NSString *)msg;//展示提示信息With自定义的View
+ (void)resignAllKeyboard:(UIView*)aView;//辞去所有的KeyBorad

- (void)loginViewShow;//显示登录框 createByZL
- (void)loadImageviewBG;//展示无数据时的背景视图zl
#pragma mark registerDelegate
-(void)registerSucceedWithParemeters:(id)paremeters;//注册成功协议内容
#pragma mark LoginViewDelegate
-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict;//登录页面被点击的代理with信息参数
 



//SP 江涛
- (void)stopMBProgressHUD;//停止
- (void)startMBProgressHUDWithString:(NSString *)str;





/****************网络请求交互及回调****************/
/*****
 @param 方法一
 @param 通过函数回调结果
 @param 函数中tag标记是那个接口请求，方便回调中判断处理相关结果
 @param isProgress为YES表示带上传进度
 *****/
//当网络重新连接的时候重新刷新所有的UI
-(void)refreshAllUIWhenNetWorkIsRechable;//ZL

-(void)sendRequestToServerUrl:(NSString *)ServerUrl CmdID:(NSString *)cmdID
                     PostDict:(NSMutableDictionary *)bodyDict
                   RequestTag:(NSString *)tag RequestType:(NSString *)requestType;    //发送请求到服务器

-(void)sendRequestImagesToServerUrl:(NSString *)ServerUrl CmdID:(NSString *)cmdID
                           PostDict:(NSMutableDictionary *)bodyDict PostImages:(NSMutableArray *)images_arr
                     UploadImageKey:(NSString *)imageKey RequestTag:(NSString *)tag Progress:(BOOL)isProgress;    //发送请求到服务器(带图片上传)

-(void)completedRequest:(id)responseObject_ indexTag:(NSString *)tag;  //请求数据返回成功结果

-(void)failedRequest:(id)error indexTag:(NSString *)tag;     //请求数据返回失败结果

/*****
 @param 方法二
 @param 通过block回调结果
 @param isProgress为YES表示带上传进度
 *****/

- (void)sendRequestToServerUrl:(void (^)(id responseObject))aCompletionBlock
                   failedBlock:(void (^)(id responseObject))aFailedBlock
                    RequestUrl:(NSString *)requestUrl  CmdID:(NSString *)cmdID
                      PostDict:(NSMutableDictionary *)bodyDict RequestType:(NSString *)requestType;   //发送请求到服务器


- (void)sendRequestImagesToServerUrl:(void (^)(id responseObject))aCompletionBlock
                         failedBlock:(void (^)(id responseObject))aFailedBlock  RequestUrl:(NSString *)requestUrl
                               CmdID:(NSString *)cmdID PostDict:(NSMutableDictionary *)bodyDict
                          PostImages:(NSMutableArray *)images_arr UploadImageKey:(NSString *)imageKey Progress:(BOOL)isProgress;   //发送请求到服务器(带图片上传)


@end










