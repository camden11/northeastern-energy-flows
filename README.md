# northeastern-energy-flows
Visualization for energy usage at Northeastern University in java and processing

About
-----------------------
NortheasternEnergyFlows provides a visualization of power usage at Northeastern during 2013 and 2014. The application provides a map of buildings on Northeastern’s campus, with each building color coded to show its power usage at the current time. Specific data on each building can also be viewed, and users also have the ability to view data at different times between December 2013 and 2014.

Current Functionality
-----------------------
- Display of relative power usage of each building (colors)
- Display of exact power usage of each data site
- Panning and zooming
- Time changing
- Precise time changing

User Interface
-----------------------
The UI is composed of three components: the building view, data window, and time bar
- Building view: shows a map of Northeastern and the relative power usage of each building on campus that data exists for at the current time. Green buildings are using low amounts of power, whereas red buildings are using the most amount of power. Grey buildings have no recorded energy data at the current time. The building view can be panned around, and zoomed in and out. For buildings with more than one data site, the building’s color represents the total amount of power recorded at each data site. Hovering on a building gives more information on that building in the data window
- Data window: shows more specific information on a building when that building is hovered over in the building view. Currently, this includes the building’s name, the codes of each of its data sites (if it has more than one), and the power levels at each data site in kilowatts.
- Time bar: shows, relatively the current location in time, and allows for changes in the current time. The circle on the time bar can be dragged for large changes in time, and the arrow keys can be used to make smaller, more precise changes in time.

Controls
-----------------------
- SHIFT + left click  + drag: zoom in and out
- SHIFT + left and right click + drag: pan
- mouse: select building
- left arrow key: decrement current time 15 minutes
- right arrow key: increment current time 15 minutes

Planned Future Functionality
------------------------
- Play and pause buttons for time
- Filter buildings by type
- View power by watts per square foot

Used Libraries
------------------------
Used Libraries
giCentre zoom http://www.gicentre.net/utils/zoom/
