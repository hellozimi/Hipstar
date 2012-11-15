//
//  CameraViewController.m
//  hipstar
//
//  Created by Simon Andersson on 11/9/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "CameraViewController.h"
#import "FilterViewController.h"
#import "Globals.h"

@interface CameraViewController () <AVCaptureVideoDataOutputSampleBufferDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImage *_generatedImage;
    BOOL _flashOn;
    BOOL _frontFacingCamera;
    
    Loader *_loader;
}

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (weak, nonatomic) IBOutlet UIView *captureView;
@property (weak, nonatomic) IBOutlet UIButton *snap;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraSwitchButton;

@end


@implementation CameraViewController (Internal)

- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates {
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
    
    self.device = [self backCamera];
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!IS_WIDESCREEN) {
        
        CGRect frame = self.flashButton.frame;
        frame.origin.y = 5;
        self.flashButton.frame = frame;
        
        frame = self.cameraSwitchButton.frame;
        frame.origin.y = 5;
        self.cameraSwitchButton.frame = frame;
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [CATransaction setDisableActions:YES];
    self.previewLayer.frame = self.captureView.layer.bounds;
    [_session startRunning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_session stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (AVCaptureDevice *)frontFacingCameraIfAvailable
{
    //  look at all the video devices and get the first one that's on the front
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == AVCaptureDevicePositionFront)
        {
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if ( ! captureDevice)
    {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}

- (AVCaptureDevice *)backCamera {
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices) {
        if (device.position == AVCaptureDevicePositionBack) {
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if ( !captureDevice) {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}

- (IBAction)switchCamera:(id)sender {
    AVCaptureDevice *device = nil;
    if (_frontFacingCamera) {
        device = [self backCamera];
        _frontFacingCamera = NO;
    }
    else {
        device = [self frontFacingCameraIfAvailable];
        _frontFacingCamera = YES;
    }
    
    [self.session removeInput:self.input];
    self.device = device;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [self.session addInput:self.input];
}

- (IBAction)openGallery:(id)sender {
    [self performSegueWithIdentifier:@"PresentGalleryViewController" sender:nil];
}

- (void)tapToFocus:(UITapGestureRecognizer *)recognizer {
    if ([self.device lockForConfiguration:nil]) {
        
        CGPoint point = [self convertToPointOfInterestFromViewCoordinates:[recognizer locationInView:recognizer.view]];
        
        if ([self.device isFocusPointOfInterestSupported]) {
            [self.device setFocusPointOfInterest:point];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
            
        }
        
        if ([self.device isExposurePointOfInterestSupported]) {
            [self.device setExposurePointOfInterest:point];
        }
        
        [self.device unlockForConfiguration];
    }
}

UIImage *scaleAndRotateImage(UIImage *image)
{
    int kMaxResolution = 1080; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
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
    
    if (_loader) {
        [_loader hide];
    }
    
    _loader = [Loader loader];
    [_loader show];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        btn.userInteractionEnabled = YES;
        btn.enabled = YES;
        if (error) {
            NSLog(@"Capture error: %@", [error localizedDescription]);
            return;
        }
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *imageToCrop = [UIImage imageWithData:imageData];
        float y = (imageToCrop.size.height - imageToCrop.size.width) / 2;
        
        // Magic ratio
        float padding = 20 * 1.6875;
        
        UIImage *baseImage = [self cropImage:imageToCrop cropRect:CGRectMake(padding, y +padding, imageToCrop.size.width - (padding * 2), imageToCrop.size.width - (padding*2)) aspectFitBounds:CGSizeMake(1080, 1080) fillColor:[UIColor blackColor]];
        
        _generatedImage = baseImage;
        
        [self performSegueWithIdentifier:@"PresentFilterViewController" sender:self];
        
    }];
}

- (IBAction)toggleFlash:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if (_flashOn) {
        _flashOn = NO;
        
        if ([self.device lockForConfiguration:nil]) {
            if ([self.device hasFlash] && self.device.isFlashAvailable) {
                [self.device setFlashMode:AVCaptureFlashModeOff];
                [btn setImage:[UIImage imageNamed:@"icon_flash_off"] forState:UIControlStateNormal];
            }
            [self.device unlockForConfiguration];
        }
    }
    else {
        _flashOn = YES;
        
        if ([self.device lockForConfiguration:nil]) {
            if ([self.device hasFlash] && self.device.isFlashAvailable) {
                [self.device setFlashMode:AVCaptureFlashModeOn];
                [btn setImage:[UIImage imageNamed:@"icon_flash_on"] forState:UIControlStateNormal];
            }
            [self.device unlockForConfiguration];
        }
    }
    
}

- (IBAction)importFromCameraRoll:(id)sender {
    
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    vc.delegate = self;
    vc.allowsEditing = YES;
    
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate Implementation

// CropRect is assumed to be in UIImageOrientationUp, as it is delivered this way from the UIImagePickerController when using AllowsImageEditing is on.
// The sourceImage can be in any orientation, the crop will be transformed to match
// The output image bounds define the final size of the image, the image will be scaled to fit,(AspectFit) the bounds, the fill color will be
// used for areas that are not covered by the scaled image.
-(UIImage *)cropImage:(UIImage *)sourceImage cropRect:(CGRect)cropRect aspectFitBounds:(CGSize)finalImageSize fillColor:(UIColor *)fillColor {
    
    CGImageRef sourceImageRef = sourceImage.CGImage;
    
    //Since the crop rect is in UIImageOrientationUp we need to transform it to match the source image.
    CGAffineTransform rectTransform = [self transformSize:sourceImage.size orientation:sourceImage.imageOrientation];
    CGRect transformedRect = CGRectApplyAffineTransform(cropRect, rectTransform);
    
    //Now we get just the region of the source image that we are interested in.
    CGImageRef cropRectImage = CGImageCreateWithImageInRect(sourceImageRef, transformedRect);
    
    //Figure out which dimension fits within our final size and calculate the aspect correct rect that will fit in our new bounds
    CGFloat horizontalRatio = finalImageSize.width / CGImageGetWidth(cropRectImage);
    CGFloat verticalRatio = finalImageSize.height / CGImageGetHeight(cropRectImage);
    CGFloat ratio = MIN(horizontalRatio, verticalRatio); //Aspect Fit
    CGSize aspectFitSize = CGSizeMake(CGImageGetWidth(cropRectImage) * ratio, CGImageGetHeight(cropRectImage) * ratio);
    
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 finalImageSize.width,
                                                 finalImageSize.height,
                                                 CGImageGetBitsPerComponent(cropRectImage),
                                                 0,
                                                 CGImageGetColorSpace(cropRectImage),
                                                 CGImageGetBitmapInfo(cropRectImage));
    
    if (context == NULL) {
        NSLog(@"NULL CONTEXT!");
    }
    
    //Fill with our background color
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, finalImageSize.width, finalImageSize.height));
    
    //We need to rotate and transform the context based on the orientation of the source image.
    CGAffineTransform contextTransform = [self transformSize:finalImageSize orientation:sourceImage.imageOrientation];
    CGContextConcatCTM(context, contextTransform);
    
    //Give the context a hint that we want high quality during the scale
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    //Draw our image centered vertically and horizontally in our context.
    CGContextDrawImage(context, CGRectMake((finalImageSize.width-aspectFitSize.width)/2, (finalImageSize.height-aspectFitSize.height)/2, aspectFitSize.width, aspectFitSize.height), cropRectImage);
    
    //Start cleaning up..
    CGImageRelease(cropRectImage);
    
    CGImageRef finalImageRef = CGBitmapContextCreateImage(context);
    UIImage *finalImage = [UIImage imageWithCGImage:finalImageRef];
    
    CGContextRelease(context);
    CGImageRelease(finalImageRef);
    return finalImage;
}

//Creates a transform that will correctly rotate and translate for the passed orientation.
//Based on code from niftyBean.com
- (CGAffineTransform) transformSize:(CGSize)imageSize orientation:(UIImageOrientation)orientation {
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (orientation) {
        case UIImageOrientationLeft: { // EXIF #8
            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,M_PI_2);
            transform = txCompound;
            break;
        }
        case UIImageOrientationDown: { // EXIF #3
            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,M_PI);
            transform = txCompound;
            break;
        }
        case UIImageOrientationRight: { // EXIF #6
            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,-M_PI_2);
            transform = txCompound;
            break;
        }
        case UIImageOrientationUp: { // EXIF #1 - do nothing
            
        }
        default: // EXIF 2,4,5,7 - ignore
            break;
    }
    return transform;
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGRect cropRect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
    [self dismissViewControllerAnimated:YES completion:^{
        
        _generatedImage = [self cropImage:originalImage cropRect:cropRect aspectFitBounds:CGSizeMake(1080, 1080) fillColor:[UIColor blackColor]];
        
        [self performSegueWithIdentifier:@"PresentFilterViewController" sender:self];
    }];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PresentFilterViewController"]) {
        FilterViewController *vc = segue.destinationViewController;
        vc.originalImage = _generatedImage;
        [_loader hide];
    }
}

@end