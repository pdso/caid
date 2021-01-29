//
//  FKCaid.m
//  caid
//
//  Created by pqso on 2021/1/28.
//

#import "FkCaid.h"
#import <sys/sysctl.h>
#import <UIKit/UIDevice.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation FkCaid

//file system size
+(NSString *)getDiskSize {
    int64_t space = -1;
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager]
                           attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (!error) {
        space = [[attrs objectForKey:NSFileSystemSize] longLongValue];
    }
    if(space < 0) {
        space = -1;
    }
    return [NSString stringWithFormat:@"%lld",space];
}

//device RAM
+(NSString *)getRAM {
    unsigned long long physicalMemory = [[NSProcessInfo processInfo]
                                         physicalMemory];
    NSString *strResult = [NSString stringWithFormat:@"%llu",physicalMemory];
    return [strResult copy];
}

//device system version
+ (NSString *) getSystemVersion {
    return [NSString stringWithFormat:@"%@",[UIDevice
                                             currentDevice].systemVersion];
}

//system update time
+(NSString *)getUpdateTime {
    NSString *result = @"";
    NSString *information =
    @"L3Zhci9tb2JpbGUvTGlicmFyeS9Vc2VyQ29uZmlndXJhdGlvblByb2ZpbGVzL1B1YmxpY0luZm8vTUNNZXRhLnBsaXN0";
    NSData *data=[[NSData alloc]initWithBase64EncodedString:information
                                                    options:0];
    NSString *dataString = [[NSString alloc]initWithData:data
                                                encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager]
                                    attributesOfItemAtPath:dataString error:&error];
    if (fileAttributes) {
        id singleAttibute = [fileAttributes objectForKey:NSFileCreationDate];
        if ([singleAttibute isKindOfClass:[NSDate class]]) {
            NSDate *dataDate = singleAttibute;
            result = [NSString stringWithFormat:@"%.6f",[dataDate
                                                         timeIntervalSince1970]];
        }
    }
    return result;
}


//carrier
+(NSString* )getCarrierName {
#if TARGET_IPHONE_SIMULATOR
    return @"SIMULATOR";
#else
    static dispatch_queue_t _queue;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _queue = dispatch_queue_create([[NSString
                                         stringWithFormat:@"com.carr.%@", self] UTF8String], NULL);
    });
    __block NSString * carr = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(_queue, ^(){
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = nil;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.1) {
            if ([info
                 respondsToSelector:@selector(serviceSubscriberCellularProviders)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"
                NSArray *carrierKeysArray =
                [info.serviceSubscriberCellularProviders.allKeys
                 sortedArrayUsingSelector:@selector(compare:)];
                carrier =
                info.serviceSubscriberCellularProviders[carrierKeysArray.firstObject];
                if (!carrier.mobileNetworkCode) {
                    carrier =
                    info.serviceSubscriberCellularProviders[carrierKeysArray.lastObject];
                }
#pragma clang diagnostic pop
            }
        }
        if(!carrier) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            carrier = info.subscriberCellularProvider;
#pragma clang diagnostic pop
        }
        if (carrier != nil) {
            NSString *networkCode = [carrier mobileNetworkCode];
            NSString *countryCode = [carrier mobileCountryCode];
            if (countryCode && [countryCode isEqualToString:@"460"] &&
                networkCode) {
                if ([networkCode isEqualToString:@"00"] || [networkCode
                                                            isEqualToString:@"02"] || [networkCode isEqualToString:@"07"] || [networkCode
                                                                                                                              isEqualToString:@"08"]) {
                    carr= @"中国移动";
                }
                if ([networkCode isEqualToString:@"01"] || [networkCode
                                                            isEqualToString:@"06"] || [networkCode isEqualToString:@"09"]) {
                    carr= @"中国联通";
                }
                if ([networkCode isEqualToString:@"03"] || [networkCode
                                                            isEqualToString:@"05"] || [networkCode isEqualToString:@"11"]) {
                    carr= @"中国电信";
                }
                if ([networkCode isEqualToString:@"04"]) {
                    carr= @"中国卫通";
                }
                if ([networkCode isEqualToString:@"20"]) {
                    carr= @"中国铁通";
                }
            }else {
                carr = [carrier.carrierName copy];
            }
        }
        if (carr.length <= 0) {
            carr = @"unknown";
        }
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, 0.5* NSEC_PER_SEC);
    dispatch_semaphore_wait(semaphore, t);
    return [carr copy];
#endif
}


//carrier
+(NSString* )getCarrierNameOrigin {
#if TARGET_IPHONE_SIMULATOR
    return @"SIMULATOR";
#else
    static dispatch_queue_t _queue;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _queue = dispatch_queue_create([[NSString
                                         stringWithFormat:@"com.carr.%@", self] UTF8String], NULL);
    });
    __block NSString * carr = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(_queue, ^(){
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = nil;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.1) {
            if ([info
                 respondsToSelector:@selector(serviceSubscriberCellularProviders)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"
                NSArray *carrierKeysArray =
                [info.serviceSubscriberCellularProviders.allKeys
                 sortedArrayUsingSelector:@selector(compare:)];
                carrier =
                info.serviceSubscriberCellularProviders[carrierKeysArray.firstObject];
                if (!carrier.mobileNetworkCode) {
                    carrier =
                    info.serviceSubscriberCellularProviders[carrierKeysArray.lastObject];
                }
#pragma clang diagnostic pop
            }
        }
        if(!carrier) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            carrier = info.subscriberCellularProvider;
#pragma clang diagnostic pop
        }
        if (carrier != nil) {
            NSString *networkCode = [carrier mobileNetworkCode];
            NSString *countryCode = [carrier mobileCountryCode];
            if (countryCode && [countryCode isEqualToString:@"460"] &&
                networkCode) {
                carr = [networkCode copy];
            }else {
                carr = [carrier.carrierName copy];
            }
        }
        if (carr.length <= 0) {
            carr = @"unknown";
        }
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, 0.5* NSEC_PER_SEC);
    dispatch_semaphore_wait(semaphore, t);
    return [carr copy];
#endif
}


//country code
+(NSString *)getCountryCode {
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    return countryCode;
}

//system boot time
+(NSString *) getSysBootTime {
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t uptime = -1;
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
    {
        uptime = boottime.tv_sec;
    }
    NSString *result = [NSString stringWithFormat:@"%ld",uptime];
    return result;
}

+ (NSString *) getTimeZone {
    NSInteger offset = [NSTimeZone systemTimeZone].secondsFromGMT;
    return [NSString stringWithFormat:@"%ld",(long)offset];
}

+(NSString *)getLanguage {
    NSString *language;
    NSLocale *locale = [NSLocale currentLocale];
    
    if ([[NSLocale preferredLanguages] count] > 0) {
        language = [[NSLocale preferredLanguages]objectAtIndex:0];
    } else {
        language = [locale objectForKey:NSLocaleLanguageCode];
    }
    return language;
}

+(NSString *)getHwModel {

    NSString *model = getSystemHardwareByName("hw.model");
    return model == nil ? @"" : model;
}

static NSString *getSystemHardwareByName(const char *typeSpecifier) { size_t size; sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString *results = [NSString stringWithUTF8String:answer];
    free(answer); return results;
}


+(NSDictionary *)totoal{
    NSString *disk = [[self class] getDiskSize];
    NSString *ram = [[self class] getRAM];
    NSString *update = [[self class] getUpdateTime];
   
    NSString *uName = [[[UIDevice currentDevice].name dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:kNilOptions];
    NSString *carrier = [[self class] getCarrierNameOrigin];
    NSString *country = [[self class] getCountryCode];
    NSString *boot = [[self class] getSysBootTime];
    
    NSString *timezone = [[self class] getTimeZone];
    NSString *language = [[self class] getLanguage];
    NSString *hwmodel = [[self class] getHwModel];
    NSString *model =  getSystemHardwareByName("hw.machine");
    
    
    NSDictionary *dic = @{@"disk": disk,
                          @"ram": ram,
                          @"update": update,
                          @"uname": uName,
                          @"carrier": carrier,
                          @"country": country,
                          @"boot": boot,
                          @"timezone": timezone,
                          @"language": language,
                          @"hwmodel": hwmodel,
                          @"model": model,
                          @"version": [UIDevice currentDevice].systemVersion};
    return  dic;
}

@end
