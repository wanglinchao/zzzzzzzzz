//
//  CasePicInfoViewController.h
//  IDIAI
//
//  Created by iMac on 16/4/6.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "PullingRefreshTableView.h"

@interface CasePicInfoViewController : GeneralWithBackBtnViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    PullingRefreshTableView *mTableView;
}

@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (assign, nonatomic) BOOL refreshing;

@property (nonatomic, strong) NSMutableArray *dataArr;   //数据源
@property (nonatomic, assign) NSInteger indexSort;   //选择的序号
@property (nonatomic,strong) NSString *shareUrl;//分享的url

@property (nonatomic,assign) NSInteger picture_style;//效果图风格
@property (nonatomic,assign) NSInteger picture_doorModel;//效果图户型
@property (nonatomic,assign) NSInteger picture_price;//效果图报价
@property (nonatomic,assign) NSInteger picture_cityCode;//城市的code

typedef void (^SelectBlockCaseInfo)(NSInteger currentPage, NSInteger totalPages, NSMutableArray *Array);
@property (nonatomic, copy) SelectBlockCaseInfo selectDoneCaseInfo;

@end
