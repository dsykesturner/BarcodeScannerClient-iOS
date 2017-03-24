//
//  ComputerConnection.m
//  BarcodeScanner
//
//  Created by Daniel Sykes-Turner on 13/3/17.
//  Copyright © 2017 Universe Apps. All rights reserved.
//

#import "ComputerConnection.h"

@implementation ComputerConnection

// Initialize with host address and port
- (id)initWithHost:(NSString*)host andPort:(int)port {
    self.connection = [[Connection alloc] initWithHostAddress:host andPort:port];
    return self;
}

// Initialize with a reference to a net service discovered via Bonjour
- (id)initWithNetService:(NSNetService*)netService {
    self.connection = [[Connection alloc] initWithNetService:netService];
    return self;
}

- (BOOL)start {
    if (!self.connection) {
        return NO;
    }
    
    // We are the delegate
    self.connection.delegate = self;
    
    return [self.connection connect];
}


- (void)stop {
    if (!self.connection) {
        return;
    }
    
    [self.connection close];
    self.connection = nil;
}

- (void)broadcastChatMessage:(NSString*)message fromUser:(NSString*)name {
    // Create network packet to be sent to all clients
    NSDictionary* packet = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", name, @"from", nil];
    
    // Send it out
    [self.connection sendNetworkPacket:packet];
}

#pragma mark - delegate

- (void)connectionAttemptFailed:(Connection*)connection {
    NSLog(@"connectionAttemptFailed");
//    [delegate roomTerminated:self reason:@"Wasn't able to connect to server"];
}


- (void)connectionTerminated:(Connection*)connection {
    NSLog(@"connectionTerminated");
//    [delegate roomTerminated:self reason:@"Connection to server closed"];
}


- (void)receivedNetworkPacket:(NSDictionary*)packet viaConnection:(Connection*)connection {
    NSLog(@"receivedNetworkPacket");
    // Display message locally
//    [delegate displayChatMessage:[packet objectForKey:@"message"] fromUser:[packet objectForKey:@"from"]];
}

@end
