//
//  SearchGJSView.m
//  IDIAI
//
//  Created by iMac on 16/1/22.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SearchGJSView.h"
#import "SearchListCell.h"

@implementation SearchGJSView

-(id)initWithFrame:(CGRect)frame historyData:(NSString *)data fromName:(NSString *)fromName{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        self.fromName=fromName;
        self.KHISTORY_SS_GongZhang=data;
        [self createSearchView];
    }
    return self;
}

#pragma mark - 创建搜索

-(void)createSearchView{
    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path_ = [path_ objectAtIndex:0];
    NSString* _filename_  = [doc_path_ stringByAppendingPathComponent:self.KHISTORY_SS_GongZhang];
    _dataArray_history=[NSMutableArray arrayWithContentsOfFile:_filename_];
    if (!_dataArray_history) {
        _dataArray_history=[NSMutableArray arrayWithCapacity:0];
    }
    if([_dataArray_history count]>15) [_dataArray_history removeObjectsInRange:NSMakeRange(15, [_dataArray_history count]-15)];
    [searchBar becomeFirstResponder];
    
    mtableview_sub=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    mtableview_sub.backgroundColor=[UIColor whiteColor];
    mtableview_sub.delegate=self;
    mtableview_sub.dataSource=self;
    mtableview_sub.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self addSubview:mtableview_sub];
    
    [self createUITextField];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_dataArray_history count]==indexPath.row) return kMainScreenHeight-64-200;
    else return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([_dataArray_history count]<=15) return [_dataArray_history count]+1;
    else return 15+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"mycellid_";
    SearchListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SearchListCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    for(id btn in cell.subviews) {
        if([btn isKindOfClass:[UIButton class]])[btn removeFromSuperview];
    }
    
    if([_dataArray_history count]!=indexPath.row){
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 49.5, kMainScreenWidth-40, 0.5)];
        line.backgroundColor=[UIColor lightGrayColor];
        line.alpha=0.6;
        [cell addSubview:line];
        
        cell.ser_his_lab.hidden=NO;
        cell.ser_his_lab.text=[_dataArray_history objectAtIndex:indexPath.row];
    }
    else {
        cell.ser_his_lab.hidden=YES;
        if([_dataArray_history count]){
            UIButton *clear_btn=[UIButton buttonWithType:UIButtonTypeCustom];
            clear_btn.frame=CGRectMake((kMainScreenWidth-20-134)/2, 100, 134, 31);
            [clear_btn setTitle:@"清除历史" forState:UIControlStateNormal];
            [clear_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            clear_btn.titleLabel.font=[UIFont systemFontOfSize:15];
            //给按钮加一个白色的板框
            clear_btn.layer.borderColor = [[UIColor redColor] CGColor];
            clear_btn.layer.borderWidth = 1.0f;
            //给按钮设置弧度,这里将按钮变成了圆形
            clear_btn.layer.cornerRadius = 4.0f;
            clear_btn.layer.masksToBounds = YES;
            [clear_btn addTarget:self action:@selector(pressClear_btn) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:clear_btn];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_dataArray_history count]!=indexPath.row){
        [searchBar resignFirstResponder];
        searchBar.text=[_dataArray_history objectAtIndex:indexPath.row];
        
        BOOL isDefault=YES;
        if(searchBar.text.length){
            for(int i=0;i<[_dataArray_history count];i++){
                NSString *str=[_dataArray_history objectAtIndex:i];
                if([str isEqualToString:searchBar.text]) {
                    [_dataArray_history exchangeObjectAtIndex:0 withObjectAtIndex:i];
                    isDefault=NO;
                    break;
                }
            }
            if(isDefault==YES) {
                if([_dataArray_history count]>=15) [_dataArray_history removeObjectsInRange:NSMakeRange(14, [_dataArray_history count]-14)];
                [_dataArray_history insertObject:searchBar.text atIndex:0];
            }
            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* doc_path = [path objectAtIndex:0];
            NSString* _filename_ = [doc_path stringByAppendingPathComponent:self.KHISTORY_SS_GongZhang];
            [_dataArray_history writeToFile:_filename_ atomically:NO];
        }
        
        [searchBar resignFirstResponder];
        [self.delegate searchType:self.fromName searchContent:searchBar.text cancle:@""];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

#pragma mark -
#pragma mark -  Others

-(void)createUITextField{
    view_search_bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
    view_search_bg.backgroundColor=[UIColor whiteColor];
    [self addSubview:view_search_bg];
    
    UIImageView *imv_ss=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_sousuo_s"]];
    imv_ss.frame=CGRectMake(10, 7.5, 15, 15);
    UIView *view_left_ss=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    view_left_ss.backgroundColor=[UIColor clearColor];
    [view_left_ss addSubview:imv_ss];
    
    searchBar=[[UITextField alloc]initWithFrame:CGRectMake(20, 27, kMainScreenWidth-90, 30)];
    searchBar.borderStyle=UITextBorderStyleRoundedRect;
    searchBar.backgroundColor =kColorWithRGB(233, 233, 236);
    searchBar.delegate=self;
    searchBar.placeholder=@"请输入搜索内容";
    searchBar.returnKeyType=UIReturnKeySearch;
    searchBar.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    searchBar.font=[UIFont systemFontOfSize:15];
    searchBar.tintColor=kColorWithRGB(192, 192, 196);
    searchBar.clearsOnBeginEditing=YES;
    searchBar.clearButtonMode=UITextFieldViewModeWhileEditing;
    searchBar.leftView=view_left_ss;
    searchBar.leftViewMode=UITextFieldViewModeAlways;
    [view_search_bg addSubview:searchBar];
    [searchBar becomeFirstResponder];
    
    UIButton *btn_cancle=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-55, 27, 50, 30)];
    [btn_cancle setTitle:@"取消" forState:UIControlStateNormal];
    [btn_cancle setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn_cancle.titleLabel.font=[UIFont systemFontOfSize:16];
    [btn_cancle addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [view_search_bg addSubview:btn_cancle];
}

#pragma mark -
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [mtableview_sub reloadData];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL isDefault=YES;
    if(textField.text.length){
        for(int i=0;i<[_dataArray_history count];i++){
            NSString *str=[_dataArray_history objectAtIndex:i];
            if([str isEqualToString:textField.text]) {
                [_dataArray_history exchangeObjectAtIndex:0 withObjectAtIndex:i];
                isDefault=NO;
                break;
            }
        }
        if(isDefault==YES) {
            if([_dataArray_history count]>=15) [_dataArray_history removeObjectsInRange:NSMakeRange(14, [_dataArray_history count]-14)];
            [_dataArray_history insertObject:textField.text atIndex:0];
        }
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename_  = [doc_path stringByAppendingPathComponent:self.KHISTORY_SS_GongZhang];
        [_dataArray_history writeToFile:_filename_ atomically:NO];
        
        [searchBar resignFirstResponder];
        [self.delegate searchType:self.fromName searchContent:searchBar.text cancle:@""];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
    return YES;
}

#pragma mark - UIButton

-(void)pressClear_btn{
    if([_dataArray_history count]){
        [_dataArray_history removeAllObjects];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename_ = [doc_path stringByAppendingPathComponent:self.KHISTORY_SS_GongZhang];
        [_dataArray_history writeToFile:_filename_ atomically:NO];
    }
    [mtableview_sub reloadData];
}

-(void)cancelSearch{
    [searchBar resignFirstResponder];
    [self.delegate searchType:self.fromName searchContent:@"" cancle:@"取消"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark - KeyBord

- (void)keyboardWillShow:(NSNotification *)notif {
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat kbSize = rect.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        mtableview_sub.frame=CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64-kbSize);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    //CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //CGFloat kbSize = rect.size.height;
    //MJLog(@"willHide---键盘高度：%f",kbSize);
    
    [UIView animateWithDuration:duration animations:^{
        mtableview_sub.frame=CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64);
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}

@end
