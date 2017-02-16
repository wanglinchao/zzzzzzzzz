//
//  MailContactObject.h
//  IDIAI
//
//  Created by Ricky on 16/5/18.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCObject.h"
@interface MailContactObject : KVCObject
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,assign)int roleId;
@property(nonatomic,assign)int userId;
@property(nonatomic,assign)BOOL isselct;
@end
