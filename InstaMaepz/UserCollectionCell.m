//
//  UserCollectionCell.m
//  InstaMaepz
//
//  Created by Julio Reyes on 8/29/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "UserCollectionCell.h"

@implementation UserCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
       
    }
    return self;
}

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage{
    CGImageRef maskReference = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                        CGImageGetHeight(maskReference),
                                        CGImageGetBitsPerComponent(maskReference),
                                        CGImageGetBitsPerPixel(maskReference),
                                        CGImageGetBytesPerRow(maskReference),
                                        CGImageGetDataProvider(maskReference), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    return maskedImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
