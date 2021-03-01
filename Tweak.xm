#define PLIST_PATH @"/var/mobile/Library/Preferences/com.gilshahar7.pearlretryprefs.plist"


@interface SBUIBiometricResource : NSObject
+ (id)sharedInstance;
- (void)noteScreenDidTurnOff;
- (void)noteScreenWillTurnOn;
@end

float delay = 0;

static void loadPrefs() {
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
	delay = [[prefs objectForKey:@"delay"] floatValue];
}

%hook SBDashBoardPearlUnlockBehavior
-(void)_handlePearlFailure{
	%orig;
	[[%c(SBUIBiometricResource) sharedInstance] noteScreenDidTurnOff];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[[%c(SBUIBiometricResource) sharedInstance] noteScreenWillTurnOn];
	});
}
%end


%ctor{
	loadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.gilshahar7.pearlretryprefs.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);


}
