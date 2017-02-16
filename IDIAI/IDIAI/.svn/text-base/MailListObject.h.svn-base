//
//  MailListObject.h
//  IDIAI
//
//  Created by Ricky on 16/5/19.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCObject.h"
#import "MailUserInfoObject.h"
@interface MailListObject : KVCObject
@property(nonatomic,assign)int sendMailId;//发件信息Id
@property(nonatomic,assign)int sendUserId;//发送用户ID
@property(nonatomic,strong)NSString *sendUserName;//发送用户姓名
@property(nonatomic,assign)int sendRoleId;//发送人角色：1：设计师； 4：工头; 9-平台监理 7：业主
@property(nonatomic,strong)KVCArray *recvUserInfos;//收件人列表
@property(nonatomic,assign)double sendDate;//收到时间
@property(nonatomic,assign)int state;//信息状态
@property(nonatomic,strong)NSString *stateName;//状态名称
@property(nonatomic,strong)NSString *userLogo;//如果是业主7：就是二进制 如果不是7：就是图片路径
@end
