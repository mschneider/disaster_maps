//
//  EventDetailView.m
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventDetailView.h"
#import "UIImage+Resize.h"


@implementation EventDetailView

@synthesize descriptionView, map, tags, event;


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
	
	showingPhoto = NO;
	UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = _backButton;

}


- (void) viewWillAppear:(BOOL)animated
{
	if (self.event) {
		[self.map addAnnotation:event.location];
		
		Location * loc = event.location;
		CLLocationCoordinate2D coord = loc.coordinate;
		
		MKCoordinateRegion region;
		MKCoordinateSpan span;
		
		span.latitudeDelta = 0.05;
		span.longitudeDelta = 0.05;
		region.center = coord;
		region.span = span;
		
		[map setRegion:region animated:NO];
		self.descriptionView.text = event.descriptionText;
		
		NSMutableString * subtitle = [NSMutableString string];
		
		NSArray * tagsArray = [event.tags allObjects];
		for (int i = 0; i < MIN(5, [tagsArray count]); i++) {
			Tag * tag = [tagsArray objectAtIndex:i];
			[subtitle appendFormat:@"%@ ", tag.tagName];
		}
		
		self.tags.text = subtitle;
		
	}

}

- (IBAction) showPhotoTapped:(id)sender
{
	if( !showingPhoto )
	{
		if (self.event.photoData) {
			UIImage * image = [[UIImage imageWithData:self.event.photoData] resizedImageWithContentMode:UIViewContentModeScaleAspectFit
																								 bounds:self.view.bounds.size
																				   interpolationQuality:kCGInterpolationMedium];
			photoFrame = [[UIImageView alloc] initWithImage:image];
			
			[self.view addSubview:photoFrame];
			
			photoFrame.frame = CGRectOffset(photoFrame.frame, 0, -480);
			
			[UIView beginAnimations:@"slidein" context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:1];
			photoFrame.frame = CGRectOffset(photoFrame.frame, 0, 480);
			photoFrame.alpha = 1.0;
			[UIView commitAnimations];
			
			showingPhoto = YES;
			
			UIButton * button = (UIButton*) sender;
			
			[button setTitle:@"Hide Photo" forState:UIControlStateNormal];
			
		}
	}
	else {
		showingPhoto = NO;
		
		UIButton * button = (UIButton*) sender;
		
		[button setTitle:@"Show Photo" forState:UIControlStateNormal];
		
		[UIView beginAnimations:@"slideout" context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1];
		photoFrame.frame = CGRectOffset(photoFrame.frame, 0, -480);
		photoFrame.alpha = 0;
		[UIView commitAnimations];
		
		[photoFrame performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
	}

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
    [super dealloc];
}


@end
