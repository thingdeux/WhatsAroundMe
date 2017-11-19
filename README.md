#  Code Test

# Installation Notes

* I've used Cocoapods to add 2 dependencies.
    - There are various ways to install it, instructions here -> https://guides.cocoapods.org/using/getting-started.html
    - Once it is installed run 'pod install' in the root of the repo.
    - After pod install finishes - make sure to open the project using the .xcworkspace file and not xcodeproj.


# Feedback

* Yelp API is well documented and easy to consume.

* Useful and very explicit requirements about what's expected from this test.

* This test is pretty involved and deceptively simple - that is - there are lots more complexities than might be expected on the outset.
    Examples:

    - Core Location Management - properly synchronizing and handling the Core Location delegate and accounting for the fact that the user can turn
        it off at any time and the app has to react accordingly.
    - Various loading and failure states for things going wrong.
    - Lots of UI considerations with these 2 screens between device dimensions [See below]
            
* This test is heavy on UI but doesn't include explicit designs.  Things like spacing between elements, colors or assets.  I had to play a bit and find
    what feels right for each element as well as find an appropriate color pallette.  It's not technically difficult but is time-consuming - might recommend
    more concrete designs / mocks if this is a trait you're not interested in testing. I would say the majority of this test was spent doing UI work and polish.
    Not sure if that was intentional? May not be what you want? See below for timings.
            
* At minimum, one would need 4 custom UICollectionViewCells (or Tableview cells) to create both views.  The elements are *just* different enough to rule
  out being able to use standard controls or re-use cells.  I chose to sligthly alter the design for the review cells so that I didn't need to create another UICollectionViewCell
  And I could re-use the cell from the header (above the image carousel.)
  
* The task was a fun one - I'll probably keep this installed on my device for quick peaks at what's available around me.
        

# Notes

## Time Breakdown

* Total time for completing this code test (timed using Toggl) -> ~20 hours and 32 minutes
    - Yelp API Registration and Documentation Familiarization - ~45 Mins - 1 Hour
    - Creation of API Models and Consumers for Search / Businesses / Reviews - ~3 Hours and 33 mins
    - View Controller / Collection View (Cell) Architecture - ~5 Hours
    - UI Polish and Tweaks - ~8 Hours
    - Bug Squashing and QA - ~2 Hours


## Excuses

* I didn't include any Unit Tests unfortunately, would generally have done so but 18+ hours is about the max I'm able to spend on this.

## Deviations [Design]:

* I deviated from the design with the search button - it's generally better in iOS to perform actions after the user clicks search on their keyboard instead of requiring a tap on a secondary element.
* I likewise deviated from the design on the "Detail" (or expanded result) view.
    - I gave the image carousel more of a mobile feel - generally the < > arrows on either side is a web convention.
    - This approach also allows for the user to lazily swipe between images instead of focusing on the arrow and slowly chunking through.
