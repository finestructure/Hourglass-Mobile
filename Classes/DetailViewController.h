
@class Task, EditingViewController;

@interface DetailViewController : UITableViewController {
}

@property (nonatomic, retain) Task *task;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSUndoManager *undoManager;

- (void)setUpUndoManager;
- (void)cleanUpUndoManager;
- (void)updateRightBarButtonItemState;

@end

