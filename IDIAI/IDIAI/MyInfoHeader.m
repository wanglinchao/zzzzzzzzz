//
//  MyInfoHeader.m
//  IDIAI
//
//  Created by iMac on 15/10/26.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyInfoHeader.h"

@implementation MyInfoHeader

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        float width=kMainScreenWidth*33/160;
        self.userLogo=[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-width)/2, self.center.y-50*width/66, width, width)];
        self.userLogo.tag=101;
        [self addSubview:self.userLogo];
        
        self.userName = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.userLogo.frame)+10, kMainScreenWidth-60, 20)];
        self.userName.backgroundColor=[UIColor clearColor];
        self.userName.tag=102;
        self.userName.textColor =  [UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
        self.userName.font = [UIFont systemFontOfSize:18];
        self.userName.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.userName];
        
        self.userAddress = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.userName.frame)+5, kMainScreenWidth-60, 20)];
        self.userAddress.backgroundColor=[UIColor clearColor];
        self.userAddress.tag=103;
        self.userAddress.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
        self.userAddress.font = [UIFont systemFontOfSize:15];
        self.userAddress.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.userAddress];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
