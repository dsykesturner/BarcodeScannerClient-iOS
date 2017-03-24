//
//  ViewController.h
//  BarcodeScanner
//
//  Created by Daniel Sykes-Turner on 13/3/17.
//  Copyright © 2017 Universe Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComputerConnection.h"

@interface ViewController : UIViewController

- (void)populateWithConnection:(ComputerConnection *)connection;

@end

