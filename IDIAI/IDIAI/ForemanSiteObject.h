//
//  ForemanSiteObject.h
//  UTopGD
//
//  Created by Ricky on 15/9/17.
//  Copyright (c) 2015年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForemanSitesPic.h"
#import "KVCObject.h"

@interface ForemanSiteObject : KVCObject
@property(nonatomic,strong)NSString *acreage;
@property(nonatomic,strong)NSString *bathroom;
@property(nonatomic,strong)NSString *bedRoom;
@property(nonatomic,strong)NSString *buildingCost;
@property(nonatomic,strong)NSString *distance;
@property(nonatomic,strong)NSString *foremanIconPath;
@property(nonatomic,strong)NSString *foremanId;
@property(nonatomic,strong)NSString *foremanName;
@property(nonatomic,strong)NSString *foremanSitesId;
@property(nonatomic,strong)KVCArray *foremanSitesPicVos;
@property(nonatomic,strong)KVCArray *foremanSitesPics;
@property(nonatomic,strong)NSString *frameId;
@property(nonatomic,strong)NSString *frameName;
@property(nonatomic,strong)NSString *latitude;
@property(nonatomic,strong)NSString *livingRoom;
@property(nonatomic,strong)NSString *longitude;
@property(nonatomic,strong)NSString *picPath;
@property(nonatomic,strong)NSString *projectLimit;
@property(nonatomic,strong)NSString *roomNumber;
@property(nonatomic,strong)NSString *sitesPic;
@property(nonatomic,strong)NSString *stieStatus;
@property(nonatomic,strong)NSString *updateDate;
@property(nonatomic,strong)NSString *veranda;
@property(nonatomic,strong)NSString *villageName;

@end
