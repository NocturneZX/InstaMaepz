//
//  IMCollectionViewController.m
//  InstaMaepz
//
//  Created by Julio Reyes on 8/30/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "IMPhotoDetailsViewController.h"
#import "IMCollectionViewController.h"
#import "UserCollectionCell.h"
#import "IMCustomReusableView.h"
#import "IMCustomCollectionLayout.h"
#import "IMInstagramPhoto.h"
#import "UIImageView+WebCache.h"

@interface IMCollectionViewController ()

@property (nonatomic, strong) IBOutlet UICollectionView *IMCollectionView;

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
- (void)loadFromPhoto:(NSArray *)photo{
    self.photoOfUsers = photo;
}
-(void)viewWillAppear:(BOOL)animated{


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Register the Custom Collection Cell
    [self.IMCollectionView registerNib:[UINib nibWithNibName:@"UserCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"UserCollectionCell"];
    
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(96, 156);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoOfUsers.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"UserCollectionCell";
    
    UserCollectionCell *collectioncell = (UserCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    IMInstagramPhoto *currentPhoto = [self.photoOfUsers objectAtIndex:indexPath.row];
    
    collectioncell.photoUserName.text = currentPhoto.photoUserName;
    collectioncell.userDistance.text = [NSString stringWithFormat:@"%.2f miles",
                                        KILOMETERS_TO_MILES(currentPhoto.distance)];
    [collectioncell.photoImage sd_setImageWithURL:[NSURL URLWithString:currentPhoto.photoStandardQualityImageURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return collectioncell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //Select a photo to get a detailed look
    IMInstagramPhoto *selectedPhoto = [self.photoOfUsers objectAtIndex:indexPath.row];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    IMPhotoDetailsViewController *detail = [storyboard instantiateViewControllerWithIdentifier:@"IMPhotoDetailsViewController"];
    [detail loadFromPhoto:selectedPhoto];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
