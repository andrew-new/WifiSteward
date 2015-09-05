//
//  MainViewController.m
//  WifiSteward
//
//  Created by zhuang chaoxiao on 15/9/2.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "MainViewController.h"
#import "NetSpyViewController.h"
#import "UIScrollView+UITouch.h"
#import "SystemServices.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "CleanViewController.h"
#import "SignViewController.h"
#import "NetSpeedViewController.h"
#import "CommInfo.h"
#import "CommData.h"

#define SystemSharedServices [SystemServices sharedServices]


@import GoogleMobileAds;

//
@interface MainViewController ()<BaiduMobAdViewDelegate>
{
    //电池
    CGFloat firstBatteryLevel;
    NSDate * curBatteryTime;
}

@property (weak, nonatomic) IBOutlet UILabel *curIPLab;
@property (weak, nonatomic) IBOutlet UILabel *wifiNameLab;

@property (weak, nonatomic) IBOutlet UIView *firstBgView;
@property (weak, nonatomic) IBOutlet UIView *secondBgView;
@property (weak, nonatomic) IBOutlet UIView *thirdBgView;
@property (weak, nonatomic) IBOutlet UIView *fourthBgView;
@property (weak, nonatomic) IBOutlet UIView *fifthBgView;
@property (weak, nonatomic) IBOutlet UIView *sixthBgView;
@property (weak, nonatomic) IBOutlet UIView *seventhBgView;

@property (weak, nonatomic) IBOutlet UILabel *netUseLab;
@property (weak, nonatomic) IBOutlet UILabel *batteryLab;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"WiFi管家";
    
    //
    [self layoutADV];
    
    //
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
    
    [self drawNetFlow];
    
    //
    [self notiBattery];
    [self drawBattery];
}


//电池百分比
-(CGFloat)getBatteryPercent
{
    return [SystemSharedServices batteryLevel]/100.0;
}

-(void)getBatteryTime
{
    firstBatteryLevel = [SystemSharedServices batteryLevel];
    curBatteryTime = [NSDate date];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(batteryCharged:)
     name:UIDeviceBatteryLevelDidChangeNotification
     object:nil
     ];
    
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(notiBattery) userInfo:nil repeats:NO];
}

-(void)notiBattery
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceBatteryLevelDidChangeNotification object:nil];
}

- (void)batteryCharged:(NSNotification *)note
{
    float currBatteryLev = [SystemSharedServices batteryLevel];
    
    if( [SystemSharedServices fullyCharged] )
    {
        _batteryLab.text = @"已充满";
    }
    else if( [SystemSharedServices charging] )
    {
        float avgChgSpeed = (firstBatteryLevel - currBatteryLev)*1.0 / [curBatteryTime timeIntervalSinceNow];
        
        float remBatteryLev = 100 - currBatteryLev;
        
        NSInteger remSeconds = remBatteryLev / avgChgSpeed;
        
        _batteryLab.text = [NSString stringWithFormat:@"%02ld:%02ld",(remSeconds)/3600,((remSeconds)%3600)/60];
        
        if( ((remSeconds)/3600== 0) && ((remSeconds)%3600/60 == 0))
        {
            _batteryLab.text = @"已充满";
        }
        else if( avgChgSpeed == 0 )
        {
            _batteryLab.text = @"计算中...";
        }
    }
    //放电
    else
    {
        float avgChgSpeed = fabs((firstBatteryLevel - currBatteryLev)*1.0 / [curBatteryTime timeIntervalSinceNow]);
        
        NSInteger remSeconds = currBatteryLev / avgChgSpeed;
        
        _batteryLab.text = [NSString stringWithFormat:@"%02ld:%02ld",(remSeconds)/3600,((remSeconds)%3600)/60];
        
        if( firstBatteryLevel - currBatteryLev == 0 )
        {
            _batteryLab.text = [NSString stringWithFormat:@"%02d:%02d",23,55];
        }
    }

}


-(void)drawBattery
{
    CGFloat precent = [self getBatteryPercent];

    //如果是充电
    if( [SystemSharedServices charging] )
    {
        if( [SystemSharedServices fullyCharged] || precent == 1 )
        {
            _batteryLab.text = @"已充满";
        }
    }
    else
    {
        if( precent == 1 )
        {
            _batteryLab.text = [NSString stringWithFormat:@"%02d:%02d",23,55];
        }
    }
}


///////////////////
-(void)drawNetFlow
{
    _netUseLab.text =  [self getNetMonthUse];
}

-(BOOL)twoDateSameMonth:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSMonthCalendarUnit ;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    
    return [comp1 month] == [comp2 month];
}

-(BOOL)twoDateSameTime:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    
    return ([comp1 year] == [comp2 year]) && ([comp1 year] == [comp2 year]) && ([comp1 day] == [comp2 day])&&([comp1 hour] == [comp2 hour])&&([comp1 minute] == [comp2 minute]);
}


-(NSString*)getNetMonthUse
{
    NetUseInfo * useInfo = [self getNetFromStore];
    if( !useInfo )
    {
        useInfo = [NetUseInfo new];
    }
    
    NSUInteger totalByte = 0;
    NSDate * powerDate = [SystemSharedServices getSystemPowerDate];
    NSDate * curDate = [NSDate date];
    NSDictionary * dataDict = [SystemSharedServices getDataCounters];
    
    if( [useInfo.lastDate isEqualToDate:powerDate] )
    {
        NSLog(@"equal");
    }
    
    //两次开机时间不同，且3个时间都在同一个月内，
    if( (![self twoDateSameTime:useInfo.lastDate date2:powerDate]) && [self twoDateSameMonth:curDate date2:powerDate ] &&  [self twoDateSameMonth:curDate date2:useInfo.lastDate ] )
    {
        totalByte = useInfo.lastByte + [dataDict[DataCounterKeyWWANSent] unsignedIntegerValue] +[dataDict[DataCounterKeyWWANReceived] unsignedIntegerValue];
        useInfo.lastDate = powerDate;
        useInfo.lastByte = totalByte;
    }
    else
    {
        totalByte = [dataDict[DataCounterKeyWWANSent] unsignedIntegerValue] +[dataDict[DataCounterKeyWWANReceived] unsignedIntegerValue];
        useInfo.lastDate = powerDate;
        useInfo.lastByte = totalByte;
    }
    
    [self setNetToStore:useInfo];
    
    //
    return [self tranByte:useInfo.lastByte];
}

-(NetUseInfo*)getNetFromStore
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSData * data = [def objectForKey:STORE_NET_INFO];
    
    NetUseInfo * useInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return useInfo;
}


-(void)setNetToStore:(NetUseInfo*)info
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:info];
    [def setObject:data forKey:STORE_NET_INFO];
    
    [def synchronize];
}

-(NSString *)tranByte:(NSUInteger)byte
{
    if( byte*1.0 / 1073741824 >= 1 )
    {
        return [NSString stringWithFormat:@"%.2fG",byte*1.0 / 1073741824];
    }
    else if( byte*1.0 / 1048576 >= 1 )
    {
        return [NSString stringWithFormat:@"%.2fM",byte*1.0 / 1048576];
    }
    else if( byte*1.0 / 1024 >= 1 )
    {
        return [NSString stringWithFormat:@"%.2fK",byte*1.0 / 1024];
    }
    
    return @"";
}

/////////////////////////////////网络流量-----end///////////////////////////////////////////////////


- (NSString *)publisherId
{
    return @"fece40ae";
}

/**
 *  应用在union.baidu.com上的APPID
 */
- (NSString*) appSpec
{
    return @"fece40ae";
}

-(void)layoutADV
{
    NSInteger flag = arc4random() % 3;
    
    
    //中间部位
    
    if( flag == 0 )
    {
        {
            CGPoint pt ;
            
            pt = CGPointMake(0, 0);
            GADBannerView * _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner origin:pt];
            
            _bannerView.adUnitID = @"ca-app-pub-3058205099381432/3977991942";//调用你的id
            _bannerView.rootViewController = self;
            [_bannerView loadRequest:[GADRequest request]];
            
            [_secondBgView addSubview:_bannerView];
        }
        
        
        {
            BaiduMobAdView * _baiduView = [[BaiduMobAdView alloc]init];
            _baiduView.AdType = BaiduMobAdViewTypeBanner;
            _baiduView.frame = CGRectMake(0, 0, kBaiduAdViewBanner468x60.width, kBaiduAdViewBanner468x60.height);
            _baiduView.delegate = self;
            [_seventhBgView addSubview:_baiduView];
            [_baiduView start];
        }

    }
    else//底部
    {
        {
            BaiduMobAdView * _baiduView = [[BaiduMobAdView alloc]init];
            _baiduView.AdType = BaiduMobAdViewTypeBanner;
            _baiduView.frame = CGRectMake(0, 0, kBaiduAdViewBanner468x60.width, kBaiduAdViewBanner468x60.height);
            _baiduView.delegate = self;
            [_secondBgView addSubview:_baiduView];
            [_baiduView start];
        }
        
        {
            CGPoint pt ;
            
            pt = CGPointMake(0, 0);
            GADBannerView * _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner origin:pt];
            
            _bannerView.adUnitID = @"ca-app-pub-3058205099381432/5454725149";//调用你的id
            _bannerView.rootViewController = self;
            [_bannerView loadRequest:[GADRequest request]];
            
            [_seventhBgView addSubview:_bannerView];
        }
    }
 
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
