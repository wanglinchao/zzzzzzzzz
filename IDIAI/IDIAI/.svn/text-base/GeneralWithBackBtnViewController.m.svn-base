//
//  GeneralWithBackBtnViewController.m
//  chronic
//
//  Created by 黄润 on 13-8-12.
//  Copyright (c) 2013年 chenhai. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
@interface GeneralWithBackBtnViewController ()


@end

@implementation GeneralWithBackBtnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.theBackButton = [[UIButton alloc] initWithFrame:[self BackButtonRect]];
    [self.theBackButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];
    //navigation item左移一点
    self.theBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.theBackButton];
    self.navigationItem.leftBarButtonItem = backBarBtn;
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed:(id)sender {
 
    [self.navigationController popViewControllerAnimated:YES];
}

@end
