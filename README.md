# StudySpot 📚
 
**Find study groups that are actually happening on campus, right now.**
 
Ever wanted to study with other people in your class but had no idea if a group was meeting today, or showed up somewhere only to find nobody there? StudySpot fixes that. It's a mobile app that shows you live study groups near you and lets organizers prove their group is really meeting.
 
Built by **Jesse Ortiz** for CSCI 567.
 
---
 
## How it works
 
1. **Post a group.** Pick your class, choose a real spot on campus (a study room, a library floor, etc.), and set a time.
2. **Find a group.** Search by class or browse groups nearby, sorted by how far away they are.
3. **Ask to join.** Send a join request to the organizer.
4. **Check in.** When the session starts, the organizer snaps a photo from the meeting spot. The app checks that they're actually there, and the photo shows up on the post so others know the group is legit before heading over.
## Who it's for
 
Students who want to study with others but don't have an easy way to know whether an in-person group is real. StudySpot gives you live, location-aware discovery of active groups and a simple way to confirm a meeting actually happened.
 
## Features
 
- **Live feed** – Everything comes from real user activity. New posts, join requests, and check-ins show up as they happen.
- **Personalized** – The feed is filtered to your classes and sorted by distance from you.
- **Photo check-ins** – Organizers take a photo with the device camera when the session starts. It's saved to that session for everyone to see.
- **Location verification** – A check-in only counts if the organizer is actually at the posted meeting spot, which cuts down on fake or inaccurate check-ins.
- **Accounts** – Sign up and log in so your posts and requests are tied to you.
## Tech stack
 
| What | How |
|------|-----|
| Database & live sync | Cloud Firestore |
| Accounts | Firebase Authentication |
| Photos | Device camera |
| Location | Device GPS |
 
Data flows both ways: the app sends new posts, join requests, and check-ins, and receives live updates when a group's status changes.
 
## Permissions
 
StudySpot asks for permission before using:
 
- **Camera** – for check-in photos
- **Location** – for sorting nearby groups and verifying check-ins
## Getting started
 
1. Clone this repo.
2. Create a Firebase project and enable **Cloud Firestore** and **Authentication** (email/password).
3. Add your Firebase config file to the project.
4. Build and run on a device or emulator. (A real device works best for testing camera and GPS.)
## Stretch goals
 
If time allows:
 
- **Organizer history** – Show a host's past check-ins so people can build trust over time.
- **Notifications** – Opt-in alerts when a group for one of your classes starts nearby.
## Status
 
🚧 In progress. This is a semester project, so things are still being built.
 
