//
//  StatusBarController.m
//  Hourglass
//
//  Created by Sven A. Schmidt on 06.10.10.
//  Copyright 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import "StatusBarController.h"
#import "DropboxController.h"


@implementation StatusBarController

@synthesize toolbarItems;
@synthesize statusLabel;
@synthesize saveButton;
@synthesize progressView;


#pragma mark -
#pragma mark Workers
#pragma mark -

// load notification handlers

- (void)fileLoadingStarted:(NSNotification *)notification {
  NSString *filename = [[NSUserDefaults standardUserDefaults] stringForKey:@"DropboxFileName"];
  filename = [filename lastPathComponent];
  self.statusLabel.text = [NSString stringWithFormat:@"Loading: %@ ... (0%%)", filename];
  [self.progressView startAnimating];
  self.saveButton.enabled = NO;
}


- (void)fileLoaded:(NSNotification *)notification {
  NSString *filename = [[NSUserDefaults standardUserDefaults] stringForKey:@"DropboxFileName"];
  self.statusLabel.text = [filename lastPathComponent];
  [self.progressView stopAnimating];
  self.saveButton.enabled = YES;
}


- (void)fileLoadProgress:(NSNotification *)notification {
  NSString *filename = [[NSUserDefaults standardUserDefaults] stringForKey:@"DropboxFileName"];
  filename = [filename lastPathComponent];
  NSNumber *progress = [[notification userInfo] objectForKey:@"progress"];
  self.statusLabel.text = [NSString stringWithFormat:@"Loading: %@ ... (%.0f%%)", filename, [progress floatValue]*100];
}


// save notification handlers

- (void)fileSavingStarted:(NSNotification *)notification {
  NSString *filename = [[NSUserDefaults standardUserDefaults] stringForKey:@"DropboxFileName"];
  filename = [filename lastPathComponent];
  self.statusLabel.text = [NSString stringWithFormat:@"Saving: %@ ... (0%%)", filename];
  [self.progressView startAnimating];
  self.saveButton.enabled = NO;
}


- (void)fileSaved:(NSNotification *)notification {
  NSString *filename = [[NSUserDefaults standardUserDefaults] stringForKey:@"DropboxFileName"];
  self.statusLabel.text = [filename lastPathComponent];
  [self.progressView stopAnimating];
  self.saveButton.enabled = YES;
}


- (void)fileSaveProgress:(NSNotification *)notification {
  NSString *filename = [[NSUserDefaults standardUserDefaults] stringForKey:@"DropboxFileName"];
  filename = [filename lastPathComponent];
  NSNumber *progress = [[notification userInfo] objectForKey:@"progress"];
  self.statusLabel.text = [NSString stringWithFormat:@"Saving: %@ ... (%.0f%%)", filename, [progress floatValue]*100];
}


// button handler


- (void)save {
  NSLog(@"saving...");
  [[DropboxController sharedInstance] saveFile];
}


#pragma mark -
#pragma mark Init
#pragma mark -


- (id)init {
  if ((self = [super init])) {
    // notification handlers
    // load
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fileLoadingStarted:)
                                                 name:kFileLoadingStarted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fileLoaded:)
                                                 name:kFileLoaded object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fileLoadProgress:)
                                                 name:kFileLoadProgress object:nil];  
    // save
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fileSavingStarted:)
                                                 name:kFileSavingStarted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fileSaved:)
                                                 name:kFileSaved object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fileSaveProgress:)
                                                 name:kFileSaveProgress object:nil];  
    
    // set up toolbar    
    self.saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(save)] autorelease];
    self.progressView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    UIBarButtonItem *activityButton = [[[UIBarButtonItem alloc] initWithCustomView:self.progressView] autorelease];
    
    CGFloat barHeight = 40;
    self.statusLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, barHeight)] autorelease];
    //labelView.text = @"Dummy filename";
    self.statusLabel.textAlignment = UITextAlignmentLeft;
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *filenameLabel = [[[UIBarButtonItem alloc] initWithCustomView:self.statusLabel] autorelease];
    
    self.toolbarItems = [NSArray arrayWithObjects:
                         self.saveButton,
                         filenameLabel,
                         activityButton, nil];
    
  }
  return self;
}


- (void)dealloc {
  [super dealloc];
}


@end
