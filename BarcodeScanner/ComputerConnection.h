//
//  ComputerConnection.h
//  BarcodeScanner
//
//  Created by Daniel Sykes-Turner on 13/3/17.
//  Copyright © 2017 Universe Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"

@interface ComputerConnection : NSObject <ConnectionDelegate>
@property (nonatomic,strong) Connection* connection;

- (BOOL)start;
- (void)stop;

// Initialize with host address and port
- (id)initWithHost:(NSString*)host andPort:(int)port;

// Initialize with a reference to a net service discovered via Bonjour
- (id)initWithNetService:(NSNetService*)netService;

// Send a message
- (void)broadcastChatMessage:(NSString*)message fromUser:(NSString*)name;
@end
