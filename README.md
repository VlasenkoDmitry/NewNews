# NewNews

New News - an application for viewing news by API newsapi.org.  
Download current news.  
Filtering news by search keywords, category, country, sources.  
Adding and removing news from bookmarks.  

Features:  
---------------
● MVC architecture.  
● With storyboard.  
● Сustom UITableViewCell xib file includes: source, author, title, description and image with urlToImage, click opens relevant news in custom UIViewController using WKWebkit.  
● Userdefault use to save data about filters. Realm database use to store data about news in bookmarks.  
● UIRefreshControl added.  
● Added a loading cell for pagination.  

  Gif app below
  ---------------

![My gif](https://media.giphy.com/media/4Go6MamMh4213MNzsk/giphy.gif)

Getting started:  
---------------
1. Clone this repo and open the Terminal
2. In Terminal, run pod install
3. Open "NewsTestPecode.xcworkspace" through Finder
