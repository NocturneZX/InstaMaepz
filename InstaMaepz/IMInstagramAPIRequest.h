//
//  IMInstagramAPIRequest.h
//  InstaMaepz
//
//  Created by Julio Reyes on 8/29/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMInstagramAPIRequestDelegate <NSObject>
    - (void) InstagramAPIRequestDidComplete: (NSArray *)resultingdata;
@end

@interface IMInstagramAPIRequest : NSObject

// Singleton
+(instancetype)sharedInstance;

// Current Location
@property (nonatomic, assign) CLLocation *searchCurrentLocation;

// Search Radius
@property (nonatomic, assign) CGFloat searchRadius;

@property id<IMInstagramAPIRequestDelegate> delegate;

- (void) getArrayOfPhotoObjectsFromLocation;


@end
