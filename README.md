# custom-event-loop-issue
This is an example project used to demonstrate an issue when implementing a
custom event loop in Objective-C.

The issue is about events being lost when the following conditions are met:
- Window is in full screen mode.
- Mouse pointer is moved in an upward direction.

When a certain area at the top of the windows is reached, the mouseMove events
are not received any more by the main window.

Here is a video of this:

