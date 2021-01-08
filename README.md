# reddit
Simple Reddit client that shows the top 50 entries from  [Reddit](www.reddit.com/top)

### Pre requisites:
- XCode 12.0
- Swift 5.0

## Guidelines

    - Assume the latest platform and use Swift
    - Use UITableView / UICollectionView to arrange the data.
    - Please refrain from using any dependency manager [cocoapods / carthage / etc], instead, use URLSession 
    - Support all Device Orientation
    - Support all Devices screen (iPhone/iPad)
    - Use Storyboards

## What to show
The app should be able to show data from each entry such as:

    - Title (at its full length, so take this into account when sizing your cells)
    - Author
    - entry date, following a format like “x hours ago” 
    - A thumbnail for those who have a picture.
    - Number of comments
    - Unread status

In addition, for those having a picture (besides the thumbnail), please allow the user to tap on the thumbnail to be sent to the full sized picture. You don’t have to implement the IMGUR API, so just opening the URL would be OK.

## What to Include

    - Pull to Refresh
    - Pagination support
    - Saving pictures in the picture gallery
    - App state-preservation/restoration
    - Indicator of unread/read post (updated status, after post it’s selected)
    - Dismiss Post Button (remove the cell from list. Animations required)
    - Dismiss All Button (remove all posts. Animations required)
    - Support split layout (left side: all posts / right side: detail post)

## Resources

    - [Reddit API](http://www.reddit.com/dev/api)
    - [Apigee](https://apigee.com/console/reddit)
    - Example JSON file (top.json) is listed.
    - Example Video of functionality is attached
    
## Comments
    - Pattern used: MVP.
    - LocalStorage: The post state is saved in the local storage by using UserDefaults (just saving ids) due to time limitations. This method is not intended for saving big amount of data that is read frecuently because each time it reads/writes the whole file, so it isn't efficient.
    The ideal would be to use another type of storage like CoreData, realm, etc for saving the post states, and even better to save the post objets to support offline mode.
    - Localized strings pending.

