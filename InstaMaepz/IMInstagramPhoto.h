//
//  IMInstagramPhoto.h
//  InstaMaepz
//
//  Created by Julio Reyes on 8/29/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMInstagramPhoto : NSObject

@property (nonatomic,retain) NSString *photoThumbnailImageUrl;
@property (nonatomic,retain) NSString *photoLowQualityImageURL;
@property (nonatomic,retain) NSString *photoStandardQualityImageURL;
@property (nonatomic,retain) NSString *photoFilterName;
@property (nonatomic,retain) NSString *photoUserName;
@property (nonatomic,retain) NSString *photoAssetType;
@property (nonatomic,retain) NSString *photoCaption;

@property (readwrite, assign) CGFloat photoLatitude;
@property (readwrite, assign) CGFloat photoLongitude;

@property (nonatomic, assign) CLLocationDistance distance;

@end
