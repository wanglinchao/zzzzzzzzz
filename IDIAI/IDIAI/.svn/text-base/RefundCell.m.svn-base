//
//  RefundCell.m
//  IDIAI
//
//  Created by Ricky on 16/1/4.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "RefundCell.h"
#import "UIImageView+WebCache.h"
@interface RefundCell ()
@property(nonatomic,strong)UIImageView *userLogo;
@property(nonatomic,strong)UILabel *namelbl;
@property(nonatomic,strong)UILabel *statelbl;
@property(nonatomic,strong)UILabel *orderNum;
@property(nonatomic,strong)UILabel *orderName;
@property(nonatomic,strong)UILabel *orderFee;
@property(nonatomic,strong)UILabel *phaseLastDate;
@property(nonatomic,strong)UIButton *eventBtn;
@property(nonatomic,strong)UIView *footView;
@end
@implementation RefundCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
        //        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
        //        cell.TitleArrow.transform = transform;
    }
    return self;
}
-(void)innerInit{
    self.userLogo =[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
    self.userLogo.layer.masksToBounds = YES;
    self.userLogo.layer.cornerRadius = 15;
    [self addSubview:self.userLogo];
    
    self.namelbl =[[UILabel alloc] initWithFrame:CGRectMake(self.userLogo.frame.size.width+self.userLogo.frame.origin.x+15, 15, 100, 15)];
    self.namelbl.textColor =[UIColor colorWithHexString:@"#575757"];
    self.namelbl.font =[UIFont systemFontOfSize:15.0];
    [self addSubview:self.namelbl];
    
    self.statelbl =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-30-200, 15, 200, 15)];
    self.statelbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
    self.statelbl.font =[UIFont systemFontOfSize:15.0];
    self.statelbl.textAlignment =NSTextAlignmentRight;
    [self addSubview:self.statelbl];
    
    UIImageView *lineimage =[[UIImageView alloc] initWithFrame:CGRectMake(12, self.userLogo.frame.origin.y+self.userLogo.frame.size.height+10, kMainScreenWidth-24, 1)];
    lineimage.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [self addSubview:lineimage];
    
    self.orderNum =[[UILabel alloc] initWithFrame:CGRectMake(15, lineimage.frame.origin.y+lineimage.frame.size.height+14, kMainScreenWidth-30, 14)];
    self.orderNum.textColor =[UIColor colorWithHexString:@"#575757"];
    self.orderNum.font =[UIFont systemFontOfSize:14];
    [self addSubview:self.orderNum];
    
    self.orderName =[[UILabel alloc] initWithFrame:CGRectMake(15, self.orderNum.frame.origin.y+self.orderNum.frame.size.height+12, kMainScreenWidth-30, 14)];
    self.orderName.textColor =[UIColor colorWithHexString:@"#575757"];
    self.orderName.font =[UIFont systemFontOfSize:14];
    [self addSubview:self.orderName];
    
    self.orderFee =[[UILabel alloc] initWithFrame:CGRectMake(15, self.orderName.frame.origin.y+self.orderName.frame.size.height+12, kMainScreenWidth-30, 14)];
    self.orderFee.textColor =[UIColor colorWithHexString:@"#575757"];
    self.orderFee.font =[UIFont systemFontOfSize:14];
    [self addSubview:self.orderFee];
    
    self.phaseLastDate =[[UILabel alloc] initWithFrame:CGRectMake(15, self.orderFee.frame.origin.y+self.orderFee.frame.size.height+12, kMainScreenWidth-30, 14)];
    self.phaseLastDate.textColor =[UIColor colorWithHexString:@"#575757"];
    self.phaseLastDate.font =[UIFont systemFontOfSize:14];
    [self addSubview:self.phaseLastDate];
    
    self.eventBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.eventBtn.frame =CGRectMake(kMainScreenWidth-15-70, self.phaseLastDate.frame.origin.y+self.phaseLastDate.frame.size.height+15, 70, 25);
    [self.eventBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
    [self.eventBtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
    self.eventBtn.titleLabel.font =[UIFont systemFontOfSize:14.0];
    self.eventBtn.layer.borderColor = [UIColor colorWithHexString:@"#ef6562" alpha:0.6].CGColor;
    self.eventBtn.layer.borderWidth = 1.0;
    self.eventBtn.layer.masksToBounds = YES;
    self.eventBtn.layer.cornerRadius = 5;
    [self addSubview:self.eventBtn];
    
    self.footView =[[UIView alloc] initWithFrame:CGRectMake(0, 210, kMainScreenWidth, 10)];
    self.footView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [self addSubview:self.footView];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setRefund:(RefundListModel *)refund{
    _refund =refund;
    [self.userLogo sd_setImageWithURL:[NSURL URLWithString:refund.userLogo] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk.png"]];
    
    self.namelbl.text =refund.userName;
    self.statelbl.text =refund.refundStateName;
    self.orderNum.text =[NSString stringWithFormat:@"订单编号: %@",refund.phaseOrderCode];
    self.orderName.text =[NSString stringWithFormat:@"订单名称: %@",refund.phaseOrderName];
    NSMutableAttributedString *totalFeestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单金额: ¥ %.2f",self.refund.refundFee]];
    [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,5)];
    [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,totalFeestr.length-5)];
    self.orderFee.attributedText = totalFeestr;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[refund.updateDate doubleValue]/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    self.phaseLastDate.text =[NSString stringWithFormat:@"更新时间: %@",confromTimespStr];
    
    if (refund.refundState==29||refund.refundState==27) {
        [self.eventBtn setTitle:@"取消退款" forState:UIControlStateNormal];
        [self.eventBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.eventBtn.hidden =YES;
        self.footView.frame =CGRectMake(0, 175, kMainScreenWidth, 10);
    }

}
-(void)setAfter:(AfterSaleListModel *)after{
    _after =after;
    
    [self.userLogo sd_setImageWithURL:[NSURL URLWithString:after.userLogo] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk.png"]];
    
    self.namelbl.text =after.userName;
    self.statelbl.text =after.csStateName;
    self.orderNum.text =[NSString stringWithFormat:@"订单编号:%@",after.phaseOrderCode];
    self.orderName.text =[NSString stringWithFormat:@"订单名称:%@",after.phaseOrderName];
    NSMutableAttributedString *totalFeestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单金额: ¥ %.2f",after.phaseOrderFee]];
    [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,5)];
    [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,totalFeestr.length-5)];
    self.orderFee.attributedText = totalFeestr;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[after.csUpdateDate doubleValue]/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    self.phaseLastDate.text =[NSString stringWithFormat:@"更新时间:%@",confromTimespStr];
    
    if (after.csState==23) {
        [self.eventBtn setTitle:@"取消售后" forState:UIControlStateNormal];
//        self.eventBtn.backgroundColor =[UIColor orangeColor];
        [self.eventBtn addTarget:self action:@selector(cancleAfterAction:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.eventBtn.hidden =YES;
        self.footView.frame =CGRectMake(0, 175, kMainScreenWidth, 10);
    }
}
-(void)cancleAction:(id)sender{
    [self.delegate touchCancle:self.refund];
}
-(void)cancleAfterAction:(id)sender{
    [self.delegate touchAfterCancle:self.after];
}
@end
