//
//  ICEDebugapplist.m
//  ICEDebug
//
//  Created by wujianrong on 2018/11/23.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugapplist.h"

@implementation ICEDebugapplist

+(NSArray*)appArray
{
    return @[ @"qunarphone://",
              @"wxbcf237c12b7ac8c2://",
              @"tbopen23259936://",
              @"wx24ca05cc7b7a643b://",
              @"wx2ff83262e421c16a://",
              @"com.fiftythree.paper://",
              @"fb1511626475810676://",
              @"wb2003410384://",
              @"qqstock://",
              @"fb221094574568058://",
              @"wb2982475902://",
              @"uberx://",
              @"diditaxi://",
              @"fb1450228115208330://",
              @"mihome://",
              @"beastbikebluegogo://",
              @"ofoapp://",
              @"mobike://",
              @"amihexinpro://",
              @"mobilephone://",
              @"mobilenotes://",
              @"com.moke.moke-1://",
              @"camcard://",
              @"camscanner://",
              @"mobisystemsofficesuite://",
              @"line://",
              @"onepassword://",
              @"clearapp://",
              @"googlechrome://",
              @"trainassist://",
              @"com.kingsoft.powerword.6://",
              @"tencentrm://",
              @"comIfeng3GifengNews://",
              @"gtgj://",
              @"doubanradio://",
              @"dzhiphone://",
              @"buka://",
              @"bilibili://",
              @"com.56Video://",
              @"rili365://",
              @"wbmain://",
              @"iaround://",
              @"momochat://",
              @"wangwangseller://",
              @"yddict://",
              @"youku://",
              @"iReader://",
              @"elongIPhone://",
              @"thunder://",
              @"wb1405365637://",
              @"CtripWireless://",
              @"SuZhouTV://",
              @"vipshop://",
              @"weishiiosscheme://",
              @"wpweipai://",
              @"wangxin://",
              @"ntesopen://",
              @"netease-mkey://",
              @"youloft.419805549://",
              @"tudou://",
              @"amihexin://",
              @"tianya://",
              @"sinaweatherpro://",
              @"sinaweather://",
              @"rm434209233MojiWeather://",
              @"qqnews://",
              @"weiyun://",
              @"sosomap://",
              @"taobaotravel://",
              @"renrenios://",
              @"qtfmp://",
              @"wx1cb534bb13ba3dbd://",
              @"cmbmobilebank://",
              @"alipay://",
              @"wx2654d9155d70a468://",
              @"com.icbc.iphoneclient://",
              @"com.kuwo.kwmusic.kwmusicForKwsing://",
              @"kugouURL://",
              @"openApp.jdMobile://",
              @"snssdk141://",
              @"qqmusic://",
              @"mttbrowser://",
              @"qmtoken://",
              @"mqqiapi://",
              @"pptv://",
              @"qiyi-iphone://",
              @"com.baofeng.play://",
              @"wb2217954495://",
              @"wb1308702128://",
              @"BaiduSSO://",
              @"baidumusic://",
              @"bainuo://",
              @"photowonder://",
              @"wondercamera://",
              @"baidumap://",
              @"bdNavi://",
              @"com.sogou.sogouinput://",
              @"sohunews://",
              @"FDMoney://",
              @"qqbizmailDistribute2://",
              @"mqqsecure://",
              @"TencentWeibo://",
              @"tmall://",
              @"tencent100689806://",
              @"tencent100689805://",
              @"tencent100692648://",
              @"tencent100695850://",
              @"ttpod://",
              @"wacai://",
              @"com.weiphone.forum://",
              @"neteasemail://",
              @"Autonavi://",
              @"BaiduIMShop://",
              @"com.baidu.tieba://",
              @"taobao://",
              @"baiduyun://",
              @"newsapp://",
              @"ucbrowser://",
              @"mqq://",
              @"tel://",
              @"sms://",
              @"mailto://",
              @"ibooks://",
              @"videos://",
              @"weixin://",
              @"sinaweibo://",
              @"weico://",
              @"jdmoble://",
              @"imeituan://",
              @"wccbyihaodian://",
              @"wcc://",
              @"yddictproapp://",
              @"zhihu://",
              @"dianping://",
              @"sinavdisk://",
              @"nplayer-http://",
              @"gplayer://",
              @"AVPlayer://",
              @"fetion://",
              @"ppstream://",
              @"sohuvideo-iphone://",
              @"weibo://",
              @"wechat://",];
}
+ (NSString*)checkApp {
    
    NSArray* list = [self appArray];
    
    if (list.count < 1) {
        return nil;
    }
    
    NSMutableString *resultArray = [NSMutableString new];
    [list enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString* scheme = obj;
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]) {
            //have it
          
                [resultArray appendString:obj];

        }
    }];
    return resultArray;
}

+(NSString *)processCommand:(NSArray *)args
{
    return [NSString stringWithFormat:@"%@", [self checkApp]];
    
}
@end
