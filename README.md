# reddit-posts
> Shows a paginated reddit posts

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![codebeat-badge][codebeat-image]][codebeat-url]

Reddit Posts it's a simple Reddit client that shows the top 50 entries from [Reddit] - www.reddit.com/top

## Installation & run

After you clone this repository just open the file `RedditPosts.xcodeproj` to see full code. With the Xcode ready to build and run, click on the play button, or using the shortcut `cmd + R`.

## Application Design

This section lists the main project's code design. The pattern chosen to be used in the project were SOLID, with some adaptation for Swift.

#### Code design

Below it's listed the layers of every application's module:
- Networking
- Data
- Services (business rules)
- UI

Each feature of the application contains the folder structure listed above.

The same code design it's set to Tests project.