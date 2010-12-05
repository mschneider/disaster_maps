//
//  EventEntryView.m
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventEntryView.h"
#import "TagTableDataSource.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+Resize.h"

@implementation EventEntryView
@synthesize tagsField, descriptionField, addPhotoButton, submitButton,tagsSearchResultsTable,toolbar, photoData;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	photoData = nil;
	NSManagedObjectContext * context = [[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	self.tagsField.delegate = self;
	
	TagTableDataSource * datasource = [[TagTableDataSource alloc]initWithManagedObjectContext:context];
	self.tagsSearchResultsTable.dataSource = datasource;
	self.tagsSearchResultsTable.delegate = self;
//	[datasource release];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"dealloc eventEntryView");
    [super dealloc];
}

- (BOOL) validateParameters
{
	if ([self.descriptionField.text length] == 0) {
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Enter Description" 
														 message:@"Please provide a short description for this entry" 
														delegate:nil 
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
		[alert show];
		[alert release];
		return NO;
	}
	
	if ([self.tagsField.text length] == 0) {
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Enter Tags" 
														 message:@"Please provide a few tags for this entry" 
														delegate:nil 
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
		[alert show];
		[alert release];
		return NO;
	}
	
}

#pragma mark -
#pragma mark UI Actions

- (IBAction) submitTapped:(id)sender
{
	NSLog(@"submit tapped!");
	if (![self validateParameters]) {
		return;
	}
	CaritasAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
	
	CLLocation * currentLocation = appDelegate.location;
	if (currentLocation == nil) {
		NSLog(@"location not available yet");
		return;
	}
	else {
		NSLog(@"location: %f lat, %f lon, %f alt", 
			  currentLocation.coordinate.latitude,
			  currentLocation.coordinate.longitude,
			  currentLocation.altitude);
	}

	
	NSManagedObjectContext *context = appDelegate.managedObjectContext;
	Location *locationObject = [NSEntityDescription
										   insertNewObjectForEntityForName:@"Location"
										   inManagedObjectContext:context];
	
	locationObject.location = currentLocation;
	
	Event* newEvent = [NSEntityDescription
				   insertNewObjectForEntityForName:@"Event"
				   inManagedObjectContext:context];
	
	newEvent.location = locationObject;
	
	newEvent.descriptionText = self.descriptionField.text;
	
	newEvent.timeStamp = [NSDate date];
	NSArray * tagStrings = [self.tagsField.text componentsSeparatedByString:@","];
	
	if (photoData) {
		newEvent.photoData = photoData;
	}

	for (NSString * str in tagStrings) {
		NSString * trimmedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		Tag * nt = [Tag getOrCreateTagWithName:trimmedString
			 inManagedObjectContext:appDelegate.managedObjectContext];
		
		[newEvent addTagsObject:nt];
		[nt addEventsObject:newEvent];
	}
	
	
	NSError *error;
	if( ![context save:&error]) 
	{
		NSLog(@"could not save new event!");
		abort();
	}
	if (photoData) {
		[photoData release];
		photoData = nil;
	}
	
	[appDelegate postEvent:newEvent];

	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	
	
}

- (IBAction) cancelTapped:(id)sender
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction) addPhotoTapped:(id)sender
{
	
	UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select source" 
															  delegate:self 
													 cancelButtonTitle:nil 
												destructiveButtonTitle:nil 
													 otherButtonTitles:@"Take a Photo",@"Select from Library",@"Cancel",nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
	
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"button clicked: %d",buttonIndex);
	if (buttonIndex == 0) // take a photo
	{
		UIImagePickerController * picker = [[UIImagePickerController alloc]init];
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		picker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
		
		picker.allowsEditing = NO;
		
		picker.delegate = self;
		
		[self presentModalViewController: picker animated: YES];
	}
	else if (buttonIndex == 1) // photo library
	{
		UIImagePickerController * picker = [[UIImagePickerController alloc]init];
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		picker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
		
		picker.allowsEditing = NO;
		
		picker.delegate = self;
		
		[self presentModalViewController: picker animated: YES];
	}
}

#pragma mark -
#pragma mark  UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if ([textField.text length] > 1 ) {
		//DO SEARCH
		NSArray * tags = [textField.text componentsSeparatedByString:@","];
		NSString * incompleteTag = [tags lastObject];
		
		incompleteTag = [incompleteTag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		[self.tagsSearchResultsTable.dataSource search:incompleteTag];
		[self.tagsSearchResultsTable reloadData];
		CGFloat newTableHeight = [tagsSearchResultsTable numberOfRowsInSection:0] * tagsSearchResultsTable.rowHeight;
		
		CGRect tableBounds = tagsSearchResultsTable.frame;
		
		[UIView beginAnimations:@"adjustHeight" context:nil];
		tableBounds.size.height = newTableHeight;
	
		
		tagsSearchResultsTable.frame = tableBounds;
		[UIView commitAnimations];	
		
		if (tagsSearchResultsTable.hidden) {
			tagsSearchResultsTable.hidden = NO;
			tagsSearchResultsTable.layer.cornerRadius = 5.0;
			[UIView beginAnimations:@"showTags" context:nil];
			tagsSearchResultsTable.alpha = 1.0;
			[UIView commitAnimations];
		}
	}
	else {
		if (!tagsSearchResultsTable.hidden) {
			[UIView beginAnimations:@"showTags" context:nil];
			tagsSearchResultsTable.alpha = 0.0;
			[UIView commitAnimations];
			tagsSearchResultsTable.hidden = YES;
		}
	}

	
	return YES;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray * tagsArray = [self.tagsField.text componentsSeparatedByString:@","];
	//self.tagsField.text = [self.tagsField.text stringByAppendingFormat:@", %@",
	
	NSMutableString * newTags = [NSMutableString string];
	
	for (int i =0; i < [tagsArray count]-1; i++) {
		[newTags appendFormat:@"%@, ", [tagsArray objectAtIndex:i]];
	}
	
	UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath]; 
	NSString * lastTag = cell.textLabel.text;
	[newTags appendString:lastTag];
	
	self.tagsField.text = newTags;
						   
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[UIView beginAnimations:@"removeTable" context:nil];
	tableView.alpha = 0.0;
	[UIView commitAnimations];
	
	tableView.hidden = YES;
}	


#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	UIBarButtonItem * doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																						target:textView action:@selector(resignFirstResponder)];
	self.toolbar.items = [self.toolbar.items arrayByAddingObject:doneBarButtonItem];
	[doneBarButtonItem autorelease];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	NSRange range;
	range.location = 0;
	range.length = [self.toolbar.items count] -1;
	self.toolbar.items = [self.toolbar.items subarrayWithRange:range];
}

#pragma mark -
#pragma mark  UIImagePickerControllerDelegate

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	[picker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
	UIImage * scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit 
														bounds:CGSizeMake(1024, 1024) 
										  interpolationQuality:kCGInterpolationMedium];
	
	self.photoData = UIImageJPEGRepresentation(scaledImage, 0.60);

//	[scaledImage release];
	NSLog(@"parentview controller: %@", [[picker parentViewController] description]);
	//TODO: EntryView gets reset here, when adding a photo taken with the camera. but not when selecting a photo from the library. find the memory issue.
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	[picker release];
}

@end
