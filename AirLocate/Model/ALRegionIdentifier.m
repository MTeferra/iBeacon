//
//  ALRegionIdentifier.m
//  AirLocate
//
//  Created by Michael Teferra on 12/20/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "ALRegionIdentifier.h"

@implementation ALRegionIdentifier


+ (NSString *) getIdentifier:(NSNumber *)minor
{
    return @"com.avg.OfficeLocate";
//    NSString *identifier =[[NSString alloc] init];
//    identifier =@"com.apple.AirLocate";
//    NSNumber *REGION3 = [[NSNumber alloc] initWithInt:3];
//    NSNumber *REGION2 = [[NSNumber alloc] initWithInt:2];
//    if (!minor) {
//        identifier = @"com.avg.sf";
//    }
//    else if ([minor compare:REGION3] == 0) {
//        identifier = @"com.avg.kitchen";
//    }
//    else if ([minor compare:REGION2] == 0) {
//        identifier = @"com.avg.paul";
//    }
//    else {
//        identifier = @"com.avg.hyon";
//    }
//    NSLog(@"Identifier = %@", identifier);
//    return identifier;
}

@end
