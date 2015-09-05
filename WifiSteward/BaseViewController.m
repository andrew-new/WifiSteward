//
//  BaseViewController.m
//  WifiSteward
//
//  Created by zhuang chaoxiao on 15/9/5.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    {
        UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        //[leftBtn setTitle:@"返回" forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"NavBack"] forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}


-(void)backClick
{
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
