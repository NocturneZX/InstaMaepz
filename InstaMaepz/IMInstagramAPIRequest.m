//
//  IMInstagramAPIRequest.m
//  InstaMaepz
//
//  Created by Julio Reyes on 8/29/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "IMInstagramPhoto.h"
#import "IMInstagramAPIRequest.h"
#import "NSString+Helpers.h"

NSString* const kInstagramOAuthClientId             = @"cd4794d2c60143caa8901c0da1860f26";
NSString* const kInstagramOAuthClientSecret         = @"157d2ed4cd2d4696ba6af35963d627fb";
NSString* const kInstagramAPIServer                 = @"https://api.instagram.com";
NSString* const kInstagramMediaSearchEndpoint       = @"/v1/media/search?";
NSString* const kInstagramMediaInfoEndpoint         = @"/media/%@";

@implementation IMInstagramAPIRequest

+(instancetype)sharedInstance
{
    static dispatch_once_t cp_singleton_once_token;
    static IMInstagramAPIRequest *sharedInstance;
    dispatch_once(&cp_singleton_once_token, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.searchRadius = 1000;
    });
    
    
    return sharedInstance;
}
- (id)init {
    
    self = [super init];
    
    if (self) {
    
    }
    
    return self;
}
- (NSString*) CreateServiceURLString {
    NSDictionary *params = @{
                             @"distance":@(self.searchRadius),
                             @"lat":@(self.searchCurrentLocation.coordinate.latitude),
                             @"lng":@(self.searchCurrentLocation.coordinate.longitude),
                             @"client_id":kInstagramOAuthClientId
                             };
    
    NSString *querystring = [NSString QueryStringWithParams:params];
    
    return [NSString stringWithFormat:@"%@/%@%@",kInstagramAPIServer,kInstagramMediaSearchEndpoint,querystring];
}

- (void) getArrayOfPhotoObjectsFromLocation{
    
    NSURL *url = [NSURL URLWithString:[self CreateServiceURLString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"URL: %@", url);

    NSOperationQueue *instagramRequestQueue = [[NSOperationQueue alloc]init];
    instagramRequestQueue.maxConcurrentOperationCount = 1;
    
    NSURLSession *instagramsession = [NSURLSession sharedSession];
    NSURLSessionDataTask *instagramtask = [instagramsession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
        
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        
        NSMutableArray *instagramPhotos = [NSMutableArray new];
        NSArray *instagramPhotoArray = [results objectForKey:@"data"];
        
        for (NSDictionary* eachPhoto in instagramPhotoArray) {
            
            //Grab each piece of data needed and Setup for the Photo class
            IMInstagramPhoto *photo = [IMInstagramPhoto new];
            photo.photoAssetType = [eachPhoto objectForKey:@"type"];
            photo.photoLowQualityImageURL = [[[eachPhoto objectForKey:@"images"]objectForKey:@"low_resolution"]objectForKey:@"url"];
            photo.photoThumbnailImageUrl = [[[eachPhoto objectForKey:@"images"]objectForKey:@"thumbnail"]objectForKey:@"url"] ;
            photo.photoStandardQualityImageURL = [[[eachPhoto objectForKey:@"images"]objectForKey:@"standard_resolution"]objectForKey:@"url"];
            photo.photoUserName = [[eachPhoto objectForKey:@"user"] objectForKey:@"username"];
            photo.photoFilterName = [eachPhoto objectForKey:@"filter"];
            
            NSNumber *photoLat = [[eachPhoto objectForKey:@"location"]objectForKey:@"latitude"];
            photo.photoLatitude = [photoLat floatValue];
            
            NSNumber *photoLong = [[eachPhoto objectForKey:@"location"] objectForKey:@"longitude"];
            photo.photoLongitude = [photoLong floatValue];
            
            //Add PhotoObject into the array
            [instagramPhotos addObject:photo];
        }
        
        // Send data to the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            // do work here
            [self.delegate InstagramAPIRequestDidComplete:instagramPhotos];
        });
        
        
    }];
    
    // Execute the task
    [instagramtask resume];

}

@end
