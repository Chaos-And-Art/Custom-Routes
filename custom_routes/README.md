# custom_routes

- We want to make it possible so that people who travel often, can start instances where they can save their 
location in set intervals while traveling in their vehicle and turn their location data into an interactive map
that their fan base can interact with. This includes selecting a specific trip, and watching a preset car/truck 
travel along the route of the trip within a map view. The main interactive map will be built into a web page, but
the travels tracking their location will also be able to view their trips and set location collection in the app.

### Things to DO:
- Choose the precision of the location, (for example make it so the starting and stopping locations aren't necessarily shown, 
  but show up as a radius of the area they are in for relative privacy) This may be done easier as a little pop up to edit the first and last locations.
- Customize UI to set trips. Such as starting a trip, ending a trip. This could be integrated with Google Maps.
    - For example, make it so you can select the destination, and then based on the destination selected, the app will determine
      the countdown intervals, as well as when the trip will end. Then you don't necessarily have to worry about resetting the timer,
      if it ends early. 
    - Name the trip based on current location, and destination. (This should be shown in trip view)
    - Create view under timer that shows trip information.
- Make it so location is collected after every countdown cycle. 
- Make it so the location data is sent to a database
- Make screen show map based on selected trip
- Make it so the other screen can show the location data based on selected trip. When selecting a trip, you can edit it to remove or add
  locations, or change the precision of the location. Then when they save it, the database is updated.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
