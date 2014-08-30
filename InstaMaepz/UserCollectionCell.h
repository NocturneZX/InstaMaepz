//
//  UserCollectionCell.h
//  InstaMaepz
//
//  Created by Julio Reyes on 8/29/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *photoUserName;
@property (weak, nonatomic) IBOutlet UILabel *userDistance;

@end
