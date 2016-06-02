#import "UIControlEvent.h"


@implementation UIControlEventHandler

- (void) action:(id)sender forEvent:(UIEvent *)event
{
	[self callback](sender, event);
}

@end