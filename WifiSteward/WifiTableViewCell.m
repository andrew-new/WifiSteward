//
//  WifiTableViewCell.m
//  WifiSteward
//
//  Created by zhuang chaoxiao on 15/12/1.
//  Copyright © 2015年 zhuang chaoxiao. All rights reserved.
//

#import "WifiTableViewCell.h"
#import "CommData.h"


@interface WifiTableViewCell()
{
    UIViewController * parVC;
}
@property (weak, nonatomic) IBOutlet UILabel *wifiNameLab;
@property (weak, nonatomic) IBOutlet UILabel *disLab;
@property (strong,nonatomic) NSArray * wifiArray;

- (IBAction)getPSWClicked;

@end


@implementation WifiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshCell:(int)row withVC:(UIViewController*)vc
{
    parVC = vc;
    //
    int rand = (arc4random()*row)%self.wifiArray.count;
    _wifiNameLab.text = self.wifiArray[rand];
    
    _disLab.text = [NSString stringWithFormat:@"%d米",row + rand];
    
}

-(NSArray*)wifiArray
{
    if( !_wifiArray )
    {
        _wifiArray = @[@"TP-Link_123",@"CM_WAP",@"ROLLROCK",@"MERCURY_10086",@"MERCURY_3",@"JOYTAL_001",@"JOYTAL_SH",@"TZC_EDU",@"zhuangchaoxiao",@"yangyili-886",@"QSMF",@"baidu_tec",@"SHANGHAI_MOBILE",@"qiaofang_002",@"PM-1",@"PM-2",@"PM-3",@"zwmch_hdc",@"FREE_WIFI",@"10086",@"China_mobile",@"zhongguoshihua",@"479408690",@"Source-JOy",@"Prod-1",@"Prod_2",@"Find_dd",@"Find_231",@"CodeAAA",@"CodeBBB",@"Build-123",@"Build555",@"jia_1",@"jia_2",@"JIA",@"Market_1",@"Market_2",@"xiaoxiaoer",@"zhuangchaoxiao",@"linxingru",@"ZZT",@"U876",@"888-888",@"999-999",@"123456",@"NO_PASSWORD",@"lianxiwo",@"momoyaoyiyao",@"nishuone",@"wodewuxian",@"WUXIANWANGLUO",@"WUXIAN-WIFI",@"DEBUG",@"CODING",@"FUCKING",@"CONNECT_ME",@"CONNECT_111",@"ZHAOXIAOJIE",@"ZHENDE",@"jiali",@"woshi",@"chufang",@"weishengjian",@"333-WIFI",@"Coffe",@"Stuback",@"Over Flow"];
    }
    
    return _wifiArray;
}

- (IBAction)getPSWClicked
{
    
    UIAlertController * c = [UIAlertController alertControllerWithTitle:@"提示" message:@"免费使用WIFI前请先给5星好评，谢谢！！！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * y = [UIAlertAction actionWithTitle:@"现在就去" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreAddress]];
        
    }];
    
    UIAlertAction * n = [UIAlertAction actionWithTitle:@"不了,我不想用免费WIFI了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    
    [c addAction:y];
    [c addAction:n];
    
    [parVC presentViewController:c animated:YES completion:nil];
}
@end
