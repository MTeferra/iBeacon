//
//  ALRegionIdentifier.h
//  AirLocate
//
//  Created by Michael Teferra on 12/20/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALRegionIdentifier : NSObject

+(NSString *) getIdentifier:(NSNumber *) minor;

@end
