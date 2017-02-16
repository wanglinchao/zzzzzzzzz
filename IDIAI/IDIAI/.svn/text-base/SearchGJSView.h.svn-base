//
//  SearchGJSView.h
//  IDIAI
//
//  Created by iMac on 16/1/22.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchGJSView;
@protocol SearchGJSViewDelegate <NSObject>
@optional
- (void)searchType:(NSString *)searchType searchContent:(NSString *)searchContent cancle:(NSString *)cancle;
@end

@interface SearchGJSView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *mtableview_sub; //显示历史记录
    UIView *view_search_bg;
    UITextField *searchBar;
}
@property (nonatomic, weak) id<SearchGJSViewDelegate>delegate;

@property (nonatomic,strong) NSString *KHISTORY_SS_GongZhang;   //plist文件名字
@property (nonatomic,strong) NSString *fromName;   //来自于那个类的搜索
@property (nonatomic,strong) NSMutableArray *dataArray_history;  //历史记录

-(id)initWithFrame:(CGRect)frame historyData:(NSString *)data fromName:(NSString *)fromName;

@end
