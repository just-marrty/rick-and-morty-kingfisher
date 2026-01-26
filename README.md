# Rick and Morty Character Browser

A SwiftUI application for browsing characters from the Rick and Morty universe with paginated navigation, cached image loading, and interactive character details. Built to demonstrate modern Swift concurrency, MVVM architecture, and efficient image caching using Kingfisher.

## Features

- Browse 20 characters per page from the Rick and Morty API
- Paginated navigation with Next/Previous page buttons
- Character detail view with status, species, type, and gender information
- Real-time image caching using Kingfisher for smooth scrolling
- Offline image persistence - images remain cached across app restarts
- Smooth fade-in/out animations during page transitions
- Automatic scroll-to-top on page change
- Loading states and error handling with user-friendly messages
- Refresh functionality to reload first page of characters
- Responsive 2-column grid layout
- Clean and modern UI with SwiftUI
- Dark mode UI with custom styling

## Architecture

The project demonstrates modern SwiftUI patterns and MVVM architecture with protocol-based dependency injection:

### Protocols

**FetchServiceProtocol** - Protocol defining character list fetching interface

- Enables dependency injection and testability
- Single method: `fetchResults()` returning `ResultWrapper` with first page
- Allows easy mocking for previews and unit tests
- Used for initial character loading

**PageServiceProtocol** - Protocol defining pagination interface

- Handles fetching specific pages using URL
- Single method: `fetchPage(url:)` returning `ResultWrapper`
- Separates pagination logic from initial data fetching
- Enables independent testing of pagination functionality

### Model

**ResultWrapper** - Decodable model representing API response structure

- Contains `info` (pagination metadata) and `results` (character array)
- Conforms to `Decodable` for JSON parsing
- Root structure for all API responses

**ResultWrapper.WrapperInfo** - Nested struct for pagination information

- Properties: `next` and `prev` (optional String URLs)
- Used for navigating between pages
- Provides URLs for next and previous page requests
- Conforms to `Decodable`

**ResultWrapper.Results** - Nested struct representing character data

- Properties: `id`, `name`, `status`, `species`, `type`, `gender`, `image`
- All properties use appropriate types (Int, String, String?)
- `type` and `image` are optional to handle missing values gracefully
- Conforms to `Identifiable`, `Decodable`, and `Hashable` for SwiftUI list operations

**NetworkError** - Custom error enum for network operations

- Cases: `invalidURL`, `badResponse`, `httpFail(Int)`, `decodingFail`
- HTTP status code passed as associated value in `httpFail`
- Provides specific error types for different failure scenarios
- Used across all service layer implementations

### Constants

**Strings** - Centralized UI string constants

- Organizes all UI strings, error messages, and system image names
- Categorized sections:
  - Error Messages (load results, next page, prev page)
  - Error showing (oups, try again)
  - ResultDetailView labels (status, species, type, gender)
  - Navigation Title and Subtitle
  - System Images (chevron.left, chevron.right, arrow.clockwise, exclamationmark.triangle)
  - Fallbacks (N/A, No type)
- Improves code maintainability and makes future localization easier
- Eliminates hardcoded strings throughout the codebase
- Used across all views and view models for consistent text display

**API** - API configuration constants

- Enum-based organization for type safety
- Stores base URL: `https://rickandmortyapi.com/api`
- Nested `Endpoints` enum with endpoint paths
- Separates network configuration from business logic
- Single source of truth for API endpoints

### Service

**FetchService** - Handles character list fetching from Rick and Morty API

- Implements `FetchServiceProtocol` for dependency injection
- Constructs URL from `API.baseURL` and `API.Endpoints.character`
- Method: `fetchResults()` - Loads first page of characters
- Uses `URLSession` with async/await for network requests
- Custom error handling with `NetworkError` enum
- Returns complete `ResultWrapper` including pagination info
- Validates HTTP response status codes (200-299 range)
- Uses `JSONDecoder` for automatic JSON parsing

**PageService** - Handles pagination requests

- Implements `PageServiceProtocol` for dependency injection
- Method: `fetchPage(url:)` - Loads specific page using provided URL
- Validates URL parameter (throws `invalidURL` if nil)
- Uses `URLSession` with async/await
- Same error handling pattern as `FetchService`
- Returns `ResultWrapper` with page-specific data and updated pagination info

### ViewModel

**ResultsListViewModel** - Manages character list state and pagination logic

- Uses `@Observable` macro for reactive UI updates
- `@MainActor` for thread-safe UI updates
- Protocol-based dependency injection (receives `FetchServiceProtocol` and `PageServiceProtocol`)
- Maps `ResultWrapper.Results` to `ResultsViewModel` for presentation
- Loading and error state management with specific error messages per operation

**Properties:**
- `results` - Array of `ResultsViewModel` for display
- `wrapperInfo` - `WrapperInfoViewModel` with pagination URLs
- `isLoading` - Boolean loading state indicator
- `errorMessage` - Optional String for error display
- `showContent` - Boolean controlling fade animations

**Methods:**
- `loadResults()` - Loads first page using `FetchServiceProtocol`
- `loadNextPage()` - Loads next page using `PageServiceProtocol` with race condition protection
- `loadPrevPage()` - Loads previous page using `PageServiceProtocol` with race condition protection
- Race condition protection: `guard let URL, !isLoading else { return }` prevents multiple simultaneous requests
- All load methods update both `results` and `wrapperInfo` after successful fetch
- Error handling sets `errorMessage` with operation-specific text from `Strings`

**ResultsViewModel** - Presentation model wrapping ResultWrapper.Results

- Wraps `ResultWrapper.Results` with computed properties
- Conforms to `Identifiable` and `Hashable` for SwiftUI list support
- Provides computed properties for view display: `id`, `name`, `status`, `species`, `type`, `gender`, `image`
- Converts image `String` to `URL?` for easy consumption
- Handles optional `type` property with default value from `Strings.noType`
- Separates domain model from presentation concerns

**WrapperInfoViewModel** - Presentation model for pagination metadata

- Wraps `ResultWrapper.WrapperInfo`
- Converts `next` and `prev` Strings to `URL?` for type safety
- Used by navigation buttons to determine enabled/disabled state
- Simplifies URL handling in views

### Views

**MainResultView** - Main container with character grid and pagination controls

- Implements custom initializer with protocol-based dependency injection
- Default `FetchService` and `PageService` with ability to inject mock services for testing
- `NavigationStack` for navigation hierarchy
- `LazyVGrid` with 2 flexible columns for efficient character display
- Loading, error, and content states with appropriate UI
- Error state displays custom UI: warning icon from `Strings`, "Oups" message, error description, retry button
- Uses `Kingfisher` `KFImage` for cached image loading with custom `rm404` placeholder

**Toolbar buttons:**
- Refresh (top-left) - reloads first page with animation
- Previous page (top-right) - loads prev page
- Next page (top-right) - loads next page

**Features:**
- State-based button disabling when no prev/next page available (`wrapperInfo?.prev/next == nil`)
- Loading state disables pagination buttons to prevent race conditions
- Smooth fade animations using `showContent` state and `withAnimation`
- Sequential animation timing with `Task.sleep` for smooth transitions
- Auto scroll-to-top on page change using `.id(results.first?.id)` modifier
- Navigation to character detail view via `NavigationLink`
- Navigation title and subtitle from `Strings`
- Fixed dark mode color scheme
- All UI strings sourced from `Strings`
- Includes multiple SwiftUI previews with mock services for different states

**ResultDetialView** - Detailed view for individual character information

- Accepts `ResultsViewModel` via initializer
- Displays character image using Kingfisher `KFImage`
- Custom placeholder and failure image (`rm404`) for missing images
- Shows character details using labels from `Strings`: Status, Species, Type, Gender
- Custom styling with rounded system font design
- Navigation title displays character name
- Inline navigation bar title display mode
- Clean layout with consistent spacing
- Dark mode support
- All labels use `Strings` constants

### Extensions

**ResultsViewModel+Extensions** - Sample data for SwiftUI previews

- Provides static sample character data for development and testing
- Used in SwiftUI previews for `ResultDetialView`
- Includes realistic sample data with complete character information

**Preview Mock Services** - Test implementations for SwiftUI previews

**MockService (FetchServiceProtocol)** - Used in "Mock Data" preview
- Returns single `ResultWrapper` with sample character data
- Includes properly structured `info` and `results` array
- Demonstrates successful data loading state

**ErrorService (FetchServiceProtocol)** - Used in "Fetch Results: Status Code Error" preview
- Throws `NetworkError.httpFail(404)` to simulate API failure
- Tests error handling for initial character loading
- Displays error UI with retry functionality

**ErrorService (PageServiceProtocol)** - Used in "Fetch Page: Status Code Error" preview
- Throws `NetworkError.httpFail(404)` for pagination requests
- Tests error handling specifically for page navigation
- Allows independent testing of pagination error states

## Dependency Injection

The project uses protocol-based constructor dependency injection:

- Services defined via protocols (`FetchServiceProtocol`, `PageServiceProtocol`)
- `ResultsListViewModel` receives services through its initializer
- `MainResultView` implements custom initializer with default implementations
- Allows easy testing and swapping implementations
- Mock services can be injected for SwiftUI previews and unit tests
- Promotes loose coupling and testability
- Multiple preview configurations demonstrate different mock implementations
- Separation of concerns between fetching initial data and pagination

## State Management

- `@State` for local view state (ViewModel instance, animation flags)
- `@Observable` macro for reactive ViewModel updates
- `@MainActor` ensures all UI updates happen on main thread
- State-based animation control with boolean flags
- Complex multi-step animations coordinated through async Tasks
- Button states tied to pagination info and loading state
- Race condition protection in pagination methods

## Image Caching Strategy

### Kingfisher Integration

Used via `KFImage` view instead of standard `AsyncImage` for superior caching:

**Two-tier automatic caching:**
1. **Memory cache** - Fast access during app session
2. **Disk cache** - Persistence across app restarts

**Default behavior (no configuration needed):**
- Images automatically cached on first load
- Subsequent views load instantly from cache
- Cache persists even after device restart

**Benefits:**
- Eliminates flickering during page navigation
- Smooth scrolling experience
- Reduced API calls and data usage
- Better UX with instant image loading
- Fallback handling with custom `rm404` placeholder image

## Technologies

- **SwiftUI** - Modern declarative UI framework
- **Async/Await** - Modern Swift concurrency for networking
- **URLSession** - HTTP networking for API communication
- **NavigationStack** - Navigation hierarchy management
- **LazyVGrid** - Efficient grid layout with lazy loading
- **Kingfisher** - Advanced image downloading and caching library
- **@Observable** - Macro-based reactive state management
- **@MainActor** - Thread-safe UI updates
- **Dependency Injection** - Protocol-based DI for testability
- **JSON Decoding** - `Codable` with custom error handling
- **Animations** - Smooth transitions with `withAnimation` and opacity
- **Task** - Async sequential animations with sleep delays
- **Constants Pattern** - Centralized string and API configuration management
- **Protocol-Oriented Programming** - Protocols for abstraction and testability

## Requirements

- iOS 26.0+
- Xcode 26.0+
- Swift 6+
- Internet connection required for initial character loading

## API

This app uses the [Rick and Morty API](https://rickandmortyapi.com/documentation):
- Endpoint: `https://rickandmortyapi.com/api/character`
- Free to use, no authentication required
- Returns paginated character data

## Credits

**Kingfisher** - A powerful, pure-Swift library for downloading and caching images from the web.
- GitHub: [onevcat/Kingfisher](https://github.com/onevcat/Kingfisher)
- Used for efficient image caching with disk persistence

## License

This project is for educational purposes.

Rick and Morty API and characters are property of their respective owners.
