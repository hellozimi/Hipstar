//
//  CameraViewController.m
//  hipstar
//
//  Created by Simon Andersson on 11/9/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (weak, nonatomic) IBOutlet UIView *captureView;
@property (weak, nonatomic) IBOutlet UIButton *snap;

@end


@implementation CameraViewController (Internal)

- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = [self.previewLayer frame].size;
    
    if ( [[self.previewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
        // Scale, switch x and y, and reverse x
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in [self.input ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if ( [[self.previewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
                        // If point is inside letterboxed area, do coordinate conversion; otherwise, don't change the default value returned (.5,.5)
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
                            // Scale (accounting for the letterboxing on the left and right of the video preview), switch x and y, and reverse x
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
                        // If point is inside letterboxed area, do coordinate conversion. Otherwise, don't change the default value returned (.5,.5)
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
                            // Scale (accounting for the letterboxing on the top and bottom of the video preview), switch x and y, and reverse x
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[self.previewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
                    // Scale, switch x and y, and reverse x
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2; // Account for cropped height
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2); // Account for cropped width
                        xc = point.y / frameSize.height;
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    CALayer *layer = self.captureView.layer;
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [layer addSublayer:self.previewLayer];
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    if (nil != error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG };
    [self.stillImageOutput setOutputSettings:outputSettings];
    [self.session addOutput:self.stillImageOutput];
    
    [self.session addInput:self.input];
    
    [self.snap addTarget:self action:@selector(snapshot:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFocus:)];
    [self.captureView addGestureRecognizer:tap];
    
    
    if ([self.device lockForConfiguration:nil]) {
        [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        [self.device unlockForConfiguration];
    }
}

#pragma mark - Actions

- (void)tapToFocus:(UITapGestureRecognizer *)recognizer {
    if ([self.device lockForConfiguration:nil]) {
        CGPoint point = [self convertToPointOfInterestFromViewCoordinates:[recognizer locationInView:recognizer.view]];
        
        [self.device setFocusPointOfInterest:point];
        [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        
        [self.device unlockForConfiguration];
    }
}

- (void)snapshot:(id)sender {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    if (!videoConnection) {
        NSLog(@"Coulnd't get video connection");
        
        return;
    }
    
    __block UIButton *btn = (UIButton *)sender;
    
    btn.userInteractionEnabled = NO;
    btn.enabled = NO;
    
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        btn.userInteractionEnabled = YES;
        btn.enabled = YES;
        if (error) {
            NSLog(@"Capture error: %@", [error localizedDescription]);
            return;
        }
        
        NSData *imgData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:imgData], nil, nil, 0);
        
    }];
}

- (IBAction)toggleFlash:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if (btn.selected) {
        [btn setTitle:@"Flash: Off" forState:UIControlStateNormal];
        btn.selected = NO;
        
        if ([self.device lockForConfiguration:nil]) {
            if ([self.device hasFlash] && self.device.isFlashAvailable) {
                [self.device setFlashMode:AVCaptureFlashModeOff];
            }
            [self.device unlockForConfiguration];
        }
    }
    else {
        [btn setTitle:@"Flash: On" forState:UIControlStateNormal];
        btn.selected = YES;
        
        if ([self.device lockForConfiguration:nil]) {
            if ([self.device hasFlash] && self.device.isFlashAvailable) {
                [self.device setFlashMode:AVCaptureFlashModeOn];
            }
            [self.device unlockForConfiguration];
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [CATransaction setDisableActions:YES];
    self.previewLayer.frame = self.captureView.layer.bounds;
    NSLog(@"%@", NSStringFromCGRect(self.captureView.frame));
    [_session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_session stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
