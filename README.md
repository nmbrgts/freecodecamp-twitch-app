Twitch Streamer List
-

This single page app lets users keep track of streamers on twitchtv. I put this together as my solution for the freeCodeCamp challenge, Use the Twitchtv JSON API.

### User Stories

As part of the challange the app must fulfill these user stories:
  - The user can see whether or not a streamer is current streaming on Twitch.tv
  - Users can click the status output and be sent directly to the streamer's channel
  - Users can see additional details about streamers that are streaming

In addition to fulfilling these user stories, users may also:
  - Filter the list for online and offline streamers
  - Add and remove streamers from the list
  - Change the order of streamers in the list

Edits made by users are cached locally and are persistant between sessions.

### Tools Used

The majority of this app is written in Elm. Elm is a pleasant, staticly typed functional language, I encourage you to read more about it [here](http://elm-lang.org). The layout of the app was developed using the Style Elements Library.

Local caching for the app is acheived using the LocalStorage API. This API is not yet avaialable in Elm, so the code that handles local storage management is written in TypeScript. The Elm app accesses this through a language featuer called Ports.

The caching strategy works something like this:
  - The cache contains a list of streamers names
  - The app maintains a data model that includes this list and as well as other information about the streamers obtained from http requests
  - If a user makes a change to their list of streamers (i.e. adding, deleting or rearranging their list) the cache is udpated to reflect these changes
  - When the app first starts, it attemps to get the cached list. If the cache doesn't exist, it will start the user with a default list of streamers.

### Further Improvements

Some ideas that I have to further improve this app:
  - Move more of the data model into the cache. This would make the initial loading of the app smoother.
  - Reduce the interfaces between Elm and JS using the methods described in Murphy Randal's ElmConf talk, [The Importance of Ports](https://www.youtube.com/watch?v=P3pL85n9_5s)
  - Currently the app banks heavily on user intuition. A solution to this might be mouse over instructions.
  - Drag and drop for rearranging streamers (though I am not very sure how this would be done)
  - Animations on transitions to make the intferace feel less jarring
