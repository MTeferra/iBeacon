/*
     File: ALAppDelegate.m
 Abstract: Main entry point for the application. Displays the main menu and notifies the user when region state transitions occur.
 
  Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 
 Copyright © 2013 Apple Inc. All rights reserved.
 WWDC 2013 License
 
 NOTE: This Apple Software was supplied by Apple as part of a WWDC 2013
 Session. Please refer to the applicable WWDC 2013 Session for further
 information.
 
 IMPORTANT: This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and
 your use, installation, modification or redistribution of this Apple
 software constitutes acceptance of these terms. If you do not agree with
 these terms, please do not use, install, modify or redistribute this
 Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple
 Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple. Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis. APPLE MAKES
 NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE
 IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 EA1002
 5/3/2013
 */

#import "ALAppDelegate.h"
#import "ALMenuViewController.h"

@interface ALAppDelegate()

- (void)sendGreeting:(NSNumber *)minor;

@end

@implementation ALAppDelegate
{
    ALMenuViewController *_menuViewController;
    UINavigationController *_rootViewController;
    CLLocationManager *_locationManager;
    NSUUID *_monitoredUUID;
    NSNumber *_nearestMinor;
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    // A user can transition in or out of a region while the application is not running.
    // When this happens CoreLocation will launch the application momentarily, call this delegate method
    // and we will let the user know via a local notification.
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    if (!beaconRegion) {
        return;
    }
    NSUUID *proximityUUID = beaconRegion.proximityUUID;
    if (!_monitoredUUID) {
        return;
    }
    if (proximityUUID != _monitoredUUID) {
        return;
    }
    NSLog(@"UUID=%@,  Major=%d, Minor=%d, state=%d", proximityUUID.UUIDString, beaconRegion.major.unsignedShortValue,
          beaconRegion.minor.unsignedShortValue, state);
   
    if(state == CLRegionStateInside)
    {
        notification.alertBody = @"You're inside the region";
    }
    else if(state == CLRegionStateOutside)
    {
        [manager stopMonitoringForRegion:beaconRegion];
        notification.alertBody = @"You're outside the region";
    }
    else
    {
        return;
    }
    
    // If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
    // If its not, iOS will display the notification to the user.
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void) sendGreeting:(NSNumber *)minor {
    _nearestMinor = minor;
    int value = [minor intValue];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
   
    switch (value) {
        case 1:
            notification.alertBody = @"You are near Hyon Lee's Desk";
            break;
        case 2:
            notification.alertBody = @"You are near Paul Vallez's Office";
            break;
        case 3:
            notification.alertBody = @"You are welcomed to get a cup of tea here.";
            break;
            
        default:
            break;
    }
    if ([notification.alertBody length]) {
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    if (!beaconRegion) {
        return;
    }
    NSUUID *proximityUUID = beaconRegion.proximityUUID;
    NSLog(@"Started Monitoring UUID=%@,  Major=%d, Minor=%d", proximityUUID.UUIDString, beaconRegion.major.unsignedShortValue,
          beaconRegion.minor.unsignedShortValue);
    _monitoredUUID = proximityUUID;
    [manager startRangingBeaconsInRegion:beaconRegion];
    
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSArray *nearBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityNear]];
    if([nearBeacons count]) {
        NSInteger count = [nearBeacons count];
        NSLog(@"%d Near Beacons Found", count);
        [nearBeacons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CLBeacon *aBeacon = obj;
            NSLog(@"A Near Beacon Found: UUID=%@,  Major=%d, Minor=%d, Accuracy=%0.2fm", aBeacon.proximityUUID.UUIDString,
                  aBeacon.major.unsignedShortValue, aBeacon.minor.unsignedShortValue, aBeacon.accuracy);
            if (!_nearestMinor) {
                [self sendGreeting:aBeacon.minor];
            }
            else if (![aBeacon.minor isEqualToNumber:_nearestMinor]) {
                [self sendGreeting:aBeacon.minor];
            }
        }];
        return;
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // This location manager will be used to notify the user of region state transitions.
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Display the main menu.
    _menuViewController = [[ALMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    _rootViewController = [[UINavigationController alloc] initWithRootViewController:_menuViewController];
    
    self.window.rootViewController = _rootViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // If the application is in the foreground, we will notify the user of the region's state via an alert.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
