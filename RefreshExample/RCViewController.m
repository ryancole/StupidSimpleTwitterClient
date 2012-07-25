//
//  RCViewController.m
//  RefreshExample
//
//  Created by Ryan Cole on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCViewController.h"
#import "AFNetworking.h"

@interface RCViewController ()

@property (nonatomic, strong) SSPullToRefreshView* pullToRefreshView;

@end

@implementation RCViewController

@synthesize tableView;
@synthesize pullToRefreshView;
@synthesize results;

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableViewDataSource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 68;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.results.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"cellIdentifier";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.textColor = [UIColor colorWithRed:0.6f green:0.7f blue:0.8f alpha:1.0f];
        
        
    }
    
    // grab the tweet for this row index
    NSDictionary* tweet = [self.results objectAtIndex:indexPath.row];
    NSString* photo_url = [tweet objectForKey:@"profile_image_url"];
    
    // set the cell text labels to this tweet text
    cell.textLabel.text = [tweet objectForKey:@"from_user_name"];
    cell.detailTextLabel.text = [tweet objectForKey:@"text"];
    
    // set tweet row image to profile image
    [cell.imageView setImageWithURL:[NSURL URLWithString:photo_url]
                   placeholderImage:[UIImage imageNamed:@"avatar.png"]];
    
    return cell;
    
}

#pragma mark - SSPullToRefreshViewDelegate Methods

- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view {
    
    return YES;
    
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    
    NSURL* url = [NSURL URLWithString:@"http://search.twitter.com/search.json?q=Apple"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation* operation;
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                success:^(NSURLRequest* request, NSHTTPURLResponse* response, id jsonObject) {
                                                                    
                                                                    self.results = [jsonObject objectForKey:@"results"];
                                                                    [self.pullToRefreshView finishLoading];
                                                                    [self.tableView reloadData];
                                                                    
                                                                }
                                                                failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id jsonObject) {
                                                                    NSLog(@"Received an HTTP %d", response.statusCode);
                                                                    NSLog(@"The error was %@", error);
                                                                }];
    
    [operation start];
    
}

- (void)pullToRefreshViewDidFinishLoading:(SSPullToRefreshView *)view {
    
    NSLog(@"stop loading ...");
    
}

@end