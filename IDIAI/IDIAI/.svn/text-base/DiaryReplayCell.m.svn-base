//
//  DiaryReplayCell.m
//  IDIAI
//
//  Created by Ricky on 15/11/25.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DiaryReplayCell.h"
#import "UIImageView+WebCache.h"
#import "Emoji.h"
@interface DiaryReplayCell ()
@property(nonatomic,strong)UIImageView *reviewerslogo;
@property(nonatomic,strong)UILabel *reviewersnamelbl;
@property(nonatomic,strong)UIImageView *typeimage;
@property(nonatomic,strong)UILabel *commentdate;
@property(nonatomic,strong)UILabel *contentlbl;
@property(nonatomic,strong)UIImageView *logoimage;
@property(nonatomic,strong)UIImageView *lineimage;
@end
@implementation DiaryReplayCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(void)innerInit{
    self.reviewerslogo =[[UIImageView alloc] initWithFrame:CGRectMake(13, 11, 33, 33)];
    self.reviewerslogo.layer.cornerRadius=17;
    self.reviewerslogo.clipsToBounds=YES;
    self.reviewerslogo.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.reviewerslogo addGestureRecognizer:tap];
    [self addSubview:self.reviewerslogo];
    
    self.reviewersnamelbl =[[UILabel alloc] initWithFrame:CGRectMake(self.reviewerslogo.frame.origin.x+self.reviewerslogo.frame.size.width+13, 11, 150, 14)];
    self.reviewersnamelbl.textColor =[UIColor colorWithHexString:@"#575757"];
    self.reviewersnamelbl.font =[UIFont systemFontOfSize:14];
    [self addSubview:self.reviewersnamelbl];
    
    self.contentlbl =[[UILabel alloc] initWithFrame:CGRectMake(self.reviewersnamelbl.frame.origin.x, self.reviewersnamelbl.frame.origin.y+self.reviewersnamelbl.frame.size.height+8, kMainScreenWidth-67, 0)];
    self.contentlbl.font =[UIFont systemFontOfSize:15];
    self.contentlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    self.contentlbl.userInteractionEnabled =YES;
    //    self.contentlbl.backgroundColor =[UIColor redColor];
    [self addSubview:self.contentlbl];
    
    self.typeimage =[[UIImageView alloc] initWithFrame:CGRectMake(self.reviewersnamelbl.frame.origin.x, self.reviewersnamelbl.frame.origin.y+self.reviewersnamelbl.frame.size.height+8, 11, 12.5)];
    self.typeimage.image =[UIImage imageNamed:@"ic_zan.png"];
    [self addSubview:self.typeimage];
    
    self.commentdate =[[UILabel alloc] initWithFrame:CGRectMake(self.reviewersnamelbl.frame.origin.x+self.reviewersnamelbl.frame.size.width, self.reviewersnamelbl.frame.origin.y+2, 120, 12)];
    self.commentdate.font =[UIFont systemFontOfSize:12];
    self.commentdate.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [self addSubview:self.commentdate];
    
    self.logoimage =[[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-11-49, 15, 49, 49)];
    self.logoimage.clipsToBounds=YES;
    self.logoimage.contentMode=UIViewContentModeScaleAspectFill;
    [self addSubview:self.logoimage];
    
    self.lineimage =[[UIImageView alloc] initWithFrame:CGRectZero];
    self.lineimage.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [self addSubview:self.lineimage];
}
-(void)tapAction:(UIGestureRecognizer *)sender{
    [self.delegate touchHead:self.reply];
}
-(CGFloat)getCellHeight{
    int height =0;
    if (self.reply.roleId !=7) {
        [self.reviewerslogo sd_setImageWithURL:[NSURL URLWithString:self.reply.logo] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk.png"]];
    }else{
        if (self.reply.logo.length>0) {
            self.reviewerslogo.image =[UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:[self.reply.logo stringByReplacingOccurrencesOfString:@"\n" withString:@""]  options:NSDataBase64DecodingIgnoreUnknownCharacters]];
        }else{
            self.reviewerslogo.image =[UIImage imageNamed:@"ic_touxiang_tk.png"];
        }
    }
    if (self.reply.nickName.length ==0) {
        self.reply.nickName =[NSString stringWithFormat:@"用户%d",(int)self.reply.userId];
    }
    self.reviewersnamelbl.text =self.reply.nickName;
    height +=self.reviewersnamelbl.frame.origin.y+self.reviewersnamelbl.frame.size.height+8;
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    CGSize size = CGSizeMake(kMainScreenWidth-125,2000);
     NSString *context=[Emoji replaceUicodeBecomeEmojiWith:self.reply.commentContext];
    CGSize labelsize = [context sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    self.contentlbl.lineBreakMode = UILineBreakModeWordWrap;
    self.contentlbl.numberOfLines =0;
    self.contentlbl.frame =CGRectMake(self.contentlbl.frame.origin.x, self.contentlbl.frame.origin.y, labelsize.width, labelsize.height);
    self.contentlbl.text =context;
    self.contentlbl.font =font;
    if (self.reply.commentType==2) {
        self.contentlbl.hidden =YES;
        height+=7+self.typeimage.frame.size.height;
        self.typeimage.hidden =NO;
    }else{
        height+=7+self.contentlbl.frame.size.height;
        self.contentlbl.hidden =NO;
        self.typeimage.hidden =YES;
    }
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self.reply.commentDate doubleValue]/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"MM月dd HH:mm"];
    NSString *replasestr =[formatter stringFromDate:date];
    self.commentdate.frame =CGRectMake(self.contentlbl.frame.origin.x, height, 120,12);
    self.commentdate.text =replasestr;
    if (self.reply.firstPicPath.length>0) {
        [self.logoimage sd_setImageWithURL:[NSURL URLWithString:self.reply.firstPicPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
    }
    height+=15+self.commentdate.frame.size.height;
    self.lineimage.frame =CGRectMake(13, height-1, kMainScreenWidth-55, 1);
    return height;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
