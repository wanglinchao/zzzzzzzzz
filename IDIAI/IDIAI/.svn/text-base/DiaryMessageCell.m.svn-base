//
//  DiaryMessageCell.m
//  IDIAI
//
//  Created by Ricky on 15/11/23.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DiaryMessageCell.h"
#import "HexColor.h"
#import "UIImageView+WebCache.h"
#import "Emoji.h"
@interface DiaryMessageCell ()
@property(nonatomic,strong)UIImageView *userlogo;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UILabel *usernamelbl;
@property(nonatomic,strong)UIImageView *typeimage;
@property(nonatomic,strong)UILabel *replasedate;
@property(nonatomic,strong)UILabel *diarynamelbl;
@property(nonatomic,strong)UILabel *contentlbl;
@property(nonatomic,strong)UIButton *praisebtn;
@property(nonatomic,strong)UIButton *commentbtn;
@property(nonatomic,strong)UIImageView *lineimage;
@end
@implementation DiaryMessageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self innerInit];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)setDetail:(DiaryDetailObject *)detail{
//    self.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    _detail =detail;
    int count;
    if (self.detail.diaryLableTitle.length>0){
        NSArray *keys=[self.detail.diaryLableTitle componentsSeparatedByString:@","];
        count=(int)keys.count/3;
    }
    self.titleView =[[UIView alloc] initWithFrame:CGRectMake(15, 10, kMainScreenWidth-30, 109+32*count)];
    self.titleView.backgroundColor =[UIColor clearColor];
    [self addSubview:self.titleView];
    
    self.userlogo =[[UIImageView alloc] initWithFrame:CGRectMake(15, self.titleView.frame.size.height+self.titleView.frame.origin.y, 33, 33)];
    self.userlogo.layer.cornerRadius=17;
    self.userlogo.clipsToBounds=YES;
    self.userlogo.tag =100002;
    self.userlogo.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLogoAction:)];
    [self.userlogo addGestureRecognizer:tap];
    [self addSubview:self.userlogo];
    
    self.usernamelbl =[[UILabel alloc] initWithFrame:CGRectMake(self.userlogo.frame.origin.x+self.userlogo.frame.size.width+6, self.userlogo.frame.origin.y+9, 42, 14)];
    self.usernamelbl.textColor =[UIColor colorWithHexString:@"#575757"];
    self.usernamelbl.font =[UIFont systemFontOfSize:14];
    self.usernamelbl.backgroundColor =[UIColor clearColor];
    [self addSubview:self.usernamelbl];
    
    self.typeimage =[[UIImageView alloc] initWithFrame:CGRectMake(self.usernamelbl.frame.origin.x+self.usernamelbl.frame.size.width+10, self.usernamelbl.frame.origin.y, 33, 14)];
    [self addSubview:self.typeimage];
    
    self.replasedate =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-195, self.usernamelbl.frame.origin.y+1, 180, 12)];
    self.replasedate.textColor =[UIColor colorWithHexString:@"#cccccc"];
    self.replasedate.font =[UIFont systemFontOfSize:12];
    self.replasedate.backgroundColor =[UIColor clearColor];
    self.replasedate.textAlignment =NSTextAlignmentRight;
    [self addSubview:self.replasedate];
    
    self.diarynamelbl =[[UILabel alloc] initWithFrame:CGRectMake(self.userlogo.frame.origin.x, self.userlogo.frame.origin.y+self.userlogo.frame.size.height+22, kMainScreenWidth-30, 15)];
    self.diarynamelbl.font =[UIFont systemFontOfSize:14];
    self.diarynamelbl.textColor =[UIColor colorWithHexString:@"#575757"];
    self.diarynamelbl.backgroundColor =[UIColor clearColor];
    [self addSubview:self.diarynamelbl];
    
    self.contentlbl =[[UILabel alloc] initWithFrame:CGRectMake(self.diarynamelbl.frame.origin.x, self.diarynamelbl.frame.size.height+self.diarynamelbl.frame.origin.y, kMainScreenWidth-30, 14)];
    self.contentlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    self.contentlbl.font =[UIFont systemFontOfSize:14];
    self.contentlbl.backgroundColor =[UIColor clearColor];
    [self addSubview:self.contentlbl];
    
    self.praisebtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.praisebtn.frame =CGRectMake(kMainScreenWidth-12-140-15, self.contentlbl.frame.origin.y+self.contentlbl.frame.size.height+14, 70, 22);
    self.praisebtn.layer.cornerRadius=10;
    self.praisebtn.clipsToBounds=YES;
    self.praisebtn.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
    self.praisebtn.layer.borderWidth = 1;
    [self.praisebtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.praisebtn];
    
    
    UIImageView *zanimage =[[UIImageView alloc] init];
    zanimage.frame =CGRectMake(11, 5, 11, 12);
    zanimage.image =[UIImage imageNamed:@"ic_zan.png"];
    zanimage.tag =101;
    if (self.detail.isPoint>0) {
        zanimage.image =[UIImage imageNamed:@"ic_zan_up_sp.png"];
    }
    [self.praisebtn addSubview:zanimage];
    
    UILabel *zancount =[[UILabel alloc] init];
    zancount.frame =CGRectMake(28, 5.5, 70-22-16,11);
    zancount.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    zancount.font =[UIFont systemFontOfSize:11];
    zancount.tag =100;
    zancount.textAlignment =NSTextAlignmentCenter;
    [self.praisebtn addSubview:zancount];
    
    self.commentbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.commentbtn.frame =CGRectMake(kMainScreenWidth-12-70, self.praisebtn.frame.origin.y, 70, 22);
    self.commentbtn.layer.cornerRadius=10;
    self.commentbtn.clipsToBounds=YES;
    self.commentbtn.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
    self.commentbtn.layer.borderWidth = 1;
    [self.commentbtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.commentbtn];
    
    
    UIImageView *commentimage =[[UIImageView alloc] init];
    commentimage.frame =CGRectMake(11, 5, 10, 10.5);
    commentimage.image =[UIImage imageNamed:@"ic_pinglun.png"];
    [self.commentbtn addSubview:commentimage];
    
    
    UILabel *commentcount =[[UILabel alloc] init];
    commentcount.frame =CGRectMake(27,5.5,70-22-16,11);
    commentcount.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    commentcount.font =[UIFont systemFontOfSize:11];
    commentcount.tag =101;
    commentcount.textAlignment =NSTextAlignmentCenter;
    [self.commentbtn addSubview:commentcount];

}
-(void)showLogoAction:(UIGestureRecognizer *)sender{
    [self.delegate touchHead:self.detail];
}
-(void)praiseAction:(UIButton *)sender{
    [self.delegate touchPraise];
}
-(void)commentAction:(UIButton *)sender{
    [self.delegate touchMessageComment];
}
-(CGFloat)getCellHeight{
    int height =0;
    if (self.detail.diaryLableTitle.length>0) {
        NSArray *keys=[self.detail.diaryLableTitle componentsSeparatedByString:@","];
        int count =0;
        int countx =0;
        int county =0;
        for (UIView *view in self.titleView.subviews) {
            [view removeFromSuperview];
        }
        for (NSString *title in keys) {
            NSLog(@"%d",(int)(kMainScreenWidth-32-216)/2);
            UILabel *titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(((kMainScreenWidth-30-216)/2+72)*countx, 32*county, 72, 22)];
            titlelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0" alpha:0.6];
            titlelbl.layer.masksToBounds = YES;
            titlelbl.layer.cornerRadius = 10;
            titlelbl.layer.borderColor =[UIColor colorWithHexString:@"#a0a0a0" alpha:0.6].CGColor;
            titlelbl.layer.borderWidth = 0.5;
            titlelbl.textAlignment =NSTextAlignmentCenter;
            titlelbl.font = [UIFont systemFontOfSize:13.0];
            titlelbl.text =title;
            count++;
            countx++;
            if (countx%3==0) {
                countx=0;
                county++;
            }
            [self.titleView addSubview:titlelbl];
        }
        if (keys.count==0) {
            self.titleView.frame =CGRectMake(15, 10, kMainScreenWidth-30, 0);
        }else{
            if (keys.count%3>0) {
                self.titleView.frame =CGRectMake(15, 10, kMainScreenWidth-30, 33*(keys.count/3+1)+10);
            }else{
                self.titleView.frame =CGRectMake(15, 10, kMainScreenWidth-30, 33*keys.count/3+10);
            }
        }
        
//        self.titleView.backgroundColor =[UIColor redColor];
        self.lineimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, self.titleView.frame.size.height-10, kMainScreenWidth-30, 1)];
        self.lineimage.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
        [self.titleView addSubview:self.lineimage];
    }else{
        self.titleView.frame =CGRectMake(15, 10, kMainScreenWidth-30, 0);
    }
    
//    self.titleView.backgroundColor =[UIColor redColor];
    height+=self.titleView.frame.origin.y+self.titleView.frame.size.height;
    
    self.userlogo.frame =CGRectMake(15, self.titleView.frame.size.height+self.titleView.frame.origin.y, 33, 33);
    height+=self.userlogo.frame.size.height;
    
    if (self.detail.diaryType==2) {
        self.userlogo.image =[UIImage imageNamed:@"ic_tiwen_u.png"];
    }else{
        if (self.detail.roleId !=7) {
            [self.userlogo sd_setImageWithURL:[NSURL URLWithString:self.detail.logo] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk.png"]];
        }else{
            if (self.detail.logo.length>0) {
                  [self.userlogo sd_setImageWithURL:[NSURL URLWithString:self.detail.logo] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk.png"]];
            }else{
                self.userlogo.image=[UIImage imageNamed:@"ic_touxiang_tk.png"];
            }
            
        }
    }
    
    UIFont *font1= [UIFont fontWithName:@"Arial" size:14];
    CGSize size1 = CGSizeMake(kMainScreenWidth-67,14);
    
    
    NSString *nickName;
   
    if (self.detail.nickName.length ==0) {
        
        if (self.detail.diaryType==2) {
            nickName =[NSString stringWithFormat:@"【用户%d】提问",self.detail.userId];
        }else {
           nickName =[NSString stringWithFormat:@"用户%d",self.detail.userId];
        
        }
    }else{
        if (self.detail.diaryType==2) {
            nickName =[NSString stringWithFormat:@"【%@】提问",self.detail.nickName];
        }else{
            nickName =[NSString stringWithFormat:@"%@",self.detail.nickName];
        }
    }
    CGSize labelsize1 = [nickName sizeWithFont:font1 constrainedToSize:size1 lineBreakMode:UILineBreakModeWordWrap];
    self.usernamelbl.frame =CGRectMake(self.userlogo.frame.origin.x+self.userlogo.frame.size.width+6, self.userlogo.frame.origin.y+9, labelsize1.width, 14);
    self.usernamelbl.text =nickName;
    self.usernamelbl.numberOfLines =2;
    self.usernamelbl.font =font1;
    
    self.typeimage.frame =CGRectMake(self.usernamelbl.frame.origin.x+self.usernamelbl.frame.size.width+10, self.usernamelbl.frame.origin.y, 33, 14);
    if (self.detail.diaryType!=2) {
        if (self.detail.roleId ==1) {
            self.typeimage.frame =CGRectMake(self.typeimage.frame.origin.x, self.typeimage.frame.origin.y, 43, 14);
            self.typeimage.image =[UIImage imageNamed:@"ic_shejishi.png"];
        }else if (self.detail.roleId ==4){
            self.typeimage.image =[UIImage imageNamed:@"ic_gongzhang_diary.png"];
        }else if (self.detail.roleId ==6){
            self.typeimage.image =[UIImage imageNamed:@"ic_jianli_diary.png"];
        }else if (self.detail.roleId ==7){
            self.typeimage.image =[UIImage imageNamed:@"ic_yezhu.png"];
        }
    }else if (self.detail.roleId ==2){
        self.typeimage.image =[UIImage imageNamed:@"ic_shangjia.png"];
    }
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self.detail.releaseDate doubleValue]/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString *replasestr =[formatter stringFromDate:date];
    self.replasedate.frame= CGRectMake(kMainScreenWidth-195, self.usernamelbl.frame.origin.y+1, 180, 12);
    self.replasedate.text =replasestr;
    if (self.detail.diaryType!=2) {
        CGSize labelsize2 = [self.detail.diaryTitle sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kMainScreenWidth-30,28) lineBreakMode:UILineBreakModeWordWrap];
        self.diarynamelbl.frame =CGRectMake(self.userlogo.frame.origin.x, self.userlogo.frame.origin.y+self.userlogo.frame.size.height+22, kMainScreenWidth-30, labelsize2.height);
        height+=self.diarynamelbl.frame.size.height+22;
        self.diarynamelbl.text =self.detail.diaryTitle;
        self.diarynamelbl.numberOfLines =0;
    }
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    CGSize size = CGSizeMake(kMainScreenWidth-30,2000);
    NSString *context=[Emoji replaceUicodeBecomeEmojiWith:self.detail.diaryContext];
    CGSize labelsize = [context sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    self.contentlbl.frame =CGRectMake(self.diarynamelbl.frame.origin.x, self.diarynamelbl.frame.size.height+self.diarynamelbl.frame.origin.y+13, labelsize.width, labelsize.height);
    if (self.detail.diaryType==2) {
        self.contentlbl.frame =CGRectMake(self.userlogo.frame.origin.x, self.userlogo.frame.origin.y+self.userlogo.frame.size.height+22, labelsize.width, labelsize.height);
    }
    self.contentlbl.lineBreakMode = UILineBreakModeWordWrap;
    self.contentlbl.numberOfLines =0;
    self.contentlbl.font =font;
    height+=labelsize.height+13+labelsize.height/14*5;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:context];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [context length])];
    self.contentlbl.attributedText = attributedString;
    [self.contentlbl sizeToFit];
//    self.contentlbl.text =context;
    
    self.praisebtn.frame =CGRectMake(kMainScreenWidth-12-140-15, self.contentlbl.frame.origin.y+self.contentlbl.frame.size.height+14, 70, 22);
    height+=14+self.praisebtn.frame.size.height;
    
    UILabel *zancount =(UILabel *)[self.praisebtn viewWithTag:100];
    zancount.text =[NSString stringWithFormat:@"%d",self.detail.pointNumber];
    UIImageView *zanimage =(UIImageView *)[self.praisebtn viewWithTag:101];
    if (self.detail.isPoint>0) {
        zanimage.image =[UIImage imageNamed:@"ic_zan_up_sp.png"];
    }else{
        zanimage.image =[UIImage imageNamed:@"ic_zan.png"];
    }
    self.commentbtn.frame =CGRectMake(kMainScreenWidth-12-70, self.praisebtn.frame.origin.y, 70, 22);
    UILabel *commentcount = (UILabel *)[self.commentbtn viewWithTag:101];
    commentcount.text =[NSString stringWithFormat:@"%d",self.detail.commentNumber];
    
    return height+20;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
