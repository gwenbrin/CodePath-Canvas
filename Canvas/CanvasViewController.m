//
//  CanvasViewController.m
//  Canvas
//
//  Created by Gwen Brinsmead on 6/29/14.
//  Copyright (c) 2014 Gwen Brinsmead. All rights reserved.
//

#import "CanvasViewController.h"

@interface CanvasViewController ()
@property (weak, nonatomic) IBOutlet UIView *trayView;
@property (weak, nonatomic) IBOutlet UIScrollView *trayScrollView;
@property (weak, nonatomic) IBOutlet UIView *canvasView;
@property (strong, nonatomic) UIImageView *createdImageView;
- (IBAction)onImagePan:(UIPanGestureRecognizer *)sender;
- (IBAction)onTrayPan:(UIPanGestureRecognizer *)sender;

- (void) onCanvasImagePan:(UIPanGestureRecognizer *)canvasImagePanGestureRecognizer;
- (void) onCanvasImagePinch:(UIPinchGestureRecognizer *)canvasImagePinchGestureRecognizer;
- (void) onCanvasImageRotation:(UIRotationGestureRecognizer *) canvasImageRotationGestureRecognizer;

@end

@implementation CanvasViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onImagePan:(UIPanGestureRecognizer *)sender {
    
    // Store original doge view, get frame
    UIImageView *originalImageView = (UIImageView *)sender.view;
    CGRect imageFrame = originalImageView.frame;
    
    // Grab location of pan
    CGPoint location = [sender locationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Panning Began");
        
        // Create and set up new doge
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        imageView.image = originalImageView.image;
        imageView.userInteractionEnabled = YES;
        imageView.center = location;
        self.createdImageView = imageView;
        
        // add new doge to main view
        [self.view addSubview:self.createdImageView];
        
        // scale up new doge image
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:10 options:0 animations:^{
            self.createdImageView.frame = CGRectMake(self.createdImageView.frame.origin.x, self.createdImageView.frame.origin.y, 100, 100);
        }completion:nil];
        

    } else if (sender.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Panning Changed");

        // move doge
        self.createdImageView.center = location;
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Panning Ended, end location %f, %f", location.x, location.y);
        
        // Add doge to canvas
        [self.canvasView addSubview:self.createdImageView];
        
        // Add pan gesture recognizer to doge
        UIPanGestureRecognizer *canvasImagePanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCanvasImagePan:)];
        [self.createdImageView addGestureRecognizer:canvasImagePanGestureRecognizer];
        
        // Add pinch gesture recognizer to doge
        UIPinchGestureRecognizer *canvasImagePinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onCanvasImagePinch:)];
        [self.createdImageView addGestureRecognizer:canvasImagePinchGestureRecognizer];
        
        // Add rotation gesture recognizer to doge
        UIRotationGestureRecognizer *canvasImageRotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onCanvasImageRotation:)];
        [self.createdImageView addGestureRecognizer:canvasImageRotationGestureRecognizer];

    }
}

- (IBAction)onTrayPan:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    static CGPoint initialLocation;
    
    CGPoint trayPositionOpen = CGPointMake(160, 529);
    CGPoint trayPositionClosed = CGPointMake(160, 584);
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Panning on Tray Began");
        
        // get initial location
        initialLocation = self.trayView.center;
        
        NSLog(@"Initial Location: %f, %f", initialLocation.x, initialLocation.y);
        
    } else if (sender.state == UIGestureRecognizerStateChanged)  {
        NSLog(@"Panning on Tray Changed");
        
        if (self.trayView.center.y < 529) {
            NSLog(@"Dont move");
            
        } else {
            
            self.trayView.center = CGPointMake(self.trayView.center.x, self.trayView.center.y + translation.y);
            [sender setTranslation:CGPointMake(0,0) inView:self.view];
            
        }
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Panning on Tray Ended");
        
        if (initialLocation.y > self.trayView.center.y) {
            
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1.2 initialSpringVelocity:12 options:0 animations:^{
                self.trayView.center = trayPositionOpen;
            }completion:nil];
            
        } else if (initialLocation.y <= self.trayView.center.y) {

            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1.2 initialSpringVelocity:12 options:0 animations:^{
                self.trayView.center = trayPositionClosed;
            }completion:nil];
            
        }
        
    }
    
}

- (void)onCanvasImagePan:(UIPanGestureRecognizer *)canvasImagePanGestureRecognizer {
    NSLog(@"Panning Canvas Image");
    
    CGPoint translation = [canvasImagePanGestureRecognizer translationInView:self.view];
    
    // move doge on canvas
    canvasImagePanGestureRecognizer.view.center = CGPointMake(canvasImagePanGestureRecognizer.view.center.x + translation.x, canvasImagePanGestureRecognizer.view.center.y + translation.y);
    [canvasImagePanGestureRecognizer setTranslation:CGPointMake(0,0) inView:self.view];
    
}

- (void)onCanvasImagePinch:(UIPinchGestureRecognizer *)canvasImagePinchGestureRecognizer {
    NSLog(@"Pinching Canvas Image");
    
    // scale doge
    canvasImagePinchGestureRecognizer.view.transform = CGAffineTransformScale(canvasImagePinchGestureRecognizer.view.transform, canvasImagePinchGestureRecognizer.scale, canvasImagePinchGestureRecognizer.scale);
    canvasImagePinchGestureRecognizer.scale = 1;
    
    
    
}

- (void)onCanvasImageRotation:(UIRotationGestureRecognizer *)canvasImageRotationGestureRecognizer {
    NSLog(@"Rotating Canvas Image");
    
    // rotate doge
    canvasImageRotationGestureRecognizer.view.transform = CGAffineTransformRotate(canvasImageRotationGestureRecognizer.view.transform, canvasImageRotationGestureRecognizer.rotation);
    canvasImageRotationGestureRecognizer.rotation = 0;
    
}



@end








