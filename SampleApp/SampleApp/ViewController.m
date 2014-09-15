//
//  ViewController.m
//  SampleApp
//
//  Created by Rob Stevens on 13/09/2014.
//  Copyright (c) 2014 Rob Stevens. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

// -------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// We're going to use the system locale to decide which UI elements to present to the user
	// We're only interested in the countries the app is going to be released in (UK, US and Germany), so we check specifically
	// for those. We're not concerned by languages at this point since text will be handled by the localized strings, we just need
	// the correct region
	
	NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];

	// Log the country code we found for debugging
	NSLog(@"Country code %@", countryCode);
	
	// We'll default to the UK signup behaviour if we don't get a recognisable locale (we could also refuse the sign up)
	if ([countryCode compare:@"UK"] == NSOrderedSame)
		[self setLocale:LOCALE_UK];
	else if ([countryCode compare:@"US"] == NSOrderedSame)
		[self setLocale:LOCALE_US];
	else if ([countryCode compare:@"DE"] == NSOrderedSame)
		[self setLocale:LOCALE_DE];
	else
		[self setLocale:LOCALE_NONE];
}

// -------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// -------------------------------------------------------------
// When we hit return on any of the text fields we'd like them to resign the first responder
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

// -------------------------------------------------------------
// If we tap anywhere other than in a control, we'll close any edit object
- (IBAction)tapEmpty:(id)sender
{
	[self.view endEditing:YES];
}

// -------------------------------------------------------------

- (IBAction)touchedDatePicker:(id)sender {
	[self.view endEditing:YES];
}

// -------------------------------------------------------------
// Action associated with the "Continue" button on the first page of the app
// We want to validate the data entered before progressing to the next step
- (IBAction)ContinueToPage2:(id)sender {
	
	// Validate each textfield for empty fields
	if ([[self.txtFirstName text] isEqualToString:@""])
	{
		[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Incomplete Form", nil)
									message:NSLocalizedString(@"Please enter your first name", nil)
								   delegate:nil
						  cancelButtonTitle:NSLocalizedString(@"OK", nil)
						  otherButtonTitles:nil]
		 show];
		return;
	}
	
	if ([[self.txtLastName text] isEqualToString:@""])
	{
		[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Incomplete Form", nil)
									message:NSLocalizedString(@"Please enter your last name", nil)
								   delegate:nil
						  cancelButtonTitle:NSLocalizedString(@"OK", nil)
						  otherButtonTitles:nil]
		 show];
		return;
	}
	
	// For the user's email, we also want to check that the text provided is in the form of an email address
	if ([[self.txtEmail text] isEqualToString:@""] || ![self validateEmail:[self.txtEmail text]])
	{
		[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Incomplete Form", nil)
									message:NSLocalizedString(@"Please enter a valid email address", nil)
								   delegate:nil
						  cancelButtonTitle:NSLocalizedString(@"OK", nil)
						  otherButtonTitles:nil]
		 show];
		return;
	}
	
	// Make sure we have a password
	if ([[self.txtPassword text] isEqualToString:@""])
	{
		[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Incomplete Form", nil)
									message:NSLocalizedString(@"Please enter a password", nil)
								   delegate:nil
						  cancelButtonTitle:NSLocalizedString(@"OK", nil)
						  otherButtonTitles:nil]
		 show];
		return;
	}

	// Copy all the data gathered so far into an NSDictionary for later passing to the server
	
	
	// Here we manually switch which view we want to display next by checking the locale
	// We'll default to the UK signup behaviour if we don't have a recognisable locale (we could also refuse the sign up)
	NSString* segue = @"UK_SignUp";
	if (self.locale == LOCALE_US)
		segue = @"US_SignUp";
	else if (self.locale == LOCALE_DE)
		segue = @"DE_SignUp";
	
	// DEBUG: For the moment this will crash on iPad since the segues are undefined, so we prevent it
	if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
		[self performSegueWithIdentifier:segue sender:self];
}

// --------------------------------------------------------------------------
// Use Regex to validate the formating of the email entered
//
// Returns NO if the email address appears invalid, YES if the address appears to be valid

-(BOOL) validateEmail:(NSString*)emailString {
	// This is not the best ever regex for checking email formatting, but we're just trying to pick up user error rather than policing what they're providing us, so it is a good compromise
    NSString *regExPattern = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
	
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
	
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
	
    return (regExMatches == 0) ? NO : YES;
}


@end
