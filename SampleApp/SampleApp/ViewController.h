//
//  ViewController.h
//  SampleApp
//
//  Created by Rob Stevens on 13/09/2014.
//  Copyright (c) 2014 Rob Stevens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

// Action for "Continue" button at base of first page
- (IBAction)ContinueToPage2:(id)sender;

// If we tap anywhere other than in a control, we'll close any edit object
- (IBAction)tapEmpty:(id)sender;

// Touching the date picker should also end any textfield editing
- (IBAction)touchedDatePicker:(id)sender;

// We maintain a property to identify the active locale
enum KnownLocales {
	LOCALE_NONE,		// If we come across an unexpected locale, we tag it as none and methods can decide their own default actions
	LOCALE_UK,
	LOCALE_DE,
	LOCALE_US
};
@property (nonatomic) int locale;

// Referencing outlets for the 4 textFields
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

// The date picker
@property (weak, nonatomic) IBOutlet UIDatePicker *pkrDate;

@end
