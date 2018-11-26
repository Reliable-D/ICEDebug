//
//  ConvertViewController.m
//  ICEDebug
//
//  Created by apple on 2018/11/23.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ConvertViewController.h"

@implementation ConvertViewController
    +(NSString*)convert:(UIViewController *)vc
    {
        NSMutableString* str = [NSMutableString new];
        [str appendString:@"<!DOCTYPE html>\r\n"];
        [str appendString:@"<html lang=\"en\">\r\n"];
        [str appendString:@"<head>\r\n"];
        [str appendString:@"<meta charset=\"UTF-8\">\r\n"];
        [str appendString:@"<meta http-equiv=\"refresh\" content=\"10\">\r\n"];
        [str appendString:@"<title>screeninfo</title>\r\n"];
        [str appendString:@"</head><body>\r\n"];
        [str appendString:@"<h2>No Host: header received</h2>\r\n"];
        UIApplication* app = [UIApplication sharedApplication];
        [str appendString:[self addsubViews:app.delegate.window]];
        [str appendString:@"</body></html>"];
        
        return str;
    }
    
    +(NSString*)colorToString:(UIColor*)color
    {
        CGFloat red = 0;
        CGFloat green = 0;
        CGFloat blue = 0;
        CGFloat alpha = 0;
        if (color != nil) {
            [color getRed:&red green:&green blue:&blue alpha:&alpha];
        }
        return [NSString stringWithFormat:@"rgba(%d,%d,%d,%f)", (int)(red*255), (int)(green*255), (int)(blue*255), alpha];
    }
    
    +(NSString*)colorToHexString:(UIColor*)color
    {
        CGFloat red = 0;
        CGFloat green = 0;
        CGFloat blue = 0;
        CGFloat alpha = 0;
        if (color != nil) {
            [color getRed:&red green:&green blue:&blue alpha:&alpha];
        }
        return [NSString stringWithFormat:@"%02x%02x%02x", (int)(red*255), (int)(green*255), (int)(blue*255)];
    }
    
    +(NSString*)addsubViews:(UIView*)view
    {
        NSMutableString* str = [NSMutableString new];
        if ([view isKindOfClass:[UILabel class]]) {
            
            [str appendString:[self getLabelHtml:view]];
        }
        else if([view isKindOfClass:[UIImageView class]])
        {
            [str appendString:[self getImageViewHtml:view]];
        }
        else
        {
            [str appendString:[self getViewHtml:view]];
        }
        
        for (UIView* subView in view.subviews) {
            [str appendString:[self addsubViews:subView]];
        }
        [str appendFormat:@"</div>"];
        return str;
    }
    
    +(NSString*)getLabelHtml:(UILabel*)view
    {
        UILabel* label = (UILabel*)view;
        return [NSString stringWithFormat:@"<div style=\"background: %@;  position: absolute; width: %dpx; height: %dpx; left: %dpx; top: %dpx;color: #%@; font-size: %dpx;\">%@",[self colorToString:[view backgroundColor]], (int)view.frame.size.width, (int)view.frame.size.height, (int)view.frame.origin.x, (int)view.frame.origin.y, [self colorToHexString:label.textColor], (int)label.font.pointSize,  label.text];
    }
    
    +(NSString*)getViewHtml:(UIView*)view
    {
        return [NSString stringWithFormat:@"<div style=\"background: %@;  position: absolute; width: %dpx; height: %dpx; left: %dpx; top: %dpx;\">",[self colorToString:[view backgroundColor]], (int)view.frame.size.width, (int)view.frame.size.height, (int)view.frame.origin.x, (int)view.frame.origin.y];
    }
    +(NSString*)getImageViewHtml:(UIImageView*)view
    {
        /*
         <div style="position: absolute; width: 50px;
         height: 50px;
         left: 30px;
         top: 400px; background-image: url('http://127.0.0.1:10087/image.png'); background-size: contain;"></div>*/
        [self addImageView:view];
        return [NSString stringWithFormat:@"<div style=\"position: absolute; width: %dpx; height: %dpx; left: %dpx; top: %dpx; background-image: url('http://127.0.0.1:10087/%@.png'); background-size: contain;\">", (int)view.frame.size.width, (int)view.frame.size.height, (int)view.frame.origin.x, (int)view.frame.origin.y, [NSString stringWithFormat:@"%lx", (long)view]];
        
      //  return [NSString stringWithFormat:@"<div style=\"position: absolute; width: %dpx; height: %dpx; left: %dpx; top: %dpx; background-image: url('%@'); background-size: contain;\">", (int)view.frame.size.width, (int)view.frame.size.height, (int)view.frame.origin.x, (int)view.frame.origin.y, @"https://www.baidu.com/img/bd_logo1.png?qua=high"];//[NSString stringWithFormat:@"%lx", (long)view]];
    }
    
    static NSMutableDictionary* _static_ice_debugImageViewList = nil;
    
    +(void)addImageView:(UIImageView*)view
    {
        if (_static_ice_debugImageViewList == nil) {
            _static_ice_debugImageViewList = [NSMutableDictionary new];
        }
        [_static_ice_debugImageViewList setObject:view forKey:[NSString stringWithFormat:@"%lx", (long)view]];
    }
    
    +(UIImage*)getImageWithKey:(NSString*)key
    {
        UIImageView* view = [_static_ice_debugImageViewList objectForKey:key];
     //   [_static_ice_debugImageViewList removeObjectForKey:key];
        return view.image;
    }
    
@end
