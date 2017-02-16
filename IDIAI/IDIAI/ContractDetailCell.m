//
//  ContractDetailCell.m
//  IDIAI
//
//  Created by Ricky on 15/12/24.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ContractDetailCell.h"
#import "util.h"
@interface ContractDetailCell ()
@property(nonatomic,strong)UILabel *nickNamelbl;
@property(nonatomic,strong)UILabel *contractstate;
@property(nonatomic,strong)UILabel *orderlbl;
@property(nonatomic,strong)UILabel *effectiveTimelbl;
@property(nonatomic,strong)UILabel *contractTypelbl;
@property(nonatomic,strong)UILabel *contractTotalFeelbl;
@property(nonatomic,strong)UILabel *orderFeelbl;
@property(nonatomic,strong)UILabel *managerFeelbl;
@property(nonatomic,strong)UILabel *userNamelbl;
@property(nonatomic,strong)UILabel *userPhoneNolbl;
@property(nonatomic,strong)UILabel *houseArealbl;
@property(nonatomic,strong)UILabel *userCommunityNamelbl;
@property(nonatomic,strong)UILabel *userAddrlbl;
@property(nonatomic,strong)UILabel *servantNamelbl;
@property(nonatomic,strong)UILabel *servantPhoneNolbl;
@property(nonatomic,strong)UILabel *durationlbl;
@property(nonatomic,strong)UILabel *companyNametitle;
@property(nonatomic,strong)UILabel *companyNamelbl;
@property(nonatomic,strong)UILabel *companyTellbl;
@property(nonatomic,strong)UILabel *managerTitlelbl;
@property(nonatomic,strong)UILabel *platformSuperFeelbl;
@property(nonatomic,strong)UIButton *commentbtn;
@property(nonatomic,strong)UIView *footView;
@property(nonatomic,strong)UILabel *partyAlbl;
@property(nonatomic,strong)UIImageView *partyAline;
@property(nonatomic,strong)UILabel *partyBlbl;
@property(nonatomic,strong)UIImageView *partyBline;
@property(nonatomic,strong)UILabel *partyClbl;
@property(nonatomic,strong)UIImageView *partyCline;
@property(nonatomic,strong)UILabel *realpaylbl;
@property(nonatomic,strong)UILabel *supervisionlbl;
@end
@implementation ContractDetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setContractDetail:(NewContractDetailObject *)contractDetail{
//    NSLog(@"%@",[self.contentView subviews]);
    for (UIView *view in [self.contentView subviews]) {
        [view removeFromSuperview];
    }
    _contractDetail =contractDetail;
    self.nickNamelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 15, (kMainScreenWidth-30)/2, 15)];
    self.nickNamelbl.font =[UIFont systemFontOfSize:15];
    self.nickNamelbl.textColor =[UIColor colorWithHexString:@"#575757"];
    [self.contentView addSubview:self.nickNamelbl];
    
    self.contractstate =[[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-30)-(kMainScreenWidth-30)/2, 15, kMainScreenWidth/2, 15)];
    self.contractstate.font =[UIFont systemFontOfSize:15];
    self.contractstate.textColor =[UIColor colorWithHexString:@"#ef6562"];
    self.contractstate.textAlignment =NSTextAlignmentRight;
    [self.contentView addSubview:self.contractstate];
    
    UIImageView *stateline =[[UIImageView alloc] initWithFrame:CGRectMake(12, self.nickNamelbl.frame.origin.y+self.nickNamelbl.frame.size.height+15, kMainScreenWidth-24, 1)];
    stateline.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [self.contentView addSubview:stateline];
    
    self.orderlbl =[[UILabel alloc] initWithFrame:CGRectMake(15, stateline.frame.origin.y+stateline.frame.size.height+15, kMainScreenWidth-30, 15)];
    self.orderlbl.font =[UIFont systemFontOfSize:15];
    self.orderlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.orderlbl];
    
    self.effectiveTimelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.orderlbl.frame.origin.y+self.orderlbl.frame.size.height+15, kMainScreenWidth-30, 15)];
    self.effectiveTimelbl.font =[UIFont systemFontOfSize:15];
    self.effectiveTimelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.effectiveTimelbl];
    
    self.contractTypelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.effectiveTimelbl.frame.origin.y+self.effectiveTimelbl.frame.size.height+15, kMainScreenWidth-30, 15)];
    self.contractTypelbl.font =[UIFont systemFontOfSize:15];
    self.contractTypelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.contractTypelbl];
    
    self.commentbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.commentbtn.frame =CGRectMake(kMainScreenWidth-94, self.effectiveTimelbl.frame.origin.y+self.effectiveTimelbl.frame.size.height, 79, 30);
    [self.commentbtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
    [self.commentbtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
    self.commentbtn.titleLabel.font =[UIFont systemFontOfSize:15];
    [self.commentbtn setTitle:@"评论" forState:UIControlStateNormal];
    [self.commentbtn setTitle:@"评论" forState:UIControlStateHighlighted];
    [self.commentbtn addTarget:self action:@selector(myappraise:) forControlEvents:UIControlEventTouchUpInside];
    self.commentbtn.layer.masksToBounds = YES;
    self.commentbtn.layer.cornerRadius = 3;
    self.commentbtn.layer.borderColor = kThemeColor.CGColor;
    self.commentbtn.layer.borderWidth = 1;
    //                if (newcontract.orderState ==3) {
    
    self.commentbtn.hidden =YES;
    
    //                }
    [self.contentView addSubview:self.commentbtn];
    
    UIImageView *contractTypeline =[[UIImageView alloc] initWithFrame:CGRectMake(12, self.contractTypelbl.frame.origin.y+self.contractTypelbl.frame.size.height+15, kMainScreenWidth-24, 1)];
    contractTypeline.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [self.contentView addSubview:contractTypeline];
    int heighty=0;
    if (self.contractDetail.contractType!=4) {
        heighty =5;
    }
    self.contractTotalFeelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, contractTypeline.frame.origin.y+contractTypeline.frame.size.height+15, kMainScreenWidth-30, 15)];
    if (self.preferential&&self.contractDetail.contractType !=4&&[self.contractDetail.state doubleValue]==1) {
        self.contractTotalFeelbl.frame =CGRectMake(15, contractTypeline.frame.origin.y+contractTypeline.frame.size.height+5+heighty, kMainScreenWidth-30, 15);
    }
    self.contractTotalFeelbl.font =[UIFont systemFontOfSize:15];
    self.contractTotalFeelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.contractTotalFeelbl];
    
    self.realpaylbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.contractTotalFeelbl.frame.origin.y+self.contractTotalFeelbl.frame.size.height+5+heighty, kMainScreenWidth-30, 15)];
    if (self.contractDetail.contractType ==4) {
        self.realpaylbl.frame =CGRectMake(15, self.contractTotalFeelbl.frame.origin.y+self.contractTotalFeelbl.frame.size.height+13.5, kMainScreenWidth-30, 15);
    }
    self.realpaylbl.font =[UIFont systemFontOfSize:15];
    self.realpaylbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.realpaylbl];
    
    if (self.contractDetail.contractType!=4) {
        heighty =20;
    }
    self.orderFeelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.contractTotalFeelbl.frame.origin.y+self.contractTotalFeelbl.frame.size.height+15, (kMainScreenWidth-30)/2, 12)];
    if (self.preferential&&[self.contractDetail.state doubleValue]==1) {
        self.orderFeelbl.frame =CGRectMake(15, self.contractTotalFeelbl.frame.origin.y+self.contractTotalFeelbl.frame.size.height+45-heighty, (kMainScreenWidth-30)/2, 12);
    }else{
        if (self.contractDetail.contractTotalFee!=self.contractDetail.originalTotalFee) {
            self.orderFeelbl.frame =CGRectMake(15, self.contractTotalFeelbl.frame.origin.y+self.contractTotalFeelbl.frame.size.height+45-heighty, (kMainScreenWidth-30)/2, 12);
        }
    }
    self.orderFeelbl.font =[UIFont systemFontOfSize:12];
    self.orderFeelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.orderFeelbl];
    
    self.managerFeelbl =[[UILabel alloc] initWithFrame:CGRectMake(self.orderFeelbl.frame.origin.x+self.orderFeelbl.frame.size.width, self.contractTotalFeelbl.frame.origin.y+self.contractTotalFeelbl.frame.size.height+15, (kMainScreenWidth-30)/2, 12)];
    if (self.preferential&&[self.contractDetail.state doubleValue]==1) {
        self.managerFeelbl.frame =CGRectMake(self.orderFeelbl.frame.origin.x+self.orderFeelbl.frame.size.width, self.contractTotalFeelbl.frame.origin.y+self.contractTotalFeelbl.frame.size.height+45, (kMainScreenWidth-30)/2, 12);
    }else{
        if (self.contractDetail.contractTotalFee!=self.contractDetail.originalTotalFee) {
            self.managerFeelbl.frame =CGRectMake(self.orderFeelbl.frame.origin.x+self.orderFeelbl.frame.size.width, self.contractTotalFeelbl.frame.origin.y+self.contractTotalFeelbl.frame.size.height+45, (kMainScreenWidth-30)/2, 12);
        }
    }
    self.managerFeelbl.font =[UIFont systemFontOfSize:12];
    self.managerFeelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.managerFeelbl];
    UIImageView *couponlinehead;
    UIImageView *couponlinefoot;
    UIButton *couponbtn;
    UILabel *couponlbl;
    UILabel *couponcontent;
    
    if (self.couponNum>0&&[self.contractDetail.state doubleValue]==1) {
        couponlinehead =[[UIImageView alloc] initWithFrame:CGRectMake(15, self.orderFeelbl.frame.origin.y+self.orderFeelbl.frame.size.height+20-heighty, kMainScreenWidth-30, 1)];
        couponlinehead.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
        [self.contentView addSubview:couponlinehead];
        
        couponbtn =[UIButton buttonWithType:UIButtonTypeCustom];
        couponbtn.frame =CGRectMake(15, couponlinehead.frame.origin.y+couponlinehead.frame.size.height, kMainScreenWidth-30, 44);
        [couponbtn addTarget:self action:@selector(couponbtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:couponbtn];
        
        couponlbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 23.5, 51, 17)];
        couponlbl.text =@"优惠券";
        couponlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
        [couponbtn addSubview:couponlbl];
        
        NSString *contentstr =[NSString string];
        contentstr =[NSString stringWithFormat:@"可用优惠%d张",self.couponNum];
        if (self.preferential&&[self.contractDetail.state doubleValue]==1) {
            if (self.preferential.exitState==1) {
                if (self.preferential.couponType==0) {
                    if (self.contractDetail.contractTotalFee>[self.preferential.couponValue doubleValue]) {
                        contentstr =[NSString stringWithFormat:@"优惠￥ %@",self.preferential.couponValue];
                    }else{
                        contentstr =[NSString stringWithFormat:@"优惠￥ %.2f",self.contractDetail.contractTotalFee];
                    }
                }else{
                    contentstr =[NSString stringWithFormat:@"优惠￥ %.2f",self.contractDetail.contractTotalFee-[self.preferential.couponValue doubleValue]/10*self.contractDetail.contractTotalFee];
                }
            }else if (self.preferential.exitState==2){
                if (self.preferential.couponType==0) {
                    if (self.contractDetail.contractType!=4) {
                        if (self.contractDetail.contractTotalFee>[self.preferential.couponValue doubleValue]) {
                            contentstr =[NSString stringWithFormat:@"优惠￥ %@",self.preferential.couponValue];
                        }else{
                            contentstr =[NSString stringWithFormat:@"优惠￥ %.2f",self.contractDetail.contractTotalFee];
                        }
                    }else{
                        if (self.contractDetail.orderFee>[self.preferential.couponValue doubleValue]) {
                            contentstr =[NSString stringWithFormat:@"优惠工程直接款￥ %@",self.preferential.couponValue];
                        }else{
                            contentstr =[NSString stringWithFormat:@"优惠工程直接款￥ %.2f",self.contractDetail.orderFee];
                        }
                    }
                    
                }else{
                    if (self.contractDetail.contractType!=4) {
                        contentstr =[NSString stringWithFormat:@"优惠￥ %.2f",self.contractDetail.contractTotalFee-[self.preferential.couponValue doubleValue]/10*self.contractDetail.contractTotalFee];
                    }else{
                        contentstr =[NSString stringWithFormat:@"优惠工程直接款￥ %.2f",self.contractDetail.orderFee-[self.preferential.couponValue doubleValue]/10*self.contractDetail.orderFee];
                    }
                }
            }else if (self.preferential.exitState==3){
                if (self.preferential.couponType==0) {
                    if ((self.contractDetail.contractTotalFee-self.contractDetail.orderFee)>[self.preferential.couponValue doubleValue]) {
                        contentstr =[NSString stringWithFormat:@"优惠平台监理费￥ %@",self.preferential.couponValue];
                    }else{
                        contentstr =[NSString stringWithFormat:@"优惠平台监理费￥ %.2f",(self.contractDetail.contractTotalFee-self.contractDetail.orderFee)];
                    }
                    
                }else{
                    contentstr =[NSString stringWithFormat:@"优惠平台监理费￥ %.2f",(self.contractDetail.contractTotalFee-self.contractDetail.orderFee)-[self.preferential.couponValue doubleValue]/10*(self.contractDetail.contractTotalFee-self.contractDetail.orderFee)];
                }
            }
            
        }
        CGSize labelsize = [util calHeightForLabel:contentstr width:kMainScreenWidth-81 font:[UIFont systemFontOfSize:15]];
        couponcontent =[[UILabel alloc] initWithFrame:CGRectMake(couponlbl.frame.origin.x+couponlbl.frame.size.width+10, 22.5, labelsize.width+20, labelsize.height)];
//        if (self.preferential&&[self.contractDetail.state intValue]==1) {
//            couponcontent.frame =CGRectMake(couponlbl.frame.origin.x+couponlbl.frame.size.width+10, 8.5, labelsize.width+20, labelsize.height);
//        }
        couponcontent.tag =1000;
        couponcontent.textColor =[UIColor whiteColor];
        couponcontent.backgroundColor =[UIColor colorWithHexString:@"#ef6562"];
        couponcontent.font =[UIFont systemFontOfSize:15];
        couponcontent.text =contentstr;
        couponcontent.layer.masksToBounds = YES;
        couponcontent.layer.cornerRadius = 5;
        couponcontent.layer.borderColor = [UIColor colorWithHexString:@"#ef6562"].CGColor;
        couponcontent.layer.borderWidth = 1;
        couponcontent.textAlignment =NSTextAlignmentCenter;
        [couponbtn addSubview:couponcontent];
        
//        promptlbl =[[UILabel alloc] initWithFrame:CGRectMake(couponlbl.frame.origin.x+couponlbl.frame.size.width+10, couponcontent.frame.origin.y+couponcontent.frame.size.height+10, kMainScreenWidth-81, 15)];
//        if (self.preferential) {
//            promptlbl.text =@"优惠使用后不可退换";
//        }else{
//            promptlbl.text =@"";
//        }
//        promptlbl.font =[UIFont systemFontOfSize:15];
//        promptlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
//        [couponbtn addSubview:promptlbl];
        
        couponlinefoot =[[UIImageView alloc] initWithFrame:CGRectMake(15, couponbtn.frame.origin.y+couponbtn.frame.size.height+20, kMainScreenWidth-30, 1)];
        couponlinefoot.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
        [self.contentView addSubview:couponlinefoot];
    }
    if (self.contractDetail.originalTotalFee!=self.contractDetail.contractTotalFee) {
        couponlinehead =[[UIImageView alloc] initWithFrame:CGRectMake(15, self.orderFeelbl.frame.origin.y+self.orderFeelbl.frame.size.height+20-heighty, kMainScreenWidth-30, 1)];
        couponlinehead.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
        [self.contentView addSubview:couponlinehead];
        
        couponbtn =[UIButton buttonWithType:UIButtonTypeCustom];
        couponbtn.frame =CGRectMake(15, couponlinehead.frame.origin.y+couponlinehead.frame.size.height, kMainScreenWidth-30, 44);
//        [couponbtn addTarget:self action:@selector(couponbtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:couponbtn];
        
        couponlbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 23.5, 51, 17)];
        couponlbl.text =@"优惠券";
        couponlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
        [couponbtn addSubview:couponlbl];
        
        NSString *contentstr =[NSString string];
        contentstr =[NSString stringWithFormat:@"优惠%.2f",self.contractDetail.originalTotalFee-self.contractDetail.contractTotalFee];
        
        CGSize labelsize = [util calHeightForLabel:contentstr width:kMainScreenWidth-81 font:[UIFont systemFontOfSize:15]];
        couponcontent =[[UILabel alloc] initWithFrame:CGRectMake(couponlbl.frame.origin.x+couponlbl.frame.size.width+10, 22.5, labelsize.width+20, labelsize.height)];
        couponcontent.tag =1000;
        couponcontent.textColor =[UIColor whiteColor];
        couponcontent.backgroundColor =[UIColor colorWithHexString:@"#ef6562"];
        couponcontent.font =[UIFont systemFontOfSize:15];
        couponcontent.text =contentstr;
        couponcontent.layer.masksToBounds = YES;
        couponcontent.layer.cornerRadius = 5;
        couponcontent.layer.borderColor = [UIColor colorWithHexString:@"#ef6562"].CGColor;
        couponcontent.layer.borderWidth = 1;
        couponcontent.textAlignment =NSTextAlignmentCenter;
        [couponbtn addSubview:couponcontent];
        
 
        
        couponlinefoot =[[UIImageView alloc] initWithFrame:CGRectMake(15, couponbtn.frame.origin.y+couponbtn.frame.size.height+20, kMainScreenWidth-30, 1)];
        couponlinefoot.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
        [self.contentView addSubview:couponlinefoot];
    }

    self.partyAlbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.orderFeelbl.frame.origin.y+self.orderFeelbl.frame.size.height+20, 30, 14)];
    if (self.contractDetail.contractType!=4) {
        self.partyAlbl.frame=CGRectMake(15, self.contractTotalFeelbl.frame.origin.y+self.contractTotalFeelbl.frame.size.height+15, 30, 14);
        if (self.contractDetail.contractTotalFee!=self.contractDetail.originalTotalFee) {
            self.partyAlbl.frame =CGRectMake(15, couponlinefoot.frame.origin.y+couponlinefoot.frame.size.height+15, 30, 14);
        }
        if (self.couponNum>0&&[self.contractDetail.state doubleValue]==1) {
            self.partyAlbl.frame=CGRectMake(15, couponlinefoot.frame.origin.y+couponlinefoot.frame.size.height+15, 30, 14);
        }
    }else{
        if (self.contractDetail.contractTotalFee!=self.contractDetail.originalTotalFee) {
            self.partyAlbl.frame =CGRectMake(15, couponlinefoot.frame.origin.y+couponlinefoot.frame.size.height+15, 30, 14);
        }
        if (self.couponNum>0&&[self.contractDetail.state doubleValue]==1) {
            self.partyAlbl.frame=CGRectMake(15, couponlinefoot.frame.origin.y+couponlinefoot.frame.size.height+20, 30, 14);
        }
    }
    
    self.partyAlbl.font =[UIFont systemFontOfSize:14.0];
    self.partyAlbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
    self.partyAlbl.text =@"甲方";
    [self.contentView addSubview:self.partyAlbl];
    
    self.partyAline =[[UIImageView alloc] initWithFrame:CGRectMake(self.partyAlbl.frame.origin.x+self.partyAlbl.frame.size.width+5, self.partyAlbl.frame.origin.y+6,kMainScreenWidth-15-self.partyAlbl.frame.origin.x-self.partyAlbl.frame.size.width-5 , 1)];
    self.partyAline.backgroundColor =[UIColor colorWithHexString:@"#ef6562"];
    [self.contentView addSubview:self.partyAline];
    
    self.userNamelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.partyAline.frame.origin.y+self.partyAline.frame.size.height+25, kMainScreenWidth-30, 15)];
    self.userNamelbl.font =[UIFont systemFontOfSize:15];
    self.userNamelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.userNamelbl];
    
    self.userPhoneNolbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.userNamelbl.frame.origin.y+self.userNamelbl.frame.size.height+15, kMainScreenWidth-30, 15)];
    self.userPhoneNolbl.font =[UIFont systemFontOfSize:15];
    self.userPhoneNolbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.userPhoneNolbl];
    
    self.houseArealbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.userPhoneNolbl.frame.origin.y+self.userPhoneNolbl.frame.size.height+15, kMainScreenWidth-30, 15)];
    self.houseArealbl.font =[UIFont systemFontOfSize:15];
    self.houseArealbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.houseArealbl];
    
    self.userCommunityNamelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.houseArealbl.frame.origin.y+self.houseArealbl.frame.size.height+15, kMainScreenWidth-30, 15)];
    self.userCommunityNamelbl.font =[UIFont systemFontOfSize:15];
    self.userCommunityNamelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.userCommunityNamelbl];
    
    self.userAddrlbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.userCommunityNamelbl.frame.origin.y+self.userCommunityNamelbl.frame.size.height+15, kMainScreenWidth-30, 15)];
    CGSize labelsize1 = [util calHeightForLabel:[NSString stringWithFormat:@"小区地址: %@",self.contractDetail.userAddr] width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:15]];
    self.userAddrlbl.numberOfLines =0;
    self.userAddrlbl.frame =CGRectMake(15, self.userCommunityNamelbl.frame.origin.y+self.userCommunityNamelbl.frame.size.height+15, labelsize1.width, labelsize1.height);
    self.userAddrlbl.font =[UIFont systemFontOfSize:15];
    self.userAddrlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.userAddrlbl];
    
    self.partyBlbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.userAddrlbl.frame.origin.y+self.userAddrlbl.frame.size.height+20, 30, 14)];
    self.partyBlbl.font =[UIFont systemFontOfSize:14.0];
    self.partyBlbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
    self.partyBlbl.text =@"乙方";
    [self.contentView addSubview:self.partyBlbl];
    
    self.partyBline =[[UIImageView alloc] initWithFrame:CGRectMake(self.partyBlbl.frame.origin.x+self.partyBlbl.frame.size.width+5, self.partyBlbl.frame.origin.y+6,kMainScreenWidth-15-self.partyBlbl.frame.origin.x-self.partyBlbl.frame.size.width-5 , 1)];
    self.partyBline.backgroundColor =[UIColor colorWithHexString:@"#ef6562"];
    [self.contentView addSubview:self.partyBline];
    
    self.servantNamelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.partyBline.frame.origin.y+self.partyBline.frame.size.height+25, kMainScreenWidth-30, 15)];
    self.servantNamelbl.font =[UIFont systemFontOfSize:15];
    self.servantNamelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.servantNamelbl];
    
    self.servantPhoneNolbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.servantNamelbl.frame.origin.y+self.servantNamelbl.frame.size.height+15, kMainScreenWidth-30, 15)];
    self.servantPhoneNolbl.font =[UIFont systemFontOfSize:15];
    self.servantPhoneNolbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.servantPhoneNolbl];
    
    self.durationlbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.servantPhoneNolbl.frame.origin.y+self.servantPhoneNolbl.frame.size.height+15, kMainScreenWidth-30, 15)];
    self.durationlbl.font =[UIFont systemFontOfSize:15];
    self.durationlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.durationlbl];
    
    self.partyClbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.durationlbl.frame.origin.y+self.durationlbl.frame.size.height+20, 30, 14)];
    self.partyClbl.font =[UIFont systemFontOfSize:14.0];
    self.partyClbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
    self.partyClbl.text =@"丙方";
    [self.contentView addSubview:self.partyClbl];
    
    self.partyCline =[[UIImageView alloc] initWithFrame:CGRectMake(self.partyClbl.frame.origin.x+self.partyClbl.frame.size.width+15, self.partyClbl.frame.origin.y+6,kMainScreenWidth-15-self.partyClbl.frame.origin.x-self.partyClbl.frame.size.width-5 , 1)];
    self.partyCline.backgroundColor =[UIColor colorWithHexString:@"#ef6562"];
    [self.contentView addSubview:self.partyCline];
    
    self.companyNametitle =[[UILabel alloc] initWithFrame:CGRectMake(15, self.partyCline.frame.origin.y+self.partyCline.frame.size.height+25, 70, 15)];
    self.companyNametitle.font =[UIFont systemFontOfSize:15];
    self.companyNametitle.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.companyNametitle];
    
    self.companyNamelbl =[[UILabel alloc] initWithFrame:CGRectMake(self.companyNametitle.frame.origin.x+self.companyNametitle.frame.size.width, self.partyCline.frame.origin.y+self.partyCline.frame.size.height+25, kMainScreenWidth-85, 15)];
    self.companyNamelbl.font =[UIFont systemFontOfSize:15];
    self.companyNamelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.companyNamelbl];
    
    self.companyTellbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.companyNametitle.frame.origin.y+self.companyNametitle.frame.size.height+15, (kMainScreenWidth-30)/2, 15)];
    self.companyTellbl.font =[UIFont systemFontOfSize:15];
    self.companyTellbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.companyTellbl];
    
    self.managerTitlelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.companyTellbl.frame.origin.y+self.companyTellbl.frame.size.height+15, kMainScreenWidth-30, 15)];
    self.managerTitlelbl.font =[UIFont systemFontOfSize:15];
    self.managerTitlelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.managerTitlelbl];
    
    self.platformSuperFeelbl =[[UILabel alloc] initWithFrame:CGRectMake(80, self.managerTitlelbl.frame.origin.y+self.managerTitlelbl.frame.size.height+15, kMainScreenWidth-105, 15)];
    self.platformSuperFeelbl.font =[UIFont systemFontOfSize:15];
    self.platformSuperFeelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentView addSubview:self.platformSuperFeelbl];
    
    if (self.contractDetail.sysSupervisorName.length>0) {
        UIView *superline =[[UIView alloc] initWithFrame:CGRectMake(15, self.platformSuperFeelbl.frame.origin.y+self.platformSuperFeelbl.frame.size.height+14, kMainScreenWidth-30, 1)];
        superline.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
        [self.contentView addSubview:superline];
        self.supervisionlbl =[[UILabel alloc] initWithFrame:CGRectMake(80, superline.frame.origin.y+superline.frame.size.height+15, kMainScreenWidth-105, 15)];
        self.supervisionlbl.font =[UIFont systemFontOfSize:15];
        self.supervisionlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
        [self.contentView addSubview:self.supervisionlbl];
    }
    self.footView =[[UIView alloc] initWithFrame:CGRectZero];
    self.footView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [self.contentView addSubview:self.footView];
//    NSLog(@"%@",[self.contentView subviews]);
}
-(void)innerInit{
    
}
-(CGFloat)getCellHeight{
//    NSLog(@"%@",[self.contentView subviews]);
    CGFloat height=0;
    if ([self.contractDetail.state doubleValue]==4) {
        self.commentbtn.hidden =NO;
    }
    self.nickNamelbl.text=self.contractDetail.userName;
    self.contractstate.text =self.contractDetail.stateName;
    if (self.contractDetail.attChangeStateName.length>0) {
        if (self.contractDetail.attChangeState ==1) {
            self.contractstate.text =self.contractDetail.attChangeStateName;
        }
    }
    self.orderlbl.text =[NSString stringWithFormat:@"合同编号: %@",self.orderCode];
    NSLog(@"%@",self.contractDetail.effectiveTime);
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self.contractDetail.effectiveTime longLongValue]/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *replasestr =[formatter stringFromDate:date];
    self.effectiveTimelbl.text =[NSString stringWithFormat:@"合同日期: %@",replasestr];
    NSString *type =[NSString string];
    switch (self.contractDetail.contractType) {
        case 1:
            type =@"设计服务";
            break;
        case 6:
            type =@"监理服务";
            break;
        case 3:
            type =@"小工服务";
            break;
        case 4:
            type =@"施工服务";
            break;
            
        default:
            break;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合同类型: %@",type]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,5)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str.length-5)];
    self.contractTypelbl.attributedText = str;
    
    NSMutableAttributedString *totalFeestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合同金额: ¥ %.2f",self.contractDetail.originalTotalFee]];
    [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,5)];
    [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,totalFeestr.length-5)];
    self.contractTotalFeelbl.attributedText = totalFeestr;
    double orderproportion =self.contractDetail.orderFee/self.contractDetail.contractTotalFee;
    double serverproportion =(self.contractDetail.contractTotalFee-self.contractDetail.orderFee)/self.contractDetail.contractTotalFee;
    if (self.preferential&&[self.contractDetail.state doubleValue]==1) {
        NSString *contractTotalFee =[NSString string];
        if (self.preferential.couponType ==0) {
            if (self.preferential.exitState ==1) {
                if (self.contractDetail.contractTotalFee>[self.preferential.couponValue doubleValue]) {
                    contractTotalFee =[NSString stringWithFormat:@"实付金额: ¥ %.2f",self.contractDetail.contractTotalFee-[self.preferential.couponValue doubleValue]];
                    if (self.contractDetail.contractType==4){
                        self.orderFeelbl.text =[NSString stringWithFormat:@"工程直接款: ¥ %.2f",self.contractDetail.orderFee+[self.preferential.couponValue doubleValue]*serverproportion-[self.preferential.couponValue doubleValue]];
                        self.managerFeelbl.text =[NSString stringWithFormat:@"监理服务费: ¥ %.2f",self.contractDetail.contractTotalFee-self.contractDetail.orderFee-[self.preferential.couponValue doubleValue]*serverproportion];
                    }
                }else{
                    contractTotalFee =[NSString stringWithFormat:@"实付金额: ¥ 0"];
                    if (self.contractDetail.contractType==4){
                        self.orderFeelbl.text =[NSString stringWithFormat:@"工程直接款: ¥ 0"];
                        self.managerFeelbl.text =[NSString stringWithFormat:@"监理服务费: ¥ 0"];
                    }
                }
            }else if (self.preferential.exitState ==2){
                if (self.contractDetail.orderFee>[self.preferential.couponValue doubleValue]) {
                    contractTotalFee =[NSString stringWithFormat:@"实付金额: ¥ %.2f",self.contractDetail.contractTotalFee-[self.preferential.couponValue doubleValue]];
                    if (self.contractDetail.contractType==4){
                        self.orderFeelbl.text =[NSString stringWithFormat:@"工程直接款: ¥ %.2f",self.contractDetail.orderFee-[self.preferential.couponValue doubleValue]];
                        self.managerFeelbl.text =[NSString stringWithFormat:@"监理服务费: ¥ %.2f",self.contractDetail.contractTotalFee-self.contractDetail.orderFee];
                    }
                }else{
                    contractTotalFee =[NSString stringWithFormat:@"实付金额: ¥ %.2f",self.contractDetail.contractTotalFee-self.contractDetail.orderFee];
                    if (self.contractDetail.contractType==4){
                        self.orderFeelbl.text =[NSString stringWithFormat:@"工程直接款: ¥ 0"];
                        self.managerFeelbl.text =[NSString stringWithFormat:@"监理服务费: ¥ %.2f",self.contractDetail.contractTotalFee-self.contractDetail.orderFee];
                    }
                }
            }else if (self.preferential.exitState ==3){
                if (self.contractDetail.contractTotalFee-self.contractDetail.orderFee>[self.preferential.couponValue doubleValue]) {
                    contractTotalFee =[NSString stringWithFormat:@"实付金额: ¥ %.2f",self.contractDetail.contractTotalFee-[self.preferential.couponValue doubleValue]];
                    if (self.contractDetail.contractType==4){
                        self.managerFeelbl.text =[NSString stringWithFormat:@"监理服务费: ¥ %.2f",self.contractDetail.contractTotalFee-self.contractDetail.orderFee-[self.preferential.couponValue doubleValue]];
                        self.orderFeelbl.text =[NSString stringWithFormat:@"工程直接款: ¥ %.2f",self.contractDetail.orderFee];
                        
                    }
                }else{
                    contractTotalFee =[NSString stringWithFormat:@"实付金额: ¥ %.2f",self.contractDetail.orderFee];
                    if (self.contractDetail.contractType==4){
                        self.managerFeelbl.text =[NSString stringWithFormat:@"监理服务费: ¥ 0"];
                        self.orderFeelbl.text =[NSString stringWithFormat:@"工程直接款: ¥ %.2f",self.contractDetail.orderFee];
                        
                    }
                }
            }
            
        }else{
            if (self.preferential.exitState ==1) {
                contractTotalFee =[NSString stringWithFormat:@"实付金额: ¥ %.2f",self.contractDetail.contractTotalFee*[self.preferential.couponValue doubleValue]/10];
            }else if (self.preferential.exitState ==2){
                contractTotalFee =[NSString stringWithFormat:@"实付金额: ¥ %.2f",self.contractDetail.orderFee*[self.preferential.couponValue doubleValue]/10+self.contractDetail.contractTotalFee-self.contractDetail.orderFee];
            }else if (self.preferential.exitState==3){
                contractTotalFee =[NSString stringWithFormat:@"实付金额: ¥ %.2f",(self.contractDetail.contractTotalFee-self.contractDetail.orderFee)*[self.preferential.couponValue doubleValue]/10+self.contractDetail.orderFee];
            }
            if (self.contractDetail.contractType==4){
                if (self.preferential.exitState==1) {
                    self.orderFeelbl.text =[NSString stringWithFormat:@"工程直接款: ¥ %.2f",self.contractDetail.orderFee*[self.preferential.couponValue doubleValue]/10];
                    self.managerFeelbl.text =[NSString stringWithFormat:@"监理服务费: ¥ %.2f",(self.contractDetail.contractTotalFee-self.contractDetail.orderFee)*[self.preferential.couponValue doubleValue]/10];
                }else if (self.preferential.exitState==2){
                    self.orderFeelbl.text =[NSString stringWithFormat:@"工程直接款: ¥ %.2f",self.contractDetail.orderFee*[self.preferential.couponValue doubleValue]/10];
                    self.managerFeelbl.text =[NSString stringWithFormat:@"监理服务费: ¥ %.2f",(self.contractDetail.contractTotalFee-self.contractDetail.orderFee)];
                }else if (self.preferential.exitState==3){
                    self.orderFeelbl.text =[NSString stringWithFormat:@"工程直接款: ¥ %.2f",self.contractDetail.orderFee];
                    self.managerFeelbl.text =[NSString stringWithFormat:@"监理服务费: ¥ %.2f",(self.contractDetail.contractTotalFee-self.contractDetail.orderFee)*[self.preferential.couponValue doubleValue]/10];
                }
                
            }
        }
        NSMutableAttributedString *realpayFeestr = [[NSMutableAttributedString alloc] initWithString:contractTotalFee];
        [realpayFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,5)];
        [realpayFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,realpayFeestr.length-5)];
        self.realpaylbl.attributedText =realpayFeestr;
    }else{
        if (self.contractDetail.contractType==4){
            self.orderFeelbl.text =[NSString stringWithFormat:@"工程直接款: ¥ %.2f",self.contractDetail.orderFee];
            self.managerFeelbl.text =[NSString stringWithFormat:@"监理服务费: ¥ %.2f",self.contractDetail.contractTotalFee-self.contractDetail.orderFee];
        }
        if (self.contractDetail.originalTotalFee!=self.contractDetail.contractTotalFee) {
            NSString *contractTotalFee =[NSString string];
            contractTotalFee =[NSString stringWithFormat:@"实付金额: ¥ %.2f",self.contractDetail.contractTotalFee];
            NSMutableAttributedString *realpayFeestr = [[NSMutableAttributedString alloc] initWithString:contractTotalFee];
            [realpayFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,5)];
            [realpayFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,realpayFeestr.length-5)];
            self.realpaylbl.attributedText =realpayFeestr;
        }
    }
    
    
    self.userNamelbl.text =[NSString stringWithFormat:@"甲       方: %@",self.contractDetail.userName];
    self.userPhoneNolbl.text =[NSString stringWithFormat:@"电       话: %@",self.contractDetail.userPhoneNo];
    self.houseArealbl.text =[NSString stringWithFormat:@"房屋面积: %@㎡",self.contractDetail.houseArea];
    self.userCommunityNamelbl.text =[NSString stringWithFormat:@"小区名称: %@",self.contractDetail.userCommunityName];
    
    self.userAddrlbl.text =[NSString stringWithFormat:@"小区地址: %@",self.contractDetail.userAddr];
    
    self.servantNamelbl.text =[NSString stringWithFormat:@"乙       方: %@",self.contractDetail.servantName];
    self.servantPhoneNolbl.text =[NSString stringWithFormat:@"电       话: %@",self.contractDetail.servantPhoneNo];
    self.durationlbl.text =[NSString stringWithFormat:@"工       期: %d天",self.contractDetail.duration];
    self.companyNametitle.text =@"丙       方:";
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    CGSize size = CGSizeMake(kMainScreenWidth-100,2000);
    NSString *context=self.contractDetail.companyName;
    CGSize labelsize = [context sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    self.companyNamelbl.lineBreakMode = UILineBreakModeWordWrap;
    self.companyNamelbl.numberOfLines =2;
    if (labelsize.height>15) {
        self.companyNamelbl.frame =CGRectMake(self.companyNamelbl.frame.origin.x, self.companyNamelbl.frame.origin.y, labelsize.width, labelsize.height);
    }else{
        self.companyNamelbl.frame =CGRectMake(self.companyNamelbl.frame.origin.x, self.companyNamelbl.frame.origin.y, labelsize.width, labelsize.height);
    }
    self.companyNamelbl.text =context;
    self.companyNamelbl.font =font;
    
    self.companyTellbl.text =[NSString stringWithFormat:@"电       话: %@",self.contractDetail.companyTel];
    self.companyTellbl.frame =CGRectMake(self.companyTellbl.frame.origin.x, self.companyNamelbl.frame.origin.y+self.companyNamelbl.frame.size.height+10, kMainScreenWidth-30, self.companyTellbl.frame.size.height);
    //    if (self.contractDetail.contractType==4) {
    //        if ([self.contractDetail.ppDiscount doubleValue]>0) {
    //            self.managerTitlelbl.text =[NSString stringWithFormat:@"管理费用: 成品保护 ¥ %.0f (享%@折)",self.contractDetail.productProFee,self.contractDetail.ppDiscount];
    //        }else{
    //            self.managerTitlelbl.text =[NSString stringWithFormat:@"管理费用: 成品保护 ¥ %.0f",self.contractDetail.productProFee];
    //        }
    //        if ([self.contractDetail.psDiscount doubleValue]>0) {
    //            self.platformSuperFeelbl.text =[NSString stringWithFormat:@" 平台监管 ¥ %.0f (享%@折)",self.contractDetail.platformSuperFee,self.contractDetail.psDiscount];
    //        }else{
    //            self.platformSuperFeelbl.text =[NSString stringWithFormat:@" 平台监管 ¥ %.0f",self.contractDetail.platformSuperFee];
    //        }
    //        height=self.platformSuperFeelbl.frame.origin.y+self.platformSuperFeelbl.frame.size.height+30;
    //        return height;
    //    }else{
    //        height=self.companyTellbl.frame.origin.y+self.companyTellbl.frame.size.height+30;
    //        return height;
    //    }
    if (self.contractDetail.sysSupervisorName.length>0) {
        if (self.contractDetail.superType ==6) {
            self.supervisionlbl.text =[NSString stringWithFormat:@"该合同已为你关联第三方监理— —%@",self.contractDetail.sysSupervisorName];
        }else{
            self.supervisionlbl.text =[NSString stringWithFormat:@"该合同已为你关联平台监理— —%@",self.contractDetail.sysSupervisorName];
        }
        self.footView.frame =CGRectMake(0, self.supervisionlbl.frame.origin.y+self.supervisionlbl.frame.size.height+10, kMainScreenWidth, 10);
        return height=self.supervisionlbl.frame.origin.y+self.supervisionlbl.frame.size.height+30;
    }else{
        self.footView.frame =CGRectMake(0, self.companyTellbl.frame.origin.y+self.companyTellbl.frame.size.height+30-10, kMainScreenWidth, 10);
        return height=self.companyTellbl.frame.origin.y+self.companyTellbl.frame.size.height+30;
    }
    
    
}
-(void)couponbtn:(UIButton *)sender{
    [self.delegate touchButton:sender];
}
-(void)myappraise:(UIButton *)sender{
    [self.delegate touchComment];
}
@end
