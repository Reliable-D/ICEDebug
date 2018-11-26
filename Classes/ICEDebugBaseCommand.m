//
//  ICEDebugBaseCommand.m
//  ICEDebug
//
//  Created by wujianrong on 2018/6/13.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugBaseCommand.h"
#include <stdlib.h>
#import <objc/runtime.h>
#import <objc/objc.h>
#import <objc/message.h>


int _icedebugC2i(char ch)
{
    // 如果是数字，则用数字的ASCII码减去48, 如果ch = '2' ,则 '2' - 48 = 2
    if(isdigit(ch))
        return ch - 48;
    
    // 如果是字母，但不是A~F,a~f则返回
    if( ch < 'A' || (ch > 'F' && ch < 'a') || ch > 'z' )
        return -1;
    
    // 如果是大写字母，则用数字的ASCII码减去55, 如果ch = 'A' ,则 'A' - 55 = 10
    // 如果是小写字母，则用数字的ASCII码减去87, 如果ch = 'a' ,则 'a' - 87 = 10
    if(isalpha(ch))
        return isupper(ch) ? ch - 55 : ch - 87;
    
    return -1;
}


@implementation ICEDebugBaseCommand

+(long)hex2dec:(NSString*)str;
{
    long len;
    long temp;
    long i;
    
    //    if (str.length %2 != 0) {
    //        str = [NSString stringWithFormat:@"0%@", str];
    //    }
    char* hex = (char*)[[str dataUsingEncoding:NSASCIIStringEncoding] bytes];
    // 此例中 hex = "1de" 长度为3, hex是main函数传递的
    len = str.length;
    temp = 0;
    for (i=0; i < len; i++) {
        temp = temp*16 + _icedebugC2i(hex[i]);
    }
    
    // 返回结果
    return temp;
}

+(NSObject*)getObjecFromStr:(NSString*)str
{
    NSString* stt = [str stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    void* ip = (void*)[self hex2dec:stt];
    NSObject* reOb = (__bridge id)(ip);
    return reOb;
}

+(NSString*)processCommand:(NSArray*)args
{
    return @"baseCommand";
}

+(NSString*)comment
{
    return @"base comment";
}

+(UIViewController*)getRootViewController
{
    UIApplication* app = [UIApplication sharedApplication];
    id <UIApplicationDelegate> delegate = app.delegate;
    UIViewController* rootVc = delegate.window.rootViewController;
    return rootVc;
}

+ (NSString*)descriptionOfDictionary:(id)object {
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}


+(NSString*)defaultError
{
    NSString* error = [NSString stringWithFormat:@"param error:%@", [self class]];
    return error;
}
@end

@implementation NSArray(ICEDebug)
-(id)iceDebugSafeObjectAtIndex:(NSUInteger)index
{
    if (index < 0) {
        return nil;
    }
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    
    
    return nil;
}
@end


BOOL iceDebugClassIsSubclassOfClass( const Class aClass, const Class superclass ) {
    
    BOOL check = class_respondsToSelector(aClass, @selector(isKindOfClass:));
    
    if (check == YES) {
        return ( [aClass isSubclassOfClass:superclass] );
    }
    else
    {
        return NO;
    }
    
    
}

//BOOL iceDebugClassIsNSObject( const Class aClass ) {
//    // returns YES if <aClass> is an NSObject derivative, otherwise NO.
//    // It does this without invoking any methods on the class being tested.
//    return iceDebugClassIsSubclassOfClass( aClass, [NSObject class]);
//}


@implementation NSObject(ICEDebug)
-(NSDictionary*)iceDebugGetAllPropertiesWithSuper:(BOOL)needSuper
{
    u_int count = -1;
    
    Class clazz = [self class];
    //Describes the instance variables declared by a class.
    Ivar* ivars = class_copyIvarList(clazz, &count);
    NSMutableArray* ivarArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        //Returns the name of an instance variable.
        const char* ivarName = ivar_getName(ivars[i]);
        [ivarArray addObject:[NSString  stringWithCString:ivarName encoding:NSUTF8StringEncoding]];
    }
    free(ivars);
    
    //Describes the properties declared by a class.
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        //A C string containing the property's name
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    NSString* className = NSStringFromClass([self class]);
    NSMutableDictionary* dumpClass = [[NSMutableDictionary alloc]init];
    [dumpClass setValue:className forKey:@"class"];
    [dumpClass setValue:ivarArray forKey:@"ivars"];
    [dumpClass setValue:propertyArray forKey:@"properties"];
    
    if (needSuper) {
        if ([self superclass] != [NSObject class]) {
            NSDictionary* subClassDump = [[[[self superclass]alloc]init] iceDebugGetAllPropertiesWithSuper:needSuper];
            [dumpClass setValue:subClassDump forKey:@"sup"];
        }
    }
    
    return dumpClass;
}

-(NSDictionary*)iceDebugGetAllValuesWithSuber:(int)superLever;
{
    u_int count = -1;
    NSMutableDictionary* dumpClass = [[NSMutableDictionary alloc]init];
    Class clazz = [self class];
    //Describes the instance variables declared by a class.
    Ivar* ivars = class_copyIvarList(clazz, &count);
    
    for (int i = 0; i < count ; i++)
    {
        //Returns the name of an instance variable.
        const char* ivarName = ivar_getName(ivars[i]);
        //        [ivarArray addObject:[NSString  stringWithCString:ivarName encoding:NSUTF8StringEncoding]];
        id value = [self valueForKey:[NSString  stringWithCString:ivarName encoding:NSUTF8StringEncoding]];
        if(value == nil)
        {
            value = @"nil";
        }
        value = [NSString stringWithFormat:@"%@", value];
        [dumpClass setValue:value forKey:[NSString  stringWithCString:ivarName encoding:NSUTF8StringEncoding]];
    }
    free(ivars);
    
    //Describes the properties declared by a class.
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    
    for (int i = 0; i < count ; i++)
    {
        //A C string containing the property's name
        const char* propertyName = property_getName(properties[i]);
        //[propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        id value = [self valueForKey:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        if(value == nil)
        {
            value = @"nil";
        }
        value = [NSString stringWithFormat:@"%@", value];
        [dumpClass setValue:value forKey:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    if (superLever > 0) {
        if ([self superclass] != [NSObject class]) {
            NSDictionary* subClassDump = [[[[self superclass]alloc]init] iceDebugGetAllPropertiesWithSuper:superLever-1];
            if (subClassDump != nil) {
                [dumpClass setValue:subClassDump forKey:@"sup"];
            }
            
        }
    }
    
    return dumpClass;
}

+ (NSArray*) iceDebugAllClassesOfKind:(Class) aClass {
    // returns a list of all Class objects that are of kind <aClass> or a subclass of it currently
    // registered in the runtime. This caches the result so that the relatively expensive
    // run-through is only performed the first time
    static NSMutableDictionary* cache = nil;
    
    if ( cache == nil )
        cache = [[NSMutableDictionary alloc] init];
    
    // is the list already cached?
    NSArray* cachedList = [cache objectForKey:NSStringFromClass( aClass )];
    
    if ( cachedList != nil )
        return cachedList;
    
    // if here, list wasn't in the cache, so build it the hard way
    NSMutableArray* list = [NSMutableArray array];
    
    Class* buffer = NULL;
    Class  cl;
    
    int i, numClasses = objc_getClassList( NULL, 0 );
    
    if( numClasses > 0 )  {
        buffer = (Class*)malloc( sizeof(Class) * numClasses );
        (void) objc_getClassList( buffer, numClasses );
        
        // Go through the list and carefully check whether the class can respond to isSubclassOfClass:
        // If so, add it to the list.
        
        for( i = 0; i < numClasses; ++i ) {
            cl = buffer[i];
            if( iceDebugClassIsSubclassOfClass( cl, aClass ))
                [list addObject:cl];
        }
        free( buffer );
    }
    
    // save in cache for next time
    [cache setObject:list forKey:NSStringFromClass( aClass )];
    
    return list;
}
@end
