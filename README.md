Rails tutorial sample application
---

Overview

## Description
This app is based on Rails tutorial Japanese version. And its tests based on minitest are replaced with ones based on RSpec with Capybara.

## Extensions

### Reply
If you addes "@<name>\n" to the head of micropost, you can reply to specific user whome <name> indicates.

Reply can be seen only by sender and receiver.

### Messages
You can send the messages to the specific user who you're mutually following.

### Notification
the receiver as follows will be received notification. The one which has been presented at least one time won't be presented again.

- following
- message
- reply

### Searching
