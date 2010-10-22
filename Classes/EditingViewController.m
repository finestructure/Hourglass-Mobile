
#import "EditingViewController.h"

@implementation EditingViewController

@synthesize textField, editedObject, editedFieldKey, editedFieldName, editingDate, datePicker;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	// Set the title to the user-visible name of the field.
	self.title = editedFieldName;

	// Configure the save and cancel buttons.
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
}


- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	// Configure the user interface according to state.
    if (editingDate) {
        textField.hidden = YES;
        datePicker.hidden = NO;
		NSDate *date = [editedObject valueForKey:editedFieldKey];
        if (date == nil) date = [NSDate date];
        datePicker.date = date;
    }
	else {
        textField.hidden = NO;
        datePicker.hidden = YES;
        textField.text = [editedObject valueForKey:editedFieldKey];
		textField.placeholder = self.title;
        [textField becomeFirstResponder];
    }
}


#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)save {
  NSLog(@"saving");
  
  // pass current value to the edited object, then pop.
  if (editingDate) {
    [editedObject setValue:datePicker.date forKey:editedFieldKey];
  } else {
    [editedObject setValue:textField.text forKey:editedFieldKey];
  }
	
  NSError *error;
  if (![[editedObject managedObjectContext] save:&error]) {
    NSLog(@"Error while saving task %@, %@", error, [error userInfo]);
  }

  [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cancel {
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [textField release];
    [editedObject release];
    [editedFieldKey release];
    [editedFieldName release];
    [datePicker release];
	[super dealloc];
}


@end

