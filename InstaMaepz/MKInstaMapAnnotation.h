//
//  MKInstaMapAnnotation.h
//  InstaMaepz
//
//  Created by Julio Reyes on 8/29/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMInstagramPhoto.h"

@interface MKInstaMapAnnotation : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) IMInstagramPhoto *photo;

-(id)initWithLocation:(CLLocationCoordinate2D)coord;

@end

