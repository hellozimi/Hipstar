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
@property (weak, nonatomic) IBOutlet UIView *captureView;
@property (weak, nonatomic) IBOutlet UIButton *snap;

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
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (nil != error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG };
    [self.stillImageOutput setOutputSettings:outputSettings];
    [self.session addOutput:self.stillImageOutput];
    
    [self.session addInput:input];
    
    [self.snap addTarget:self action:@selector(snapshot:) forControlEvents:UIControlEventTouchUpInside];
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
