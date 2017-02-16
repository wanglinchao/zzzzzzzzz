//
//  MyToDoObject.h
//  IDIAI
//
//  Created by Ricky on 16/5/23.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCObject.h"
#import "MyToDoInfoObject.h"
@interface MyToDoObject : KVCObject
@property(nonatomic,assign)int userId;//用户ID
@property(nonatomic,strong)NSString *userName;//姓名
@property(nonatomic,assign)int roleId;//1：设计师； 4：工头; 9-平台监理 7：业主
@property(nonatomic,strong)NSString *phaseName;//阶段名称
@property(nonatomic,assign)long beginDate;//开始时间
@property(nonatomic,strong)KVCArray *phaseTodoInfos;//待办信息
@property(nonatomic,strong)NSString *userLogo;//用户头像
@property(nonatomic,strong)NSMutableArray *unfinised;//未完成数组
@property(nonatomic,strong)NSMutableArray *finised;//已完成数组
@property(nonatomic,assign)BOOL ishide;//是否隐藏
//userId	int
//userName	String
//roleId	Int
//phaseName	String
//beginDate	Long
//phaseTodoInfos	PhaseTodoInfo
@end
