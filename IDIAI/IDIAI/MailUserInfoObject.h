//
//  MailUserInfoObject.h
//  IDIAI
//
//  Created by Ricky on 16/5/19.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailUserInfoObject : NSObject
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,assign)int roleId;
@property(nonatomic,strong)NSString *stateName;
@property(nonatomic,assign)int state;
@end
