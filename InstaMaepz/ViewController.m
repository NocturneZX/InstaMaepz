//
//  ViewController.m
//  InstaMaepz
//
//  Created by Julio Reyes on 8/29/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

// VIew Controllers
#import "ViewController.h"
#import "IMCollectionViewController.h"
#import "IMPhotoDetailsViewController.h"

// Handlers
#import "MKInstaMapAnnotation.h"
#import "IMLocationService.h"
#import "IMInstagramAPIRequest.h"

@interface ViewController () <IMInstagramAPIRequestDelegate>

//API Requests
@property IMInstagramAPIRequest *datadownloader;

//Data
@property (nonatomic, strong) NSArray *photosFromLocations;
@property (nonatomic, strong) MBProgressHUD *HUD;

//Views
@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet MKMapView *MKInstaMapView;

//Gesture Recognizer
@property (nonatomic, strong) UITapGestureRecognizer *MKTapGestureRecognizer;

@end

@implementation ViewController
@synthesize photosFromLocations;
//@synthesize MKInstaMapView;
//@synthesize slider;
//@synthesize HUD;
//@synthesize datadownloader; // Auto Property Synthesized
#define DEFAULT_RADIUS 1000

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.MKInstaMapView.delegate = self;
    self.MKInstaMapView.userTrackingMode = MKUserTrackingModeFollow;
    
    IMLocationService *locationManager = [IMLocationService sharedService];
    
    // Create observer that monitors if there have been a new location
    [locationManager addObserver:self
              forKeyPath:@"currentLocation"
                 options:NSKeyValueObservingOptionNew
                 context:NULL];

	// Do any additional setup after loading the view, typically from a nib.
    self.MKTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.MKInstaMapView addGestureRecognizer:self.MKTapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapView methods
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

}


- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    [self showHUDWithMessage:@"Could not determine your location" detailMessage:@"Try re-connecting to the Internet and try again"];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    

}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    // Set up the view
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[MKInstaMapAnnotation class]]) {
        MKInstaMapAnnotation *instagramPhotoAnnotation = (MKInstaMapAnnotation*) annotation;
        MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MKPinAnnotationView"];
        // Create an new view if none exist.
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:@"MKPinAnnotationView"];
            annotationView.canShowCallout = YES;
            annotationView.enabled = YES;
            
        } else {
            annotationView.annotation = annotation;
        }
        
        // Declare and initialize the variable for the thumbnail. Then download image using GCD
        UIImageView *thumbnail = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 48.0f, 48.0f)];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:instagramPhotoAnnotation.photo.photoThumbnailImageUrl]];
            if (imgData) {
                UIImage *image = [UIImage imageWithData:imgData];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [thumbnail setImage:image];
                        
                    });// end dispatch_async(dispatch_get_main_queue())
                }else{
                    [thumbnail setImage:[UIImage imageNamed:@"notifications.png"]];
                }
            }
        });// end dispatch_async(dispatch_get_global_queue())
        annotationView.leftCalloutAccessoryView  = thumbnail;
        return annotationView;
    }
    
    // Return nada if neither
    return nil;
}

-(void)CenterTheMap:(CGFloat) radius{
    
    CGFloat newDistances = radius * 1.2;
    
    // Create the new MKCoordinateRegion of map
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance([IMLocationService currentLocation].coordinate
                                                                      , newDistances, newDistances);
    
    // Set the region on the map which will center it.
    [self.MKInstaMapView setRegion:newRegion animated:YES];
    
}

#pragma mark - API Methods
- (void) InstagramAPIRequestDidComplete: (NSArray *)resultingdata{
    
    // Show photos on the map
    NSLog(@"%@", resultingdata);
    if (resultingdata == 0) {
        [self showHUDWithMessage:@"Found no photos near you. Try moving somewhere with some action going on and trying again!" detailMessage:nil];
    }else{
        [resultingdata enumerateObjectsUsingBlock:^(IMInstagramPhoto *photo, NSUInteger idx, BOOL *stop){
            
            //Set the resulting data to local array
            self.photosFromLocations = resultingdata;
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(photo.photoLatitude, photo.photoLongitude);
            photo.distance = [self FindDistance:coordinate];
            
            MKInstaMapAnnotation *annotation = [[MKInstaMapAnnotation alloc]initWithLocation:coordinate];
            annotation.photo = photo;
            annotation.title = [NSString stringWithFormat:@"%.2f km by %@",
                                [self FindDistance:coordinate] , photo.photoUserName];
            annotation.subtitle = [NSString stringWithFormat:@"Filter: %@", photo.photoFilterName];
            
            [self.MKInstaMapView addAnnotation:annotation];
            
            NSLog(@"MAP LAT: %f, SERVICE LAT: %f", self.MKInstaMapView.userLocation.location.coordinate.longitude, [IMLocationService currentLocation].coordinate.longitude);

            
        }];
    }
    
}

-(void)getInstagramData: (CLLocation *)loc{
    
    // Declare and initialize the downloader
    self.datadownloader = [IMInstagramAPIRequest sharedInstance];
    self.datadownloader.delegate = self;
    self.datadownloader.searchCurrentLocation = loc;
    self.datadownloader.searchRadius = DEFAULT_RADIUS;
    [self CenterTheMap:DEFAULT_RADIUS];
    
    [self.datadownloader getArrayOfPhotoObjectsFromLocation];
    
}

- (void)showHUDWithMessage:(NSString *)message detailMessage:(NSString *)detailMessage {
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.removeFromSuperViewOnHide = YES;
    self.HUD.mode = MBProgressHUDModeText;
    [self.view addSubview:self.HUD];
    
    self.HUD.labelText = message;
    self.HUD.detailsLabelText = detailMessage;
    
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:3.5f];
}

#pragma mark - CLLocation KVO Methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    IMLocationService *locationManager = [IMLocationService sharedService];

    if ([keyPath isEqual:@"currentLocation"]) {
        
        if (locationManager.currentLocation) {
            
            [locationManager stopUpdatingLocation];
            
            CLLocation *currentLoc = [IMLocationService sharedService].currentLocation;
        
            // Call Instagram API and clear the old annotations
            
            NSArray *annotations = self.MKInstaMapView.annotations;
            if(annotations.count > 0) {
                [self.MKInstaMapView removeAnnotations:annotations];
            }
            [self.MKInstaMapView removeOverlays:self.MKInstaMapView.overlays];
            [self getInstagramData:currentLoc];
        
        }
        
    } else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(CLLocationDistance)FindDistance:(CLLocationCoordinate2D)coord{
    CLLocation * userLocation = [IMLocationService currentLocation];
    CLLocation * location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    CLLocationDistance distance = [userLocation distanceFromLocation:location];
    return distance / 1000;
}
#pragma mark - UITapGestureRecognizer Methods
-(void) handleTapGesture:(UITapGestureRecognizer*) gestureRecognizer {
    if (self.photosFromLocations.count == 0){
        return;
    }
    
    // Check if the annotations is not tapped. If not, then push into the next viewcontroller
    CGPoint locInView = [gestureRecognizer locationInView:self.MKInstaMapView];
    id obj = [self.MKInstaMapView hitTest:locInView withEvent:nil];
    if ([obj isKindOfClass:[MKPinAnnotationView class]]) {
        return; // skip if tapped on an annotation
    } else {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        IMCollectionViewController *phtoCollectionView = [storyboard instantiateViewControllerWithIdentifier:@"IMCollectionViewController"];
        [self.navigationController pushViewController:phtoCollectionView animated:YES];
        
    }
}
@end
