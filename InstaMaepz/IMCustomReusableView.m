//
//  IMCustomReusableView.m
//  InstaMaepz
//
//  Created by Julio Reyes on 9/1/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "IMCustomReusableView.h"

@implementation IMCustomReusableView

static NSString * const IMCustomLogoName  = @"IMPhotoLogo";

+ (CGSize)defaultSize
{
    return [UIImage imageNamed:IMCustomLogoName].size;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *image = [UIImage imageNamed:IMCustomLogoName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = self.bounds;
        
        [self addSubview:imageView];
    }
    return self;
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
