//
//  ContactViewController.m
//  IDIAI
//
//  Created by Ricky on 16/5/16.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ContactViewController.h"
#import "PinYinForObjc.h"
#import "DiaryObject.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "MailContactObject.h"
#define kSectionSelectorWidth 20
@interface ContactViewController ()
@property(nonatomic,strong)NSMutableArray *contactArray;
@property(nonatomic,strong)UIButton *releasebtn;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"添加收信人";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithHexString:@"#efeff4"];
    self.contactArray =[NSMutableArray array];
    
    // Do any additional setup after loading the view.
    _testTableView = [[UITableView alloc] init];
    _testTableView.dataSource = self;
    _testTableView.delegate = self;
    _testTableView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    _testTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_testTableView];
    
    _selectionView = [[CHSectionSelectionView alloc] init];
    _selectionView.backgroundColor = [UIColor clearColor];
    _selectionView.dataSource = self;
    _selectionView.delegate = self;
    _selectionView.showCallouts = YES; // the view should show a callout when an item is selected
    _selectionView.calloutDirection = SectionCalloutDirectionLeft; // Callouts should appear on the right side
    _selectionView.calloutPadding = 20;
    _selectionView.fixedSectionItemHeight=15;
    [self.view addSubview:_selectionView];
    
    self.releasebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.releasebtn.frame = CGRectMake(0, 0, 42, 42);
    [self.releasebtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.releasebtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
    //右移
    [self.releasebtn addTarget:self action:@selector(releaseAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.releasebtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)releaseAction:(id)sender{
    self.selectDone(self.contactArray);
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _testTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-40);
    _selectionView.frame = CGRectMake(self.view.bounds.size.width-kSectionSelectorWidth, 40, kSectionSelectorWidth, self.view.bounds.size.height-40);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requstMailContact];
}
-(void)requstMailContact{
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token;
        NSString *string_userid;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        else{
            string_token=@"";
            string_userid=@"";
        }
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0365\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"roleId\":7}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"写信联系人列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==103651) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        
                        NSArray *arr_=[jsonDict objectForKey:@"recvUserInfoVos"];
                        for(NSDictionary *dict in arr_){
                            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[MailContactObject class]];
                            MailContactObject *item = [parser parseDictionary:dict];
                            [self.contactArray addObject:item];
                        }
                        if ([arr_ count]) {
                            [self prepareDataWithArray];
                            
                            [_selectionView reloadSections];
                        }
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                              });
                          }
                               method:url postDict:nil];
    });
}
//准备收信人列表排序等工作
- (void)prepareDataWithArray{
    

    
    if (!sections) sections = [NSMutableArray array];
    if (sections.count) [sections removeAllObjects];
    
    if (!cellData) cellData = [NSMutableArray array];
    if (cellData.count) [cellData removeAllObjects];
    
    for (NSInteger ix = 'A'; ix <= 'Z'; ++ix) {
        @autoreleasepool {
            [sections addObject:[NSString stringWithFormat:@"%c", ix]];
        }
    }
    
    NSMutableArray *tmpSectionSArray = [sections mutableCopy];
    
    for (NSString *section in sections) {
        @autoreleasepool {
            
            NSMutableDictionary *tmpSectionDict = [NSMutableDictionary dictionary];   //存放相应字母对应的城市列表
            
            NSMutableArray *tmpSectionArray = [NSMutableArray array]; //字母对应的城市列表
            
            for (MailContactObject *mailobject in self.contactArray) {
                @autoreleasepool {
//                    if([cityName rangeOfString:@"重庆"].length) cityName=@"从庆市";
                    
                    NSString *firstName = [NSString stringWithFormat:@"%@",[PinYinForObjc chineseConvertToPinYinHead:[mailobject.userName substringWithRange:NSMakeRange(0, 1)]]];
                    if ([[firstName uppercaseString] isEqualToString:section]) [tmpSectionArray addObject:mailobject];
                    
                }
            }
            
            if (!tmpSectionArray.count) [tmpSectionSArray removeObject:section];
            else {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userName"
                                                                               ascending:YES];
                NSArray *sortDescriptors = @[sortDescriptor];
                tmpSectionArray = [[tmpSectionArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
                
                [tmpSectionDict setObject:tmpSectionArray forKey:section];
                [cellData addObject:tmpSectionDict];
            }
        }
    }
    
    sections = tmpSectionSArray;
    
    
    //刷新列表
    [_testTableView reloadData];
    
}
//////////////////////////////////////////////////////////////////////////
#pragma mark - SectionSelectionView DataSource

// Tell the datasource how many sections we have - best is to forward to the tableviews datasource
-(NSInteger)numberOfSectionsInSectionSelectionView:(CHSectionSelectionView *)sectionSelectionView
{
    return [_testTableView.dataSource numberOfSectionsInTableView:_testTableView];
}

// Create a nice callout view so that you see whats selected when
// your finger covers the sectionSelectionView
-(UIView *)sectionSelectionView:(CHSectionSelectionView *)selectionView callOutViewForSelectedSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    
    label.frame = CGRectMake(0, 0, 55,55); // you MUST set the size of the callout in this method
    
    // do some ui stuff
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:20];
    label.text = [_testTableView.dataSource tableView:_testTableView titleForHeaderInSection:section];
    label.textAlignment = NSTextAlignmentCenter;
    
    // dont use that in your code cause layer shadows are
    // negatively affecting performance
    
    [label.layer setCornerRadius:label.frame.size.width/2];
    [label.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [label.layer setBorderWidth:2.0f];
    [label.layer setShadowColor:[UIColor clearColor].CGColor];
    [label.layer setShadowOpacity:0.8];
    [label.layer setShadowRadius:5.0];
    [label.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    return label;
}


// Create the view that is displayed inside the sectionSelectionView
// This is basically our letter index. CHSectionSelectionItemView subclass
// should be used here. The frame of the view is set by the sectionSelectionView
// it takes its, width and height/numberOfSections for the height
-(CHSectionSelectionItemView *)sectionSelectionView:(CHSectionSelectionView *)selectionView sectionSelectionItemViewForSection:(NSInteger)section
{
    DemoSectionItemSubclass *selectionItem = [[DemoSectionItemSubclass alloc] init];
    selectionItem.contentView.backgroundColor =[UIColor clearColor];
    
    selectionItem.titleLabel.text = [_testTableView.dataSource tableView:_testTableView titleForHeaderInSection:section];
    if(section==0 || section==1){
        selectionItem.titleLabel.font = [UIFont systemFontOfSize:9];
    }
    else{
        selectionItem.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    selectionItem.titleLabel.backgroundColor=[UIColor clearColor];
    selectionItem.titleLabel.textColor = [UIColor colorWithHexString:@"#ef6562"];
    selectionItem.titleLabel.highlightedTextColor = [UIColor grayColor];
    selectionItem.titleLabel.shadowColor = [UIColor colorWithHexString:@"#ef6562"];
    selectionItem.titleLabel.shadowOffset = CGSizeMake(0,1);
    
    
    return selectionItem;
}
#pragma mark - SectionSelectionView Delegate

// Jump to the selected section in our tableview
-(void)sectionSelectionView:(CHSectionSelectionView *)sectionSelectionView didSelectSection:(NSInteger)section
{
    [_testTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark - TableView Delegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) return nil;
    else return [sections objectAtIndex:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) return nil;
    else{
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 20)];
        view.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
        UILabel *contentlbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 0, kMainScreenWidth-30, 20)];
        contentlbl.text =[sections objectAtIndex:section];
        contentlbl.textColor =[UIColor blackColor];
        contentlbl.font =[UIFont boldSystemFontOfSize:13];
        contentlbl.backgroundColor =[UIColor clearColor];
        [view addSubview:contentlbl];
        return view;
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark - TableView DataSource

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    cell.frame = CGRectMake(-320, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
//    [UIView animateWithDuration:0.7 animations:^{
//        cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
//    } completion:^(BOOL finished) {
//        ;
//    }];
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"mycellid_%ld",(long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.contentView.backgroundColor = [UIColor blackColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
        
    }
    cell.textLabel.font=[UIFont systemFontOfSize:20];
//    if (tableView == self.searchDisplayController.searchResultsTableView){
//        NSString *name=[cellData objectAtIndex:indexPath.row];
//        cell.textLabel.text =name;
//        cell.textLabel.font =[UIFont systemFontOfSize:15];
//    }
//    else{
    
    MailContactObject *mailobject=[[[cellData objectAtIndex:indexPath.section] objectForKey:[sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    if (self.selectlist.count>0) {
        for (NSDictionary *dic in self.selectlist) {
            if (mailobject.userId ==[[dic objectForKey:@"userId"] integerValue]) {
                mailobject.isselct =YES;
            }
        }
    }
    
    cell.textLabel.font =[UIFont systemFontOfSize:15];
    if (mailobject.roleId ==1) {
        cell.textLabel.text =[NSString stringWithFormat:@"%@[设计师]",mailobject.userName];
    }else if (mailobject.roleId ==4){
        cell.textLabel.text =[NSString stringWithFormat:@"%@[工长]",mailobject.userName];
    }else if (mailobject.roleId ==9){
        cell.textLabel.text =[NSString stringWithFormat:@"%@[平台监理]",mailobject.userName];
    }else if (mailobject.roleId ==7){
        cell.textLabel.text =[NSString stringWithFormat:@"%@[业主]",mailobject.userName];
    }else if (mailobject.roleId ==6){
        cell.textLabel.text =[NSString stringWithFormat:@"%@[第三方监理]",mailobject.userName];
    }else{
        cell.textLabel.text =mailobject.userName;
    }
    if (mailobject.isselct ==YES) {
        cell.imageView.image =[UIImage imageNamed:@"ic_gouxuan_press"];
    }else{
        cell.imageView.image =[UIImage imageNamed:@"ic_gouxian"];
    }
//
//    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return [searchResults count];
//    }
//    else{

        return [[[cellData objectAtIndex:section] objectForKey:[sections objectAtIndex:section]] count];
//    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (tableView == self.searchDisplayController.searchResultsTableView) return 1;
    return [sections count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        if([delegate respondsToSelector:@selector(didSelectedCity:)]) [delegate didSelectedCity:[searchResults objectAtIndex:indexPath.row]];
//    }
//    else{
//        if(indexPath.section==0){
//            UITableViewCell *cell=[self.testTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            if([cell.textLabel.text isEqualToString:@""] || [cell.textLabel.text isEqualToString:@"定位失败"] || [cell.textLabel.text rangeOfString:@"暂未开通"].length){
//                
//            }
//            else{
//                if([delegate respondsToSelector:@selector(didSelectedCity:)]) [delegate didSelectedCity:[[[cellData objectAtIndex:indexPath.section] objectForKey:[sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
//                [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUDDecorationDistrictOfRow];
//            }
//        }
//        else{
//            if([delegate respondsToSelector:@selector(didSelectedCity:)]) [delegate didSelectedCity:[[[cellData objectAtIndex:indexPath.section] objectForKey:[sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUDDecorationDistrictOfRow];
//        }
//    }
    MailContactObject *mailobject=[[[cellData objectAtIndex:indexPath.section] objectForKey:[sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    mailobject.isselct =!mailobject.isselct;
    NSMutableArray *dataArray =[NSMutableArray array];
    if (self.selectlist.count>0) {
        for (NSDictionary *dic in self.selectlist) {
            if (mailobject.userId ==[[dic objectForKey:@"userId"] integerValue]) {
                if (mailobject.isselct ==NO) {
                    [dataArray addObject:dic];
                }
            }
        }
    }
    [self.selectlist removeObjectsInArray:dataArray];
    [_testTableView reloadData];
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
