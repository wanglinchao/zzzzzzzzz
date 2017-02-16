//
//  InstructViewController.m
//  IDIAI
//
//  Created by Ricky on 16/3/15.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "InstructViewController.h"
#import "util.h"
@interface InstructViewController ()<UIWebViewDelegate>

@end

@implementation InstructViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    UIWebView *webView_=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    webView_.delegate=self;
    [self.view addSubview:webView_];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"youhuimaguze" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView_ loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
//    UIScrollView *backscroll =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
//    [self.view addSubview:backscroll];
//    
//    UIImageView *headimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 81*kMainScreenWidth/320)];
//    headimage.image =[UIImage imageNamed:@"bg_youhuimaguze.png"];
//    [backscroll addSubview:headimage];
//    UILabel *questionone =[[UILabel alloc] initWithFrame:CGRectMake(25, headimage.frame.origin.y+headimage.frame.size.height+25, kMainScreenWidth-50, 20)];
//    questionone.text =@"Q:什么是优惠码？";
//    CGSize labelsize1 = [questionone.text sizeWithFont:[UIFont systemFontOfSize:20]
//                                       constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                                           lineBreakMode:UILineBreakModeWordWrap];
//    questionone.frame =CGRectMake(questionone.frame.origin.x, questionone.frame.origin.y, labelsize1.width, labelsize1.height);
//    questionone.numberOfLines =0;
//    questionone.textColor =[UIColor colorWithHexString:@"#575757"];
//    questionone.font =[UIFont systemFontOfSize:20];
//    [backscroll addSubview:questionone];
//    
//    UILabel *answerone =[[UILabel alloc] initWithFrame:CGRectMake(25, questionone.frame.origin.y+questionone.frame.size.height+10, kMainScreenWidth-50, 15)];
//    NSString *answerstrone =@"A:优惠码是由屋托邦或与屋托邦合作的商家发放给用户的，作为兑换屋托邦优惠的凭证，成功兑换后将以优惠券的形式保存至屋托邦账户“我的优惠”中。";
//    labelsize1 = [questionone.text sizeWithFont:[UIFont systemFontOfSize:15]
//                              constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                                  lineBreakMode:UILineBreakModeWordWrap];
//    answerone.frame =CGRectMake(answerone.frame.origin.x, answerone.frame.origin.y, labelsize1.width, labelsize1.height);
//    answerone.numberOfLines =0;
//    answerone.text =answerstrone;
//    answerone.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
//    answerone.font =[UIFont systemFontOfSize:15];
//    [backscroll addSubview:answerone];
//    
//    UILabel *questiontwo =[[UILabel alloc] initWithFrame:CGRectMake(25, answerone.frame.origin.y+answerone.frame.size.height+25, kMainScreenWidth-50, 20)];
//    questiontwo.text =@"Q:优惠码是什么样的?";
//    labelsize1 = [questionone.text sizeWithFont:[UIFont systemFontOfSize:20]
//                                     constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                                         lineBreakMode:UILineBreakModeWordWrap];
//    questiontwo.frame =CGRectMake(questiontwo.frame.origin.x, questiontwo.frame.origin.y, labelsize1.width, labelsize1.height);
//    questiontwo.numberOfLines =0;
//    questiontwo.textColor =[UIColor colorWithHexString:@"#575757"];
//    questiontwo.font =[UIFont systemFontOfSize:20];
//    [backscroll addSubview:questiontwo];
//    
//    UILabel *answertwo =[[UILabel alloc] initWithFrame:CGRectMake(25, questiontwo.frame.origin.y+questiontwo.frame.size.height+10, kMainScreenWidth-50, 15)];
//    NSString *answerstrtwo =@"A:优惠码是一串中文、数字或字母的组合。";
//    labelsize1 = [answerstrtwo sizeWithFont:[UIFont systemFontOfSize:20]
//                                constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                                    lineBreakMode:UILineBreakModeWordWrap];
//    answertwo.frame =CGRectMake(answertwo.frame.origin.x, answertwo.frame.origin.y, labelsize1.width, labelsize1.height);
//    answertwo.numberOfLines =0;
//    answertwo.text =answerstrtwo;
//    answertwo.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
//    answertwo.font =[UIFont systemFontOfSize:15];
//    [backscroll addSubview:answertwo];
//    
//    UILabel *questionthree =[[UILabel alloc] initWithFrame:CGRectMake(25, answertwo.frame.origin.y+answertwo.frame.size.height+25, kMainScreenWidth-50, 20)];
//    questionthree.text =@"Q:怎样获得优惠码？";
//    labelsize1 = [questionthree.text sizeWithFont:[UIFont systemFontOfSize:20]
//                            constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                                lineBreakMode:UILineBreakModeWordWrap];
//    questionthree.frame =CGRectMake(questionthree.frame.origin.x, questionthree.frame.origin.y, labelsize1.width, labelsize1.height);
//    questionthree.numberOfLines =0;
//    questionthree.textColor =[UIColor colorWithHexString:@"#575757"];
//    questionthree.font =[UIFont systemFontOfSize:20];
//    [backscroll addSubview:questionthree];
//    
//    UILabel *answerthree =[[UILabel alloc] initWithFrame:CGRectMake(25, questionthree.frame.origin.y+questionthree.frame.size.height+10, kMainScreenWidth-50, 15)];
//    NSString *answerstrthree =@"A: 优惠码是和各商家合作发出的，它们会在这些地方：\n1、合作商家的官网、新浪官方微博、微信公众号\n2、屋托邦的新浪官方微博、微信公众号\n3、其他任何途径\n温馨提示：每种优惠码的名额有限，大家看到后要第一时间领取哦。";
//    labelsize1 = [answerstrthree sizeWithFont:[UIFont systemFontOfSize:15]
//                           constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                               lineBreakMode:UILineBreakModeWordWrap];
//    answerthree.frame =CGRectMake(answerthree.frame.origin.x, answerthree.frame.origin.y, labelsize1.width, labelsize1.height);
//    answerthree.numberOfLines =0;
//    answerthree.text =answerstrthree;
//    answerthree.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
//    answerthree.font =[UIFont systemFontOfSize:15];
//    [backscroll addSubview:answerthree];
//    
//    UILabel *questionfour =[[UILabel alloc] initWithFrame:CGRectMake(25, answerthree.frame.origin.y+answerthree.frame.size.height+25, kMainScreenWidth-50, 20)];
//    questionfour.text =@"Q:一个用户一天内最多能兑换几次优惠码？";
//    labelsize1 = [questionone.text sizeWithFont:[UIFont systemFontOfSize:20]
//                              constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                                  lineBreakMode:UILineBreakModeWordWrap];
//    questionfour.frame =CGRectMake(questionfour.frame.origin.x, questionfour.frame.origin.y, labelsize1.width, labelsize1.height);
//    questionfour.numberOfLines =0;
//    questionfour.textColor =[UIColor colorWithHexString:@"#575757"];
//    questionfour.font =[UIFont systemFontOfSize:20];
//    [backscroll addSubview:questionfour];
//    
//    UILabel *answerfour =[[UILabel alloc] initWithFrame:CGRectMake(25, questionfour.frame.origin.y+questionfour.frame.size.height+10, kMainScreenWidth-50, 15)];
//    NSString *answerstrfour =@"A:一个用户一天内不限优惠码的兑换次数";
//    labelsize1 = [answerstrfour sizeWithFont:[UIFont systemFontOfSize:15]
//                           constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                               lineBreakMode:UILineBreakModeWordWrap];
//    answerfour.frame =CGRectMake(answerfour.frame.origin.x, answerfour.frame.origin.y, labelsize1.width, labelsize1.height);
//    answerfour.numberOfLines =0;
//    answerfour.text =answerstrfour;
//    answerfour.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
//    answerfour.font =[UIFont systemFontOfSize:15];
//    [backscroll addSubview:answerfour];
//    
//    UILabel *questionfive =[[UILabel alloc] initWithFrame:CGRectMake(25, answerfour.frame.origin.y+answerfour.frame.size.height+25, kMainScreenWidth-50, 20)];
//    questionfive.text =@"Q:优惠码可以重复兑换吗？";
//    labelsize1 = [questionone.text sizeWithFont:[UIFont systemFontOfSize:20]
//                              constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                                  lineBreakMode:UILineBreakModeWordWrap];
//    questionfive.frame =CGRectMake(questionfive.frame.origin.x, questionfive.frame.origin.y, labelsize1.width, labelsize1.height);
//    questionfive.numberOfLines =0;
//    questionfive.textColor =[UIColor colorWithHexString:@"#575757"];
//    questionfive.font =[UIFont systemFontOfSize:20];
//    [backscroll addSubview:questionfive];
//    
//    UILabel *answerfive =[[UILabel alloc] initWithFrame:CGRectMake(25, questionfive.frame.origin.y+questionfive.frame.size.height+10, kMainScreenWidth-50, 15)];
//    NSString *answerstrfive =@"A:不能哦。一个优惠码只能兑换一张优惠券，不能重复兑换。";
//    labelsize1 = [answerstrfive sizeWithFont:[UIFont systemFontOfSize:15]
//                          constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                              lineBreakMode:UILineBreakModeWordWrap];
//    answerfive.frame =CGRectMake(answerfive.frame.origin.x, answerfive.frame.origin.y, labelsize1.width, labelsize1.height);
//    answerfive.numberOfLines =0;
//    answerfive.text =answerstrfive;
//    answerfive.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
//    answerfive.font =[UIFont systemFontOfSize:15];
//    [backscroll addSubview:answerfive];
//    
//    UILabel *questionsix =[[UILabel alloc] initWithFrame:CGRectMake(25, answerfive.frame.origin.y+answerfive.frame.size.height+25, kMainScreenWidth-50, 20)];
//    questionsix.text =@"Q:优惠码可以找零或兑换吗？";
//    labelsize1 = [questionone.text sizeWithFont:[UIFont systemFontOfSize:20]
//                              constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                                  lineBreakMode:UILineBreakModeWordWrap];
//    questionsix.frame =CGRectMake(questionsix.frame.origin.x, questionsix.frame.origin.y, labelsize1.width, labelsize1.height);
//    questionsix.numberOfLines =0;
//    questionsix.textColor =[UIColor colorWithHexString:@"#575757"];
//    questionsix.font =[UIFont systemFontOfSize:20];
//    [backscroll addSubview:questionsix];
//    
//    UILabel *answersix =[[UILabel alloc] initWithFrame:CGRectMake(25, questionsix.frame.origin.y+questionsix.frame.size.height+10, kMainScreenWidth-50, 15)];
//    NSString *answerstrsix =@"A:不可以。使用优惠码兑换成功的优惠券支付订单时，优惠券金额高于订单金额的，差额部分不找零不兑换；优惠券金额低于订单金额的，差额部分由用户支付，优惠券一旦使用不退还。";
//    labelsize1 = [answerstrsix sizeWithFont:[UIFont systemFontOfSize:15]
//                            constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                                lineBreakMode:UILineBreakModeWordWrap];
//    answersix.frame =CGRectMake(answersix.frame.origin.x, answersix.frame.origin.y, labelsize1.width, labelsize1.height);
//    answersix.numberOfLines =0;
//    answersix.text =answerstrsix;
//    answersix.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
//    answersix.font =[UIFont systemFontOfSize:15];
//    [backscroll addSubview:answersix];
//    
//    UILabel *questionseven =[[UILabel alloc] initWithFrame:CGRectMake(25, answersix.frame.origin.y+answersix.frame.size.height+25, kMainScreenWidth-50, 20)];
//    questionseven.text =@"Q:什么是优惠码的”有效期“？";
////    labelsize1 = [util calHeightForLabel:questionseven.text width:kMainScreenWidth-50 font:[UIFont systemFontOfSize:20]];
//    labelsize1 = [questionseven.text sizeWithFont:[UIFont systemFontOfSize:20]
//                        constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                            lineBreakMode:UILineBreakModeWordWrap];
//    questionseven.frame =CGRectMake(questionseven.frame.origin.x, questionseven.frame.origin.y, labelsize1.width, labelsize1.height);
//    questionseven.numberOfLines =0;
//    questionseven.textColor =[UIColor colorWithHexString:@"#575757"];
//    questionseven.font =[UIFont systemFontOfSize:20];
//    [backscroll addSubview:questionseven];
//    
//    UILabel *answerseven =[[UILabel alloc] initWithFrame:CGRectMake(25, questionseven.frame.origin.y+questionseven.frame.size.height+10, kMainScreenWidth-50, 15)];
//    NSString *answerstrseven =@"A：优惠码所兑换成的优惠券上会注明”有效期“，该优惠券仅能在注明的有效期内使用。";
//    labelsize1 = [answerstrseven sizeWithFont:[UIFont systemFontOfSize:15]
//                       constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                           lineBreakMode:UILineBreakModeWordWrap];
//    answerseven.frame =CGRectMake(answerseven.frame.origin.x, answerseven.frame.origin.y, labelsize1.width, labelsize1.height);
//    answerseven.numberOfLines =0;
//    answerseven.text =answerstrseven;
//    answerseven.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
//    answerseven.font =[UIFont systemFontOfSize:15];
//    [backscroll addSubview:answerseven];
//    
//    UILabel *prompt =[[UILabel alloc] initWithFrame:CGRectMake(25, answerseven.frame.origin.y+answerseven.frame.size.height+25, kMainScreenWidth-50, 20)];
//    prompt.text =@"特别提示：";
//    prompt.textColor =[UIColor colorWithHexString:@"#575757"];
//    prompt.font =[UIFont systemFontOfSize:20];
//    [backscroll addSubview:prompt];
//    
//    UILabel *promptcontent =[[UILabel alloc] initWithFrame:CGRectMake(25, prompt.frame.origin.y+prompt.frame.size.height+10, kMainScreenWidth-50, 15)];
//    NSString *promptstr =@"如果用户对使用规则或者使用屋托邦软件或相关服务过程中有任何疑问需要任何帮助，请及时与屋托邦客服联系，联系电话400-888-7372";
//    labelsize1 = [promptstr sizeWithFont:[UIFont systemFontOfSize:15]
//                              constrainedToSize:CGSizeMake(kMainScreenWidth-50, 2000)
//                                  lineBreakMode:UILineBreakModeWordWrap];
//    promptcontent.frame =CGRectMake(promptcontent.frame.origin.x, promptcontent.frame.origin.y, labelsize1.width, labelsize1.height);
//    promptcontent.numberOfLines =0;
//    promptcontent.text =promptstr;
//    promptcontent.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
//    promptcontent.font =[UIFont systemFontOfSize:15];
//    [backscroll addSubview:promptcontent];
//    
//    backscroll.contentSize =CGSizeMake(kMainScreenWidth, promptcontent.frame.origin.y+promptcontent.frame.size.height+64+10);
    // Do any additional setup after loading the view.
}
-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
