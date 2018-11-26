//
//  ICEDebugMacro.h
//  ICEDebug
//
//  Created by wujianrong on 2018/6/14.
//  Copyright © 2018年 wanda. All rights reserved.
//

#ifndef ICEDebugMacro_h
#define ICEDebugMacro_h



#define ICE_DEBUG_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define ICE_DEBUG_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define ICE_DEBUG_VR(v) ((v).frame.origin.x + (v).frame.size.width)
#define ICE_DEBUG_VW(v)  (v).frame.size.width
#define ICE_DEBUG_VH(v)  (v).frame.size.height
#define ICE_DEBUG_VB(v)  ((v).frame.origin.y + (v).frame.size.height)
#define ICE_DEBUG_VL(v) (v).frame.origin.x
#define ICE_DEBUG_VT(v) (v).frame.origin.y
#define ICE_DEBUG_RGB(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define ICE_DEBUG_MX(v, value) (v).frame = CGRectMake((value), (v).frame.origin.y, (v).frame.size.width, (v).frame.size.height)

#define ICE_DEBUG_MY(v, value) (v).frame = CGRectMake((v).frame.origin.x, (value), (v).frame.size.width, (v).frame.size.height)

#define ICE_DEBUG_MW(v, value)         (v).frame = CGRectMake((v).frame.origin.x, (v).frame.origin.y, (value), (v).frame.size.height)
#define ICE_DEBUG_MH(v, value)         (v).frame = CGRectMake((v).frame.origin.x, (v).frame.origin.y, (v).frame.size.width, (value))

#define ICE_DEBUG_MO(v, value)  (v).frame = CGRectMake(value.x, value.y, (v).frame.size.width, (v).frame.size.height)
#endif /* ICEDebugMacro_h */
