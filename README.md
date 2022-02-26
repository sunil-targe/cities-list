# cities-list

### Date: 26 Feb 2022 📅

### Description
- Native iOS App that allows to fetch 200k+ cities and filter the results by a given prefix string.
- Fetaching the list of cities from [here](https://raw.githubusercontent.com/SiriusiOS/ios-assignment/main/cities.json).

### Architecture 🛠
 - Used MVVM architecture with UIKit design
 - Used closures to perform binding between View and ViewModel 
 - Used "if let, guard let" to manage optionals and I avoided force unwraping throughout the app
 - Network error handling using system config. reachability class  
 - Validate API, functions and the interface using Unit test cases and UI test cases

### Why I used MVVM?
because it's typically easier for small project 

### Language 👾
- Swift

### Deployement info 📲
- Minimum deployement iOS version is 13.1
- Supported devices: iPhone, iPad and iPod
- Supported orientations: Both portraint and landscape 

### NOTES 📝
- I really care about the user interface and I always keep this on top in my every app architecture. So in this short time, I tried to bring better possible app design with clean code architecture.

