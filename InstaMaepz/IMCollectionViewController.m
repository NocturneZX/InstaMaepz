//
//  IMCollectionViewController.m
//  InstaMaepz
//
//  Created by Julio Reyes on 8/30/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "IMCollectionViewController.h"
#import "UserCollectionCell.h"

@interface IMCollectionViewController ()

@property (nonatomic, strong) UICollectionView *IMCollectionView;

@property (nonatomic, strong) NSArray *photoOfUsers;

@end

@implementation IMCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    //Register the Custom Collection Cell
    [self.IMCollectionView registerNib:[UINib nibWithNibName:@"UserCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"IMInstagramPhotoCollectionViewCell"];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumInteritemSpacing = 8;
    flowLayout.itemSize = CGSizeMake(96, 156);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionView Delegation
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoOfUsers.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"IMInstagramPhotoCollectionViewCell";
    
    UserCollectionCell *cell = (UserCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(150, 150);
}


@end
