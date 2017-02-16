//
//  MailDetailObject.h
//  IDIAI
//
//  Created by Ricky on 16/5/19.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCObject.h"
#import "MailUserInfoObject.h"
@interface MailDetailObject : KVCObject
@property(nonatomic,assign)int sendMaillId;//发件信息Id
@property(nonatomic,assign)int sendUserId;//发送用户ID
@property(nonatomic,strong)NSString *sendUserName;//发送用户姓名
@property(nonatomic,assign)int sendRoleId;//发送人角色：1：设计师； 4：工头; 9-平台监理 7：业主
@property(nonatomic,strong)KVCArray *recvUserInfos;//收件人列表
@property(nonatomic,assign)long recvDate;//收到时间
@property(nonatomic,strong)NSString *mailContent;//信件内容
@property(nonatomic,strong)KVCArray *maillAttchments;//信件附件,多个用，隔开
@property(nonatomic,strong)NSString *userLogo;//用户头像
@property(nonatomic,strong)NSString *stateName;
@end
