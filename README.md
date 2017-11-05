Rails tutorial sample application
---

Overview

## Description
This app is based on Rails tutorial Japanese version. And its tests based on minitest are replaced with ones based on RSpec with Capybara.

## Requirements
Sqlite and ImageMagick have to be installed.

```
sudo apt-get install libsqlite3-dev

sudo apt-get install imagemagick --fix-missing
```

## Preparation

```
bundle install
bundle exec rails db:migrate
```

If you need data, execute the following command.
```
bundle exec rails db:seed
```


## Extensions
In addition to the rails tutorial, the following extensions are added.

You can use the example user( email:example@railstutorial.org, password:foobar ) to see the following extensions

### Reply
If you addes "@{name}" to the first line of micropost, you can reply to the specific user whome {name} indicates. Then, the reply in itself must start at the second line.

Replies can be seen on home page.

Replies can be seen only by the sender and the receiver.

### Messages
You can send the messages to the specific user who you're mutually following.

Messages can be seen on messages page, which you can go to by clicking the Messages link of the Account in the header.

### Notification
The receiver as follows will be received notification. The one which has been presented at least one time won't be presented again.

- following
- message
- reply

Notifications can be seen on home page.
