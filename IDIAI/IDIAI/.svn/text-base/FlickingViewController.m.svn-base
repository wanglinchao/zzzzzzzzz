//
//  FlickingViewController.m
//  IDIAI
//
//  Created by iMac on 15-7-2.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "FlickingViewController.h"
#import "UIView+SDExtension.h"
#import <AVFoundation/AVFoundation.h>
#import <ZXingObjC/ZXingObjC.h>
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "ShopOfGoodsViewController.h"
#import "GoodsDetailViewController.h"
#import "IDIAIAppDelegate.h"

static const CGFloat kBorderW = 60;
static const CGFloat kMargin = 15;

@interface FlickingViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property (nonatomic ,strong) AVCaptureSession *captureSession;              //捕捉会话
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, weak) UIView *maskView;

@end

@implementation FlickingViewController

-(void)backTouched{
    [_captureSession stopRunning];
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    if(isTapImagePicker==YES) [self.navigationController setNavigationBarHidden:YES animated:NO];
    else [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    IDIAIAppDelegate *delegate=(IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:YES animated:NO];
    
    isTapImagePicker=NO;
    //开始捕获
    [_captureSession startRunning];
}

-(void)viewWillDisappear:(BOOL)animated{
    if(isTapImagePicker==YES) [self.navigationController setNavigationBarHidden:YES animated:NO];
    else [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //停止捕获
    [_captureSession stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self setupMaskView];
    
   // [self setupBottomBar];
    
    [self setupScanWindowView];
    
    [self beginScanning];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(10, 0, 80,80)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui_b.png"] forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake( 0, 0, 0, 50)];
    [leftButton addTarget:self
                   action:@selector(backTouched)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    UILabel *rightLab=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-50, 24, 40, 30)];
    rightLab.backgroundColor=[UIColor blackColor];
    rightLab.alpha=0.2;
    rightLab.layer.cornerRadius=10;
    rightLab.layer.masksToBounds=YES;
    [self.view addSubview:rightLab];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(kMainScreenWidth-80, 20, 80, 40)];
    [rightButton setTitle:@"相册" forState:UIControlStateNormal];
    rightButton.titleEdgeInsets=UIEdgeInsetsMake(10, 30, 10, 10);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [rightButton addTarget:self
                    action:@selector(Getimage)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
}

/***************************************************/
//从相册选择二维码识条形码、二维码
/***************************************************/

-(void)Getimage{
    [_captureSession stopRunning];
    
    if (!_imagePickerController) {
        
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    isTapImagePicker=YES;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma - mark - UIImagePickerViewControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self getInfoWithImage:image];
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_captureSession startRunning];
    
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark 照片处理
-(void)getInfoWithImage:(UIImage *)img{
    
    UIImage *loadImage= img;
    CGImageRef imageToDecode = loadImage.CGImage;
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    
    if (result) {
        NSString *contents = result.text;
        //[self ScanDecor:contents];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FlickingSucceed" object:contents];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [_captureSession stopRunning];
        [self showInfoWithMessage:@"图片中未检测到二维码／条码" andTitle:nil];
    }
}

- (void)showInfoWithMessage:(NSString *)message andTitle:(NSString *)title
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
    [alter show];
}

/**************************************/
//摄像头扫描条形码、二维码
/**************************************/

- (void)setupMaskView
{
//    UIView *mask = [[UIView alloc] init];
//    _maskView = mask;
//
//    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
//    mask.layer.borderWidth =kBorderW;
//    
//    mask.bounds = CGRectMake(0, 0, self.view.sd_width, self.view.sd_height * 1.0);
//    mask.center = CGPointMake(self.view.sd_width * 0.5, self.view.sd_height * 0.5);
//    mask.sd_y = 0;
//    
//    [self.view addSubview:mask];
    
    //CGFloat scanWindowH = self.view.sd_height * 0.6 - kBorderW * 2;
    CGFloat scanWindowH = self.view.sd_width - kMargin * 6;
    CGFloat scanWindowW = self.view.sd_width - kMargin * 4;
    
    UIView *mask_left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMargin*2, kMainScreenHeight)];
    mask_left.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:mask_left];
    
    UIView *mask_right = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth-kMargin*2, 0, kMargin*2, kMainScreenHeight)];
    mask_right.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:mask_right];
    
    UIView *mask_top = [[UIView alloc] initWithFrame:CGRectMake(kMargin*2, 0,scanWindowW, (kMainScreenHeight-scanWindowH)/2)];
    mask_top.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:mask_top];
    
    UIView *mask_bottom = [[UIView alloc] initWithFrame:CGRectMake(kMargin*2, (kMainScreenHeight-scanWindowH)/2+scanWindowH-2,  scanWindowW, (kMainScreenHeight-scanWindowH)/2+2)];
    mask_bottom.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:mask_bottom];
    
    UILabel *tishi_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, mask_bottom.frame.origin.y+20, kMainScreenWidth-40, 20)];
    tishi_lab.backgroundColor=[UIColor clearColor];
    tishi_lab.font=[UIFont systemFontOfSize:15];
    tishi_lab.textColor=[UIColor whiteColor];
    tishi_lab.textAlignment=NSTextAlignmentCenter;
    tishi_lab.text=@"将二维码/条码放入框内，即可自动扫描";
    [self.view addSubview:tishi_lab];
}

- (void)setupBottomBar
{
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.sd_height * 0.9, self.view.sd_width, self.view.sd_height * 0.1)];
    bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self.view addSubview:bottomBar];
}

- (void)setupScanWindowView
{
    //CGFloat scanWindowH = self.view.sd_height * 0.6 - kBorderW * 2;
    CGFloat scanWindowH = self.view.sd_width - kMargin * 6;
    CGFloat scanWindowW = self.view.sd_width - kMargin * 4;
    UIView *scanWindow = [[UIView alloc] initWithFrame:CGRectMake(kMargin*2, (kMainScreenHeight-scanWindowH)/2, scanWindowW, scanWindowH)];
    scanWindow.clipsToBounds = YES;
    [self.view addSubview:scanWindow];
    
    CGFloat scanNetImageViewH = 241;
    CGFloat scanNetImageViewW = scanWindow.sd_width;
    UIImageView *scanNetImageView = [[UIImageView alloc] initWithImage:[self imageWithColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] Image:[UIImage imageNamed:@"scan_net"]]];
    scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath = @"transform.translation.y";
    scanNetAnimation.byValue = @(scanWindowH);
    scanNetAnimation.duration = 1.0;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [scanNetImageView.layer addAnimation:scanNetAnimation forKey:nil];
    [scanWindow addSubview:scanNetImageView];
    
    CGFloat buttonWH = 18;
    
    UIButton *topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"scan_1"] forState:UIControlStateNormal];
    [scanWindow addSubview:topLeft];
    
    UIButton *topRight = [[UIButton alloc] initWithFrame:CGRectMake(scanWindowW - buttonWH, 0, buttonWH, buttonWH)];
    [topRight setImage:[UIImage imageNamed:@"scan_2"] forState:UIControlStateNormal];
    [scanWindow addSubview:topRight];
    
    UIButton *bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, scanWindowH - buttonWH, buttonWH, buttonWH)];
    [bottomLeft setImage:[UIImage imageNamed:@"scan_3"] forState:UIControlStateNormal];
    [scanWindow addSubview:bottomLeft];
    
    UIButton *bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(topRight.sd_x, bottomLeft.sd_y, buttonWH, buttonWH)];
    [bottomRight setImage:[UIImage imageNamed:@"scan_4"] forState:UIControlStateNormal];
    [scanWindow addSubview:bottomRight];
}

- (void)beginScanning
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    output.rectOfInterest = CGRectMake(0.1, 0, 0.9, 1);
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _captureSession = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_captureSession addInput:input];
    [_captureSession addOutput:output];
    
    //扫码类型，设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,         //二维码
                                     AVMetadataObjectTypeCode39Code,     //条形码   韵达和申通
                                     AVMetadataObjectTypeCode128Code,    //CODE128条码  顺丰用的
                                     AVMetadataObjectTypeCode39Mod43Code,
                                     AVMetadataObjectTypeEAN13Code,
                                     AVMetadataObjectTypeEAN8Code,
                                     AVMetadataObjectTypeCode93Code,    //条形码,星号来表示起始符及终止符,如邮政EMS单上的条码
                                     AVMetadataObjectTypeUPCECode]];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_captureSession startRunning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [_captureSession stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        
        if(metadataObject.stringValue.length>=1){
           // [self ScanDecor:metadataObject.stringValue];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"FlickingSucceed" object:metadataObject.stringValue];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (!parent) {
        self.navigationController.navigationBar.hidden = NO;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [_captureSession startRunning];
    }
}

#pragma mark -
#pragma mark - 发送扫一扫二维码到服务器验证

-(void)ScanDecor:(NSString *)DecorUrl{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0249" forKey:@"cmdID"];
        [postDict setObject:@"" forKey:@"token"];
        [postDict setObject:@"" forKey:@"userID"];
        [postDict setObject:@"iOS" forKey:@"deviceType"];
        [postDict setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
        NSString *string=[postDict JSONString];
        
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:DecorUrl forKey:@"qrCode"];
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
                NSLog(@"扫描二维码返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[jsonDict objectForKey:@"resCode"] integerValue]==102491) {
                        if([[jsonDict objectForKey:@"mark"] integerValue]==1){
                            [self.navigationController popViewControllerAnimated:NO];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetBrandShop" object:[jsonDict objectForKey:@"resMsg"]];                                //品牌
                        }
                        else if([[jsonDict objectForKey:@"mark"] integerValue]==2){
                            NSString *shopID=[[[jsonDict objectForKey:@"resMsg"] componentsSeparatedByString:@"="] lastObject];
                            ShopOfGoodsViewController *shopVC=[[ShopOfGoodsViewController alloc]init];   //商家
                            shopVC.shopIdStr=[NSString stringWithFormat:@"%@",shopID];
                            [self.navigationController pushViewController:shopVC animated:YES];
                        }
                        else if([[jsonDict objectForKey:@"mark"] integerValue]==3){
                            NSString *shopID=[[[jsonDict objectForKey:@"resMsg"] componentsSeparatedByString:@"="] lastObject];
                            GoodsDetailViewController *goodsVC=[[GoodsDetailViewController alloc]init];  //商品详情
                            goodsVC.goodsIdStr=[NSString stringWithFormat:@"%@",shopID];
                            [self.navigationController pushViewController:goodsVC animated:YES];
                        }
                        else{
                            [_captureSession stopRunning];
                            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"无法识别的二维码" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
                            [alter show];
                        }
                    }
                    else if([[jsonDict objectForKey:@"resCode"] integerValue]==102492) {
                        [_captureSession stopRunning];
                        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"该商品已下架" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
                        [alter show];
                    }
                    else if([[jsonDict objectForKey:@"resCode"] integerValue]==102493) {
                        [_captureSession stopRunning];
                        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"该商品不存在" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
                        [alter show];
                    }
                    else if([[jsonDict objectForKey:@"resCode"] integerValue]==102499) {
                        [_captureSession stopRunning];
                        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:[jsonDict objectForKey:@"resMsg"] delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
                        [alter show];
                    }
                    else {
                        [_captureSession stopRunning];
                        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"无法识别的二维码" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
                        [alter show];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                 [_captureSession startRunning];
                              });
                          }
                               method:url postDict:post];
    });
    
}

#pragma mark -
#pragma mark -改变图片颜色
- (UIImage *)imageWithColor:(UIColor *)color Image:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0,image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
