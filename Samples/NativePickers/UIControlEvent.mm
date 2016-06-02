#import "UIControlEvent.h"


@implementation UIControlEventProxy

- (void) action:(id)sender forEvent:(UIEvent *)event
{
	[self callback](sender, event);
}

@end