//
//  CityListViewController.m
//  IDIAI
//
//  Created by iMac on 14-11-25.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CityListViewController.h"
#import "HexColor.h"
#import "util.h"
#import <QuartzCore/QuartzCore.h>
#import "PinYinForObjc.h"
#import "ChineseInclude.h"
#import "CityListObj.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "IDIAIAppDelegate.h"
#import "PinYinForObjc.h"
#import "MBProgressHUD.h"

#define kSectionSelectorWidth 20

@interface CityListViewController () 
{
    MBProgressHUD *phud;
}
    
@end

@implementation CityListViewController
@synthesize delegate,searchDisplayController;

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:NO];
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    lab_nav_title.font=[UIFont systemFontOfSize:19];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor blackColor];
    lab_nav_title.text=@"城市列表";
    self.navigationItem.titleView = lab_nav_title;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, -5, 0, 55);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

-(void)PressBarItemLeft{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    _locService.delegate=self;
    _geocodesearch.delegate=self;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_locService stopUserLocationService];
    _locService.delegate=nil;
    _geocodesearch.delegate=nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    IDIAIAppDelegate *delegate_=(IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    if([delegate_.array_city_list count]) {
        [self prepareDataWithArray]; //准备城市列表排序等工作
    }
    else {
        [self requestCitylist];
    }
    
    [_selectionView reloadSections];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _testTableView.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-40);
    _selectionView.frame = CGRectMake(self.view.bounds.size.width-kSectionSelectorWidth, 40, kSectionSelectorWidth, self.view.bounds.size.height-40);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    [self customizeNavigationBar];

    searchResults = [NSMutableArray arrayWithCapacity:0];
    
    _testTableView = [[UITableView alloc] init];
    _testTableView.dataSource = self;
    _testTableView.delegate = self;
    [self.view addSubview:_testTableView];
    
    _selectionView = [[CHSectionSelectionView alloc] init];
    _selectionView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    _selectionView.dataSource = self;
    _selectionView.delegate = self;
    _selectionView.showCallouts = YES; // the view should show a callout when an item is selected
    _selectionView.calloutDirection = SectionCalloutDirectionLeft; // Callouts should appear on the right side
    _selectionView.calloutPadding = 20;
    _selectionView.fixedSectionItemHeight=15;
    [self.view addSubview:_selectionView];
    
    [self createSearchBar];
    
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        _locService = [[BMKLocationService alloc]init];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务不可用"
                                                        message:@"GPS定位尚未打开，请在设置中开启定位"
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是",nil];
        [alert show];
    }
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
   
    [self createProgressView];
}

-(void)createProgressView{
    if (!phud) {
        phud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:phud];
        phud.mode=MBProgressHUDModeIndeterminate;
        //self.pHUD.dimBackground=YES; //是否开启背景变暗
        phud.labelText = @"";
        phud.blur=NO;  //是否开启ios7毛玻璃风格
        phud.darkBlur=YES; //受blur限制（blur为YES时设置darkBlur才有用）
        [phud show:YES];
    }
    else{
        [phud show:YES];
    }
}

//准备城市列表排序等工作
- (void)prepareDataWithArray{
    
    IDIAIAppDelegate *delegate_=(IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
            
            for (CityListObj *obj in delegate_.array_city_list) {
                @autoreleasepool {
                    NSString *cityName=obj.cityName;
                    if([cityName rangeOfString:@"重庆"].length) cityName=@"从庆市";
                    
                    NSString *firstName = [NSString stringWithFormat:@"%@",[PinYinForObjc chineseConvertToPinYinHead:[cityName substringWithRange:NSMakeRange(0, 1)]]];
                  if ([[firstName uppercaseString] isEqualToString:section]) [tmpSectionArray addObject:obj];

                }
            }
            
            if (!tmpSectionArray.count) [tmpSectionSArray removeObject:section];
            else {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cityName"
                                                                               ascending:YES];
                NSArray *sortDescriptors = @[sortDescriptor];
                tmpSectionArray = [[tmpSectionArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
                
                [tmpSectionDict setObject:tmpSectionArray forKey:section];
                [cellData addObject:tmpSectionDict];
            }
        }
    }
    sections = tmpSectionSArray;
    
    //获取热门城市
    NSMutableArray *hot_city=[NSMutableArray arrayWithCapacity:0];
    for (CityListObj *obj in delegate_.array_city_list) {
        if([obj.isHotCity integerValue]==1) [hot_city addObject:obj];
        else continue;
    }
    if([hot_city count]){
    [sections insertObject:@"热门" atIndex:0];
    [cellData insertObject:@{@"热门":hot_city} atIndex:0];
    }
    
    //设置定位状态
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
    [sections insertObject:@"定位" atIndex:0];
    [cellData insertObject:@{@"定位":@[[CityListObj objWithDict:@{@"cityAcronym":[NSString stringWithFormat:@"%@",[PinYinForObjc chineseConvertToPinYinHead:@"定位中..."]],@"cityCode":@"",@"cityName":@"",@"isHotCity":@""}]]} atIndex:0];
    }
    else {
        [sections insertObject:@"定位" atIndex:0];
        [cellData insertObject:@{@"定位":@[[CityListObj objWithDict:@{@"cityAcronym":[NSString stringWithFormat:@"%@",[PinYinForObjc chineseConvertToPinYinHead:@"定位失败"]],@"cityCode":@"",@"cityName":@"定位失败",@"isHotCity":@""}]]} atIndex:0];
    }
    
    [phud hide:YES afterDelay:0.5];
    //刷新列表
    [_testTableView reloadData];
    
    [_locService startUserLocationService];
}


//请求城市列表
-(void)requestCitylist{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0041\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],string_token,string_userid];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"城市列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10411) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        
                        NSArray *arr_=[jsonDict objectForKey:@"cityList"];
                        NSMutableArray *data_=[NSMutableArray arrayWithCapacity:0];
                        if ([arr_ count]) {
                            for(NSDictionary *dict in arr_){
                                [data_ addObject:[CityListObj objWithDict:dict]];
                            };
                            
                            IDIAIAppDelegate *delegate_=(IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                            delegate_.array_city_list=data_;
                            
                            [self prepareDataWithArray];
                        }
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [phud hide:YES];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [phud hide:YES];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

-(void)createSearchBar
{
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    mySearchBar.delegate = self;
   // mySearchBar.barStyle=UIBarStyleDefault;
    mySearchBar.searchBarStyle=UISearchBarStyleMinimal;
    [mySearchBar setPlaceholder:@"输入城市名或首字母查询"];
    mySearchBar.tintColor=[UIColor grayColor];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.delegate=self;
    
    [self.view addSubview:mySearchBar];
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
    
    selectionItem.titleLabel.text = [_testTableView.dataSource tableView:_testTableView titleForHeaderInSection:section];
    if(section==0 || section==1){
    selectionItem.titleLabel.font = [UIFont systemFontOfSize:9];
    }
    else{
    selectionItem.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    selectionItem.titleLabel.backgroundColor=[UIColor clearColor];
    selectionItem.titleLabel.textColor = [UIColor redColor];
    selectionItem.titleLabel.highlightedTextColor = [UIColor grayColor];
    selectionItem.titleLabel.shadowColor = [UIColor whiteColor];
    selectionItem.titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    
    return selectionItem;
}

//////////////////////////////////////////////////////////////////////////
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
    if (tableView == self.searchDisplayController.searchResultsTableView){
        CityListObj *obj=[searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text =obj.cityName;
        cell.textLabel.font =[UIFont systemFontOfSize:15];
    }
    else{
        CityListObj *obj=[[[cellData objectAtIndex:indexPath.section] objectForKey:[sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        cell.textLabel.text =obj.cityName ;
        cell.textLabel.font =[UIFont systemFontOfSize:15];
        
        if(indexPath.section==0 && indexPath.row==0){
        UIButton *btn_location=(UIButton *)[cell viewWithTag:100];
        if(!btn_location) btn_location=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-70, 2, 60, 40)];
        btn_location.tag=100;
        [btn_location setImage:[UIImage imageNamed:@"ic_gx"] forState:UIControlStateNormal];
        [btn_location addTarget:self action:@selector(PressBtn_Location) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn_location];
        }
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else{
    if(section==0) return 1;
    else return [[[cellData objectAtIndex:section] objectForKey:[sections objectAtIndex:section]] count];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) return 1;
    return [sections count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     if (tableView == self.searchDisplayController.searchResultsTableView) {
         if([delegate respondsToSelector:@selector(didSelectedCity:)]) [delegate didSelectedCity:[searchResults objectAtIndex:indexPath.row]];
     }
     else{ 
        if(indexPath.section==0){
            UITableViewCell *cell=[self.testTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            if([cell.textLabel.text isEqualToString:@""] || [cell.textLabel.text isEqualToString:@"定位失败"] || [cell.textLabel.text rangeOfString:@"暂未开通"].length){
          
            }
            else{
                if([delegate respondsToSelector:@selector(didSelectedCity:)]) [delegate didSelectedCity:[[[cellData objectAtIndex:indexPath.section] objectForKey:[sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUDDecorationDistrictOfRow];
            }
        }
        else{
            if([delegate respondsToSelector:@selector(didSelectedCity:)]) [delegate didSelectedCity:[[[cellData objectAtIndex:indexPath.section] objectForKey:[sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
                            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUDDecorationDistrictOfRow];
        }
     }
}

#pragma mark -
#pragma UISearchDisplayDelegate

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    _selectionView.alpha=0.0;
    _selectionView.hidden=YES;
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    _selectionView.alpha=1.0;
    _selectionView.hidden=NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(! searchResults)searchResults = [[NSMutableArray alloc]init];
    else if([searchResults count]) [searchResults removeAllObjects];
    //在输入的文字中不包含中文的检索
    if (mySearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (int i=2; i<cellData.count; i++) {
            for (int j=0; j<[[[cellData objectAtIndex:i] objectForKey:[sections objectAtIndex:i]] count]; j++) {
                CityListObj *obj=[[[cellData objectAtIndex:i] objectForKey:[sections objectAtIndex:i]] objectAtIndex:j];
            //在搜索列表中的文字中包含中文的检索
            if ([ChineseInclude isIncludeChineseInString:obj.cityName]) {
                //汉字包含有的字母
               /* NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:[obj.cityName substringToIndex:searchBar.text.length]];
                NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:obj];
                } */
                //每个汉字的头字母
                NSInteger cityLength;
                if(searchBar.text.length>=obj.cityName.length) cityLength=obj.cityName.length;
                else cityLength=searchBar.text.length;
                
                NSString *cityName=obj.cityName;
                if([cityName rangeOfString:@"重庆"].length) cityName=@"从庆市";
                
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:[cityName substringToIndex:cityLength]];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:obj];
                }
            }
            //在搜索列表中的文字中不包含中文的检索
            else {
                NSRange titleResult=[obj.cityName rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:obj];
                }
            }
          }
        }
    }
   //在输入的文字中只包含中文的检索
    else if (mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
      for (int i=2; i<cellData.count; i++) {
            for (CityListObj *obj in [[cellData objectAtIndex:i] objectForKey:[sections objectAtIndex:i]]) {
                NSInteger cityLength;
                if(searchBar.text.length>=obj.cityName.length) cityLength=obj.cityName.length;
                else cityLength=searchBar.text.length;
                NSRange titleResult=[[obj.cityName substringToIndex:cityLength] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:obj];
                }
            }
        }
     }
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==alertView.cancelButtonIndex) {
       [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    else{
        if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
    }
}

#pragma mark - PressBtn_Location

-(void)PressBtn_Location{
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        if (!_locService) {
            _locService = [[BMKLocationService alloc]init];
            _locService.delegate=self;
        }
        UITableViewCell *cell=(UITableViewCell *)[_testTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.textLabel.text=@"";
        [_locService startUserLocationService];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务不可用"
                                                        message:@"GPS定位尚未打开，请在设置中开启定位"
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是",nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark - Animation

- (void)startAnimation
{
    UITableViewCell *cell=[self.testTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIButton *btn_location=(UIButton *)[cell viewWithTag:100];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0.0);  // 设定动画起始帧和结束帧
    animation.toValue = @(M_PI);
    animation.duration = 0.5;  //动画持续时间
    animation.cumulative = YES;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.repeatCount = 3000;  //重复次数
    [btn_location.layer addAnimation:animation forKey:@"transform.rotation.z"];
}

#pragma mark -
#pragma mark - BMKGeoCodeSearchDelegate

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        //将定位城市与开通城市比较
        IDIAIAppDelegate *delegate_=(IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        if([delegate_.array_city_list count]){
            BOOL is_city_kt=NO;
            for(CityListObj *obj in delegate_.array_city_list){
                if([obj.cityName isEqualToString:result.addressDetail.city]) {
                    is_city_kt=YES;
                    [cellData replaceObjectAtIndex:0 withObject:@{@"定位":@[[CityListObj objWithDict:@{@"cityAcronym":[NSString stringWithFormat:@"%@",[PinYinForObjc chineseConvertToPinYinHead:result.addressDetail.city]],@"cityCode":obj.cityCode,@"cityName":result.addressDetail.city,@"isHotCity":obj.isHotCity}]]}];
                    break;
                }
                else continue;
            }
            
            if(is_city_kt==NO){
                [cellData replaceObjectAtIndex:0 withObject:@{@"定位":@[[CityListObj objWithDict:@{@"cityAcronym":[NSString stringWithFormat:@"%@",[PinYinForObjc chineseConvertToPinYinHead:@""]],@"cityCode":@"",@"cityName":[NSString stringWithFormat:@"%@（暂未开通）",result.addressDetail.city],@"isHotCity":@""}]]}];
            }
            
            [_testTableView reloadData];
            [_locService stopUserLocationService];
        }
        else {
            [_locService stopUserLocationService];
            [self createProgressView];
            [self requestCitylist];
        }

    }
    else{
        [cellData replaceObjectAtIndex:0 withObject:@{@"定位":@[[CityListObj objWithDict:@{@"cityAcronym":[NSString stringWithFormat:@"%@",[PinYinForObjc chineseConvertToPinYinHead:@""]],@"cityCode":@"",@"cityName":@"定位失败",@"isHotCity":@""}]]}];
        [_testTableView reloadData];
        [_locService stopUserLocationService];
        
    }
}

#pragma mark -
#pragma mark - BMKLocationServiceDelegate


//在将要启动定位时，会调用此函数
- (void)willStartLocatingUser{
   [self startAnimation];
}

//在停止定位后，会调用此函数
- (void)didStopLocatingUser{
    UITableViewCell *cell=[self.testTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIButton *btn_location=(UIButton *)[cell viewWithTag:100];
    [btn_location.layer removeAnimationForKey:@"transform.rotation.z"];
}

//定位失败后，会调用此函数
- (void)didFailToLocateUserWithError:(NSError *)error{
    UITableViewCell *cell=[self.testTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIButton *btn_location=(UIButton *)[cell viewWithTag:100];
    [btn_location.layer removeAnimationForKey:@"transform.rotation.z"];
}

//用户位置更新后，会调用此函数
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation.location.coordinate.latitude >0 && userLocation.location.coordinate.longitude >0) {
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
        BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag) NSLog(@"反geo检索发送成功");
        else NSLog(@"反geo检索发送失败");
    }
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
