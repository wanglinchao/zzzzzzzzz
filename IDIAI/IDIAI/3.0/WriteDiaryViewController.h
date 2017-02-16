//
//  WriteDiaryViewController.h
//  IDIAI
//
//  Created by PM on 16/7/13.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
@protocol writeDiaryDelegate;//SP
@interface WriteDiaryViewController : GeneralWithBackBtnViewController

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UITextField * textfield;//日记标题
@property(nonatomic,strong)UITextView * textView;//日记内容
@property (nonatomic,strong)UIButton * theRightBtn;//发布按钮

@property(nonatomic,strong)NSMutableArray *photoURL;//已发布的帖子，再次编辑时后台返回的图片地址
@property(nonatomic,assign)int diaryId;//帖子的id 新帖子时无id 再次编辑时帖子时有id即id>0
@property(nonatomic,assign)NSInteger diaryType1;//1写帖子 2提问
@property(nonatomic,assign)NSInteger useType;//使用该文件的类型 1utop 2 SP
@property (weak, nonatomic) id<writeDiaryDelegate> delegate;//SP 端使用
@property (nonatomic,assign)NSInteger roleId;

//@property (nonatomic,assign)NSInteger releaseType;//0发帖 1


- (void)releaseNewDiary:(UIButton *)sender;

@end

@protocol writeDiaryDelegate <NSObject>
- (void)FinishedEdit;

@end
