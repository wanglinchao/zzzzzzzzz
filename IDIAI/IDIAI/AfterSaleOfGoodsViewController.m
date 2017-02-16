//
//  AfterSaleOfGoodsViewController.m
//  IDIAI
//
//  Created by Ricky on 15/5/6.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "AfterSaleOfGoodsViewController.h"
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

@interface AfterSaleOfGoodsViewController ()<UITextViewDelegate> {
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

@implementation AfterSaleOfGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"售后维修";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:[UIColor colorWithHexString:@"#CFCFCF" alpha:0.5]];
    
    self.theScrollView.backgroundColor=[UIColor whiteColor];
    
    _uilabel=[[UILabel alloc]initWithFrame:CGRectMake(17, 53, 150, 20)];
    _uilabel.text =@"最多200字";
    _uilabel.font=[UIFont systemFontOfSize:15];
    _uilabel.enabled = NO;//lable必须设置为不可用
    _uilabel.textAlignment=NSTextAlignmentLeft;
    _uilabel.textColor=[UIColor lightGrayColor];
    _uilabel.backgroundColor = [UIColor clearColor];
    [self.theScrollView addSubview:_uilabel];
    
    self.reasonTV.delegate=self;
    self.reasonTV.layer.cornerRadius = 5;
    self.reasonTV.layer.borderColor = [UIColor colorWithHexString:@"#CFCFCF" alpha:0.6].CGColor;
    self.reasonTV.layer.borderWidth = 1.0;
    self.reasonTV.layer.masksToBounds = YES;
    self.reasonTV.font=[UIFont systemFontOfSize:15];
    
    self.imgBtn1.layer.masksToBounds = YES;
    self.imgBtn1.layer.cornerRadius = 3;
    self.imgBtn1.layer.borderColor = [UIColor colorWithHexString:@"#CFCFCF" alpha:0.6].CGColor;
    self.imgBtn1.layer.borderWidth = 1;
    
    self.imgBtn2.layer.masksToBounds = YES;
    self.imgBtn2.layer.cornerRadius = 3;
    self.imgBtn2.layer.borderColor = [UIColor colorWithHexString:@"#CFCFCF" alpha:0.6].CGColor;
    self.imgBtn2.layer.borderWidth = 1;
    
    self.imgBtn3.layer.masksToBounds = YES;
    self.imgBtn3.layer.cornerRadius = 3;
    self.imgBtn3.layer.borderColor = [UIColor colorWithHexString:@"#CFCFCF" alpha:0.6].CGColor;
    self.imgBtn3.layer.borderWidth = 1;
    
    self.applyBtn.backgroundColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    self.applyBtn.layer.masksToBounds = YES;
    self.applyBtn.layer.cornerRadius = 5;
    self.applyBtn.layer.borderColor = [UIColor colorWithHexString:@"#EF6562" alpha:1.0].CGColor;
    self.applyBtn.layer.borderWidth = 1;
    
    self.Line.backgroundColor=[UIColor colorWithHexString:@"#CFCFCF" alpha:0.3];
    
//    [self requestCallNum];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickImgBtn:(UIButton *)sender {
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
        [TLToast showWithText:@"请输入售后原因"];
        return NO;
    } else if (self.reasonTV.text.length > 200) {
        [TLToast showWithText:@"输入内容最多200个字符"];
        return NO;
    }
    
    return YES;
}

- (IBAction)clickApplyBtn:(id)sender {
    if ([self verifyItems]) {
        [self requestApplyAfterSale];
    }
}

#pragma mark - 申请售后
-(void)requestApplyAfterSale {
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
    [postDict setObject:@"ID0208" forKey:@"cmdID"];
    [postDict setObject:string_token forKey:@"token"];
    [postDict setObject:string_userid forKey:@"userID"];
    [postDict setObject:@"ios" forKey:@"deviceType"];
    [postDict setObject:kCityCode forKey:@"cityCode"];
    
    NSString *string=[postDict JSONString];
    NSDictionary *bodyDic = @{@"orderId":self.orderIdStr,
                              @"reason":self.reasonTV.text,
                              @"orderDetailId":self.shopOrderDetailStr,
                              @"shopId":self.shopIdStr,
                              @"goodsId":self.goodsid
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
    if ([[jsonDict objectForKey:@"resCode"]integerValue] == 102081) {
        [TLToast showWithText:@"申请售后成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        customPromp.contenttxt =@"申请售后失败";
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        [customPromp addGestureRecognizer:tap];
        [customPromp show];
//        [TLToast showWithText:@"申请售后失败"];
    }
    
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
@end
