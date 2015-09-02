//
//  MainViewController.m
//  WifiSteward
//
//  Created by zhuang chaoxiao on 15/9/2.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "MainViewController.h"
#import "Header.h"
#import "NetSpyViewController.h"
#import "UIScrollView+UITouch.h"
#import "SystemServices.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "CleanViewController.h"
#import "SignViewController.h"
#import "NetSpeedViewController.h"



@interface MainViewController ()
{
    
}

@property (weak, nonatomic) IBOutlet UILabel *curIPLab;
@property (weak, nonatomic) IBOutlet UILabel *wifiNameLab;



@property (weak, nonatomic) IBOutlet UIView *firstBgView;
@property (weak, nonatomic) IBOutlet UIView *secondBgView;
@property (weak, nonatomic) IBOutlet UIView *thirdBgView;
@property (weak, nonatomic) IBOutlet UIView *fourthBgView;
@property (weak, nonatomic) IBOutlet UIView *fifthBgView;
@property (weak, nonatomic) IBOutlet UIView *sixthBgView;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"WiFi管家";
    
    
    NSString * curIpStr = [[SystemServices sharedServices] currentIPAddress];
    NSString * wifiNameStr = [self getWifiName];
    
    if( curIpStr )
    {
        _curIPLab.text = curIpStr;
    }
    else
    {
        _curIPLab.text = @"未连接WIFI";
    }
    
    if( wifiNameStr )
    {
        _wifiNameLab.text = wifiNameStr;
    }
    else
    {
        _wifiNameLab.text = @"";
    }
    
    
    //
    
}

-(NSString *)getWifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces)
    {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces)
    {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef)
        {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * t = [touches anyObject];
    
    CGPoint pt;
    
    pt = [t locationInView:_firstBgView];
    if( CGRectContainsPoint(_firstBgView.bounds, pt))
    {
        if( pt.x < [UIScreen mainScreen].bounds.size.width/2 )
        {
            NetSpyViewController * vc = [[NetSpyViewController alloc]initWithNibName:@"NetSpyViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
            return;
        }
        
        if( pt.x > [UIScreen mainScreen].bounds.size.width/2 )
        {
            CleanViewController * vc = [[CleanViewController alloc]initWithNibName:@"CleanViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
            return;
        }
    }
    
    //
    pt = [t locationInView:_thirdBgView];
    if( CGRectContainsPoint(_thirdBgView.bounds, pt))
    {
        SignViewController * vc = [[SignViewController alloc]initWithNibName:@"SignViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    //
    pt = [t locationInView:_fourthBgView];
    if( CGRectContainsPoint(_fourthBgView.bounds, pt))
    {
        NetSpeedViewController * vc = [[NetSpeedViewController alloc]initWithNibName:@"NetSpeedViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    //
    pt = [t locationInView:_fifthBgView];
    if( CGRectContainsPoint(_fifthBgView.bounds, pt))
    {
        return;
    }
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
