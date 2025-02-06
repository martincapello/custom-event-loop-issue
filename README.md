# custom-event-loop-issue
This is a branch of an example project used to demonstrate an issue when implementing a
custom event loop in Objective-C.

In this branch the issue is fixed.

The issue was about events being lost when the following conditions are met:
- Window is in full screen mode.
- Mouse pointer is moved in an upward direction.

When a certain area at the top of the windows was reached, the mouseMove events
were not received any more by the main window.

Here is a video of this:

https://github.com/user-attachments/assets/d3462ffc-7632-4f03-9cd4-ea6be23b5b51
