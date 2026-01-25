# Rick and Morty Character Browser

A SwiftUI application for browsing characters from the Rick and Morty universe with paginated navigation, cached image loading, and interactive character details. Built to demonstrate modern Swift concurrency, MVVM architecture, and efficient image caching using Kingfisher.

## Features

- Browse 20 characters per page from the [Rick and Morty API](https://rickandmortyapi.com)
- Paginated navigation with Next/Previous page buttons
- Character detail view with status, species, type, and gender
- Cached image loading using Kingfisher for smooth scrolling
- Offline image persistence - images cached across app restarts
- Smooth fade-in/out animations during page transitions
- Automatic scroll-to-top on page change
- Loading states and error handling with user-friendly messages
- Responsive 2-column grid layout
- Dark mode UI with custom styling

## Architecture

The project follows **MVVM (Model-View-ViewModel)** architecture with protocol-oriented design and dependency injection.

### Model

**`ResultWrapper`** - Main data structure for API response
- Contains `info` (pagination metadata) and `results` (character array)
- Conforms to `Decodable` for JSON parsing

**`ResultWrapper.WrapperInfo`** - Pagination information
- Properties: `next` and `prev` (optional String URLs)
- Used for navigating between pages

**`ResultWrapper.Results`** - Character data model
- Properties: `id`, `name`, `status`, `species`, `type`, `gender`, `image`
- Conforms to `Identifiable`, `Decodable`, and `Hashable`

### Service Layer

**`FetchService`** - Handles character list fetching
- Implements `FetchServiceProtocol`
- Base URL: `https://rickandmortyapi.com/api/character`
- Method: `fetchResults()` - Loads first page of characters
- Uses `URLSession` with `async/await`
- Returns complete `ResultWrapper` including pagination info

**`PageService`** - Handles pagination requests
- Implements `PageServiceProtocol`
- Method: `fetchPage(url:)` - Loads specific page using provided URL
- Custom error handling with `NetworkError` enum
- Uses `URLSession` with `async/await`

**`NetworkError`** - Custom error enum
- Cases: `invalidURL`, `badResponse`, `httpFail(Int)`, `decodingFail`

### ViewModel

**`ResultsListViewModel`** - Manages character list state and pagination
- Uses `@Observable` macro for reactive UI updates
- Marked with `@MainActor` for thread-safe UI updates
- Dependency injection via initializer (receives `FetchServiceProtocol` and `PageServiceProtocol`)

**Properties:**
- `results` - Array of `ResultsViewModel` for display
- `wrapperInfo` - Pagination info (next/prev URLs)
- `isLoading` - Loading state indicator
- `errorMessage` - Optional error message
- `showContent` - Controls fade animations

**Methods:**
- `loadResults()` - Loads first page
- `loadNextPage()` - Loads next page using `wrapperInfo.next`
- `loadPrevPage()` - Loads previous page using `wrapperInfo.prev`
- Race condition protection with `guard !isLoading` checks
- All load methods update both `results` and `wrapperInfo` after successful fetch

**`ResultsViewModel`** - Presentation layer for single character
- Wraps `ResultWrapper.Results` with computed properties
- Properties: `id`, `name`, `status`, `species`, `type`, `gender`, `image`
- Converts image `String` to `URL?` for easy consumption
- Conforms to `Identifiable` and `Hashable` for SwiftUI lists

**`WrapperInfoViewModel`** - Presentation layer for pagination
- Wraps `ResultWrapper.WrapperInfo`
- Converts `next` and `prev` Strings to `URL?` for type safety
- Used by navigation buttons to determine enabled/disabled state

### Views

**`MainResultView`** - Main application view with character grid
- `NavigationStack` for navigation hierarchy
- `LazyVGrid` with 2 flexible columns for character display
- Dependency injection - accepts `FetchServiceProtocol` and `PageServiceProtocol` in initializer

**Toolbar buttons:**
- Refresh (top-left) - reloads first page
- Previous page (top-right) - loads prev page
- Next page (top-right) - loads next page

**Features:**
- State-based button disabling when no prev/next page available
- Loading state disables pagination buttons to prevent race conditions
- Smooth fade animations using `showContent` state and `withAnimation`
- Sequential animation timing with `Task.sleep` for smooth transitions
- Auto scroll-to-top on page change using `.id(results.first?.id)`
- Error state with custom UI (warning icon, message, retry button)
- Loading indicator during operations
- Dark mode preferred color scheme

**`ResultDetialView`** - Detailed character information view
- Displays character image using Kingfisher `KFImage`
- Custom placeholder and failure image (`rm404`)
- Character details: Status, Species, Type, Gender
- Custom styling with rounded system font
- Navigation title displays character name
- Inline navigation bar title display mode
- Dark mode support

## Dependency Injection

The project uses **protocol-oriented dependency injection**:

- Services defined via protocols (`FetchServiceProtocol`, `PageServiceProtocol`)
- `ResultsListViewModel` receives services through initializer
- `MainResultView` creates ViewModel with service instances
- Default implementations provided for production use
- Easy mocking for testing and Xcode previews

**Benefits:**
- Easy testing and swapping implementations
- Promotes loose coupling between views, view models, and services
- Clean separation of concerns

## State Management

- `@State` for local view state (ViewModel instance, animation flags)
- `@Observable` macro for reactive ViewModel updates
- `@MainActor` ensures all UI updates happen on main thread
- State-based animation control with boolean flags
- Complex multi-step animations coordinated through async Tasks
- Button states tied to pagination info and loading state

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
- **Dependency Injection** - Protocol-based DI for testability
- **JSON Decoding** - `Codable` with custom error handling
- **Animations** - Smooth transitions with `withAnimation` and opacity
- **Task** - Async sequential animations with sleep delays

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
