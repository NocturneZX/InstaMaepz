//
//  IMPhotoDetailsViewController.h
//  InstaMaepz
//
//  Created by Julio Reyes on 8/30/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMInstagramPhoto.h"

@interface IMPhotoDetailsViewController : UIViewController
- (void)loadFromPhoto:(IMInstagramPhoto *)photo;
@end
