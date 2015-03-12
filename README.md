# Inneract app

## About Inneract
*  Who we are: 
Our mission is to increase underserved students’ access to design, through free design education, resources and new career opportunities. We believe that by surfacing pathways to the field of design and providing professional mentorship, we can boost student success, ultimately leading to an increase in diversity in design and technology. To achieve this, we engage practicing designers and other professionals to teach students about their respective disciplines. 
* We need an app to…
 Allow our team to communicate with volunteers, parents and the gener lnneract Project
* Why this app will make a meaningful impact for us: 
An app would drastically simplify communication directly from our organization to our stakeholders. It would strengthen and increase our network and helps our team work more efficiently by providing a simple solution to managing interested volunteers and parents. 
* App Audience: 
   * Volunteers 
   * Parents 
* App Main Functions (in order of priority): 
   * Connect volunteers to teaching opportunities   
   * Connect parents to current/future classes for youth 
   * Display the latest IP news or social events 
   * Signup forms (classes and volunteer opportunities) 
   * Search 
   * Online payment
   
## Group Milestones
- [x] __Milestone 1 (due March 4):  Wireframes complete.__  
    These don't have to be visually polished, but they have to be "use case" complete. They should cover new user and existing user states. Don't use lorem ipsum text, it should be detailed enough to derive the app schema based on the wireframes.
- [X] __Milestone 2: (due March 11): Basic functionality complete.__
   Models implemented, backed by Parse. Can achieve the use cases. May be visually simple using stock controls and navigation.
- [ ] __Milestone 3: (due March 18): Iteration sprint.__
   Start adding visual polish, augment and basic user stories with additional features.
- [ ] __Milestone 4: (due March 25): Polish sprint. __
   Add final visual polish, add any bells and whistles (custom transitions, WatchKit integration, Push notification, etc).

### Walkthrough
![Demo](inneract-demo.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

### Main Features
- [x] people list, profile details, editing profile
- [x] login/out, join, create account, login with facebook
- [x] feeds, feeds details, search, share and bookmark
- [ ] form/payments (deferred as initial design is not mobile friendly (thinking of leveraging typeform)


### scenarios:


- [x] User can sign up and creates an account​ 
- [x] User can log in with IP login
  - [x] and go to feeds page (ip news feeds) upon success​
- [x] User can log in with FB
  - [ ] and go to feeds page (ip news feeds) upon success​
- [x]  User can browse "IpNews" "feeds". Click to show details view with media (video, text, images​, buttons​)
  - [ ] media and photo gallery support
  - [ ] support for highlighted feed (different cell)
- [x] User can search feeds/volunteer/classes/profiles
  - [ ] support for "no matching feed found" (different cell)
  - [ ] support for global search (on all fields, not only title)
- [x] User, typically a volunteer, can browse "Volunteer" news from "feeds" 
  - [x] User can click to show details view, 
  - [ ] User can apply after filling a form​
- [x] User, typically a parent, can browse "Class" news from "feeds". 
  - [x] User can click to show details view, 
  - [ ] User can apply after filling a form​
  - [ ] User can pay 
- [ ] class, volunteer feeds can be shared 
- [ ]  class, volunteer feeds can be bookmarked. 
- [x] User can view her profile,  edit it, and logs out​ 
- [x] User can browse people list, click to view details (same as profile but non editable)​


### Refinements to be added
- [ ] support for highlighted feeds with different rendering, paralax
- [ ] global search
- [ ] support for media (videos, gallery)
- [ ] support for user "badge" (ex: gold/silver/bronze user)
- [ ] use official colors/icons/rendering from Inneract
- [ ] better layout/look and feel (use Maurice colors and icons too).
- [ ] do not hide view when loading data
- [ ] filter existing data for volunteer and classes (do not make again a network call)
- [ ] 40x40 for share and book mark button, change state for share and bookmark buttons when chosen

Credits
---------
* [Facebook API](https://developers.facebook.com/)
* [Parse API] (https://www.parse.com/docs/ios_guide)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [SVProgressHUD](https://github.com/TransitApp/SVProgressHUD)

## Q&A
- What are the target devices?
   for the moment, app is for iPhone only
- Where are the assets?
   Go to google docs to find assets or dropbox link provided by Maurice. Must eventually import them in the app.
- Which apps should this app be benchmarked against?
   - For News feed: Facebook Paper app, Yahoo News digest, Tumblr
   - For Form: TypeForm
   - For payment: Paypal
-  Where can we access the back-end data
   - Back-end is hosted on Parse, including some assets such as the profile images, go to: https://www.parse.com/apps/ipios
   - Other media: video, photos gallery will be located on some CDNs
   - Full profile, articles will be available on the web sites

  



