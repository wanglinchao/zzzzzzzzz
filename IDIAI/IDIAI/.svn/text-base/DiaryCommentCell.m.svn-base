//
//  DiaryCommentCell.m
//  IDIAI
//
//  Created by Ricky on 15/11/24.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DiaryCommentCell.h"
#import "HexColor.h"
#import "UIImageView+WebCache.h"
#import "Emoji.h"
#import "TYAttributedLabel.h"
@interface DiaryCommentCell ()<TYAttributedLabelDelegate>
@property(nonatomic,strong)UIImageView *reviewerslogo;
@property(nonatomic,strong)UILabel *reviewersnamelbl;
@property(nonatomic,strong)UIImageView *typeimage;
@property(nonatomic,strong)UILabel *countlbl;
@property(nonatomic,strong)UILabel *commentdate;
@property(nonatomic,strong)UILabel *contentlbl;
@property(nonatomic,strong)UIImageView *lineimage;
@property(nonatomic,strong)UIView *headbackView;
@end
@implementation DiaryCommentCell
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
    UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchHeadAction:)];
    [self.reviewerslogo addGestureRecognizer:tap1];
    [self addSubview:self.reviewerslogo];
    
    self.reviewersnamelbl =[[UILabel alloc] initWithFrame:CGRectMake(self.reviewerslogo.frame.origin.x+self.reviewerslogo.frame.size.width+13, 11, 150*kMainScreenWidth/375, 14)];
    self.reviewersnamelbl.textColor =[UIColor colorWithHexString:@"#575757"];
    self.reviewersnamelbl.font =[UIFont systemFontOfSize:14];
    [self addSubview:self.reviewersnamelbl];
    
    self.commentdate =[[UILabel alloc] initWithFrame:CGRectMake(self.reviewersnamelbl.frame.origin.x+self.reviewersnamelbl.frame.size.width, self.reviewersnamelbl.frame.origin.y, 100*kMainScreenWidth/375, 12)];
    self.commentdate.font =[UIFont systemFontOfSize:12];
    self.commentdate.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    self.commentdate.textAlignment =NSTextAlignmentRight;
    [self addSubview:self.commentdate];
    
    self.countlbl =[[UILabel alloc] initWithFrame:CGRectMake(self.commentdate.frame.origin.x+self.commentdate.frame.size.width, self.reviewersnamelbl.frame.origin.y, kMainScreenWidth-self.commentdate.frame.origin.x-self.commentdate.frame.size.width-13, 12)];
    self.countlbl.font =[UIFont systemFontOfSize:12];
    self.countlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    self.countlbl.textAlignment =NSTextAlignmentRight;
//    self.countlbl.backgroundColor =[UIColor redColor];
    [self addSubview:self.countlbl];
    
    self.contentlbl =[[UILabel alloc] initWithFrame:CGRectMake(self.reviewersnamelbl.frame.origin.x, self.reviewersnamelbl.frame.origin.y+self.reviewersnamelbl.frame.size.height+8, kMainScreenWidth-67, 0)];
    self.contentlbl.font =[UIFont systemFontOfSize:15];
    self.contentlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
//    self.contentlbl.userInteractionEnabled =YES;
//    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapAciton:)];
//    [self.contentlbl addGestureRecognizer:tap];
//    self.contentlbl.backgroundColor =[UIColor redColor];
    [self addSubview:self.contentlbl];
    
    self.headbackView =[[UIView alloc] initWithFrame:CGRectMake(self.reviewerslogo.frame.origin.x+self.reviewerslogo.frame.size.width+13, 11, kMainScreenWidth-67-self.reviewersnamelbl.frame.origin.x, 0)];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapAciton:)];
    [self.headbackView addGestureRecognizer:tap];
//    self.headbackView.backgroundColor =[UIColor purpleColor];
    [self addSubview:self.headbackView];

    
    self.lineimage =[[UIImageView alloc] initWithFrame:CGRectZero];
    self.lineimage.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [self addSubview:self.lineimage];
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)commentTapAciton:(UIGestureRecognizer *)sender{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]==self.commentobject.userId) {
        return;
    }
    [self.delegate touchComment:self.commentobject Row:self.row];
}
-(void)replyTapAction:(UIGestureRecognizer *)sender{
    DiaryReplyCommentObject *reply =[self.commentobject.replyComments objectAtIndex:sender.view.tag-1000];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]==reply.userId) {
        return;
    }
    [self.delegate touchReplay:[self.commentobject.replyComments objectAtIndex:sender.view.tag-1000] Row:self.row];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)touchHeadAction:(id)sender{
    [self.delegate touchCommentHead:self.commentobject];
}
-(CGFloat)getCellHeight{
    int height =0;
    if (self.commentobject.roleId !=7) {
        [self.reviewerslogo sd_setImageWithURL:[NSURL URLWithString:self.commentobject.logo] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk.png"]];
    }else{
        if (self.commentobject.logo.length>0) {
            [self.reviewerslogo sd_setImageWithURL:[NSURL URLWithString:self.commentobject.logo] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk.png"]];
//            self.reviewerslogo.image =[UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:[self.commentobject.logo stringByReplacingOccurrencesOfString:@"\n" withString:@""]  options:NSDataBase64DecodingIgnoreUnknownCharacters]];
        }else{
            self.reviewerslogo.image =[UIImage imageNamed:@"ic_touxiang_tk.png"];
        }
    }
    
    
    if (self.commentobject.nickName.length ==0) {
        self.commentobject.nickName =[NSString stringWithFormat:@"用户%d",self.commentobject.userId];
    }
    self.reviewersnamelbl.text =self.commentobject.nickName;
    height +=self.reviewersnamelbl.frame.origin.y+self.reviewersnamelbl.frame.size.height;
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self.commentobject.commentDate doubleValue]/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *replasestr =[formatter stringFromDate:date];
    self.commentdate.text =replasestr;
    
    self.countlbl.text =[NSString stringWithFormat:@"%d楼",(int)self.row+1];
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    CGSize size = CGSizeMake(kMainScreenWidth-67,2000);
    NSString *context=[Emoji replaceUicodeBecomeEmojiWith:self.commentobject.commentContext];
    CGSize labelsize = [context sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    self.contentlbl.lineBreakMode = UILineBreakModeWordWrap;
    self.contentlbl.numberOfLines =0;
    self.contentlbl.frame =CGRectMake(self.contentlbl.frame.origin.x, self.contentlbl.frame.origin.y, labelsize.width, labelsize.height);
    self.contentlbl.text =context;
    self.contentlbl.font =font;
    height+=18+self.contentlbl.frame.size.height;
    self.headbackView.frame =CGRectMake(self.headbackView.frame.origin.x, self.headbackView.frame.origin.y, self.headbackView.frame.size.width, height);
    int count =0;
    for (int i=0; i<self.commentobject.replyComments.count; i++) {
        UIView *view =[self viewWithTag:1000+i];
        [view removeFromSuperview];
        view =nil;
    }
    int replycount=0;
    for (DiaryReplyCommentObject *reply in self.commentobject.replyComments) {
        UIFont *font1 = [UIFont fontWithName:@"Arial" size:15];
        CGSize size1 = CGSizeMake(kMainScreenWidth-77,2000);
        if (reply.nickName.length ==0) {
            reply.nickName =[NSString stringWithFormat:@"用户%d",reply.userId];
        }
        if (reply.toNickName.length ==0) {
            reply.toNickName =[NSString stringWithFormat:@"用户%d",reply.toUserId];
        }
        NSString *context1=[Emoji replaceUicodeBecomeEmojiWith:reply.replyContext];
        NSString *content_reply =[NSString stringWithFormat:@"%@回复%@:%@",reply.nickName,reply.toNickName,context1];
        CGSize labelsize1 = [[NSString stringWithFormat:@"%@回复%@:%@",reply.nickName,reply.toNickName,context1] sizeWithFont:font1 constrainedToSize:size1 lineBreakMode:NSLineBreakByWordWrapping];
        UIView *replybackView =[[UIView alloc] initWithFrame:CGRectMake(53, height, kMainScreenWidth-67, labelsize1.height+10)];
        replybackView.backgroundColor =[UIColor colorWithHexString:@"efeff4"];
        replybackView.tag =1000+count;
        
//        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyTapAction:)];
//        [replybackView addGestureRecognizer:tap];

        TYAttributedLabel *reply_lab = [[TYAttributedLabel alloc] init];
        reply_lab.delegate=self;
        reply_lab.tag=10000+replycount;
        reply_lab.backgroundColor=[UIColor clearColor];
        reply_lab.textColor=[UIColor colorWithHexString:@"#a0a0a0" alpha:1.0];
        reply_lab.font=font1;
        reply_lab.linesSpacing=0;
        reply_lab.text =content_reply ;
        [reply_lab addLinkWithLinkData:content_reply linkColor:[UIColor colorWithHexString:@"#a0a0a0" alpha:1.0] underLineStyle:kCTUnderlineStyleNone range:NSMakeRange(0, content_reply.length)];
        [reply_lab addLinkWithLinkData:reply.nickName linkColor:[UIColor colorWithHexString:@"#ef6562" alpha:1.0] underLineStyle:kCTUnderlineStyleNone range:NSMakeRange(0, reply.nickName.length)];
        [reply_lab addLinkWithLinkData:reply.toNickName linkColor:[UIColor colorWithHexString:@"#ef6562" alpha:1.0] underLineStyle:kCTUnderlineStyleNone range:NSMakeRange(0+reply.nickName.length+2, reply.toNickName.length)];
        [reply_lab sizeToFit];
        [reply_lab setFrameWithOrign:CGPointMake(5, 5) Width:kMainScreenWidth-67];
        replybackView.frame =CGRectMake(replybackView.frame.origin.x, replybackView.frame.origin.y, replybackView.frame.size.width, reply_lab.frame.size.height+10);
        [replybackView addSubview:reply_lab];
        height+=replybackView.frame.size.height;
//        UILabel *repleylbl =[[UILabel alloc] initWithFrame:CGRectMake(5, 5, labelsize1.width, labelsize1.height)];
//        repleylbl.font =font1;
//        repleylbl.lineBreakMode = UILineBreakModeWordWrap;
//        repleylbl.numberOfLines =0;
////        if (reply.nickName.length ==0) {
////            reply.nickName =@"匿名用户";
////        }
////        if (reply.toNickName.length ==0) {
////            reply.nickName =@"匿名用户";
////        }
//        
////        NSLog(@"%d",(int)context1.length);
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@回复%@:%@",reply.nickName,reply.toNickName,context1]];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(0,reply.nickName.length)];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(reply.nickName.length,2)];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(reply.nickName.length+2,reply.toNickName.length)];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(reply.nickName.length+reply.toNickName.length+2,context1.length+1)];
//        repleylbl.attributedText = str;
        [replybackView addSubview:reply_lab];
        [self addSubview:replybackView];
        replycount++;
    }
    height+=15;
    self.lineimage.frame =CGRectMake(13, height-1, kMainScreenWidth-13, 1);
    return height;
}
#pragma mark - TYAttributedLabelDelegate

-(void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)poin{
    
    DiaryReplyCommentObject *reply =[self.commentobject.replyComments objectAtIndex:attributedLabel.tag-10000];
    if (textStorage.range.location==0&&textStorage.range.length==reply.nickName.length) {
        [self.delegate touchnickName:reply];
    }else if (textStorage.range.location==reply.nickName.length+2&&textStorage.range.length==reply.toNickName.length){
        [self.delegate touchtonickName:reply];
    }else{
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:User_ID]);
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]==reply.userId) {
            return;
        }
        [self.delegate touchReplay:reply Row:self.row];
    }
}
@end
