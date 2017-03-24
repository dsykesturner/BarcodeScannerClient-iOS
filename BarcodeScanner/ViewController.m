//
//  ViewController.m
//  BarcodeScanner
//
//  Created by Daniel Sykes-Turner on 13/3/17.
//  Copyright © 2017 Universe Apps. All rights reserved.
//

#import "ViewController.h"
#import "MTBBarcodeScanner.h"
#import "ComputerConnection.h"
#import "AppConfig.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIView *cameraView;
@property (nonatomic, weak) IBOutlet UILabel *lblScannedBarcode;
@property (nonatomic, weak) IBOutlet UIButton *btnBroadcastBarcode;
@property (nonatomic, strong) MTBBarcodeScanner *scanner;
@property (nonatomic, strong) NSMutableArray *uniqueCodes;
@property (nonatomic, strong) ComputerConnection *computerConnection;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set device name
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [AppConfig getInstance].name = uniqueIdentifier;
    
    self.btnBroadcastBarcode.hidden = true;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupDeviceCamera];
    
    [self testConnection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populateWithConnection:(ComputerConnection *)connection {
    self.computerConnection = connection;
    if ([self.computerConnection start]) {
        NSLog(@"Connected!");
    } else {
        NSLog(@"Unable to connect :(");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unable to connect" message:@"It seems the connection has vanished. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:true];
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
}

- (IBAction)broadastBarcodeTapped:(id)sender {
    [self.computerConnection broadcastChatMessage:self.lblScannedBarcode.text fromUser:[AppConfig getInstance].name];
}

- (void)testConnection {
    
    [self.computerConnection broadcastChatMessage:@"connected" fromUser:[AppConfig getInstance].name];
}

- (void)setupDeviceCamera {
    
    // Start the camera
    self.cameraView.layer.masksToBounds = true;
    self.scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.cameraView];
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            NSError *error = nil;
            [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
                // We scanned a barcode! Update the label with the latest scan
                if (codes && codes.count >= 1) {
                    self.lblScannedBarcode.text = ((AVMetadataMachineReadableCodeObject *)codes.firstObject).stringValue;
                    self.btnBroadcastBarcode.hidden = false;
                }
            } error:&error];
            
        } else {
            // The user denied access to the camera, or
            NSLog(@"Camera denied access");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Camera access failed" message:@"The camera could not be accessed. Please make sure you have given permission to the camera." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:nil]];
            [self presentViewController:alert animated:true completion:nil];
        }
    }];
    
    // Limit the scanning area
    __weak ViewController *weakSelf = self;
    self.scanner.didStartScanningBlock = ^{
        float rectWidth = 320;
        float rectHeight = 125;
        float screenWidth = weakSelf.cameraView.frame.size.width;
        float screenHeight = weakSelf.cameraView.frame.size.height;
        CGRect scanningRect = CGRectMake(screenWidth/2-rectWidth/2, screenHeight/2-rectHeight/2, rectWidth, rectHeight);
        weakSelf.scanner.scanRect = scanningRect;
        
        UIView *scanView = [[UIView alloc] initWithFrame:scanningRect];
        scanView.backgroundColor = [UIColor clearColor];
        scanView.layer.borderColor = [UIColor greenColor].CGColor;
        scanView.layer.borderWidth = 2;
        [weakSelf.cameraView addSubview:scanView];
        
    };
}




@end
