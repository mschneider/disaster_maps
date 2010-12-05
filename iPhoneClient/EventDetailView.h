//
//  EventDetailView.h
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface EventDetailView : UIViewController {
	Event * event;
	MKMapView * map;
	UILabel * tags;
	UITextView * descriptionView;
	
	BOOL showingPhoto;
	UIImageView * photoFrame;
}

@property (nonatomic, retain) Event * event;
@property (nonatomic, retain) IBOutlet MKMapView * map;
@property (nonatomic, retain) IBOutlet UILabel * tags;
@property (nonatomic, retain) IBOutlet UITextView * descriptionView;

- (IBAction) showPhotoTapped:(id)sender;

@end
