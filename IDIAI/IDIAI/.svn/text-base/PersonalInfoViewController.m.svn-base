//
//  PersonalInfoViewController.m
//  IDIAI
//
//  Created by Ricky on 14-11-27.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "UIImageView+OnlineImage.h"
#import "TPKeyboardAvoidingTableView.h"
#import "TLToast.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+fixOrientation.h"
#import "WritePersonalDataVC.h"
#import "IDIAIAppDelegate.h"
#import "util.h"
#import "CustomProvinceCApicker.h"
#import "savelogObj.h"
#import "UIImageView+WebCache.h"
#import "UIImage+fixOrientation.h"
#define ORIGINAL_MAX_WIDTH 640.0f

@interface PersonalInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CustomProvinceCApickerDelegate> {
    TPKeyboardAvoidingTableView *_theTableView;
   
    
}
@property (nonatomic,strong) UIImage *image;

@end


@implementation PersonalInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    
    if (self.isHomePage ==YES) {
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
        
        [appDelegate.nav setNavigationBarHidden:NO animated:NO];
        [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
        
        
        //修改navBar字体大小文字颜色
        NSDictionary *attris = @{ NSFontAttributeName:[UIFont systemFontOfSize:19],
                                  NSForegroundColorAttributeName:[UIColor blackColor] };
        [self.navigationController.navigationBar setTitleTextAttributes:attris];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [_theTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帐号信息";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    _theTableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:kTableViewWithoutTabBarFrame];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    [self.view addSubview:_theTableView];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 100)];
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    logoutBtn.frame = CGRectMake(10, 28, kMainScreenWidth - 20, 44);
    logoutBtn.layer.cornerRadius = 6;
    [logoutBtn setTitle:@"保存" forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutBtn.backgroundColor = kThemeColor;
    [logoutBtn addTarget:self action:@selector(savePersonalInfo:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kMainScreenWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
    [footerView addSubview:lineView];
    
    _theTableView.tableFooterView = footerView;
    
    _headIV = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth - 100, 11.5, 65, 65)];
    _nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, kMainScreenWidth - 80 - 30 - 20, 44)];
    _nicknameLabel.text = @"填写你的昵称";
    _nicknameLabel.textColor = kFontPlacehoderColor;
    _nicknameLabel.textAlignment = NSTextAlignmentRight;
    _maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       [_maleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _maleBtn.frame = CGRectMake(kMainScreenWidth - 100, 10, 35, 25);
    [_maleBtn setBackgroundImage:[UIImage imageNamed:@"bg_sz_nor"] forState:UIControlStateNormal];
    [_maleBtn setBackgroundImage:[UIImage imageNamed:@"bg_sz"] forState:UIControlStateSelected];
    [_maleBtn setTitle:@"男" forState:UIControlStateNormal];
    [_maleBtn setTitleColor:kFontPlacehoderColor forState:UIControlStateNormal];
    [_maleBtn addTarget:self action:@selector(clickMaleBtn:) forControlEvents:UIControlEventTouchUpInside];
    _femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _femaleBtn.frame = CGRectMake(kMainScreenWidth - 50, 10, 35, 25);
    [_femaleBtn setBackgroundImage:[UIImage imageNamed:@"bg_sz_nor"] forState:UIControlStateNormal];
    [_femaleBtn setBackgroundImage:[UIImage imageNamed:@"bg_sz"] forState:UIControlStateSelected];
    [_femaleBtn setTitle:@"女" forState:UIControlStateNormal];
    [_femaleBtn setTitleColor:kFontPlacehoderColor forState:UIControlStateNormal];
    [_femaleBtn addTarget:self action:@selector(clickFemaleBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:User_sex]isEqualToString:@"女"]) {
//            _femaleBtn.selected = YES;
//            _maleBtn.selected = NO;
//         
//        } else {
//            _maleBtn.selected = YES;
//            _femaleBtn.selected = NO;
//    }
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_sex] length]>=1) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:User_sex]isEqualToString:@"女"]) {
            _femaleBtn.selected = YES;
            [_femaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _maleBtn.selected = NO;
        } else {
            _maleBtn.selected = YES;
            [_maleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _femaleBtn.selected = NO;
        }
    } else {
            _maleBtn.selected = YES;
        [_maleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _femaleBtn.selected = NO;
    }
    
    _districtLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, kMainScreenWidth - 80 - 20 - 30, 44)];
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:kUDUserDistrict]) {
//        _districtLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:kUDUserDistrict];
////        _districtLabel.textColor = [UIColor darkTextColor];
//    } else {
//    _districtLabel.text = @"请选择区域";
//    _districtLabel.textColor = kFontPlacehoderColor;
//    }

    _districtLabel.textAlignment = NSTextAlignmentRight;
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 21, kMainScreenWidth - 80 - 20 - 30, 44)];
    _addressLabel.text = @"填写地址";
    _addressLabel.textColor = kFontPlacehoderColor;
    _addressLabel.textAlignment = NSTextAlignmentRight;
    _addressLabel.numberOfLines=0;
    _xiaoquLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, kMainScreenWidth - 80 - 20 - 30, 44)];
    _xiaoquLabel.text = @"填写小区名称";
    _xiaoquLabel.textColor = kFontPlacehoderColor;
    _xiaoquLabel.textAlignment = NSTextAlignmentRight;
    _cellphoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, kMainScreenWidth - 80 - 20 - 30, 44)];
//    _cellphoneLabel.textColor = kFontPlacehoderColor;
    _cellphoneLabel.textAlignment = NSTextAlignmentRight;
    _cellphoneLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:User_Name];
    

    //获取省市区id
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceCode] length]>1) self.provinceCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceCode];
    else self.provinceCode=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_CityCode] length]>1) self.cityCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_CityCode];
    else self.cityCode=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaCode] length]>1) self.areaCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaCode];
    else self.areaCode=@"";
    //获取省市区名字
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceName] length]>0) self.provinceName=[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceName];
    else self.provinceName=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_CityName] length]>0) self.cityName=[[NSUserDefaults standardUserDefaults] objectForKey:User_CityName];
    else self.cityName=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaName] length]>0) self.areaName=[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaName];
    else self.areaName=@"";
    
    if(!arr_Province) arr_Province=[NSMutableArray arrayWithObjects:@[self.provinceName,self.provinceCode],@[self.cityName,self.cityCode],@[self.areaName,self.areaCode],nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.title = @"帐号信息";
}

#pragma mark - tableViewDatasource and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 88;
    }
    else if (indexPath.row == 4) {
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss] length]>=1){
            CGSize size=[util calHeightForLabel:[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss] width:kMainScreenWidth - 80 - 20 - 30 font:[UIFont systemFontOfSize:17]];
            _addressLabel.frame=CGRectMake(100, 15, kMainScreenWidth - 80 - 20 - 30, size.height);
            return size.height+30;
        }
        else
        return 88;
    }
    else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 80, 44)];
        titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.03];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(0, 0, 40, 30);
        titleLabel.center = titleView.center;
        titleLabel.text = @"区域";
        [titleView addSubview:titleLabel];
        return titleView;
    }
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PersionalInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSArray *titleArr = @[@"头    像：",@"昵    称：",@"性    别：",@"省市区：",@"地    址：",@"小区名称：",@"手机号："];
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
//        if([self ReadPhoto]){
//            
//            [_headIV  setImage:[self circleImage:[self ReadPhoto] withParam:1.0]];
//        }
//        else
//            [_headIV  setImage:[UIImage imageNamed:@"ic_me_touxiang"]];
        
        NSString * url = [[NSUserDefaults standardUserDefaults]objectForKey:User_logo];
        
       __weak typeof(self) weaself =self;
            [_headIV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"ic_me_touxiang"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
           if (!imageURL) {
                [_headIV setImage:[weaself circleImage:[UIImage imageNamed:@"ic_me_touxiang"] withParam:1.0]];
           }else {
                [_headIV  setImage:[weaself circleImage:[weaself imageWithImage:image scaledToSize:CGSizeMake(100, 100)] withParam:1.0]];
           }
       }];
       
        [cell.contentView addSubview:_headIV];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 1) {
        
        [cell.contentView addSubview:_nicknameLabel];
        if (self.nickNameIsChanged) {
            _nicknameLabel.text = self.nickName;
                _nicknameLabel.textColor = [UIColor darkTextColor];
        }else {
        
        
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName] length]>=1) {
            _nicknameLabel.text=[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName];
            _nicknameLabel.textColor = [UIColor darkTextColor];
            self.nickName = _nicknameLabel.text;
        } else {
            _nicknameLabel.text=@"填写你的昵称";
            self.nickName =@"";
        }
    }
    

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 2) {
        [cell.contentView addSubview:_maleBtn];
        [cell.contentView addSubview:_femaleBtn];
    } else if (indexPath.row == 3) {
        [cell.contentView addSubview:_districtLabel];
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_ProvinceName] length]>=1){
            if([self.provinceName isEqualToString:self.cityName])
                _districtLabel.text = [NSString stringWithFormat:@"%@%@",self.provinceName,self.areaName];
            else
                _districtLabel.text = [NSString stringWithFormat:@"%@%@%@",self.provinceName,self.cityName,self.areaName];
            _districtLabel.textColor =  [UIColor darkTextColor];;
        }
        else{
        _districtLabel.text = @"请选择区域";
//            self.provinceName =@"";//viewDidLoad 中已经设置了
//            self.cityName =@"";
//            self.areaName = @"";
//            self.provinceCode=@"";
//            self.cityCode =@"";
//            self.areaCode =@"";
        }
    
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    } else if (indexPath.row == 4) {
        [cell.contentView addSubview:_addressLabel];
        if (self.addressIsChanged) {
            _addressLabel.textColor = [UIColor darkTextColor];
            _addressLabel.text = self.address;
        }else {
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss] length]>=1) {
            _addressLabel.text =[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss];
            _addressLabel.textColor = [UIColor darkTextColor];
            self.address  = _addressLabel.text;
        } else {
            _addressLabel.text =@"填写地址";
            self.address =@"";
         }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 5) {
        [cell.contentView addSubview:_xiaoquLabel];
        if (self.xiaoquIsChanged) {
            _xiaoquLabel.textColor = [UIColor darkTextColor];
            _xiaoquLabel.text = self.xiaoQu;
        }else {
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Village] length]>=1) {
            _xiaoquLabel.text =[[NSUserDefaults standardUserDefaults]objectForKey:User_Village];
            _xiaoquLabel.textColor = [UIColor darkTextColor];
            self.xiaoQu = _xiaoquLabel.text;
        } else {
            _xiaoquLabel.text =@"填写小区名称";
            self.xiaoQu =@"";
         }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        [cell.contentView addSubview:_cellphoneLabel];
    }
    
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) {
        [self.view endEditing:YES];
        CustomProvinceCApicker *picker_pro = [[CustomProvinceCApicker alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 250)title:@"选择省市区"];
        picker_pro.delegate=self;
        [picker_pro setSelectedTitles:arr_Province animated:YES];
        [picker_pro show];
        
    } else if (indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        [actionSheet showInView:self.view];
    } else if (indexPath.row == 1) {
//        UITableViewCell *cell=(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        WritePersonalDataVC *writvc=[[WritePersonalDataVC alloc]init];
        writvc.title_main=@"昵称";
        writvc.select_index=indexPath.row;
//        writvc.title_diplay=cell.detailTextLabel.text;
        writvc.title_diplay = _nicknameLabel.text;
        [self.navigationController pushViewController:writvc animated:YES];
    } else if (indexPath.row == 4) {
//        UITableViewCell *cell=(UITableViewCell *)[mtableview cellForRowAtIndexPath:indexPath];
//        UILabel *lab=(UILabel *)[cell viewWithTag:1002];
        WritePersonalDataVC *writvc=[[WritePersonalDataVC alloc]init];
        writvc.title_main=@"地址";
        writvc.select_index=indexPath.row;
        writvc.title_diplay= _addressLabel.text;
        [self.navigationController pushViewController:writvc animated:YES];
    }
    else if (indexPath.row == 5) {
        WritePersonalDataVC *writvc=[[WritePersonalDataVC alloc]init];
        writvc.title_main=@"小区名称";
        writvc.select_index=indexPath.row;
        writvc.title_diplay= _xiaoquLabel.text;
        [self.navigationController pushViewController:writvc animated:YES];
    }
}

- (void)clickLogoutBtn:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定退出当前账号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.delegate=self;
    [alertView show];
}

#pragma mark -
#pragma mark -PickerViewDelegate

-(void)actionSheetProvinceCAPickerView:(CustomProvinceCApicker *)pickerView didSelectTitles:(NSArray *)titles{
    
    NSMutableString *province_name=[NSMutableString string];
    if([arr_Province count]) [arr_Province removeAllObjects];
    for(int i=0;i<[titles count];i++){
        NSArray *arr=[titles objectAtIndex:i];
        [arr_Province addObject:arr];
        
        if(i==1 && [@"上海市北京市天津市重庆市" rangeOfString:[arr objectAtIndex:0]].length>0)[province_name appendFormat:@"%@",@""]; //获取省市区名字
        else [province_name appendFormat:@"%@",[arr objectAtIndex:0]]; //获取省市区名字
        
        //获取省市区code码
        if(i==0) {
            self.provinceCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
            self.provinceName=[arr objectAtIndex:0];
        }
        else if(i==1) {
            self.cityCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
            self.cityName=[arr objectAtIndex:0];
        }
        else if(i==2) {
            self.areaCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
            self.areaName=[arr objectAtIndex:0];
        }
    }
    
    //台湾、澳门、香港没有市区
    if([titles count]==1){
        self.cityCode=@"";
        self.areaCode=@"";
        self.cityName=@"";
        self.areaName=@"";
    }
    
    _districtLabel.text=province_name;
    _districtLabel.textColor=[UIColor darkTextColor];
    [self SendpersonalDistrictInfo];
}

#pragma mark - 选择区域

- (void)clickMaleBtn:(UIButton *)btn {
    if (_maleBtn.selected == YES) {
        return;
    }
    btn.selected = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _femaleBtn.selected = NO;
    [_femaleBtn setTitleColor:kFontPlacehoderColor forState:UIControlStateNormal];
    
    self.sex_selected=@"1";
//    [self SendpersonalSexInfo];
}

- (void)clickFemaleBtn:(UIButton *)btn {
    if (_femaleBtn.selected == YES) {
        return;
    }
    btn.selected = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _maleBtn.selected = NO;
    [_maleBtn setTitleColor:kFontPlacehoderColor forState:UIControlStateNormal];
    
    self.sex_selected=@"2";
//    [self SendpersonalSexInfo];
}

#pragma mark - 头像设置

#pragma mark -
#pragma mark - UIImagePickerDelegate
//开始拍照
-(void)takePhoto
{
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             
                         }];
    }
    else
    {
        [TLToast showWithText:@"该设备不支持摄像头拍照" bottomOffset:200.0f duration:1.0];
    }
}

//打开本地相册
-(void)LocalPhoto
{
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             
                         }];
    }
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    portraitImg = [self imageByScalingToMaxSize:portraitImg];
    // 裁剪
    VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
    imgEditorVC.delegate = self;
    [picker pushViewController:imgEditorVC animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //NSLog(@"您取消了选择图片");
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
        self.image = editedImage;
        [_headIV  setImage:[self circleImage:[self imageWithImage:self.image scaledToSize:CGSizeMake(100, 100)] withParam:1.0]];
        
//        [self SendpersonalInfo:self.image];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

//裁剪为圆形图片
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

////头像存在本地
//-(void)savePhotoTOdisk:(NSData *)photo_data{
//    NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
//    [photo_data writeToFile:aPath atomically:YES];
//}
////手机读取头像
//-(UIImage *)ReadPhoto{
//    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
//    UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
//    return imgFromUrl3;
//}

//发送个人信息
-(void)SendpersonalInfo{
    
    NSString *url=[NSString stringWithFormat:@"%@/dispatch/upload.action",kDefaultUpdateVersionServerURL];
//    
//    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
//    [postDict setObject:@"ID0017" forKey:@"cmdID"];
//    [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] forKey:@"token"];
//    [postDict setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]] forKey:@"userID"];
//    [postDict setObject:@"iOS" forKey:@"deviceType"];
//    NSString *string=[postDict JSONString];
    
    
    NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
    [postDict02 setObject:@"utopheader" forKey:@"folder"];

//    [postDict02 setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]] forKey:@"userID"];
//    if ([self.headIV.image isEqual:[UIImage imageNamed:@"ic_me_touxiang"]]) {
//        [postDict02 setObject:@"" forKey:@"userLogo"];
//    }else{
//
//    [postDict02 setObject:[NSString stringWithFormat:@"%@",[UIImageJPEGRepresentation([self imageWithImage:self.headIV.image scaledToSize:CGSizeMake(100, 100)], 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]] forKey:@"userLogo"];
//    }
    
//    NSString *string02=[postDict02 JSONString];
//    
//    NSURL* url_string = [NSURL URLWithString:url];      
//    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url_string];
//    request.delegate = self;
//    [request setPostValue:string forKey:@"header"];
//    [request setPostValue:string02 forKey:@"body"];
//  
//    [request setUserInfo:[NSDictionary dictionaryWithObject:@"userInfo" forKey:@"key"]];
//    [request startAsynchronous];
    NSLog(@"=============%@",self.headIV.image);
    NSMutableArray * uerLogoArr = [NSMutableArray array];
    [uerLogoArr addObject:self.headIV.image];
    
    [self sendRequestImagesToServerUrl:^(id responseObject) {
    
        [self firstRequestFinished:responseObject];
    } failedBlock:^(id responseObject) {
        [self stopMBProgressHUD];
        [util showError:responseObject];
    } RequestUrl:url CmdID:@"" PostDict:postDict02 PostImages:uerLogoArr UploadImageKey:@"filedata" Progress:YES];
    
}

#pragma mark = actionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        [self takePhoto];
    }
    if (buttonIndex==1) {
        [self LocalPhoto];
    }
}

#pragma mark -

-(void)firstRequestFinished:(id)responseObject{
    
    
    if(kResCode1==103371){
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        NSLog(@"responseObject========%@",responseObject);
        if ([responseObject objectForKey:@"paths"]) {
            [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:@"paths"] forKey:User_logo];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        
        [postDict02 setObject:self.nickName forKey:@"nickName"];
        if (!self.sex_selected) {
            self.sex_selected=@"";
        }else{
            [postDict02 setObject:self.sex_selected forKey:@"sex"];
        }
        
        [postDict02 setObject:self.address forKey:@"userAddress"];
        
        [postDict02 setObject:self.provinceName forKey:@"provinceName"];
        [postDict02 setObject:self.provinceCode forKey:@"provinceCode"];
        [postDict02 setObject:self.cityCode forKey:@"cityCode"];
        [postDict02 setObject:self.cityName forKey:@"cityName"];
        
        [postDict02 setObject:self.areaName forKey:@"areaName"];
        [postDict02 setObject:self.areaName forKey:@"areaName"];
        [postDict02 setObject:self.areaCode forKey:@"areaCode"];
        [postDict02 setObject:self.xiaoQu forKey:@"villageName"];
        [postDict02 setObject:@"1" forKey:@"httpver"];
        [postDict02 setObject: [responseObject objectForKey:@"paths"] forKey:@"avtar"];
        
        
        [self sendRequestToServerUrl:^(id responseObject) {
            [self stopMBProgressHUD];
            [self secondRequestFinished:responseObject];
        } failedBlock:^(id responseObject) {
            [self stopMBProgressHUD];
            [util showError:responseObject];
        } RequestUrl:url CmdID:@"ID0017" PostDict:postDict02 RequestType:@"GET"];
        
    }else   {
        [self stopMBProgressHUD];
        [TLToast showWithText:@"上传失败"];
        [self postfailedOperation];
    }
    
    
    
//    else if (kResCode1==10192) {
//        NSLog(@"================userId为空");
//        [self postfailedOperation];
//    }else if (kResCode1==10193) {
//        [self postfailedOperation];
//        [TLToast showWithText:@"保存失败,你可能未登录或登录失效了"];
//        
//    }
//    else if (kResCode1==10194) {
//        [TLToast showWithText:@"保存失败,你的用户名称过长"];
//    }else if (kResCode1==10195) {
//        [self postfailedOperation];
//        [TLToast showWithText:@"保存失败,你的用户地址过长"];
//    } else if (kResCode1==10199) {
//        [self postfailedOperation];
//        [TLToast showWithText:@"操作失败"];
//    }else if (kResCode1==10003) {
//        [self postfailedOperation];
//        [TLToast showWithText:@"token为空"];
//    }else if (kResCode1==10196) {
//        [self postfailedOperation];
//        [TLToast showWithText:@"业主同步信息失败"];
//    }else if (kResCode1==10197) {
//        [TLToast showWithText:@"财务系统接口未开启"];
//        [self postfailedOperation];
//    }

}

-(void)secondRequestFinished:(id)responseObject{
    
    if(kResCode1==10191){
        //        [self savePhotoTOdisk:UIImagePNGRepresentation([self.image fixOrientation])];
        [[NSUserDefaults standardUserDefaults]setObject:self.nickName forKey:User_nickName];
        
        if([self.sex_selected isEqualToString:@"1"])
            [[NSUserDefaults standardUserDefaults]setObject:@"男" forKey:User_sex];
        if([self.sex_selected isEqualToString:@"2"])
            [[NSUserDefaults standardUserDefaults]setObject:@"女" forKey:User_sex];
        
        [[NSUserDefaults standardUserDefaults]setObject:self.provinceName forKey:User_ProvinceName];
        [[NSUserDefaults standardUserDefaults]setObject:self.provinceCode forKey:User_ProvinceCode];
        [[NSUserDefaults standardUserDefaults]setObject:self.cityName forKey:User_CityName];
        [[NSUserDefaults standardUserDefaults]setObject:self.cityCode forKey:User_CityCode];
        [[NSUserDefaults standardUserDefaults]setObject:self.areaName forKey:User_AreaName];
        [[NSUserDefaults standardUserDefaults]setObject:self.areaCode forKey:User_AreaCode];
        
        [[NSUserDefaults standardUserDefaults]setObject:self.address forKey:User_Addrss];
        [[NSUserDefaults standardUserDefaults]setObject:self.xiaoQu forKey:User_Village];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [TLToast showWithText:@"保存成功" duration:1];
       }else   {
            [TLToast showWithText:@"上传失败"];
            [self postfailedOperation];
        }
}


//- (void)requestFailed:(ASIHTTPRequest *)request {
//    
//    [savelogObj saveLog:@"个人信息修改" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:6];
//    [request setResponseEncoding:NSUTF8StringEncoding];
//    NSString *respString = [request responseString];
//    NSDictionary *jsonDict = [respString objectFromJSONString];
//    NSLog(@"%@",jsonDict);
//    NSInteger resCode = [[jsonDict objectForKey:@"resCode"] integerValue];
//
//     if (resCode==10192) {
//        NSLog(@"================userId为空");
//         [self postfailedOperation];
//    }
//    else if (resCode==10193) {
//        [self postfailedOperation];
//        [TLToast showWithText:@"保存失败,你可能未登录或登录失效了"];
//        
//    }
//    else if (resCode==10194) {
//        [TLToast showWithText:@"保存失败,你的用户名称过长"];
//    }else if (resCode==10195) {
//        [self postfailedOperation];
//        [TLToast showWithText:@"保存失败,你的用户地址过长"];
//    } else if (resCode==10199) {
//        [self postfailedOperation];
//        [TLToast showWithText:@"操作失败"];
//    }else if (resCode==10003) {
//        [self postfailedOperation];
//        [TLToast showWithText:@"token为空"];
//    }else if (resCode==10196) {
//        [self postfailedOperation];
//        [TLToast showWithText:@"业主同步信息失败"];
//    }else if (resCode==10197) {
//        [TLToast showWithText:@"财务系统接口未开启"];
//        [self postfailedOperation];
//    }
//    else   {
//        [TLToast showWithText:@"服务器异常,请稍后再试"];
//        [self postfailedOperation];
//    }
//}



//    if([[request.userInfo objectForKey:@"key"] isEqualToString:@"userInfo"]){
//        [TLToast showWithText:@"上传头像失败" bottomOffset:200.0f duration:1.0];
//        if([self ReadPhoto])
//            [_headIV  setImage:[self circleImage:[self imageWithImage:[self ReadPhoto] scaledToSize:CGSizeMake(100, 100)] withParam:1.0]];
//        else
//            [_headIV  setImage:[UIImage imageNamed:@"ic_me_touxiang"]];
//    }
//    if ([[request.userInfo objectForKey:@"key"] isEqualToString:@"sex"]) {
//        [TLToast showWithText:@"设置性别失败" bottomOffset:200.0f duration:1.5];
//    }
//    
//    if ([[request.userInfo objectForKey:@"key"] isEqualToString:@"areaCode"]) {
//        [TLToast showWithText:@"设置区域失败" bottomOffset:200.0f duration:1.5];
//    }


- (void)postfailedOperation{
    if([[NSUserDefaults standardUserDefaults]objectForKey:User_logo]){
    NSString * url = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_logo]];
        
    __weak typeof(self) weaself =self;
   [_headIV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"ic_me_touxiang"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       [_headIV  setImage:[weaself circleImage:[weaself imageWithImage:image scaledToSize:CGSizeMake(100, 100)] withParam:1.0]];
    }];
    }else{
        [_headIV  setImage:[UIImage imageNamed:@"ic_me_touxiang"]];
    }

}



//- (void)requestFinished:(ASIHTTPRequest *)request {
//    
//    if([[request.userInfo objectForKey:@"key"] isEqualToString:@"userInfo"]){
//        [request setResponseEncoding:NSUTF8StringEncoding];
//        NSString *respString = [request responseString];
//        NSDictionary *jsonDict = [respString objectFromJSONString];
//        NSLog(@"%@",jsonDict);
//        NSInteger resCode = [[jsonDict objectForKey:@"resCode"] integerValue];
//    
//        if(resCode==10191){
//            [self savePhotoTOdisk:UIImagePNGRepresentation([self.image fixOrientation])];
//            
//            [[NSUserDefaults standardUserDefaults]setObject:self.nickName forKey:User_nickName];
//            
//            if([self.sex_selected isEqualToString:@"1"])
//            [[NSUserDefaults standardUserDefaults]setObject:@"男" forKey:User_sex];
//            if([self.sex_selected isEqualToString:@"2"])
//            [[NSUserDefaults standardUserDefaults]setObject:@"女" forKey:User_sex];
//            
//            
//            [[NSUserDefaults standardUserDefaults]setObject:self.provinceName forKey:User_ProvinceName];
//            [[NSUserDefaults standardUserDefaults]setObject:self.provinceCode forKey:User_ProvinceCode];
//            [[NSUserDefaults standardUserDefaults]setObject:self.cityName forKey:User_CityName];
//            [[NSUserDefaults standardUserDefaults]setObject:self.cityCode forKey:User_CityCode];
//            [[NSUserDefaults standardUserDefaults]setObject:self.areaName forKey:User_AreaName];
//            [[NSUserDefaults standardUserDefaults]setObject:self.areaCode forKey:User_AreaCode];
//            
//            [[NSUserDefaults standardUserDefaults]setObject:self.address forKey:User_Addrss];
//            [[NSUserDefaults standardUserDefaults]setObject:self.xiaoQu forKey:User_Village];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//             [TLToast showWithText:@"保存成功" duration:1];
//            
//                }
//        
//    }
////    
//    if([[request.userInfo objectForKey:@"key"] isEqualToString:@"photo"]){
//        [request setResponseEncoding:NSUTF8StringEncoding];
//        NSString *respString = [request responseString];
//        NSDictionary *jsonDict = [respString objectFromJSONString];
//        NSLog(@"%@",jsonDict);
//        if ([[jsonDict objectForKey:@"resCode"] integerValue]==10191) {
//            [TLToast showWithText:@"上传头像成功" bottomOffset:200.0f duration:1.0];
//            [self savePhotoTOdisk:UIImagePNGRepresentation([self.image fixOrientation])];
//        }
//        else{
//            [TLToast showWithText:@"上传头像失败" bottomOffset:200.0f duration:1.0];
//            if([self ReadPhoto])
//                [_headIV  setImage:[self circleImage:[self imageWithImage:[self ReadPhoto] scaledToSize:CGSizeMake(100, 100)] withParam:0.0]];
//            else
//                [_headIV  setImage:[UIImage imageNamed:@"头像.png"]];
//        }
//    }
//    if ([[request.userInfo objectForKey:@"key"] isEqualToString:@"sex"]) {
//        [request setResponseEncoding:NSUTF8StringEncoding];
//        NSString *respString = [request responseString];
//        NSDictionary *jsonDict = [respString objectFromJSONString];
//        if ([[jsonDict objectForKey:@"resCode"] integerValue]==10191) {
//            [TLToast showWithText:@"设置性别成功" bottomOffset:200.0f duration:1.5];
//            if([self.sex_selected isEqualToString:@"1"])
//                [[NSUserDefaults standardUserDefaults]setObject:@"男" forKey:User_sex];
//            if([self.sex_selected isEqualToString:@"2"])
//                [[NSUserDefaults standardUserDefaults]setObject:@"女" forKey:User_sex];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//        }
//        else{
//            [TLToast showWithText:@"设置性别失败" bottomOffset:200.0f duration:1.5];
//        }
//    }
//    if ([[request.userInfo objectForKey:@"key"] isEqualToString:@"areaCode"]) {
//        [request setResponseEncoding:NSUTF8StringEncoding];
//        NSString *respString = [request responseString];
//        NSDictionary *jsonDict = [respString objectFromJSONString];
//        if ([[jsonDict objectForKey:@"resCode"] integerValue]==10191) {
//            [TLToast showWithText:@"设置区域成功" bottomOffset:200.0f duration:1.5];
//            [[NSUserDefaults standardUserDefaults]setObject:self.provinceName forKey:User_ProvinceName];
//            [[NSUserDefaults standardUserDefaults]setObject:self.provinceCode forKey:User_ProvinceCode];
//            [[NSUserDefaults standardUserDefaults]setObject:self.cityName forKey:User_CityName];
//            [[NSUserDefaults standardUserDefaults]setObject:self.cityCode forKey:User_CityCode];
//            [[NSUserDefaults standardUserDefaults]setObject:self.areaName forKey:User_AreaName];
//            [[NSUserDefaults standardUserDefaults]setObject:self.areaCode forKey:User_AreaCode];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//        }
//        else{
//            [TLToast showWithText:@"设置区域失败" bottomOffset:200.0f duration:1.5];
//        }
//    }

//}

//发送性别修改
-(void)SendpersonalSexInfo{
    NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:@"ID0017" forKey:@"cmdID"];
    [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] forKey:@"token"];
    [postDict setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]] forKey:@"userID"];
    [postDict setObject:@"iOS" forKey:@"deviceType"];
    NSString *string=[postDict JSONString];
    
    NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
    [postDict02 setObject:@"" forKey:@"nickName"];
    [postDict02 setObject:self.sex_selected forKey:@"sex"];
    [postDict02 setObject:@"" forKey:@"userAddress"];
    [postDict02 setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]] forKey:@"userID"];
    [postDict02 setObject:@"" forKey:@"userLogo"];
    [postDict02 setObject:@"" forKey:@"provinceName"];
    [postDict02 setObject:@"" forKey:@"provinceCode"];
    [postDict02 setObject:@"" forKey:@"cityName"];
    [postDict02 setObject:@"" forKey:@"cityCode"];
    [postDict02 setObject:@"" forKey:@"areaName"];
    [postDict02 setObject:@"" forKey:@"areaCode"];
    [postDict02 setObject:@"" forKey:@"villageName"];

    
    NSString *string02=[postDict02 JSONString];
    
    NSURL* url_string = [NSURL URLWithString:url];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url_string];
    request.delegate = self;
    [request setPostValue:string forKey:@"header"];
    [request setPostValue:string02 forKey:@"body"];
    [request setUserInfo:[NSDictionary  dictionaryWithObject:@"sex" forKey:@"key"]];
    [request startAsynchronous];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        
    }
    if (buttonIndex==1) {
//        NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
//        [[NSFileManager defaultManager] removeItemAtPath:aPath3 error:nil];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_logo];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Name];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Password];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Token];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_ID];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Addrss];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Mobile];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_sex];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_nickName];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_ProvinceName];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_CityName];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_AreaName];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_ProvinceCode];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_CityCode];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_AreaCode];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//发送区域修改
-(void)SendpersonalDistrictInfo{
    NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:@"ID0017" forKey:@"cmdID"];
    [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] forKey:@"token"];
    [postDict setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]] forKey:@"userID"];
    [postDict setObject:@"iOS" forKey:@"deviceType"];
    [postDict setObject:kCityCode forKey:@"cityCode"];
    NSString *string=[postDict JSONString];
    
    NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
    [postDict02 setObject:@"" forKey:@"nickName"];
    [postDict02 setObject:@"" forKey:@"sex"];
    [postDict02 setObject:@"" forKey:@"userAddress"];
    [postDict02 setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]] forKey:@"userID"];
    [postDict02 setObject:@"" forKey:@"userLogo"];
    [postDict02 setObject:@"" forKey:@"villageName"];
    
    [postDict02 setObject:self.provinceName forKey:@"provinceName"];
    [postDict02 setObject:self.provinceCode forKey:@"provinceCode"];
    [postDict02 setObject:self.cityName forKey:@"cityName"];
    [postDict02 setObject:self.cityCode forKey:@"cityCode"];
    [postDict02 setObject:self.areaName forKey:@"areaName"];
    [postDict02 setObject:self.areaCode forKey:@"areaCode"];
    
    NSString *string02=[postDict02 JSONString];
    
    NSURL* url_string = [NSURL URLWithString:url];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url_string];
    request.delegate = self;
    [request setPostValue:string forKey:@"header"];
    [request setPostValue:string02 forKey:@"body"];
    [request setUserInfo:[NSDictionary  dictionaryWithObject:@"areaCode" forKey:@"key"]];
    [request startAsynchronous];
    
}

//请求行政区域列表
-(void)requestDistrictNOlist{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0029\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,kCityCode];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                //NSLog(@"行政区号：返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10291) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *arr_=[jsonDict objectForKey:@"adminAreasList"];
                        if ([arr_ count]) {
                            
                        }
                        
                    });
                }
                else if (code==10299) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                              });
                          }
                               method:url postDict:nil];
    });
    
}
-(void)savePersonalInfo:(id)sender{
//    [TLToast showWithText:@"上传中..."];
//    if ([sender isKindOfClass:[UIButton class]]) {
//        UIButton  *  senderNew = sender;
//        senderNew.enabled =NO;
//    }
    [self SendpersonalInfo];
//    
//    NSString *requestUrl=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
//    
////    
////    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
////    [postDict setObject:@"ID0017" forKey:@"cmdID"];
////    [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] forKey:@"token"];
////    [postDict setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]] forKey:@"userID"];
////    [postDict setObject:@"iOS" forKey:@"deviceType"];
////    [postDict setObject:kCityCode forKey:@"cityCode"];
////    NSString *string=[postDict JSONString];
//    
//    NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
//    [postDict02 setObject:self.nicknameLabel.text forKey:@"nickName"];
//    [postDict02 setObject:self.sex_selected forKey:@"sex"];
//    [postDict02 setObject:self.addressLabel.text forKey:@"userAddress"];
//    [postDict02 setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]] forKey:@"userID"];
//    [postDict02 setObject:self.xiaoquLabel.text forKey:@"villageName"];
//    
//    [postDict02 setObject:self.provinceName forKey:@"provinceName"];
//    [postDict02 setObject:self.provinceCode forKey:@"provinceCode"];
//    [postDict02 setObject:self.cityName forKey:@"cityName"];
//    [postDict02 setObject:self.cityCode forKey:@"cityCode"];
//    [postDict02 setObject:self.areaName forKey:@"areaName"];
//    [postDict02 setObject:self.areaCode forKey:@"areaCode"];
//    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
//    [imageArray addObject:self.headIV.image];
////    NSString *string02=[postDict02 JSONString];
//    
//    [self sendRequestImagesToServerUrl:^(id resObj) {
//        if([[resObj objectForKey:@"resCode"] integerValue]==10191){
//            [TLToast showWithText:@"上传成功" duration:1];
//         
//        }
//        else if ([[resObj objectForKey:@"resCode"] integerValue]==10192) {
//            NSLog(@"================userId为空");
//            
//            }
//        else if ([[resObj objectForKey:@"resCode"] integerValue]==10193) {
//            [TLToast showWithText:@"上传失败,你可能未登录或登录失效了"];
//        }
//        else if ([[resObj objectForKey:@"resCode"] integerValue]==10194) {
//            [TLToast showWithText:@"上传失败,你的用户名称过长"];
//        }else if ([[resObj objectForKey:@"resCode"] integerValue]==10195) {
//            [TLToast showWithText:@"上传失败,你的用户地址过长"];
//        } else if ([[resObj objectForKey:@"resCode"] integerValue]==10199) {
//            [TLToast showWithText:@"操作失败"];
//        }else if ([[resObj objectForKey:@"resCode"] integerValue]==10003) {
//            [TLToast showWithText:@"token为空"];
//        }else if ([[resObj objectForKey:@"resCode"] integerValue]==10196) {
//            [TLToast showWithText:@"业主同步信息失败"];
//        }else if ([[resObj objectForKey:@"resCode"] integerValue]==10197) {
//            [TLToast showWithText:@"财务系统接口未开启"];
//        }
//           else   {
//            [TLToast showWithText:@"服务器异常,请稍后再试"];
//        }
//
//    } failedBlock:^(id resobj) {
//        [self stopRequest];
//         [TLToast showWithText:resobj duration:1];
//    } RequestUrl:requestUrl CmdID:@"ID0017" PostDict:postDict02 PostImages:imageArray UploadImageKey:@"userLogo" Progress:NO];
//    
//

}


@end
