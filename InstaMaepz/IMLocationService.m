//
//  IMLocationService.m
//  InstaMaepz
//
//  Created by Julio Reyes on 8/29/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "IMLocationService.h"

@interface IMLocationService ()
    - (BOOL)isValidLocation:(CLLocation *)newLocation withOldLocation:(CLLocation *)oldLocation;
@end

@implementation IMLocationService

@synthesize currentLocation;
@synthesize locationManager;
@synthesize locationManagerStartDate;
@synthesize locationTimer;

static IMLocationService *sharedManager;

+(IMLocationService *)sharedService{
    //static IMLocationService *_sharedLocalData = nil;
    if (!sharedManager) {
        @synchronized(self){
            sharedManager = [[IMLocationService alloc]init];
        }
    }
    return sharedManager;
}

- (id)init {
    self = [super init];
    
    if(self) {
        currentLocation = [[CLLocation alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        
        locationManager.delegate        = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.distanceFilter  = 100;
        
        [self startUpdatingLocation];
        
        locationManagerStartDate = [NSDate date];
    }

    return self;
}

#pragma mark - CLLocationManagerDelegate
+ (CLLocation *)currentLocation
{
    return [IMLocationService sharedService].locationManager.location;
}
- (void)startUpdatingLocation{
    [locationManager startUpdatingLocation];
    self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                          target:self
                                                        selector:@selector(stopUpdatingLocation)
                                                        userInfo:nil
                                                         repeats:NO];
}
- (void)stopUpdatingLocation{
    [locationManager stopUpdatingLocation];
    [self.locationTimer invalidate];
    
    NSLog(@"%f, %f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSInteger locationAge = abs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]);
    
    /**
     * if the time interval returned from core location is more than two minutes we ignore it because it might be from an old session
     */
    
    if (locationAge > 120 || ![self isValidLocation:newLocation withOldLocation:oldLocation]) {
        return;
    }
    
    self.currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                    message:[error description]
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    
    [alert show];
}

#pragma mark - Private Methods
- (BOOL)isValidLocation:(CLLocation *)newLocation withOldLocation:(CLLocation *)oldLocation {
    
    // Filter out nil locations
    if (!newLocation) {
        return NO;
    }
    
    // Filter out points by invalid accuracy
    if (newLocation.horizontalAccuracy < 0) {
        return NO;
    }
    
    // Filter out points that are out of order
    NSTimeInterval secondsSinceLastPoint = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
    
    if (secondsSinceLastPoint < 0) {
        return NO;
    }
    
    // Filter out points created before the manager was initialized
    NSTimeInterval secondsSinceManagerStarted = [newLocation.timestamp timeIntervalSinceDate:locationManagerStartDate];
    
    if (secondsSinceManagerStarted < 0) {
        return NO;
    }
    
    // The newLocation is good to use
    return YES;
}


@end
