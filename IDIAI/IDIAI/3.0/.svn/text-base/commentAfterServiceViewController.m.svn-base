//
//  commentAfterServiceViewController.m
//  IDIAI
//
//  Created by PM on 16/8/9.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//


#import "commentAfterServiceViewController.h"
#import "IDIAI3ConfirmPaymentViewController.h"
#import "SWAddPhotoView.h"
#import "QBImagePickerController.h"
#import "SWShareImageDetailViewController.h"
#import "TLToast.h"
#define TextViewHeight 150
#define ImageRowHeight 98
@interface commentAfterServiceViewController ()<UITableViewDataSource,UITableViewDelegate,SWAddPhotoViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,QBImagePickerControllerDelegate>
@property(nonatomic,strong)NSMutableArray * addImages;
@property(nonatomic,strong)UITextField *passWord;
@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,strong)SWAddPhotoView * addPhotoView;
@property(nonatomic,assign)NSInteger photocount;//剩余可添加图片数量
@property(nonatomic,strong)UILabel * placeholderLab;
@property(nonatomic,strong)UILabel *titlelbl2;
@end

@implementation commentAfterServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }

    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    self.tableView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.tableView addGestureRecognizer:tap];
     self.addImages =[NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)hideKeyBoard{
    
    [self.passWord resignFirstResponder];
    [self.textView resignFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        //        NSString *contentstr =@"亲，恭喜您的本项服务已顺利完成，请根据您的装修体验，对本次服务如实评审，您的评审结果，有助于屋托邦对服务提供方的检验考核，去行使您的权利吧：";
        //        CGSize labelSize = {0, 0};
        //        labelSize = [contentstr sizeWithFont:[UIFont systemFontOfSize:12]
        //                            constrainedToSize:CGSizeMake(kMainScreenWidth-40, 2000)
        //                                lineBreakMode:UILineBreakModeWordWrap];
        if (self.addPhotoView.photos.count==3) {
            return self.addPhotoView.frame.size.height+192-ImageRowHeight;
        }
        return self.addPhotoView.frame.size.height+192;
    }else{
    
        return 43;
    }

}
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 5;
    }
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier1 =@"CELL1";
    static NSString * identifier2 =@"CELL2";
    UITableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
    UITableViewCell * cell2 = [tableView dequeueReusableCellWithIdentifier:identifier2];
    if (!cell1) {
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
    }
    if (!cell2) {
        cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
    }
    if (indexPath.section==0) {
                 UIView * topGapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 11)];
                 topGapView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
                 [cell1.contentView addSubview:topGapView];

            if (!_titlelbl2) {
                _titlelbl2 =[[UILabel alloc] initWithFrame:CGRectMake(15,21, kMainScreenWidth-40, 17)];
                _titlelbl2.textColor =[UIColor colorWithHexString:@"#575757"];
                _titlelbl2.backgroundColor= [UIColor whiteColor];
                _titlelbl2.text =@"我要评";
                _titlelbl2.font =[UIFont systemFontOfSize:17.0];
                [cell1.contentView addSubview:_titlelbl2];
            }
            
            if (!self.textView) {
                self.textView = [[UITextView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(_titlelbl2.frame)+10, kMainScreenWidth-40, TextViewHeight )];
                self.textView.textColor=[UIColor darkGrayColor];
                self.textView.font =[UIFont systemFontOfSize:15];
                self.textView.delegate =self;
                self.textView.layer.borderWidth = 1;
                self.textView.layer.cornerRadius = 3;
                self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                [cell1.contentView addSubview:self.textView];
            }
            
            
            if (!self.placeholderLab) {
                self.placeholderLab = [[UILabel alloc]initWithFrame:CGRectMake(5,0,CGRectGetWidth(self.textView.frame)-20,40)];
                self.placeholderLab.text=@"评论内容请控制在200个汉字以内";
                
                self.placeholderLab.font =[UIFont systemFontOfSize:17];
                self.placeholderLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
                [self.textView addSubview:self.placeholderLab];
            }
            
            if (!self.addPhotoView) {
                self.addPhotoView =[[SWAddPhotoView alloc] initWithFrame: CGRectMake(15,CGRectGetMaxY(self.textView.frame)+15, kMainScreenWidth-40, 0)];
                self.addPhotoView.delegate =self;
                self.addPhotoView.photocount =3;
                self.addPhotoView.photos =[NSMutableArray array];
                [cell1.contentView addSubview:self.addPhotoView];
            }
            
            cell1.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell1;
        
    }else{
              UIButton *completebtn =[UIButton buttonWithType:UIButtonTypeCustom];
            completebtn.frame =CGRectMake(11,1.5, kMainScreenWidth-22, 40);
            [completebtn setBackgroundColor:kThemeColor];
            completebtn.layer.cornerRadius = 5;
            completebtn.layer.masksToBounds = YES;
            [completebtn addTarget:self action:@selector(commentAfterPay:) forControlEvents:UIControlEventTouchUpInside];
            [completebtn setTitle:@"提交" forState:UIControlStateNormal];
            [cell2.contentView addSubview:completebtn];
            cell2.backgroundColor =[UIColor clearColor];

        
    }
    cell2.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell2;
    
}

-(void)commentAfterPay:(UIButton*)sender{
     sender.enabled=NO;
    [self startMBProgressHUDWithString:nil];
    NSString * url = [NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:self.phaseOrderCode forKey:@"phaseOrderCode"];
    [bodyDic setObject:self.textView.text forKey:@"objContent"];
    
    
    [self.addImages removeAllObjects];
    
    if (self.addPhotoView.photos.count==0) {
        self.addImages =nil;
    }else{
        for (id photo in self.addPhotoView.photos)
            if ([photo isKindOfClass:[UIImage class]]) {
                NSData *data1 = UIImageJPEGRepresentation(photo,0.01);
                NSLog(@"%d",(int)data1.length);
                //                UIImage  * photo1  = [UIImage imageWithData:data1];
                [self.addImages addObject:photo];
            }
    }
    NSLog(@"===========%@",self.addImages);
    __weak typeof(self) weakself =self;
     [self sendRequestImagesToServerUrl:^(id responseObject) {
         [self stopMBProgressHUD];
         sender.enabled = YES;
         [weakself performSelector:@selector(handleAfterCommittingCommentInfoSuccess:) withObject:responseObject afterDelay:0.5];
         
     } failedBlock:^(id responseObject) {
         [weakself stopMBProgressHUD];
         [util showError:responseObject];
         sender.enabled=YES;
         
         
     } RequestUrl:url CmdID:@"ID0373" PostDict:bodyDic PostImages:self.addImages UploadImageKey:@"filedata" Progress:YES];



}
-(void)handleAfterCommittingCommentInfoSuccess:(id)responseObject{
    
    if (kResCode1==103371) {
        [TLToast showWithText:@"评论成功"];
        NSArray * viewControllers = self.navigationController.viewControllers;
        if ([[viewControllers objectAtIndex:viewControllers.count-2] isKindOfClass:[IDIAI3ConfirmPaymentViewController class]]) {
            [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-3]  animated:YES];
        }
    }else if(kResCode1==103379){
        [TLToast showWithText:@"操作失败"];
    
    }


}

#pragma mark addPhotoViewDelegate

-(void)addPhotoCount:(NSInteger)count
{
    
    [self hideKeyBoard];
    self.photocount =count;
    UIActionSheet *action =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    action.actionSheetStyle =UIActionSheetStyleBlackTranslucent;
    [action showInView:self.view];
    
    
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            if (self.photocount ==0) {//?
                [TLToast showWithText:@"最多允许上传3张图片"];
                return;
            }
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            //指定源类型前，检查图片源是否可用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                //指定源的类型
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
                imagePicker.allowsEditing = YES;
                
                //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
                imagePicker.delegate = self;
                
                //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
                imagePicker.allowsEditing = YES;
                
                //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
                imagePicker.delegate = self;
                
                //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
            break;
        case 1:
        {
            if (self.photocount ==0) {//?
                [TLToast showWithText:@"最多允许上传3张图片"];
                return;
            }
            QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = YES;
            
            imagePickerController.limitsMaximumNumberOfSelection = YES;
            imagePickerController.maximumNumberOfSelection = self.photocount;
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
            [self presentViewController:navigationController animated:YES completion:nil];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 删除图片
-(void)detelePhotoCount:(NSInteger)count
{
    SWShareImageDetailViewController *sharedetail =[[SWShareImageDetailViewController alloc] init];
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:sharedetail];
    NSMutableArray *photosArray =[[NSMutableArray alloc] init];
    [photosArray addObjectsFromArray:[self.addPhotoView.photos copy]];
    sharedetail.photos =photosArray;
    sharedetail.index =(int)count-100;
    __weak  typeof(self) weakself =self;
    sharedetail.selectDone =^(NSMutableArray *photosArray){
        
        [weakself.addPhotoView setPhotos:photosArray];
        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    };
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}


#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    
    
    if ([imagePickerController isKindOfClass:[QBImagePickerController class]]) {
        if(imagePickerController.allowsMultipleSelection) {
            NSMutableArray *images =[NSMutableArray array];
            for (NSDictionary *dic in info) {
                UIImage *image =[dic objectForKey:@"UIImagePickerControllerOriginalImage"];
                NSData *origImageData = UIImageJPEGRepresentation(image, 1.0);
                for (int i=0; i<1; i++) {
                    if ([origImageData length] <= 4*1024*1024) {
                        image =[UIImage imageWithData:origImageData];
                        [images addObject:image];
                    }else {
                        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                        origImageData =imageData;
                        i--;
                    }
                }
            }
            [self.addPhotoView addImages:images];
        }
    }else{
        NSMutableArray *images =[NSMutableArray array];
        UIImage *image =[info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *origImageData = UIImageJPEGRepresentation(image, 1.0);
        for (int i=0; i<1; i++) {
            if ([origImageData length] <= 4*1024*1024) {
                image =[UIImage imageWithData:origImageData];
                [images addObject:image];
            }else {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                origImageData =imageData;
                i--;
            }
        }
        [self.addPhotoView addImages:images];
    }
    
    CATransition *animation = [CATransition animation];
    animation.duration = .3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    [imagePickerController.view.window.layer addAnimation:animation forKey:nil];
    __weak  typeof(self) weakself =self;
    [imagePickerController dismissViewControllerAnimated:NO completion:^{
        UISegmentedControl *segment =(UISegmentedControl *)[weakself.navigationController.navigationBar viewWithTag:100];
        segment.hidden =YES;
        
        [segment removeFromSuperview];
    }];
    //    [imagePickerController dismissViewControllerAnimated:YES completion:^{
    //        UISegmentedControl *segment =(UISegmentedControl *)[self.navigationController.navigationBar viewWithTag:100];
    //        segment.hidden =YES;
    //
    //
    //                [segment removeFromSuperview];
    //    }];
    
    [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    CATransition *animation = [CATransition animation];
    animation.duration = .3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [imagePickerController.view.window.layer addAnimation:animation forKey:nil];
    __weak  typeof(self) weakself =self;
    [imagePickerController dismissViewControllerAnimated:NO completion:^{
        UISegmentedControl *segment =(UISegmentedControl *)[weakself.navigationController.navigationBar viewWithTag:100];
        segment.hidden =YES;
        
        [segment removeFromSuperview];
    }];
    
    //    [imagePickerController dismissViewControllerAnimated:YES completion:^{
    //        UISegmentedControl *segment =(UISegmentedControl *)[self.navigationController.navigationBar viewWithTag:100];
    //        segment.hidden =YES;
    //        //        [segment removeFromSuperview];
    //    }];
    
}


- (NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"";
}

- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"";
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    return [NSString stringWithFormat:@"图片%lu张", (unsigned long)numberOfPhotos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"视频%lu", (unsigned long)numberOfVideos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"图片%lu 视频%lu", (unsigned long)numberOfPhotos, (unsigned long)numberOfVideos];
}

-(void)backpopView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length==0) {
        self.placeholderLab.hidden = NO;
    }else{
        self.placeholderLab.hidden = YES;
        
    }
    if (textView.text.length>200) {
        [self.textView endEditing:YES];
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
