//
//  EventEntryView.h
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventEntryView : UIViewController <UIImagePickerControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITextViewDelegate, UIActionSheetDelegate> {
	
	UITextField * tagsField;
	UITextView * descriptionField;
	UIButton * addPhotoButton;
	UIButton * submitButton;
	UITableView * tagsSearchResultsTable;
	UIToolbar * toolbar;
	
	NSData * photoData;

}

@property (nonatomic, retain) IBOutlet UITextField * tagsField;
@property (nonatomic, retain) IBOutlet UITextView * descriptionField;
@property (nonatomic, retain) IBOutlet UIButton * addPhotoButton;
@property (nonatomic, retain) IBOutlet UIButton * submitButton;
@property (nonatomic, retain) IBOutlet UITableView * tagsSearchResultsTable;
@property (nonatomic,retain) IBOutlet UIToolbar * toolbar;
@property (nonatomic, retain) NSData * photoData;

- (IBAction) submitTapped:(id)sender;
- (BOOL) validateParameters;
- (IBAction) cancelTapped:(id)sender;
- (IBAction) addPhotoTapped:(id)sender;

@end
