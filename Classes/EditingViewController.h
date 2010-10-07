
@interface EditingViewController : UIViewController {
}

@property (nonatomic, retain) IBOutlet UITextField *textField;

@property (nonatomic, retain) NSManagedObject *editedObject;
@property (nonatomic, retain) NSString *editedFieldKey;
@property (nonatomic, retain) NSString *editedFieldName;

@property (nonatomic, assign, getter=isEditingDate) BOOL editingDate;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

- (IBAction)cancel;
- (IBAction)save;

@end

