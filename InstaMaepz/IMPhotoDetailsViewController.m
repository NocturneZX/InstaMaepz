//
//  IMPhotoDetailsViewController.m
//  InstaMaepz
//
//  Created by Julio Reyes on 8/30/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "IMPhotoDetailsViewController.h"
#import "UIImageView+WebCache.h"
@interface IMPhotoDetailsViewController ()
//Views
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *photoUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoFilterLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoCaptionLabel;

@property (strong, nonatomic) IBOutlet UIView *detailView;
//Data
@property (nonatomic, strong) IMInstagramPhoto *selectedPhoto;

@end

@implementation IMPhotoDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        self.detailView.alpha = 1.0;
    }else{
        self.detailView.alpha = 0.0;
    }
    
    self.photoCaptionLabel.text = self.selectedPhoto.photoCaption;
    self.photoUsernameLabel.text = self.selectedPhoto.photoUserName;
    self.photoFilterLabel.text = self.selectedPhoto.photoFilterName;
    
    self.photoCaptionLabel.font = OPEN_SANS_FONT;
    self.photoUsernameLabel.font = OPEN_SANS_FONT;
    self.photoFilterLabel.font = OPEN_SANS_FONT_ITALIC;
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.selectedPhoto.photoStandardQualityImageURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Pre-load selection
-(void)loadFromPhoto:(IMInstagramPhoto *)photo{
    self.selectedPhoto = photo;
}
-(IBAction)TapImage:(id)sender{
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        if (self.detailView.alpha == 0) {
            [UIView animateWithDuration:0.7 animations:^{
                self.navigationController.navigationBarHidden = NO;
                self.detailView.alpha = 0.7;
                self.detailView.center = CGPointMake(self.detailView.center.x, 260.0);
            }];
        }else{
            if (!UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
                [UIView animateWithDuration:0.7 animations:^{
                    self.detailView.alpha = 0.0;
                    self.navigationController.navigationBarHidden = YES;
                }];
            }
        }
        
    }
//    else
//    {
//        // Set to Aspect Fill and hide the nav bar so the image can be seen in fullscreen
//        self.navigationController.navigationBarHidden = NO;
//        self.detailView.alpha = 1.0;
//    }
    //[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(transitionNow) userInfo:nil repeats:NO];
}

#pragma mark - Interface Orientation setup
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
// Check to see if the phone is in landscape. If so, change the content mode of the image so that it compliments the image itself
-(void) viewWillAppear:(BOOL)animated{
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        // Set to Aspect Fill and hide the nav bar so the image can be seen in fullscreen
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.navigationController.navigationBarHidden = YES;
        self.detailView.alpha = 0.0;
    }
    else
    {
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.navigationController.navigationBarHidden = NO;
        self.detailView.alpha = 1.0;
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.navigationController.navigationBarHidden = NO;
        self.detailView.alpha = 1.0;
    }
    else
    {
        // Set to Aspect Fill and hide the nav bar so the image can be seen in fullscreen
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.navigationController.navigationBarHidden = YES;
        self.detailView.alpha = 0.0;

    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
