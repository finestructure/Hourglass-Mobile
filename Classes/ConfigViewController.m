//
//  ConfigViewController.m
//  Hourglass
//
//  Created by Sven A. Schmidt on 30.09.10.
//  Copyright 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import "ConfigViewController.h"


@implementation ConfigViewController

@synthesize linkButton;

#pragma mark -
#pragma mark Workers
#pragma mark -


-(IBAction)linkButtonPressed:(id)sender {
  if (![[DBSession sharedSession] isLinked]) {
    DBLoginController* controller = [[DBLoginController new] autorelease];
    controller.delegate = self;
    [controller presentFromController:self];
  } else {
    [[DBSession sharedSession] unlink];
    [[[[UIAlertView alloc] 
       initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked" 
       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
      autorelease]
     show];
    [self updateButtons];
  }
}


- (void)updateButtons {
  NSString* title = [[DBSession sharedSession] isLinked] ? @"Unlink Dropbox" : @"Link Dropbox";
  [linkButton setTitle:title forState:UIControlStateNormal];
}  


- (DBRestClient*)restClient {
  if (!restClient) {
    restClient = 
    [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    restClient.delegate = self;
  }
  return restClient;
}


#pragma mark -
#pragma mark Lifecycle
#pragma mark -


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  if ([[DBSession sharedSession] isLinked]) {
    [[self restClient] loadAccountInfo];
  }
  
  [self updateButtons];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark DBLoginControllerDelegate methods
#pragma mark -


- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info {
  NSLog(@"User id: %@", [info userId]);
  NSLog(@"Display name: %@", [info displayName]);
}


#pragma mark -
#pragma mark DBLoginControllerDelegate methods
#pragma mark -


- (void)loginControllerDidLogin:(DBLoginController*)controller {
  [self updateButtons];
}

- (void)loginControllerDidCancel:(DBLoginController*)controller {  
}

@end
