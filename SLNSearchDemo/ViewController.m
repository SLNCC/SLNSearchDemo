//
//  ViewController.m
//  SLNSearchDemo
//
//  Created by 乔冬 on 17/3/16.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import "ViewController.h"
#import "SLNSearchViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *slFirstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    slFirstBtn.backgroundColor = [UIColor redColor];
    slFirstBtn.frame = CGRectMake(0, 64, 80, 80);
    [slFirstBtn addTarget:self action:@selector(slFirstBtnClikedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:slFirstBtn];

    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
        UIImage *Img = [UIImage imageNamed:@"search_icon_history"];
    UIImage *Img1 = [UIImage imageNamed:@"search_icon_fork"];
}
- (void)slFirstBtnClikedBtn:(UIButton *)sender{
    SLNSearchViewController *Vc = [[SLNSearchViewController alloc]init];
    [self.navigationController pushViewController:Vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
