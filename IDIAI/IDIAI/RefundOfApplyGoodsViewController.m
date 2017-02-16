//
//  RefundOfApplyGoodsViewController.m
//  IDIAI
//
//  Created by iMac on 15-8-10.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "RefundOfApplyGoodsViewController.h"
#import "NSStringAdditions.h"
#import "TLToast.h"
#import "LoginVC.h"
#import "AutomaticLogin.h"
#import "ImageZoomView.h"
#import "util.h"
#import "CustomPromptView.h"
typedef NS_ENUM(NSInteger, kPHOTO_TYPES) {
    kPHOTO1,
    kPHOTO2,
    kPHOTO3,
    kPHOTO4,
    kPHOTO5
};

@interface RefundOfApplyGoodsViewController ()<UITextFieldDelegate,UITextViewDelegate>{
    kPHOTO_TYPES _photoTypes;
    NSString *_imageFile1;
    NSString *_imageFile2;
    NSString *_imageFile3;
    UIButton *_imgDeleteBtn1;
    UIButton *_imgDeleteBtn2;
    UIButton *_imgDeleteBtn3;
//    NSString *_callNum;
    CustomPromptView *customPromp;
}

@end

@implementation RefundOfApplyGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"申请退款";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:[UIColor colorWithHexString:@"#CFCFCF" alpha:0.5]];
    
    self.theScrollView=[[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    self.theScrollView.contentSize=CGSizeMake(kMainScreenWidth, kMainScreenHeight*2);
    [self.view addSubview:self.theScrollView];
    
    float height=15;
    
    UILabel *goodsNamelbl =[[UILabel alloc] initWithFrame:CGRectMake(10, height, kMainScreenWidth-20, 20)];
    goodsNamelbl.font =[UIFont systemFontOfSize:17.0];
    goodsNamelbl.textColor =[UIColor colorWithHexString:@"#575757"];
    goodsNamelbl.text =[NSString stringWithFormat:@"商品名称:%@",self.goodsName];
    [self.theScrollView addSubview:goodsNamelbl];
    height+=30;
    
    UILabel *feelbl =[[UILabel alloc] initWithFrame:CGRectMake(10, height, kMainScreenWidth-20, 20)];
    feelbl.font =[UIFont systemFontOfSize:17.0];
    feelbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
    feelbl.text =[NSString stringWithFormat:@"实付金额:%.2f",[self.goodsTotalMoneyStr floatValue]];
    [self.theScrollView addSubview:feelbl];
    height+=30;
    
    UILabel *reasonTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, height, 200, 20)];
    reasonTitle.font=[UIFont systemFontOfSize:16];
    reasonTitle.textAlignment=NSTextAlignmentLeft;
    reasonTitle.text=@"退款原因：";
    [self.theScrollView addSubview:reasonTitle];
    
    height+=30;
    
    self.reasonTV=[[UITextView alloc] initWithFrame:CGRectMake(10, height, kMainScreenWidth-20, 110)];
    self.reasonTV.delegate=self;
    self.reasonTV.layer.cornerRadius = 5;
    self.reasonTV.layer.borderColor = [UIColor colorWithHexString:@"#CFCFCF" alpha:0.6].CGColor;
    self.reasonTV.layer.borderWidth = 1;
    self.reasonTV.layer.masksToBounds = YES;
    self.reasonTV.font=[UIFont systemFontOfSize:15];
    [self.theScrollView addSubview:self.reasonTV];
    
    _uilabel=[[UILabel alloc]initWithFrame:CGRectMake(15, height+7, 150, 20)];
    _uilabel.text =@"最多200字";
    _uilabel.font=[UIFont systemFontOfSize:15];
    _uilabel.enabled = NO;//lable必须设置为不可用
    _uilabel.textAlignment=NSTextAlignmentLeft;
    _uilabel.textColor=[UIColor lightGrayColor];
    _uilabel.backgroundColor = [UIColor clearColor];
    [self.theScrollView addSubview:_uilabel];
    
    height+=120;
    
    UILabel *typeTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, height, 200, 20)];
    typeTitle.font=[UIFont systemFontOfSize:16];
    typeTitle.textAlignment=NSTextAlignmentLeft;
    typeTitle.text=@"退款类型：";
    [self.theScrollView addSubview:typeTitle];
    
    height+=30;
    
    UILabel *typeOne=[[UILabel alloc]initWithFrame:CGRectMake(55, height, 40, 20)];
    typeOne.font=[UIFont systemFontOfSize:16];
    typeOne.textAlignment=NSTextAlignmentLeft;
    typeOne.text=@"退款";
    [self.theScrollView addSubview:typeOne];
    
    UILabel *typeTwo=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-105, height, 80, 20)];
    typeTwo.font=[UIFont systemFontOfSize:16];
    typeTwo.textAlignment=NSTextAlignmentLeft;
    typeTwo.text=@"退货退款";
    [self.theScrollView addSubview:typeTwo];
    
    self.typeBtn1=[[UIButton alloc]initWithFrame:CGRectMake(typeOne.frame.origin.x-45, height-10, 60, 40)];
    [self.typeBtn1 setImage:[UIImage imageNamed:@"ic_xuanze_nor"] forState:UIControlStateNormal];
    [self.typeBtn1 setImage:[UIImage imageNamed:@"ic_xuanze"] forState:UIControlStateSelected];
    [self.typeBtn1 addTarget:self action:@selector(clickTypeBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [self.theScrollView addSubview:self.typeBtn1];
    self.typeBtn1.selected=YES;
    
    self.typeBtn2=[[UIButton alloc]initWithFrame:CGRectMake(typeTwo.frame.origin.x-45, height-10, 60, 40)];
    [self.typeBtn2 setImage:[UIImage imageNamed:@"ic_xuanze_nor"] forState:UIControlStateNormal];
    [self.typeBtn2 setImage:[UIImage imageNamed:@"ic_xuanze"] forState:UIControlStateSelected];
    [self.typeBtn2 addTarget:self action:@selector(clickTypeBtn2:) forControlEvents:UIControlEventTouchUpInside];
    [self.theScrollView addSubview:self.typeBtn2];
    
    height+=40;
    
    UILabel *refundMoneyTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, height, 80, 20)];
    refundMoneyTitle.font=[UIFont systemFontOfSize:16];
    refundMoneyTitle.textAlignment=NSTextAlignmentLeft;
    refundMoneyTitle.text=@"退款金额：";
    [self.theScrollView addSubview:refundMoneyTitle];
    
    UILabel *refundMoneyDesc=[[UILabel alloc]initWithFrame:CGRectMake(refundMoneyTitle.frame.origin.x+80, height+3, kMainScreenWidth-110, 15)];
    refundMoneyDesc.font=[UIFont systemFontOfSize:12];
    refundMoneyDesc.textAlignment=NSTextAlignmentLeft;
    refundMoneyDesc.text=@"退款金额不超过商品金额";
    refundMoneyDesc.textColor=[UIColor grayColor];
    [self.theScrollView addSubview:refundMoneyDesc];
    
    height+=30;
    
    self.TFView=[[UIView alloc]initWithFrame:CGRectMake(10, height, kMainScreenWidth-20, 40)];
    self.TFView.backgroundColor=[UIColor whiteColor];
    self.TFView.layer.cornerRadius = 5;
    self.TFView.layer.borderColor = [UIColor colorWithHexString:@"#CFCFCF" alpha:0.6].CGColor;
    self.TFView.layer.borderWidth = 1;
    self.TFView.layer.masksToBounds = YES;
    [self.theScrollView addSubview:self.TFView];
    
    self.moneyTF=[[UITextField alloc]initWithFrame:CGRectMake(15, height, kMainScreenWidth-30, 40)];
    self.moneyTF.borderStyle=UITextBorderStyleNone;
    self.moneyTF.delegate=self;
    self.moneyTF.keyboardType=UIKeyboardTypeDecimalPad;
    self.moneyTF.font=[UIFont systemFontOfSize:15];
    self.moneyTF.placeholder=@"输入退款金额￥";
    [self.theScrollView addSubview:self.moneyTF];
    
    height+=55;
    
    UILabel *pzTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, height, 100, 20)];
    pzTitle.font=[UIFont systemFontOfSize:16];
    pzTitle.textAlignment=NSTextAlignmentLeft;
    pzTitle.text=@"上传凭证：";
    [self.theScrollView addSubview:pzTitle];
    
    height+=40;
    
    self.imgBtn1=[[UIButton alloc]initWithFrame:CGRectMake(10, height-10, (kMainScreenWidth-60)/3, 70)];
    self.imgBtn1.tag=101;
    self.imgBtn1.layer.masksToBounds = YES;
    self.imgBtn1.layer.cornerRadius = 3;
    self.imgBtn1.layer.borderColor = [UIColor colorWithHexString:@"#CFCFCF" alpha:0.6].CGColor;
    self.imgBtn1.layer.borderWidth = 1;
    [self.imgBtn1 setImage:[UIImage imageNamed:@"ic_add.png"] forState:UIControlStateNormal];
    [self.imgBtn1 addTarget:self action:@selector(clickImgBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.theScrollView addSubview:self.imgBtn1];
    
    self.imgBtn2=[[UIButton alloc]initWithFrame:CGRectMake(30+(kMainScreenWidth-60)/3, height-10, (kMainScreenWidth-60)/3, 70)];
    self.imgBtn2.tag=102;
    self.imgBtn2.layer.masksToBounds = YES;
    self.imgBtn2.layer.cornerRadius = 3;
    self.imgBtn2.layer.borderColor = [UIColor colorWithHexString:@"#CFCFCF" alpha:0.6].CGColor;
    self.imgBtn2.layer.borderWidth = 1;
    [self.imgBtn2 setImage:[UIImage imageNamed:@"ic_add.png"] forState:UIControlStateNormal];
    [self.imgBtn2 addTarget:self action:@selector(clickImgBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.theScrollView addSubview:self.imgBtn2];
    
    self.imgBtn3=[[UIButton alloc]initWithFrame:CGRectMake(50+(kMainScreenWidth-60)/3*2, height-10, (kMainScreenWidth-60)/3, 70)];
    self.imgBtn3.tag=103;
    self.imgBtn3.layer.masksToBounds = YES;
    self.imgBtn3.layer.cornerRadius = 3;
    self.imgBtn3.layer.borderColor = [UIColor colorWithHexString:@"#CFCFCF" alpha:0.6].CGColor;
    self.imgBtn3.layer.borderWidth = 1;
    [self.imgBtn3 setImage:[UIImage imageNamed:@"ic_add.png"] forState:UIControlStateNormal];
    [self.imgBtn3 addTarget:self action:@selector(clickImgBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.theScrollView addSubview:self.imgBtn3];
    
    height+=80;
    
    
    UILabel *tishiTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, height, 100, 20)];
    tishiTitle.font=[UIFont systemFontOfSize:16];
    tishiTitle.textAlignment=NSTextAlignmentLeft;
    tishiTitle.text=@"温馨提示：";
    [self.theScrollView addSubview:tishiTitle];
    
    height+=25;
    
    CGSize size=[util calHeightForLabel:@"如商品存在质量问题或长时间未发货，请联系卖家协商处理或退款，服务商同意退款后，退款金额会在7～15天到账，如需帮助可联系客服。" width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:13]];
    NSMutableAttributedString *contentstr =[[NSMutableAttributedString alloc] initWithString:@"如商品存在质量问题或长时间未发货，请联系卖家协商处理或退款，服务商同意退款后，退款金额会在7～15天到账，如需帮助可联系客服。"];
    [contentstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,45)];
    [contentstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(45,4)];
    [contentstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(49,contentstr.length-49)];
    UILabel *tishiValue=[[UILabel alloc]initWithFrame:CGRectMake(10, height, kMainScreenWidth-20, size.height)];
//    tishiValue.textColor=[UIColor grayColor];
    tishiValue.font=[UIFont systemFontOfSize:13];
    tishiValue.textAlignment=NSTextAlignmentLeft;
    tishiValue.numberOfLines=0;
    tishiValue.attributedText =contentstr;
    [self.theScrollView addSubview:tishiValue];
    
    height+=size.height+30;
    
    self.applyRefundBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, height-10, kMainScreenWidth-20, 40)];
    self.applyRefundBtn.backgroundColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    [self.applyRefundBtn setTitle:@"申请退款" forState:UIControlStateNormal];
    [self.applyRefundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.applyRefundBtn.layer.masksToBounds = YES;
    self.applyRefundBtn.layer.cornerRadius = 5;
    self.applyRefundBtn.layer.borderColor = [UIColor colorWithHexString:@"#EF6562" alpha:1.0].CGColor;
    self.applyRefundBtn.layer.borderWidth = 1;
    [self.applyRefundBtn addTarget:self action:@selector(clickApplyRefundBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.theScrollView addSubview:self.applyRefundBtn];
    
    height+=50;
    
    self.theScrollView.contentSize=CGSizeMake(kMainScreenWidth, height);
    
    //导航右按钮
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 90, 40)];
    [rightButton setImage:[UIImage imageNamed:@"btn_dianhua"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 25, 0, -5);
    [rightButton addTarget:self
                    action:@selector(clickTelBtn:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setFrame:CGRectMake(5, 5, 40, 40)];
//    [rightButton setImage:[UIImage imageNamed:@"ico_kefu"] forState:UIControlStateNormal];
//    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [rightButton addTarget:self
//                    action:@selector(clickTelBtn:)
//          forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
//    [self requestCallNum];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickImgBtn:(UIButton *)sender {
    if (sender.tag == 101) {
        if(_imageFile1) {
            ImageZoomView *zoomView = [[ImageZoomView alloc] initWithView:self.view.window Images:_photo1];
            [zoomView show];
            return;
        }
        else _photoTypes = kPHOTO1;
    } else if (sender.tag == 102) {
        if(_imageFile2) {
            ImageZoomView *zoomView = [[ImageZoomView alloc] initWithView:self.view.window Images:_photo2];
            [zoomView show];
            return;
        }
        else _photoTypes = kPHOTO2;
    } else if (sender.tag == 103) {
        if(_imageFile3) {
            ImageZoomView *zoomView = [[ImageZoomView alloc] initWithView:self.view.window Images:_photo3];
            [zoomView show];
            return;
        }
        else _photoTypes = kPHOTO3;
    } else if (sender.tag == 104) {
        _photoTypes = kPHOTO4;
    } else {
        _photoTypes = kPHOTO5;
    }
    UIActionSheet *choosePhotoActionSheet;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"拍照", @""), NSLocalizedString(@"从相册选择", @""), nil];
    } else {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"从相册选择", @""), nil];
    }
    
    [choosePhotoActionSheet showInView:self.view];
    
    //    [choosePhotoActionSheet showInView:[UIApplication sharedApplication].keyWindow];//当有tabbar时用此方法，以解决cancel按钮底部无响应 huangrun
    //    choosePhotoActionSheet.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-choosePhotoActionSheet.frame.size.height, [UIScreen mainScreen].bounds.size.width, choosePhotoActionSheet.frame.size.height);
    //    //解决iOS7中sheet显示错乱的问题 huangrun
    
    
}



- (void)clickTelBtn:(id)sender {
//    if (_callNum) {
        NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",callNumber];
        UIWebView *callWebview = [[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
        [self.view addSubview:callWebview];
//    } else {
//        [self requestCallNum];
//    }
}

- (BOOL)verifyItems {
    if ([NSString isEmptyOrWhitespace:self.reasonTV.text]) {
        [TLToast showWithText:@"请输入退款原因"];
        return NO;
    } else if (self.reasonTV.text.length > 200) {
        [TLToast showWithText:@"输入内容最多200个字符"];
        return NO;
    } else if ([NSString isEmptyOrWhitespace:self.moneyTF.text]) {
        [TLToast showWithText:@"请输入退款金额"];
        return NO;
    } else if ([self.moneyTF.text floatValue] > [self.goodsTotalMoneyStr floatValue]) {
        [TLToast showWithText:@"退款金额超限"];
        return NO;
    }else if ([self.moneyTF.text floatValue]<=0){
        [TLToast showWithText:@"退款金额不能为0或负数"];
        return NO;
    }
    return YES;
}

- (void)clickApplyRefundBtn:(id)sender {
    if ([self verifyItems]) {
        [self requestApplyRefund];
    }
}

#pragma mark - 申请退款
-(void)requestApplyRefund {
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
    [postDict setObject:@"ID0209" forKey:@"cmdID"];
    [postDict setObject:string_token forKey:@"token"];
    [postDict setObject:string_userid forKey:@"userID"];
    [postDict setObject:@"ios" forKey:@"deviceType"];
    [postDict setObject:kCityCode forKey:@"cityCode"];
    
    NSString *string=[postDict JSONString];
    
    NSString *moneyStr = [NSString stringWithFormat:@"%.2f",[self.moneyTF.text floatValue]];
    
    NSString *typeStr;
    if (self.typeBtn1.selected) {
        typeStr = @"1";
    } else if (self.typeBtn2.selected) {
        typeStr = @"2";
    }
    NSDictionary *bodyDic = @{@"orderId":self.orderIdStr,
                              @"reason":self.reasonTV.text,
                              @"refundMoney":moneyStr,
                              @"orderDetailId":self.shopOrderDetailStr,
                              @"goodsId":self.shopGoodsDetailIdStr,
                              @"refundType":typeStr,
                              @"goodsTotalMoney":self.goodsTotalMoneyStr,
                              @"shopId":self.shopIdStr
                              };
    
    //    NSData *imageDat1;
    //    NSData *imageDat2;
    //    NSData *imageDat3;
    //
    //    if (_photo1) {
    //        imageDat1 = UIImageJPEGRepresentation(_photo1, 0.5);
    //    }
    //    if (_photo2) {
    //        imageDat2 = UIImageJPEGRepresentation(_photo2, 0.5);
    //    }
    //    if (_photo3) {
    //        imageDat3 = UIImageJPEGRepresentation(_photo3, 0.5);
    //    }
    
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: url]];
    
    NSString *string02=[bodyDic JSONString];
    [request setPostValue:string forKey:@"header"];
    [request setPostValue:string02 forKey:@"body"];
    if (_imageFile1)
        [request addFile: _imageFile1 forKey: @"filedata"];
    if (_imageFile2)
        [request addFile: _imageFile2 forKey: @"filedata"];
    if (_imageFile3)
        [request addFile: _imageFile3 forKey: @"filedata"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request startAsynchronous];
    [self startRequestWithString:@"加载中..."];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = sourceType;
    [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];//用self来present会导致进度导航条消失 huangrun
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    if (_photoTypes == kPHOTO1) {
        [self.imgBtn1 setImage:nil forState:UIControlStateNormal];
        self.photo1 = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.imgBtn1 setBackgroundImage:_photo1 forState:UIControlStateNormal];
        _imgDeleteBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        CGPoint origin = self.imgBtn1.frame.origin;
        CGSize size = self.imgBtn1.frame.size;
        _imgDeleteBtn1.frame = CGRectMake(origin.x + size.width - 10, origin.y - 10, 20, 20);
        [_imgDeleteBtn1 setImage:[UIImage imageNamed:@"ic_jian.png"] forState:UIControlStateNormal];
        _imgDeleteBtn1.tag = 101;
        [_imgDeleteBtn1 addTarget:self action:@selector(clickImgDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.theScrollView addSubview:_imgDeleteBtn1];
        
        //照片保存
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        BOOL success;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        if ([mediaType isEqualToString:@"public.image"]){
            
            //            UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            
            NSLog(@"found an image");
            
            _imageFile1 = [documentsDirectory stringByAppendingPathComponent:@"temp1.jpg"];
            
            ;    NSLog(@"%@",_imageFile1);
            
            success = [fileManager fileExistsAtPath:_imageFile1];
            
            if(success) {
                
                success = [fileManager removeItemAtPath:_imageFile1 error:&error];
                
            }
            
            [UIImageJPEGRepresentation(image, 0.1f) writeToFile:_imageFile1 atomically:YES];
        }
    } else if (_photoTypes == kPHOTO2) {
        [self.imgBtn2 setImage:nil forState:UIControlStateNormal];
        self.photo2 = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.imgBtn2 setBackgroundImage:_photo2 forState:UIControlStateNormal];
        _imgDeleteBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        CGPoint origin = self.imgBtn2.frame.origin;
        CGSize size = self.imgBtn2.frame.size;
        _imgDeleteBtn2.frame = CGRectMake(origin.x + size.width - 10, origin.y - 10, 20, 20);
        [_imgDeleteBtn2 setImage:[UIImage imageNamed:@"ic_jian.png"] forState:UIControlStateNormal];
        _imgDeleteBtn2.tag = 102;
        [_imgDeleteBtn2 addTarget:self action:@selector(clickImgDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.theScrollView addSubview:_imgDeleteBtn2];
        
        //照片保存
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        BOOL success;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        if ([mediaType isEqualToString:@"public.image"]){
            
            //            UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            
            NSLog(@"found an image");
            
            _imageFile2 = [documentsDirectory stringByAppendingPathComponent:@"temp2.jpg"];
            
            ;    NSLog(@"%@",_imageFile2);
            
            success = [fileManager fileExistsAtPath:_imageFile2];
            
            if(success) {
                
                success = [fileManager removeItemAtPath:_imageFile2 error:&error];
                
            }
            
            [UIImageJPEGRepresentation(image, 0.1f) writeToFile:_imageFile2 atomically:YES];
        }
        
    } else if (_photoTypes == kPHOTO3) {
        [self.imgBtn3 setImage:nil forState:UIControlStateNormal];
        self.photo3 = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.imgBtn3 setBackgroundImage:_photo3 forState:UIControlStateNormal];
        _imgDeleteBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        CGPoint origin = self.imgBtn3.frame.origin;
        CGSize size = self.imgBtn3.frame.size;
        _imgDeleteBtn3.frame = CGRectMake(origin.x + size.width - 10, origin.y - 10, 20, 20);
        [_imgDeleteBtn3 setImage:[UIImage imageNamed:@"ic_jian.png"] forState:UIControlStateNormal];
        _imgDeleteBtn3.tag = 103;
        [_imgDeleteBtn3 addTarget:self action:@selector(clickImgDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.theScrollView addSubview:_imgDeleteBtn3];
        
        //照片保存
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        BOOL success;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        if ([mediaType isEqualToString:@"public.image"]){
            
            //            UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            
            NSLog(@"found an image");
            
            _imageFile3 = [documentsDirectory stringByAppendingPathComponent:@"temp3.jpg"];
            
            ;    NSLog(@"%@",_imageFile3);
            
            success = [fileManager fileExistsAtPath:_imageFile3];
            
            if(success) {
                
                success = [fileManager removeItemAtPath:_imageFile3 error:&error];
                
            }
            
            [UIImageJPEGRepresentation(image, 0.1f) writeToFile:_imageFile3 atomically:YES];
        }
        
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark -ASIHTTPRequestDelegate

- (void)requestFailed:(ASIHTTPRequest *)request {
    [self stopRequest];
    customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    customPromp.contenttxt =@"操作失败";
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
    [customPromp addGestureRecognizer:tap];
    [customPromp show];
//    [TLToast showWithText:@"操作失败"];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self stopRequest];
    NSString *respString = [request responseString];
    NSDictionary *jsonDict = [respString objectFromJSONString];
    if ([[jsonDict objectForKey:@"resCode"]integerValue] == 102091) {
        [TLToast showWithText:@"申请退款成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNCUpdateRefundStatus object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNCUpdateOrderStatus object:nil];
        NSArray * ctrlArray = self.navigationController.viewControllers;
        if ([self.sourceVCStr isEqualToString:@"detailVC"]) {
            [self.navigationController popToViewController:[ctrlArray objectAtIndex:1] animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else  {
        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        customPromp.contenttxt =@"申请退款失败";
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        [customPromp addGestureRecognizer:tap];
        [customPromp show];
//        [TLToast showWithText:@"申请退款失败"];
    }
    
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

- (void)clickImgDeleteBtn:(UIButton *)btn {
    if (btn.tag == 101) {
        [self.imgBtn1 setImage:[UIImage imageNamed:@"ic_add.png"] forState:UIControlStateNormal];
        [self.imgBtn1 setBackgroundImage:nil forState:UIControlStateNormal];
        [_imgDeleteBtn1 removeFromSuperview];
        
        BOOL success;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        _imageFile1 = [documentsDirectory stringByAppendingPathComponent:@"temp1.jpg"];
        
        ;    NSLog(@"%@",_imageFile1);
        
        success = [fileManager fileExistsAtPath:_imageFile1];
        
        if(success) {
            
            success = [fileManager removeItemAtPath:_imageFile1 error:&error];
            _imageFile1 = nil;
            
        }
        
    } else if (btn.tag == 102) {
        [self.imgBtn2 setImage:[UIImage imageNamed:@"ic_add.png"] forState:UIControlStateNormal];
        [self.imgBtn2 setBackgroundImage:nil forState:UIControlStateNormal];
        [_imgDeleteBtn2 removeFromSuperview];
        
        BOOL success;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        _imageFile2 = [documentsDirectory stringByAppendingPathComponent:@"temp2.jpg"];
        
        ;    NSLog(@"%@",_imageFile2);
        
        success = [fileManager fileExistsAtPath:_imageFile2];
        
        if(success) {
            
            success = [fileManager removeItemAtPath:_imageFile2 error:&error];
            _imageFile2 = nil;
            
        }
        
    } else {
        [self.imgBtn3 setImage:[UIImage imageNamed:@"ic_add.png"] forState:UIControlStateNormal];
        [self.imgBtn3 setBackgroundImage:nil forState:UIControlStateNormal];
        [_imgDeleteBtn3 removeFromSuperview];
        
        BOOL success;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        _imageFile3 = [documentsDirectory stringByAppendingPathComponent:@"temp3.jpg"];
        
        ;    NSLog(@"%@",_imageFile3);
        
        success = [fileManager fileExistsAtPath:_imageFile3];
        
        if(success) {
            
            success = [fileManager removeItemAtPath:_imageFile3 error:&error];
            _imageFile3 = nil;
            
        }
        
    }
}


- (void)clickTypeBtn1:(UIButton *)sender {
    sender.selected = YES;
    self.typeBtn2.selected = NO;
}

- (void)clickTypeBtn2:(UIButton *)sender {
    sender.selected = YES;
    self.typeBtn1.selected = NO;
}

#pragma mark -
#pragma mark - UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _uilabel.text = @"最多200字";
    }else{
        _uilabel.text = @"";
    }
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
