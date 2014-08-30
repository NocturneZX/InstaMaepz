//
//  MKInstaMapAnnotation.m
//  InstaMaepz
//
//  Created by Julio Reyes on 8/29/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "MKInstaMapAnnotation.h"

@implementation MKInstaMapAnnotation

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    if ((self = [super init])) {
        _coordinate = coord;
    }
    return self;
}

@end

