//
//  BaseModel.m
//  IDIAI
//
//  Created by PM on 16/6/14.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{


}
 // 当设置类中不存在的成员变量时，需要实现该方法， 在获取时防止程序崩溃
-(id)valueForUndefinedKey:(NSString *)key{

    return nil;
}



@end
