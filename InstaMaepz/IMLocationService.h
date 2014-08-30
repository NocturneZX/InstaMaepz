//
//  IMLocationService.h
//  InstaMaepz
//
//  Created by Julio Reyes on 8/29/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMLocationService : NSObject<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSDate *locationManagerStartDate;
    NSTimer *locationTimer;
}

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, retain) CLLocation * currentLocation;
@property (nonatomic, retain) NSDate* locationManagerStartDate;
@property (nonatomic, retain) NSTimer* locationTimer;

+(IMLocationService *)sharedService;
+(CLLocation *)currentLocation;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;
@end
