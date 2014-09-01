//
//  IMCollectionViewController.h
//  InstaMaepz
//
//  Created by Julio Reyes on 8/30/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMCollectionViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
- (void)loadFromPhoto:(NSArray *)photo;
@end
