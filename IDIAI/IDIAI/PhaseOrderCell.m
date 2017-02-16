//
//  PhaseOrderCell.m
//  IDIAI
//
//  Created by Ricky on 15/12/25.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "PhaseOrderCell.h"
@interface PhaseOrderCell ()
@property(nonatomic,strong)UILabel *titlelbl;
@property(nonatomic,strong)UIView *contentBackView;
@property(nonatomic,strong)UIImageView *arrowimage;
@property(nonatomic,strong)UILabel *percentagelbl;
@property(nonatomic,strong)UILabel *phaseOrderNamelbl;
@property(nonatomic,strong)UILabel *phaseOrderPricelbl;
@property(nonatomic,strong)UILabel *orderCodelbl;
@property(nonatomic,strong)UILabel *phaseDesclbl;
@property(nonatomic,strong)UIImageView *roundimage;
@property(nonatomic,strong)UIButton *showContract;
@end
@implementation PhaseOrderCell
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
- (void)awakeFromNib {
    // Initialization code
}
-(void)innerInit{
    self.titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 15, kMainScreenWidth, 15)];
    self.titlelbl.font =[UIFont systemFontOfSize:15];
    self.titlelbl.textColor =[UIColor colorWithHexString:@"#575757"];
    self.titlelbl.hidden =YES;
    [self addSubview:self.titlelbl];
    
    self.contentBackView =[[UIView alloc] initWithFrame:CGRectMake(33, 15, kMainScreenWidth-43, 40)];
    self.contentBackView.layer.masksToBounds = YES;
    self.contentBackView.layer.cornerRadius = 10;
    self.contentBackView.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
    self.contentBackView.layer.borderWidth = 1;
    self.contentBackView.hidden =YES;
    [self addSubview:self.contentBackView];
    
    self.roundimage =[[UIImageView alloc] initWithFrame:CGRectMake(15, self.contentBackView.frame.origin.y+13, 14, 14)];
    self.roundimage.layer.masksToBounds = YES;
    self.roundimage.layer.cornerRadius = 7;
    self.roundimage.backgroundColor =[UIColor colorWithHexString:@"#ef6562"];
    [self addSubview:self.roundimage];
    
    self.arrowimage =[[UIImageView alloc] initWithFrame:CGRectMake(self.contentBackView.frame.size.width-18, 16, 10, 5)];
    self.arrowimage.hidden =YES;
    self.arrowimage.image =[UIImage imageNamed:@"ic_jintou_u.png"];
    [self.contentBackView addSubview:self.arrowimage];
    
    self.percentagelbl =[[UILabel alloc] initWithFrame:CGRectMake(self.arrowimage.frame.origin.x-152, 11, 152, 15)];
    self.percentagelbl.font =[UIFont systemFontOfSize:15];
    self.percentagelbl.textColor =[UIColor colorWithHexString:@"#575757"];
//    self.percentagelbl.backgroundColor =[UIColor orangeColor];
    [self.contentBackView addSubview:self.percentagelbl];
    
    self.phaseOrderNamelbl =[[UILabel alloc] initWithFrame:CGRectMake(11, 11, 60, 15)];
    self.phaseOrderNamelbl.font =[UIFont systemFontOfSize:15];
    self.phaseOrderNamelbl.textColor =[UIColor colorWithHexString:@"#575757"];
//    self.phaseOrderNamelbl.backgroundColor =[UIColor blueColor];
    [self.contentBackView addSubview:self.phaseOrderNamelbl];
    
    self.phaseOrderPricelbl =[[UILabel alloc] initWithFrame:CGRectMake(81, 11, 92, 15)];
    self.phaseOrderPricelbl.font =[UIFont systemFontOfSize:15];
    self.phaseOrderPricelbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
    //    self.phaseOrderNamelbl.backgroundColor =[UIColor blueColor];
    [self.contentBackView addSubview:self.phaseOrderPricelbl];

    
    self.orderCodelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.phaseOrderNamelbl.frame.origin.y+self.phaseOrderNamelbl.frame.size.height+15, self.contentBackView.frame.size.width-30, 12)];
    self.orderCodelbl.font =[UIFont systemFontOfSize:12];
    self.orderCodelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentBackView addSubview:self.orderCodelbl];
    
    self.phaseDesclbl =[[UILabel alloc] initWithFrame:CGRectMake(15, self.orderCodelbl.frame.origin.y+self.orderCodelbl.frame.size.height+8, self.contentBackView.frame.size.width-30, 12)];
    self.phaseDesclbl.font =[UIFont systemFontOfSize:12];
    self.phaseDesclbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self.contentBackView addSubview:self.phaseDesclbl];
    
    self.showContract =[UIButton buttonWithType:UIButtonTypeCustom];
    self.showContract.frame =CGRectMake(kMainScreenWidth-110, 0, 100, 45);
//    self.showContract.backgroundColor =[UIColor orangeColor];
    [self.showContract addTarget:self action:@selector(showContract:) forControlEvents:UIControlEventTouchUpInside];
    self.showContract.hidden =YES;
    [self addSubview:self.showContract];
    
    UILabel *conractlbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 80, 15)];
    conractlbl.text =@"查看合同 >";
    conractlbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
    conractlbl.textAlignment =NSTextAlignmentRight;
    conractlbl.font =[UIFont systemFontOfSize:15.0];
    [self.showContract addSubview:conractlbl];
    
//    UIImageView *arrow =[[UIImageView alloc] initWithFrame:CGRectMake(self.showContract.frame.size.width-6.5, 16.5, 6.5, 12)];
//    arrow.image =[UIImage imageNamed:@"ic_jinatou_r.png"];
//    [self.showContract addSubview:arrow];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(CGFloat)getCellHeight{
    CGFloat height=0;
    if (self.orderObject!=nil) {
        double orderproportion =self.engineering/self.contractTotalFee;
        NSMutableAttributedString *percentagestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"占%@%%",self.orderObject.payCent]];
        [percentagestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,1)];
        [percentagestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(1,percentagestr.length-1)];
        self.percentagelbl.attributedText =percentagestr;
        self.percentagelbl.textAlignment =NSTextAlignmentRight;
        NSString *couponFeestr =[NSString stringWithFormat:@"¥ %.2f",[self.orderObject.phaseOrderFee floatValue]];
        if (self.preferential) {
            if (self.preferential.couponType==0) {
                if ([self.preferential.couponValue doubleValue]>=self.engineering) {
                    couponFeestr =[NSString stringWithFormat:@"¥ 0"];
                }else{
                    if (self.preferential.exitState==1) {
                        couponFeestr =[NSString stringWithFormat:@"¥ %.2f",[self.orderObject.phaseOrderFee doubleValue]-[self.preferential.couponValue doubleValue]*[self.orderObject.payCent doubleValue]/100*orderproportion];
                    }else if (self.preferential.exitState ==2){
                        couponFeestr =[NSString stringWithFormat:@"¥ %.2f",[self.orderObject.phaseOrderFee doubleValue]-[self.preferential.couponValue doubleValue]*[self.orderObject.payCent doubleValue]/100];
                    }
                    
                }
            }else{
                couponFeestr =[NSString stringWithFormat:@"¥ %.2f",[self.orderObject.phaseOrderFee doubleValue]*[self.preferential.couponValue doubleValue]/10];
            }
        }
//        NSMutableAttributedString *phaseOrderFeestr = [[NSMutableAttributedString alloc] initWithString:couponFeestr];
//        [phaseOrderFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,self.orderObject.phaseOrderName.length)];
//        [phaseOrderFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(self.orderObject.phaseOrderName.length,phaseOrderFeestr.length-self.orderObject.phaseOrderName.length)];
        self.phaseOrderNamelbl.text =self.orderObject.phaseOrderName;
        self.phaseOrderPricelbl.text =couponFeestr;
//        self.phaseOrderNamelbl.lineBreakMode = UILineBreakModeMiddleTruncation;
        
        self.orderCodelbl.text =[NSString stringWithFormat:@"订单编号: %@",self.orderObject.phaseOrderCode];
        if (self.orderObject.phaseOrderCode.length<=0) {
            self.orderCodelbl.hidden =YES;
        }else{
            self.orderCodelbl.hidden =NO;
        }
        
        UIFont *font = [UIFont fontWithName:@"Arial" size:12];
        CGSize size = CGSizeMake(self.contentBackView.frame.size.width-30,2000);
        NSString *context=self.orderObject.phaseDesc;
        CGSize labelsize = [context sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        self.phaseDesclbl.lineBreakMode = UILineBreakModeWordWrap;
        self.phaseDesclbl.numberOfLines =0;
        self.phaseDesclbl.frame =CGRectMake(self.phaseDesclbl.frame.origin.x, self.phaseDesclbl.frame.origin.y, labelsize.width, labelsize.height);
        self.phaseDesclbl.text =context;
        self.phaseDesclbl.font =font;
        height =self.phaseDesclbl.frame.size.height+self.phaseDesclbl.frame.origin.y+15;
        if (self.isfirst==YES) {
            NSString *engineeringstr =[NSString stringWithFormat:@"实付合同款: ¥ %.2f",self.engineering];
            if (self.preferential) {
                if (self.preferential.exitState==1) {
                    if (self.preferential.couponType==0) {
                        if ([self.preferential.couponValue doubleValue]*orderproportion>=self.engineering) {
                            engineeringstr =[NSString stringWithFormat:@"实付合同款: ¥ 0"];
                        }else{
                            engineeringstr =[NSString stringWithFormat:@"实付合同款: ¥ %.2f",self.engineering-[self.preferential.couponValue doubleValue]*orderproportion];
                        }
                    }else{
                        engineeringstr =[NSString stringWithFormat:@"实付合同款: ¥ %.2f",self.engineering*[self.preferential.couponValue doubleValue]/10];
                    }
                }else if (self.preferential.exitState==2){
                    if (self.preferential.couponType==0) {
                        if ([self.preferential.couponValue doubleValue]>=self.engineering) {
                            engineeringstr =[NSString stringWithFormat:@"实付合同款: ¥ 0"];
                        }else{
                            engineeringstr =[NSString stringWithFormat:@"实付合同款: ¥ %.2f",self.engineering-[self.preferential.couponValue doubleValue]];
                        }
                    }else{
                        engineeringstr =[NSString stringWithFormat:@"实付合同款: ¥ %.2f",self.engineering*[self.preferential.couponValue doubleValue]/10];
                    }
                }
                
            }
            NSMutableAttributedString *totalFeestr = [[NSMutableAttributedString alloc] initWithString:engineeringstr];
            [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,6)];
            [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(6,totalFeestr.length-6)];
            self.titlelbl.attributedText =totalFeestr;
            
            if (self.isOpen ==YES) {
                self.contentBackView.frame =CGRectMake(33, self.titlelbl.frame.origin.y+self.titlelbl.frame.size.height+15, kMainScreenWidth-43, height);
                self.roundimage.frame =CGRectMake(15, self.contentBackView.frame.origin.y+13, 14, 14);
                self.contentBackView.hidden =NO;
                self.roundimage.hidden =NO;
                self.titlelbl.hidden =NO;
                self.arrowimage.hidden =NO;
                CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
                self.arrowimage.transform = transform;
                if (self.contractType !=4) {
                    self.titlelbl.hidden =YES;
                }
//                self.contentBackView.backgroundColor =[UIColor redColor];
                return height+self.titlelbl.frame.origin.y+self.titlelbl.frame.size.height+10;
            }else{
                self.contentBackView.frame =CGRectMake(33, self.titlelbl.frame.origin.y+self.titlelbl.frame.size.height+15, kMainScreenWidth-43, 40);
                self.roundimage.frame =CGRectMake(15, self.contentBackView.frame.origin.y+13, 14, 14);
                self.contentBackView.hidden =NO;
                self.roundimage.hidden =NO;
                self.titlelbl.hidden =NO;
                self.arrowimage.hidden =NO;
                CGAffineTransform transform = CGAffineTransformMakeRotation(0);
                self.arrowimage.transform = transform;
                if (self.contractType !=4) {
                    self.titlelbl.hidden =YES;
                }
//                self.contentBackView.backgroundColor =[UIColor orangeColor];
                return 45+self.titlelbl.frame.origin.y+self.titlelbl.frame.size.height+10;
            }
        }else{
            if (self.isOpen ==YES) {
                self.contentBackView.frame =CGRectMake(33, 15, kMainScreenWidth-43, height);
                self.roundimage.frame =CGRectMake(15, self.contentBackView.frame.origin.y+13, 14, 14);
                self.contentBackView.hidden =NO;
                self.roundimage.hidden =NO;
                self.titlelbl.hidden =NO;
                self.arrowimage.hidden =NO;
                self.titlelbl.text =@"";
                CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
                self.arrowimage.transform = transform;
                if (self.contractType !=4) {
                    self.titlelbl.hidden =YES;
                }
//                self.contentBackView.backgroundColor =[UIColor blueColor];
                return height+15;
            }else{
                self.contentBackView.frame =CGRectMake(33, 15, kMainScreenWidth-43, 40);
                self.roundimage.frame =CGRectMake(15, self.contentBackView.frame.origin.y+13, 14, 14);
                self.contentBackView.hidden =NO;
                self.roundimage.hidden =NO;
                self.titlelbl.hidden =NO;
                self.arrowimage.hidden =NO;
                self.titlelbl.text =@"";
                CGAffineTransform transform = CGAffineTransformMakeRotation(0);
                self.arrowimage.transform = transform;
                if (self.contractType !=4) {
                    self.titlelbl.hidden =YES;
                }
//                self.contentBackView.backgroundColor =[UIColor greenColor];
                return 55;
            }
            
        }
    }else if (self.orderdetail!=nil){
        if (self.isfirst==YES){
            NSMutableAttributedString *totalFeestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付合同款: ¥ %.2f",self.contractTotalFee]];
            [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,5)];
            [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(5,totalFeestr.length-5)];
            self.titlelbl.attributedText =totalFeestr;
            self.contentBackView.frame =CGRectMake(33, self.titlelbl.frame.origin.y+self.titlelbl.frame.size.height+15, kMainScreenWidth-43,40);
//            NSMutableAttributedString *phaseOrderFeestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ¥ %.2f",self.orderdetail.phaseOrderName,self.orderdetail.phaseOrderFee]];
//            [phaseOrderFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,self.orderdetail.phaseOrderName.length)];
//            [phaseOrderFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(self.orderdetail.phaseOrderName.length,phaseOrderFeestr.length-self.orderdetail.phaseOrderName.length)];
            self.phaseOrderNamelbl.text =self.orderdetail.phaseOrderName;
            self.phaseOrderPricelbl.text =[NSString stringWithFormat:@"¥ %.2f",self.orderdetail.phaseOrderFee];
            self.roundimage.frame =CGRectMake(15, self.contentBackView.frame.origin.y+13, 14, 14);
            self.contentBackView.hidden =NO;
            self.roundimage.hidden =NO;
            self.titlelbl.hidden =NO;
            self.arrowimage.hidden =YES;
            self.showContract.hidden =NO;
            self.percentagelbl.text =self.orderdetail.phaseOrderStateName;
            self.percentagelbl.textAlignment =NSTextAlignmentRight;
            return 45+self.titlelbl.frame.origin.y+self.titlelbl.frame.size.height+10;
        }else{
//            NSMutableAttributedString *phaseOrderFeestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ¥ %.2f",self.orderdetail.phaseOrderName,self.orderdetail.phaseOrderFee]];
//            [phaseOrderFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,self.orderdetail.phaseOrderName.length)];
//            [phaseOrderFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(self.orderdetail.phaseOrderName.length,phaseOrderFeestr.length-self.orderdetail.phaseOrderName.length)];
            self.phaseOrderNamelbl.text =self.orderdetail.phaseOrderName;
            self.phaseOrderPricelbl.text =[NSString stringWithFormat:@"¥ %.2f",self.orderdetail.phaseOrderFee];
            self.arrowimage.hidden =YES;
            self.contentBackView.frame =CGRectMake(33, 15, kMainScreenWidth-43, 40);
            self.roundimage.frame =CGRectMake(15, self.contentBackView.frame.origin.y+13, 14, 14);
            self.contentBackView.hidden =NO;
            self.roundimage.hidden =NO;
            self.titlelbl.hidden =NO;
            self.arrowimage.hidden =YES;
            self.titlelbl.text =@"";
             self.showContract.hidden =YES;
            self.percentagelbl.text =self.orderdetail.phaseOrderStateName;
            self.percentagelbl.textAlignment =NSTextAlignmentRight;
            CGAffineTransform transform = CGAffineTransformMakeRotation(0);
            self.arrowimage.transform = transform;
            return 55;
        }
        
    }else{
        return 0;
    }
}
-(void)showContract:(id)sender{
    [self.delegate touchContract];
}
@end
