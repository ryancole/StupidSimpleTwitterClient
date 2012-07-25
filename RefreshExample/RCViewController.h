//
//  RCViewController.h
//  RefreshExample
//
//  Created by Ryan Cole on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPullToRefresh.h"

@interface RCViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SSPullToRefreshViewDelegate>

@property (nonatomic, retain) NSArray* results;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end