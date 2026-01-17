# Rick and Morty

A SwiftUI application for browsing characters from the Rick and Morty universe with paginated navigation, cached image loading for smooth scrolling, and interactive character details. Built to explore efficient asynchronous image loading using Kingfisher for clean UX without constant reloading.

## Features
- Browse 20 characters per page fetched from Rick and Morty API
- Paginated navigation with Next/Previous page buttons
- Character detail view with status, species, type, and gender information
- Cached image loading using Kingfisher for smooth scrolling experience
- Offline image persistence - images remain cached after app restart
- Smooth fade-in/out animations during page transitions
- Automatic scroll-to-top on page change
- Loading states and error handling with user-friendly messages
- Responsive grid layout with 2 columns
- Dark mode UI with custom styling

## Architecture

The project demonstrates modern SwiftUI patterns and MVVM architecture:

### Model

**ResultWrapper** - Main data structure for API response
- Contains `info` (pagination metadata) and `results` (character array)
- Conforms to `Decodable` for JSON parsing

**ResultWrapper.WrapperInfo** - Pagination information
- Properties: `next` and `prev` (optional String URLs)
- Used for navigating between pages

**ResultWrapper.Results** - Character data model
- Properties: `id`, `name`, `status`, `species`, `type`, `gender`, `image`
- Conforms to `Identifiable`, `Decodable`, and `Hashable`
- All properties use appropriate types (Int, String, String?)

### Service

**FetchService** - Handles all API communication
- Base URL: `https://rickandmortyapi.com/api`
- Endpoint: `/character`
- Custom error handling with `NetworkError` enum (invalidURL, badResponse, httpFail, decodingFail)
- `fetchResults()` - Loads first page of characters
- `fetchPage(url:)` - Loads specific page using provided URL
- Uses `URLSession` with async/await
- Returns complete `ResultWrapper` including pagination info

### ViewModel

**ResultsListViewModel** - Manages character list state and pagination
- Uses `@Observable` macro for reactive UI updates
- `@MainActor` for thread-safe UI updates
- Dependency injection via initializer (receives `FetchService`)
- Properties:
  - `results` - Array of `ResultsViewModel` for display
  - `wrapperInfo` - Pagination info (next/prev URLs)
  - `isLoading` - Loading state indicator
  - `errorMessage` - Optional error message
- Methods:
  - `loadResults()` - Loads first page
  - `loadNextPage()` - Loads next page from `wrapperInfo.next`
  - `loadPrevPage()` - Loads previous page from `wrapperInfo.prev`
- All load methods update both `results` and `wrapperInfo` after successful fetch

**ResultsViewModel** - Presentation layer for single character
- Wraps `ResultWrapper.Results` with computed properties
- Properties: `id`, `name`, `status`, `species`, `type`, `gender`, `image`
- Converts image String to URL for easy consumption
- Conforms to `Identifiable` and `Hashable` for SwiftUI lists

**WrapperInfoViewModel** - Presentation layer for pagination
- Wraps `ResultWrapper.WrapperInfo`
- Converts `next` and `prev` Strings to URL? for type safety
- Used by navigation buttons to determine enabled/disabled state

### Views

**MainResultView** - Main application view with character grid
- `NavigationStack` for navigation hierarchy
- `LazyVGrid` with 2 flexible columns for character display
- Dependency injection - creates `ResultsListViewModel` with `FetchService` in initializer
- Three toolbar buttons:
  - Refresh (top-left) - reloads first page
  - Previous page (top-right) - loads prev page
  - Next page (top-right) - loads next page
- State-based button disabling when no prev/next page available
- Smooth fade animations using `showContent` state and `withAnimation`
- Sequential animation timing with `Task.sleep` for smooth transitions
- Auto scroll-to-top on page change using `.id(results.first?.id)`
- Error state with custom UI (warning icon, message, retry button)
- Loading indicator during initial load
- Dark mode preferred color scheme

**ResultDetialView** - Detailed character information view
- Displays character image using Kingfisher `KFImage`
- Custom placeholder and failure image (rm404)
- Character details: Status, Species, Type, Gender
- Custom styling with rounded system font
- Navigation title displays character name
- Inline navigation bar title display mode
- Dark mode support

### Dependency Injection

The project uses constructor-based dependency injection:
- `ResultsListViewModel` receives `FetchService` through initializer
- `MainResultView` creates ViewModel with fresh `FetchService` instance
- This pattern allows for easy testing and swapping implementations
- Promotes loose coupling between views, view models, and services

### State Management
- `@State` for local view state (ViewModel instance, showContent animation flag)
- `@Observable` macro for reactive ViewModel updates
- State-based animation control with boolean flags
- Complex multi-step animations coordinated through async Tasks
- Button states tied to pagination info (enabled/disabled)

### Image Caching Strategy

**Kingfisher Integration**
- Used via `KFImage` view instead of standard `AsyncImage`
- Automatic two-tier caching:
  - Memory cache for fast access during app session
  - Disk cache for persistence across app restarts
- Default behavior (no configuration needed):
  - Images automatically cached on first load
  - Subsequent views load instantly from cache
  - Cache persists even after device restart
- Benefits:
  - Eliminates flickering during page navigation
  - Smooth scrolling experience
  - Reduced API calls and data usage
  - Better user experience with instant image loading
- Fallback handling with custom rm404 placeholder image

## Technologies
- **SwiftUI** - Modern declarative UI framework
- **Async/Await** - Asynchronous networking using modern Swift concurrency
- **URLSession** - HTTP networking for API communication
- **NavigationStack** - Navigation hierarchy management
- **LazyVGrid** - Efficient grid layout with lazy loading
- **Kingfisher** - Advanced image downloading and caching library
- **Observable** - Using @Observable macro for reactive UI updates
- **Dependency Injection** - Constructor-based DI for testability
- **JSON Decoding** - Custom Decodable implementation
- **Animation** - Smooth transitions with withAnimation and opacity
- **Task** - Async sequential animations with sleep delays

## Requirements
- iOS 26.0+
- Xcode 26.0+
- Swift 6+
- Internet connection required for initial character loading

## Credits

**Kingfisher** - A powerful, pure-Swift library for downloading and caching images from the web.  
https://github.com/onevcat/Kingfisher
