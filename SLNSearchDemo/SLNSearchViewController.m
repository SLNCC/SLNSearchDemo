//
//  SLNSearchViewController.m
//  SLNSearchDemo
//
//  Created by 乔冬 on 17/3/16.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import "SLNSearchViewController.h"
#import "SLNTextView.h"
#import "SLNOneColumsTableCell.h"
#import "SLNHistoryTableViewCell.h"
#import "SLNDeleteAllTableViewCell.h"
#import "SLNLabelView.h"
#import "SLNDataBase.h"
#import "SLNSearchReaultViewController.h"

@interface SLNSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SLNLabelViewDelegate>
{
    SLNDataBase *slnDataBase;
    SLNLabelView *   slnLabelView;
}
@property (nonatomic,strong) UITableView *slnSearchTableView;
@property (nonatomic,strong) UITableView *slnShowTableView;
@property (nonatomic,strong) UITextField *slnTextField;
//热门数据
@property (nonatomic,strong)  NSMutableArray *hotArray;
//展示数据
@property (nonatomic,strong) NSArray *dataArray;
//历史记录
@property (nonatomic,strong) NSArray *hostoryArray;
@end

@implementation SLNSearchViewController
-(NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
-(NSArray *)hostoryArray{
    if (_hostoryArray == nil) {
        _hostoryArray = [NSArray array];
    }
    return _hostoryArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        _hotArray = [NSMutableArray array];
    slnDataBase = [[SLNDataBase alloc]init];
    [self request];
    [self setNavBar];
    [self addTableView];

}
-(void)cacelAction{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark--数据源--热门标签和历史记录
-(void)request{
    //热门标签
    NSArray *array  =  @[@"热卖", @"海尔冰箱", @"额呵呵和", @"呵呵", @"你好", @"不好？" , @"很不好", @"浴巾", @"座椅", @"依靠着", @"一览这", @"天下", @"海尔天下"];
    for (NSString *string in array) {
        SLNHostory *hostory = [slnDataBase createSLNHostoryEntityWithTitle: string] ;
        [_hotArray addObject:hostory];
    }

    //历史记录
    _hostoryArray = [slnDataBase slnSelectAllCoreData];

}
#pragma mark--数据源:搜索结果展示
- (void)slnSearchResults:(NSString *)text{
    _dataArray = @[@"热卖", @"海尔冰箱", @"额呵呵和", @"呵呵", @"你好", @"不好？" , @"很不好", @"浴巾", @"座椅", @"依靠着", @"一览这", @"天下", @"海尔天下"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{   
        
        [self .slnShowTableView reloadData];
    });
}
- (void)addTableView{
    slnLabelView = [[SLNLabelView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 180 +49 +23)];
    slnLabelView.delegate = self;
    slnLabelView.tags = _hotArray;
    slnLabelView.tagTextFont = [UIFont systemFontOfSize:14];
    [self.view addSubview:slnLabelView];
    
    self.slnSearchTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self .slnSearchTableView registerNib:[UINib nibWithNibName:@"SLNHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"SLNHistoryTableViewCell"];
    [self .slnSearchTableView registerNib:[UINib nibWithNibName:@"SLNDeleteAllTableViewCell" bundle:nil] forCellReuseIdentifier:@"SLNDeleteAllTableViewCell"];
    [self.view addSubview:self.slnSearchTableView];
    self.slnSearchTableView.tableHeaderView = slnLabelView;
    
    self.slnShowTableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    self.slnShowTableView.hidden = YES;
    [self.slnShowTableView registerNib:[UINib nibWithNibName:@"SLNOneColumsTableCell" bundle:nil] forCellReuseIdentifier:@"SLNOneColumsTableCell" ];
    [self.view addSubview:self.slnShowTableView];
}
#pragma mark --SLNLabelViewDelegate--热门标签点击事件
-(void)slnDidSelectItemAtIndexPath:(NSIndexPath *)indexPath SLNHostory:(SLNHostory *)slnHostory{
        _hostoryArray = [slnDataBase readInsertAndCreateSLNHostoryEntityWithTitle:slnHostory.title];
    [self slnSearchText:slnHostory.title];
    [self.slnSearchTableView reloadData];
    [self slnResignFirstResponder];

    [self slnHiddenShowTableView];
#warning mark--添加正确的数据源。
    [self slnSearchResults:slnHostory.title];
    NSLog(@"%@",slnHostory);
}
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.slnShowTableView) {
             return _dataArray.count;
    }
    if (_hostoryArray.count > 0) {
        return _hostoryArray.count + 1;
    }
    return _hostoryArray.count ;
}
//cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.slnShowTableView) {
        SLNOneColumsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLNOneColumsTableCell"  forIndexPath:indexPath];
        return cell;
    }
    if (indexPath.row < _hostoryArray.count) {
        SLNHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLNHistoryTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.row = indexPath.row;
        SLNHostory *hostory = _hostoryArray[indexPath.row];
        cell.slnTitleLabel.text = hostory.title;
        NSMutableArray *array = [NSMutableArray arrayWithArray: _hostoryArray ];
        
        cell.callbackDelegteRowBlock = ^(NSInteger index){
            NSLog(@"%ld",index);
            SLNHostory *hostory = _hostoryArray[indexPath.row];
            [array removeObjectAtIndex:index];
            _hostoryArray = [slnDataBase readDeletePerManagedObject:hostory];
            [self.slnSearchTableView reloadData];
        };
    
        return cell;
    }else{
        SLNDeleteAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLNDeleteAllTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
  
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.slnShowTableView) {
        return 130;
    }else{
        return 50;
    }
}

#pragma mark -- UITableViewDelegate
#pragma mark --选中cell的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_slnTextField resignFirstResponder];
    if (tableView == self.slnSearchTableView){
        if (indexPath.row == _hostoryArray.count) {
           _hostoryArray =  [slnDataBase readDeleteAllCoreData];
            [self.slnSearchTableView reloadData];
            return;
        }
    }
    if (tableView == self.slnShowTableView) {
        
        SLNSearchReaultViewController *vc = [[SLNSearchReaultViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [self slnHiddenShowTableView];
    SLNHostory *hostory = _hostoryArray[indexPath.row];
    [self slnSearchText:hostory.title];
#warning mark--添加正确的数据源。
    [self slnSearchResults:hostory.title];
    
}


#pragma mark - UITextFieldDelegate
#pragma mark --搜索事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *text = textField.text;
    NSLog(@"搜索之前%ld",_hostoryArray.count);
    if(text.length >0){
        _hostoryArray = [slnDataBase readInsertAndCreateSLNHostoryEntityWithTitle:text];
            NSLog(@"搜索之后%ld",_hostoryArray.count);
    }
    [self slnResignFirstResponder];
    [self.slnSearchTableView reloadData];
    [self slnHiddenShowTableView];
#warning mark--添加正确的数据源。
    [self slnSearchResults:text];
    return true;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self slnShowHiddenTableView];
    return true;
}
#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self slnResignFirstResponder];
}
#pragma mark -- private
-(void)slnResignFirstResponder{
        [_slnTextField resignFirstResponder];
}
-(void)slnSearchText:(NSString *)text{
            _slnTextField.text = text;
}
//展示搜索，隐藏展示数据
-(void)slnShowHiddenTableView{
    self.slnSearchTableView.hidden = NO;
    self.slnShowTableView.hidden = YES;
}
//展示数据，隐藏搜索
-(void)slnHiddenShowTableView{
    self.slnSearchTableView.hidden = YES;
    self.slnShowTableView.hidden = NO;
}
#pragma mark -- getter
-(UITableView *)slnSearchTableView{
    if (!_slnSearchTableView) {
         _slnSearchTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _slnSearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _slnSearchTableView.delegate = self;
        _slnSearchTableView.dataSource = self;
    }
    return _slnSearchTableView;
}
-(UITableView *)slnShowTableView{
    if (!_slnShowTableView) {
        _slnShowTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _slnShowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _slnShowTableView.delegate = self;
        _slnShowTableView.dataSource = self;
    }
    return _slnShowTableView;
}

#pragma mark -- 导航搜索布局
-(void)setNavBar{
    CGFloat h = 35;
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width , h);
    CGFloat imgW = 14;
    CGFloat imgH = 14;
    CGFloat left = 8;
    
    UIView *leftView = [[UIView alloc]init];
    leftView.frame = CGRectMake(0, (h -imgW)/2.0, imgW +left,imgH);
    leftView.backgroundColor = [UIColor clearColor];
    
    UIImage *Img = [UIImage imageNamed:@"home_search"];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.frame =    CGRectMake(left, 0, imgW ,imgH);
    [leftView addSubview:imgView];
    imgView.image = Img;
    
    _slnTextField = [[UITextField alloc]initWithFrame:rect];
    _slnTextField.placeholder = @"请输入搜索关键字";
    _slnTextField.leftViewMode = UITextFieldViewModeAlways;
    _slnTextField.leftView =  leftView;
    _slnTextField.delegate = self;
    _slnTextField.returnKeyType = UIReturnKeySearch;
    _slnTextField.textColor = [UIColor colorWithRed:212/256.0 green:213/256.0 blue:214/256.0 alpha:1.0];
    _slnTextField.clearButtonMode = UITextFieldViewModeAlways;
    _slnTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.navigationItem.titleView = _slnTextField;
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cacelAction)];
    //    [rightItem setTitleTextAttributes:@{NSBackgroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [rightItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
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
