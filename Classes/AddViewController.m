
#import "AddViewController.h"

@implementation AddViewController

@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
  // Override the DetailViewController viewDidLoad with different navigation bar items and title.
  self.title = @"New Task";
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
}


#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)cancel:(id)sender {
	[delegate addViewController:self didFinishWithSave:NO];
}

- (IBAction)save:(id)sender {
	[delegate addViewController:self didFinishWithSave:YES];
}


@end
