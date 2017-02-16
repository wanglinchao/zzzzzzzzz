//
//  MyToDoInfoObject.h
//  IDIAI
//
//  Created by Ricky on 16/5/23.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCObject.h"
@interface MyToDoInfoObject : KVCObject
@property(nonatomic,assign)int finished;
@property(nonatomic,strong)NSString *todoDesc;
@property(nonatomic,assign)int todoId;
@property(nonatomic,assign)int status;
@end
