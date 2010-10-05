//
//  SettingsTableViewController.m
//  Hourglass
//
//  Created by Sven A. Schmidt on 04.10.10.
//  Copyright 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AccountViewController.h"
#import "DropboxController.h"
#import "DirectoryViewController.h"


@implementation SettingsTableViewController

#pragma mark -
#pragma mark Workers
#pragma mark -


-(void)accountInfoLoaded:(NSNotification *)notification {
  [self.tableView reloadData];
}


#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = NSLocalizedString(@"Settings", @"Settings tab bar item title");

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(accountInfoLoaded:)
                                               name:kAccountInfoLoaded object:nil];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
  }
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  if ([[DBSession sharedSession] isLinked]) {
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Unlink";
      cell.detailTextLabel.text = [[DropboxController sharedInstance] userId];
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Choose File";
      cell.detailTextLabel.text = @"/Test.sqlite";
    }
  } else {
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Link";
      cell.detailTextLabel.text = [[DropboxController sharedInstance] userId];
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Choose File";
      cell.detailTextLabel.text = @"/Test.sqlite";
    }
  }
   
  return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return @"Dropbox Integration";
}


#pragma mark -
#pragma mark Table view delegate
#pragma mark -


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    AccountViewController *vc = [[[AccountViewController alloc] initWithNibName:@"AccountView" 
                                                                         bundle:nil] autorelease];
    [self.navigationController pushViewController:vc animated:YES];
  } else if (indexPath.row == 1) {
    DirectoryViewController *vc = [[[DirectoryViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [vc loadMetadata:@"/"];
    [self.navigationController pushViewController:vc animated:YES];
  }
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

