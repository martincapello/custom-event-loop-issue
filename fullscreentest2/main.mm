//
// Custom event loop (failing) example
//

#include <Cocoa/Cocoa.h>

bool running = true;

@interface MyApplication : NSApplication
- (void)myrun;
- (void)sendEvent:(NSEvent *)event;
@end

@implementation MyApplication
- (void)myrun
{
    [self finishLaunching];

    do {
        @autoreleasepool {
            NSEvent* event = [self nextEventMatchingMask:NSEventMaskAny
                                     untilDate:[NSDate distantFuture]
                                        inMode:NSDefaultRunLoopMode
                                       dequeue:YES];
     
            if (event) {
                [self sendEvent:event];
            }
        }
    } while (running);
}

- (void)sendEvent:(NSEvent *)event
{
    NSString* wins = @"";
    for (id w in self.windows) {
        unsigned long sm = [w styleMask];
        NSString* n = [[NSString alloc] initWithFormat: @"%ld:%ld ", [w windowNumber], sm];
        wins = [wins stringByAppendingString:n];
    }

    if (event.type == NSEventTypeMouseMoved) {
        NSLog(@"n: %ld, x: %1.0f, y: %1.0f, type: %d, wins: %@", (long)event.windowNumber, event.locationInWindow.x, event.locationInWindow.y, event.type, wins);
    }
    else {
        NSLog(@"n: %ld, type: %d, wins: %@", (long)event.windowNumber, event.type, wins);

    }
  [super sendEvent:event];
}
@end

@interface MyWindowDelegate : NSObject
- (BOOL)windowShouldClose:(NSWindow*)sender;
@end

@implementation MyWindowDelegate
- (BOOL)windowShouldClose:(NSWindow*)sender
{
    running = false;
    return true;
}
@end

@interface MyView : NSView
@property NSPoint pos;

- (void)mouseMoved:(NSEvent*)event;
- (void)drawRect:(NSRect)dirtyRect;
@end

@implementation MyView
- (void)mouseMoved:(NSEvent*)event
{
    self.pos = event.locationInWindow;
    
    [super mouseMoved:event];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    @autoreleasepool {
        //note we are using the convenience method, so we don't need to autorelease the object
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:26], NSFontAttributeName,[NSColor blackColor], NSForegroundColorAttributeName, nil];
        
        NSString *pos = [NSString stringWithFormat:@"x: %1.2f, y: %1.2f",
                                                       self.pos.x, self.pos.y];
        
        NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:pos attributes: attributes];
                
        int posy = [self frame].size.height - [currentText size].height;
        
        [currentText drawAtPoint:NSMakePoint(0, posy)];
    }
}
@end

int main(int argc, const char * argv[]) {
    MyApplication* app = MyApplication.sharedApplication;
    app.ActivationPolicy = NSApplicationActivationPolicyRegular;
     
    NSWindow* win = [NSWindow alloc];
    win.acceptsMouseMovedEvents = true;
        
    NSScreen* nsScreen = [NSScreen mainScreen];
    NSWindowStyleMask style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
    NSRect contentRect = NSMakeRect(0, 0, 400, 300);
    win = [win initWithContentRect:contentRect
                               styleMask:style
                                 backing:NSBackingStoreBuffered
                                   defer:NO
                                  screen:nsScreen];
    

    MyView* view = [[MyView alloc] initWithFrame:contentRect];
    [view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                                options:NSTrackingMouseMoved | NSTrackingInVisibleRect | NSTrackingActiveAlways
                                                                  owner:view
                                                               userInfo:nil];
    [view addTrackingArea:trackingArea];

    id delegate = [MyWindowDelegate alloc];
    
    [win setDelegate: delegate];

    [win setContentView: view];
    
    [win center];
    
    [win makeKeyAndOrderFront:win];
            
    [app myrun];  // Why this doesn't work well in fullscreen mode?
    
    //[app run];  // If this line is used instead of the previous, it works as expected.

    
    return 0;
}
