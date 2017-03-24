//
//  ComputerSearchViewController.m
//  BarcodeScanner
//
//  Created by Daniel Sykes-Turner on 13/3/17.
//  Copyright © 2017 Universe Apps. All rights reserved.
//

#import "ComputerSearchViewController.h"
#import "ViewController.h"

#import "ServerBrowserDelegate.h"
#import "ServerBrowser.h"
#import "ComputerConnection.h"

@interface ComputerSearchViewController () <UITableViewDelegate, UITableViewDataSource, ServerBrowserDelegate>
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) ServerBrowser *serverBrowser;
@end

@implementation ComputerSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.serverBrowser = [[ServerBrowser alloc] init];
    self.serverBrowser.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.serverBrowser start];
}

- (void)pickServer:(NSNetService *)server {
    
    // Create connection that will connect to that server
    ComputerConnection* cConnection = [[ComputerConnection alloc] initWithNetService:server];
    
    // Stop browsing and switch over to chat room
    [self.serverBrowser stop];
    
    ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    [vc populateWithConnection:cConnection];
    
    [self.navigationController pushViewController:vc animated:true];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.serverBrowser.servers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serverListCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"serverListCellIdentifier"];
    }
    
    NSNetService* server = [self.serverBrowser.servers objectAtIndex:indexPath.row];
    cell.textLabel.text = [server name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSNetService* selectedServer = [self.serverBrowser.servers objectAtIndex:indexPath.row];
    [self pickServer:selectedServer];
}

#pragma mark - ServerBrowserDelegate
- (void)updateServerList {
    [self.tableView reloadData];
}


@end
