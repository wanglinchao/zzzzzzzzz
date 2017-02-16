//
//  EditRequermentViewController.m
//  IDIAI
//
//  Created by iMac on 15-6-26.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "EditRequermentViewController.h"
#import "util.h"
#import "TLToast.h"
#import "IDIAIAppDelegate.h"


@interface EditRequermentViewController ()

@property (strong, nonatomic) UILabel *uilabel;

@end

@implementation EditRequermentViewController
@synthesize uilabel,delegate;

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:[UIColor colorWithHexString:@"#F1F0F6" alpha:1.0]];
    
    CGRect frame = CGRectMake(100, 29, 100, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkTextColor];
    label.text = @"需求描述";
    self.navigationItem.titleView=label;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 60);
    [leftButton addTarget:self
                   action:@selector(backTouched:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 80, 40)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
    rightButton.titleEdgeInsets=UIEdgeInsetsMake(0, 40, 0, 0);
    [rightButton addTarget:self
                    action:@selector(SaveThing)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self.navigationItem setRightBarButtonItem:rightItem];
    
}

-(void)backTouched:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    IDIAIAppDelegate *delegate_ = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate_.nav setNavigationBarHidden:NO animated:NO];
    
    if([self.fromwhere isEqualToString:@"111"]){
        [delegate_.nav setNavigationBarHidden:YES animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    [self customizeNavigationBar];
    
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(15, 30, kMainScreenWidth-30, 300)];
    _textView.textColor = [UIColor grayColor];//设置textview里面的字体颜色
    _textView.font = [UIFont systemFontOfSize:17];//设置字体名字和字体大小
    _textView.delegate = self;//设置它的委托方法
    _textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    _textView.text = self.content;//设置它显示的内容
    _textView.returnKeyType = UIReturnKeyDone;//返回键的类型
    _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    _textView.scrollEnabled = YES;//是否可以拖动
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    _textView.layer.borderColor = [UIColor colorWithHexString:@"#F1F0F6" alpha:1.0].CGColor;
    _textView.layer.borderWidth =1.5;
    _textView.layer.cornerRadius =8.0;
    [self.view addSubview:_textView];
    
    uilabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 40, kMainScreenWidth -30, 20)];
    if(!self.content.length) uilabel.text =@"输入的内容不超过200字";
    else uilabel.text =@"";
    uilabel.font=[UIFont systemFontOfSize:17];
    uilabel.enabled = NO;//lable必须设置为不可用
    uilabel.textAlignment=NSTextAlignmentLeft;
    uilabel.textColor=[UIColor lightGrayColor];
    uilabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:uilabel];
}

-(void)SaveThing{
    if(_textView.text.length>200) [TLToast showWithText:@"内容已超过200字"];
    else{
        [delegate GetEditRequerment:_textView.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark - UITextViewDelegate

-(void)textViewDidEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        uilabel.text =@"输入的内容不超过200字";
    }else{
        uilabel.text = @"";
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
