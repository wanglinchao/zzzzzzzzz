//
//  ManageFeeCell.m
//  IDIAI
//
//  Created by Ricky on 15/12/25.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ManageFeeCell.h"
@interface ManageFeeCell ()
@property(nonatomic,strong)UILabel *manageFeelbl;
@property(nonatomic,strong)UILabel *orderCodelbl;
@property(nonatomic,strong)UILabel *phaseDesclbl;
@property(nonatomic,strong)UILabel *productProFeelbl;
@property(nonatomic,strong)UILabel *psDiscountlbl;
@property(nonatomic,strong)UILabel *platformSuperFeelbl;
@property(nonatomic,strong)UIView *footView;
@property(nonatomic,strong)UILabel *ppDiscountlbl;
@end
@implementation ManageFeeCell
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
-(void)innerInit{
    self.manageFeelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 15, kMainScreenWidth-30, 15)];
    self.manageFeelbl.font =[UIFont systemFontOfSize:15];
    self.manageFeelbl.textColor =[UIColor colorWithHexString:@"#575757"];
    [self addSubview:self.manageFeelbl];
    
    self.orderCodelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.manageFeelbl.frame.origin.y+self.manageFeelbl.frame.size.height+11, kMainScreenWidth-30, 12)];
    self.orderCodelbl.font =[UIFont systemFontOfSize:12];
    self.orderCodelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self addSubview:self.orderCodelbl];
    
    self.platformSuperFeelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.orderCodelbl.frame.origin.y+self.orderCodelbl.frame.size.height+15, kMainScreenWidth-30, 12)];
    self.platformSuperFeelbl.font =[UIFont systemFontOfSize:12];
    self.platformSuperFeelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self addSubview:self.platformSuperFeelbl];
    
    self.productProFeelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.platformSuperFeelbl.frame.origin.y+self.platformSuperFeelbl.frame.size.height+10, kMainScreenWidth-30, 12)];
    self.productProFeelbl.font =[UIFont systemFontOfSize:12];
    self.productProFeelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self addSubview:self.productProFeelbl];
    
    
    self.phaseDesclbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.productProFeelbl.frame.origin.y+self.productProFeelbl.frame.size.height+15, kMainScreenWidth-30, 12)];
    self.phaseDesclbl.font =[UIFont systemFontOfSize:12];
    self.phaseDesclbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self addSubview:self.phaseDesclbl];
    
    self.footView =[[UIView alloc] initWithFrame:CGRectZero];
    self.footView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [self addSubview:self.footView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setPsDiscount:(NSString *)psDiscount{
    _psDiscount =psDiscount;
}
-(CGFloat)getCellHeight{
    int height =0;
    double prefertialpay =0;
    if (self.prefertial) {
        if (self.prefertial.exitState==1) {
            if (self.prefertial.couponType ==0) {
                prefertialpay =[self.prefertial.couponValue doubleValue]*[self.orderObject.phaseOrderFee doubleValue]/self.contractTotalFee;
            }else if (self.prefertial.couponType ==1){
                prefertialpay =[self.orderObject.phaseOrderFee doubleValue]*(1-[self.prefertial.couponValue doubleValue]/10);
            }
            
        }else if (self.prefertial.exitState==3){
            if (self.prefertial.couponType ==0) {
                prefertialpay =[self.prefertial.couponValue doubleValue];
            }else if (self.prefertial.couponType ==1){
                prefertialpay =[self.orderObject.phaseOrderFee doubleValue]*(1-[self.prefertial.couponValue doubleValue]/100);
            }
            
        }
    }
    NSMutableAttributedString *totalFeestr;
    NSLog(@"%f",[self.orderObject.phaseOrderFee doubleValue]-prefertialpay);
    if ([self.orderObject.phaseOrderFee doubleValue]-prefertialpay<=0) {
        totalFeestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"监理服务费: ¥ 0"]];
    }else{
       totalFeestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"监理服务费: ¥ %.2f",[self.orderObject.phaseOrderFee doubleValue]-prefertialpay]];
    }
    
    [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,5)];
    [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(5,totalFeestr.length-5)];
     self.manageFeelbl.attributedText = totalFeestr;
    
    self.orderCodelbl.text =[NSString stringWithFormat:@"订单编号: %@",self.orderObject.phaseOrderCode];
    if (self.orderObject.phaseOrderCode.length<=0) {
        self.orderCodelbl.hidden =YES;
    }else{
        self.orderCodelbl.hidden =NO;
    }
    int addheight =-59;
    if (self.type ==4) {
        NSMutableAttributedString *productProFee;
        NSString *productProFeelenth =[NSString stringWithFormat:@"%.2f",self.platformSuperFee-prefertialpay*self.platformSuperFee/[self.orderObject.phaseOrderFee doubleValue]];
        if ([self.psDiscount doubleValue]>0) {
            NSLog(@"%.2f",self.platformSuperFee-prefertialpay*self.platformSuperFee/[self.orderObject.phaseOrderFee doubleValue]);
            if ([self.orderObject.phaseOrderFee doubleValue]==0) {
                productProFee = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"平台监理: ¥ 0  %@折",self.psDiscount]];
            }else{
                productProFee = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"平台监理: ¥ %.2f  %@折",self.platformSuperFee-prefertialpay*self.platformSuperFee/[self.orderObject.phaseOrderFee doubleValue],self.psDiscount]];
            }
            
//            productProFee = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"平台监理: ¥ %.2f  %@折",[self.orderObject.phaseOrderFee doubleValue]-prefertialpay-(self.productProFee-prefertialpay*self.productProFee/[self.orderObject.phaseOrderFee doubleValue]),self.psDiscount]];
            [productProFee addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,8+productProFeelenth.length)];
            [productProFee addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(8+productProFeelenth.length,productProFee.length-8-productProFeelenth.length)];
            
        }else{
            if ([self.orderObject.phaseOrderFee doubleValue]==0) {
                productProFee = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"平台监理: ¥ 0  %@折",self.psDiscount]];
            }else{
                productProFee = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"平台监理: ¥ %.2f",self.platformSuperFee-prefertialpay*self.platformSuperFee/[self.orderObject.phaseOrderFee doubleValue]]];
            }
            
            [productProFee addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,7+productProFeelenth.length)];
        }
        addheight =addheight+12+15;
        self.productProFeelbl.attributedText =productProFee;
        NSMutableAttributedString *platformSuperFee;
        NSString *platformSuperFeelenth =[NSString stringWithFormat:@"%.2f",self.productProFee-prefertialpay*self.productProFee/[self.orderObject.phaseOrderFee doubleValue]];
        if ([self.ppDiscount doubleValue]>0) {
            if ([self.orderObject.phaseOrderFee doubleValue]==0) {
                platformSuperFee = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"成品保护: ¥ 0  %@折",self.psDiscount]];
            }else{
                platformSuperFee = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"成品保护: ¥ %.2f %@折",self.productProFee-prefertialpay*self.productProFee/[self.orderObject.phaseOrderFee doubleValue],self.ppDiscount]];
            }
            
            [platformSuperFee addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,8+platformSuperFeelenth.length)];
            [platformSuperFee addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(8+platformSuperFeelenth.length,platformSuperFee.length-8-platformSuperFeelenth.length)];
            
        }else{
            if ([self.orderObject.phaseOrderFee doubleValue]==0) {
                platformSuperFee = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"成品保护: ¥ 0  %@折",self.psDiscount]];
            }else{
                platformSuperFee = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"成品保护: ¥ %.2f",self.productProFee-prefertialpay*self.productProFee/[self.orderObject.phaseOrderFee doubleValue]]];
            }
            
            [platformSuperFee addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,7+platformSuperFeelenth.length)];
        }
        addheight =addheight+12+10;
        self.platformSuperFeelbl.attributedText =platformSuperFee;
    }else{
        self.productProFeelbl.text =@"";
        self.platformSuperFeelbl.text =@"";
    }
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    CGSize size = CGSizeMake(kMainScreenWidth-30,2000);
    NSString *context=self.orderObject.phaseDesc;
    CGSize labelsize = [context sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    self.phaseDesclbl.lineBreakMode = UILineBreakModeWordWrap;
    self.phaseDesclbl.numberOfLines =0;
    float desheight =0;
    if (addheight ==-59) {
        desheight =self.orderCodelbl.frame.size.height+self.orderCodelbl.frame.origin.y;
    }else{
        desheight =self.productProFeelbl.frame.size.height+self.productProFeelbl.frame.origin.y;
    }
    self.phaseDesclbl.frame =CGRectMake(self.phaseDesclbl.frame.origin.x, desheight+15, labelsize.width, labelsize.height);
    self.phaseDesclbl.text =context;
    self.phaseDesclbl.font =font;
    
    self.footView.frame =CGRectMake(0, self.phaseDesclbl.frame.size.height+self.phaseDesclbl.frame.origin.y+15, kMainScreenWidth, 10);
    height =self.phaseDesclbl.frame.size.height+self.phaseDesclbl.frame.origin.y+25;
    return height;
}
@end
