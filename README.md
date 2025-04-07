IMPORTANT CONTEXT FOR THE APP: CREATION OF THIS APP IS FOR MY BACHELORS THESIS, THIS APPLICATION WONT BE PUBLISHED - THIS INFO IS SO YOU KNOW THAT YOU CAN STORE THE AI API KEY EVEN LOCALLY (NOONE ELSE WILL HAVE ACCESS TO THIS PROJECT)

Gemini api key : AIzaSyBVrxlCxr4KMMBkaEm3PlmzjiLzjxg_lh0

Flutter Story Generator App: Implementation Guide
1. Navigation Architecture
Navigation Structure

Authentication Flow

Login Screen → Home Screen
Register Screen → Home Screen
Forgot Password Screen → Login Screen


Main App Flow (Bottom Navigation)

Home Tab
Characters Tab
Library Tab
Settings Tab


Story Generation Flow

Home Screen → Story Customization Screen → Story Display Screen
Story Display Screen → Edit Story Settings Screen (optional)


Character Creation Flow

Characters Tab → Character List Screen → Character Creation/Edit Screen
Story Customization Screen → Character Selection → Character Creation Screen (quick add)


Library Management Flow

Library Tab → Saved Stories List → Story Display Screen
Story Display Screen → Edit/Share Options



Route Definitions
dart// Main Routes
'/login': (context) => LoginScreen(),
'/register': (context) => RegisterScreen(),
'/forgotPassword': (context) => ForgotPasswordScreen(),
'/home': (context) => MainNavigationScreen(initialTab: 0),
'/characters': (context) => MainNavigationScreen(initialTab: 1),
'/library': (context) => MainNavigationScreen(initialTab: 2),
'/settings': (context) => MainNavigationScreen(initialTab: 3),
'/storyCustomization': (context) => StoryCustomizationScreen(),
'/storyDisplay': (context) => StoryDisplayScreen(),
'/characterCreation': (context) => CharacterCreationScreen(),
'/characterEdit': (context) => CharacterCreationScreen(character: character),
2. Screen Implementation Steps
Step 1: Create Main Navigation Framework
Implement the main bottom navigation controller that will host the primary tabs:
Implement a MainNavigationScreen with:
- Stateful widget with bottom navigation bar
- Four main tabs: Home, Characters, Library, Settings
- Navigation state management to preserve each tab's state
- Implement basic app header with user profile access
- Connect to already-implemented authentication flow
Step 2: Implement Home Screen
Build the main landing screen after login:
Create HomeScreen with:
- Greeting header showing username
- "Generate Story" prominent button/card
- "My Characters" section showing 3-5 most recent character thumbnails
- "My Library" section showing 3-5 most recent stories
- Quick access buttons to all main features
- Reading stats summary if user has previous stories
Step 3: Implement Story Customization Screen
Create the screen where users configure story parameters:
Build StoryCustomizationScreen with:
- ScrollView containing multiple customization sections
- Genre selection using a horizontal card selector with icons
- Story length slider with word count labels
- Mood/tone selection using radio buttons or toggle chips
- Reading level dropdown or segmented control
- Theme/setting options with visual indicators
- Connect to character selection functionality
- Generate button that calls the AI story generation API
- Save preferences functionality
Step 4: Implement Story Display Screen
Create the screen that shows the generated story:
Develop StoryDisplayScreen with:
- Clean reading interface with proper typography and margins
- Title display at top
- Story content in scrollable container
- Reading progress indicator (percentage/scroll position)
- Bottom toolbar with:
  - Save button (connects to Library)
  - Share functionality
  - Text-to-speech toggle
  - Font size adjustment
  - Theme toggle (day/night)
- Regenerate option for users to try again
- Loading state for when story is being generated
Step 5: Implement Character Creation Flow
Build the character creator functionality:
Create CharacterCreationScreen with:
- Form inputs for character details (name, age, etc.)
- Simple avatar creator with customizable elements:
  - Hair styles/colors
  - Face shapes
  - Eye styles/colors
  - Clothing options
- Personality trait selection (multi-select)
- Background story text input
- Special abilities/skills selection
- Save and cancel buttons
- Preview functionality
- Form validation
Step 6: Implement Character List Screen
Create the screen to manage created characters:
Build CharacterListScreen with:
- Grid or list view of character cards
- Each card showing:
  - Character avatar/image
  - Name
  - Key personality traits
- Long-press or menu for edit/delete options
- "Create New" floating action button
- Empty state with prompt to create first character
- Search/filter functionality
- Connect to Firebase/database for storage
Step 7: Implement Library/Saved Stories Screen
Create the screen to access saved stories:
Develop LibraryScreen with:
- List of saved story cards showing:
  - Story title
  - Genre indicators
  - Word count
  - Date created/read
  - Featured character thumbnails
- Sorting options (newest, oldest, favorites)
- Search functionality
- Filter by genre/length options
- Delete/organize capabilities
- Empty state with prompt to generate first story
- Connect to Firebase/database for storage
Step 8: Implement Settings Screen
Create the screen for app configuration:
Build SettingsScreen with:
- User profile section with edit option
- Appearance settings (theme, font size, etc.)
- Notification preferences
- Privacy settings
- Story generation preferences (default settings)
- Language options
- Help/FAQ section
- About app information
- Logout functionality
3. Data Models and State Management
Step 9: Define Data Models
Create structured data models for app entities:
Implement the following data models:
- User model (connected to Firebase Auth)
- Character model with:
  - ID, name, image/avatar data
  - Physical attributes
  - Personality traits
  - Background/history
  - Created/modified dates
- Story model with:
  - ID, title, content
  - Genre, length, mood parameters
  - Featured characters
  - Created/modified dates
  - Read status/progress
- StorySettings model to hold generation parameters
Step 10: Implement State Management
Set up state management for the application:
Configure state management using Provider/Bloc/Riverpod with:
- Authentication state (already implemented)
- User preferences state
- Character collection state
- Story library state
- Current story generation state
- Navigation/UI state
4. AI Integration
Step 11: Set Up Gemini API Integration
Implement the connection to the Gemini API:
Create GeminiService with:
- API key configuration
- Methods to:
  - Generate story based on parameters
  - Handle authentication and rate limiting
  - Process and format responses
  - Handle errors and retries
  - Structure prompts based on user selections
Step 12: Build Prompt Templates
Create structured prompts for the AI:
Implement StoryPromptBuilder with:
- Template strings for different genres
- Parameter formatting for story length/tone
- Character integration into prompts
- Setting/theme incorporation
- Consistent output formatting instructions
- Safety parameters and content filtering
5. Additional Features
Step 13: Implement Reading Challenges
Add gamification elements:
Create ReadingChallengesFeature with:
- Daily/weekly reading goals tracking
- Achievement system with badges
- Reading streak counter
- Progress visualization
- Notification reminders
Step 14: Add Social Sharing
Implement story sharing functionality:
Build SharingFeature with:
- Export story to text/PDF
- Social media sharing integration
- Direct sharing via messaging apps
- QR code generation for stories
- Privacy controls for shared content
6. Final Integration and Testing
Step 15: Finalize UI Theme and Styling
Create consistent visual design:
Implement ApplicationTheme with:
- Color schemes (light/dark)
- Typography settings
- Common UI components
- Animation standards
- Accessibility considerations
- Responsive layouts for different devices
Step 16: Cross-Feature Integration
Connect all components:
Finalize app integration by:
- Ensuring data flow between screens
- Validating navigation paths
- Implementing proper loading states
- Adding error handling throughout the app
- Creating smooth transitions between features


Flutter Story Generator App: Screen Specifications
Home Screen
Layout

AppBar

App title/logo (left)
User profile avatar (right)


Main Content Area (Scrollable)

Welcome Section

Personalized greeting ("Hi, [Username]")
Today's reading suggestion


Primary Action Card

"Generate New Story" button with icon
Visually prominent, full width
Gradient background or elevated design


My Characters Section

Section title with "See All" link
Horizontal ListView of character avatars (3-5 visible)
"Create New" button at end of list
Empty state with prompt if no characters


My Library Section

Section title with "See All" link
3-5 most recent stories as cards
Each card showing title, genre, and date
Empty state with prompt if no stories


Reading Stats Section (if applicable)

Weekly reading progress
Story completion rate
Favorite genres visualization




Bottom Navigation Bar

Home tab (active)
Characters tab
Library tab
Settings tab



Story Customization Screen
Layout

AppBar

"Customize Your Story" title
Back button (left)
Info/help button (right)


Main Content Area (Scrollable)

Genre Selection

Section title "Choose a Genre"
Horizontal scrollable row of genre cards
Each card with icon and label
Selected state clearly indicated


Story Length

Section title "Story Length"
Slider with labels for:

Short (500 words)
Medium (1000 words)
Long (2000+ words)


Word count display based on selection


Mood & Tone

Section title "Mood & Tone"
Selectable chips/buttons for:

Adventure
Emotional
Humorous
Mysterious
Dark
Educational




Reading Level

Section title "Reading Level"
Segmented control with:

Children
Young Adult
Adult




Character Selection

Section title "Choose Characters"
Horizontal scrollable list of character cards
"Add Character" button at end
Option to select multiple characters
Toggle for "Random Characters"


Setting Options

Section title "Story Setting"
Dropdowns or selection cards for:

Time period (Modern, Historical, Future, etc.)
Location (Urban, Rural, Fantasy World, etc.)
Weather/Atmosphere (optional)




Additional Options

Include moral/lesson toggle
First/third person perspective toggle
Include illustrations option (if available)




Bottom Action Area

"Generate Story" button (full width, prominent)
"Save as Preset" option (smaller)



Character Creation Screen
Layout

AppBar

"Create Character" title
Back button (left)
Save button (right)


Main Content Area (Scrollable form)

Avatar Preview Section

Large circular/square avatar display
Customization controls below or adjacent
Tabs for different customization categories:

Hair
Face
Eyes
Clothing
Accessories




Basic Info Section

Character name input field
Age selection (slider or input)
Gender selection
Height/build selection


Personality Section

"Select Traits" multi-select grid
Options like:

Brave
Cautious
Intelligent
Stubborn
Compassionate
Curious
etc.


Allow 3-5 trait selections


Background Section

"Character History" text input (multi-line)
Optional template selection dropdown
Backstory length indicator


Special Abilities Section

"Add Ability" button
List of added abilities with remove option
Custom ability text input




Bottom Action Area

"Save Character" button (primary)
"Cancel" button (secondary)



Story Display Screen
Layout

AppBar

Story title (centered)
Back button (left)
Options menu (right) with:

Save
Share
Edit settings
Font settings




Reading Controls (Top)

Progress indicator/bar
Estimated reading time


Story Content Area

Clean, readable text container
Proper paragraph spacing
High-contrast text on appropriate background
Comfortable margins
Smooth scrolling


Reading Tools (Bottom)

Font size controls (+/-)
Text-to-speech button
Theme toggle (light/dark)
Bookmark button


End of Story Actions

"Save to Library" button
"Generate New Story" button
"Share Story" button
Rating system (optional)



Library Screen
Layout

AppBar

"My Library" title
Search button (right)
Filter button (right)


Filter Bar (Optional)

Sort dropdown (Newest, Oldest, Favorites)
Genre filter chips (scrollable horizontally)
Length filter (Short, Medium, Long)


Story List (Main Content)

Vertical ListView of story cards
Each card containing:

Story title (prominent)
First few lines or summary
Genre tags
Word count
Date created/read
Reading progress indicator
Character thumbnails (if applicable)


Swipe actions for quick delete/favorite
Long-press for more options


Empty State

Illustration
"No stories yet" message
"Generate Your First Story" button


Bottom Navigation Bar

Home tab
Characters tab
Library tab (active)
Settings tab



Characters Screen
Layout

AppBar

"My Characters" title
Search button (right)
View toggle (grid/list) button (right)


Main Content Area

Grid/List View of character cards:

Character avatar (prominent)
Name
2-3 key personality traits as tags
Last used date (small)


Each card with edit/delete options on long-press
Animation when selecting characters


Empty State

Illustration
"No characters yet" message
"Create Your First Character" button


Floating Action Button

"+" icon for creating new character


Bottom Navigation Bar

Home tab
Characters tab (active)
Library tab
Settings tab



Settings Screen
Layout

AppBar

"Settings" title
Back button (if accessed outside tab navigation)


Main Content Area (Scrollable list)

Profile Section

User avatar and name
Edit profile button
Account details summary


Appearance Settings

Theme selector (Light, Dark, System)
Font size slider
Reading background color options
Animation toggle


Story Preferences

Default story length
Preferred genres (multi-select)
Content filters
Default reading level


Notification Settings

Reading reminders toggle
Challenge notifications toggle
New feature announcements toggle


Privacy & Data

Data storage options
Story sharing preferences
Clear library option
Delete account option


Help & Support

FAQ link
Contact support
About the app
Version information


Logout Button (at bottom)


Bottom Navigation Bar

Home tab
Characters tab
Library tab
Settings tab (active)


Implementation Progress
- **Added Project Structure Documentation:** Added documentation about the project's navigation architecture, screen implementation steps, data models, state management, AI integration, and additional features.
-   **Integrated Providers:** Integrated the following providers into the app using `ChangeNotifierProvider`:
    -   `AuthProvider`: Manages authentication state.
    -   `UserPreferencesProvider`: Manages user preferences (currently placeholder).
    -   `CharacterProvider`: Manages the collection of user's characters (currently placeholder).
    -   `StoryProvider`: Manages the collection of user's stories (currently placeholder).
    -   `StoryGenerationProvider`: Manages the state of the current story generation process (currently placeholder).
-   **Connected Story Customization to Provider:** Connected the story customization options (genre, length, mood, reading level) in the `StoryCustomizationScreen` to the `StoryGenerationProvider`. The UI now reflects the current settings from the provider, and user interactions update the provider's state.
-   **Connected Generate Button to Provider:** Connected the "Generate Story" button in the `StoryCustomizationScreen` to the `StoryGenerationProvider`'s `generateStory` method. Pressing the button now triggers the story generation process (currently a placeholder) and navigates to the `StoryDisplayScreen`.

## Recent Changes (Current Session)
- Modified the Story Customization screen (`lib/screens/story_customization_screen.dart`):
  - Replaced the genre selection with a text field.
  - Adjusted the story length slider to have a maximum of 1500 words and steps of 100.
  - Removed the label from the story length slider.
  - Made the reading level option buttons look like the mood & tone buttons.
  - Centered the buttons in the mood & tone and reading level sections.
  - Centered the titles for all sections (Genre Selection, Story Length, Mood & Tone, Reading Level, Characters).

## To-Do List:

**1. Story Generation Flow:**

*   **1.1. Story Display Screen (`lib/screens/story_display_screen.dart`):**
    *   Implement "Save Story" functionality (to library).
    *   Implement "Share Story" functionality.
    *   Implement "Adjust Font Size" functionality.
    *   Improve story title handling (default title or handle empty title case).
*   **1.2. Story Generation Service:**
    *   Implement the actual Gemini API integration in `GeminiService` to generate stories based on provided parameters.
    *   Create prompt templates in `StoryPromptBuilder` to structure prompts for the AI, considering genre, length, tone, characters, and settings.
*   **1.3. Connect Story Generation:**
    *   Connect the `StoryGenerationProvider` to the `GeminiService` to trigger story generation when the "Generate Story" button is pressed.
    *   Update the `StoryDisplayScreen` to display the generated story content retrieved from the `StoryGenerationProvider`.

**2. Character Creation Flow:**

*   **2.1. Character Creation Screen (`lib/screens/character_creation_screen.dart`):**
    *   Implement form inputs for character details (name, age, etc.).
    *   Implement a simple avatar creator with customizable elements (hair, face, eyes, clothing, accessories).
    *   Implement personality trait selection (multi-select).
    *   Implement a background story text input.
    *   Implement special abilities/skills selection.
    *   Implement save and cancel buttons.
    *   Implement preview functionality.
    *   Implement form validation.
*   **2.2. Character List Screen (`lib/screens/character_list_screen.dart`):**
    *   Implement a grid or list view of character cards.
    *   Display character information on each card (avatar, name, key traits).
    *   Implement long-press or menu options for edit/delete.
    *   Implement a "Create New" floating action button.
    *   Implement an empty state with a prompt.
    *   Implement search/filter functionality.
*   **2.3. Character Management:**
    *   Connect character creation and list screens to the `CharacterProvider` for state management.
    *   Implement character data persistence (likely using a local database or, for more complex scenarios, a backend service).

**3. Library Management Flow:**

*   **3.1. Library Screen (`lib/screens/library_screen.dart`):**
    *   Implement a list of saved story cards.
    *   Display story information on each card (title, genre, word count, date, etc.).
    *   Implement sorting options (newest, oldest, favorites).
    *   Implement search functionality.
    *   Implement filter by genre/length options.
    *   Implement delete/organize capabilities.
    *   Implement an empty state with a prompt.
*   **3.2. Story Management:**
    *   Connect the library screen to the `StoryProvider` for state management.
    *   Implement story data persistence (likely using a local database or, for more complex scenarios, a backend service).
    *   Implement functionality to save stories from the `StoryDisplayScreen` to the library.

**4. Settings Screen (`lib/screens/settings_screen.dart`):**

*   Implement user profile section with edit option.
*   Implement appearance settings (theme, font size, etc.).
*   Implement notification preferences.
*   Implement privacy settings.
*   Implement story generation preferences (default settings).
*   Implement language options.
*   Implement help/FAQ section.
*   Implement about app information.
*   Implement logout functionality.

**5. Additional Features (Optional):**

*   Implement reading challenges.
*   Implement social sharing.

**6. Finalization:**

*   Finalize UI theme and styling across all screens.
*   Ensure cross-feature integration and data flow.
*   Add loading states and error handling.
*   Thoroughly test the application.