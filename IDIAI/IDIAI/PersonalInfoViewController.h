//
//  PersonalInfoViewController.h
//  IDIAI
//
//  Created by Ricky on 14-11-27.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "VPImageCropperViewController.h"

@interface PersonalInfoViewController : GeneralWithBackBtnViewController <UITableViewDataSource, UITableViewDelegate, VPImageCropperDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
     NSMutableArray *arr_Province; //省市区数组
}

@property (nonatomic,strong) NSString *provinceCode;
@property (nonatomic,strong) NSString *cityCode;
@property (nonatomic,strong) NSString *areaCode;
@property (nonatomic,strong) NSString *provinceName;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *areaName;
@property (nonatomic,assign) BOOL isHomePage;
@property (nonatomic,strong) NSString *sex_selected;
@property (nonatomic,copy) NSString * nickName;
@property (nonatomic,copy) NSString * address;
@property (nonatomic,copy) NSString * xiaoQu;

@property (nonatomic,strong)UIImageView * headIV;
@property (nonatomic,strong)UILabel * nicknameLabel;
@property (nonatomic,strong)UIButton * maleBtn;
@property (nonatomic,strong)UIButton * femaleBtn;
@property (nonatomic,strong)UILabel * districtLabel;
@property (nonatomic,strong)UILabel * addressLabel;
@property (nonatomic,strong)UILabel * xiaoquLabel;
@property (nonatomic,strong)UILabel * cellphoneLabel;


@property(nonatomic,assign)BOOL headImgIsChanged;
@property(nonatomic,assign)BOOL nickNameIsChanged;
@property(nonatomic,assign)BOOL addressIsChanged;
@property(nonatomic,assign)BOOL xiaoquIsChanged;








@end
