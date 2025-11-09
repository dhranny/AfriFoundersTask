# AfriFounders Flutter Developer Task
## Design Decisions
### Provider for state management
I chose Provider for state management because 
it simplifies the boilerplate of writing inherited 
widget without also being worried about the extra blot
that riverpod brings with it. Provider is the perfect 
an app of this size. That is why i chose it.

### Hive for storage
The task suggests hive or sharedpreferences for state management.
Hive is the better choice here because sharedpreferences 
is not designed to store heavy user data. As the name suggests,
sharedpreference is to store the preferences or setting of the
user. 

## Architecture
* MVVM Pattern: Separation of UI and business logic
* Custom Widgets: Reusable TaskItem component for clean code
* Provider Pattern: Centralized state management
* Single Responsibility: Each class has one clear purpose

## Tools and Languages Used
* Flutter
* Dart
* Yaml
* Hive
* Provider
* GoogleFonts
