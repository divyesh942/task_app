# Task App Project Workflow

## Overview

This project is a Flutter task manager app built with Material 3 and GetX. It stores data locally with `SharedPreferences`, so there is no backend or remote API.

Main capabilities:

- Create tasks
- Edit tasks
- Mark tasks complete or incomplete
- Archive tasks
- Restore or permanently remove archived tasks
- Automatically persist tasks on every change

## Tech Stack

- Flutter
- Material 3
- GetX for dependency injection, navigation, and reactive UI updates
- `SharedPreferences` for local persistence
- `flutter_svg` for SVG icons and illustrations
- `uuid` for task IDs

Reference: `pubspec.yaml`

## App Startup Flow

Entry point: `lib/main.dart`

Startup sequence:

1. `WidgetsFlutterBinding.ensureInitialized()` prepares Flutter bindings.
2. `Preferences.init()` initializes the `SharedPreferences` wrapper.
3. `Get.put(DashboardController(), permanent: true)` registers the main controller globally.
4. `runApp(const MyApp())` launches the app.
5. `GetMaterialApp` opens the dashboard screen with `home: const MyDashBoard()`.

This means the app depends on `Preferences.init()` running before storage access happens.

## Core Architecture

### 1. Data Model

File: `lib/model/task.dart`

Each task contains:

- `id`
- `title`
- `description`
- `priority`
- `isChecked`
- `isArchived`

The model supports `Task.fromMap()` and `toMap()` so tasks can be encoded to JSON and saved locally.

### 2. State Controller

File: `lib/screens/home/controller/dashboard_controller.dart`

`DashboardController` is the main source of truth.

Reactive state:

- `tasks = <Task>[].obs`
- `isLoading = false.obs`

Derived task collections:

- `activeTasks`: tasks that are not archived
- `archiveTasks`: tasks that are archived
- `completedTasks`: checked and not archived
- `incompleteTasks`: unchecked and not archived

Main mutations:

- `fetchTasks()`
- `addTask(Task task)`
- `updateTask(Task task)`
- `toggleChecked(Task task)`
- `toggleArchive(Task task)`
- `unarchiveTask(Task task)`
- `deleteFromArchive(Task task)`

Tasks are re-sorted before persistence. Priority sorting is based on enum order in `lib/config/app_enums.dart`, so display order is:

1. High
2. Medium
3. Low
4. Very Low

### 3. Local Persistence

Files:

- `lib/services/preference.dart`
- `lib/services/local_storage_service.dart`
- `lib/constant/storage_keys.dart`

How it works:

1. The controller calls `LocalStorageService`.
2. The storage service reads and writes the `tasks` key.
3. Tasks are saved as a `List<String>` where each item is a JSON-encoded task.
4. On app launch, `fetchTasks()` loads saved tasks and pushes them into the observable list.

This is a local-only persistence model.

## Main User Workflow

### Dashboard

File: `lib/screens/home/view/dashboard_screen.dart`

The dashboard is the main screen. It contains:

- a header
- a `TabBar` with `All`, `Complete`, and `Incomplete`
- a `TabBarView` for each task view
- a floating action button for creating tasks
- a drawer or embedded sidebar depending on screen width

The entire body is wrapped in `Obx(...)`, so UI updates automatically when controller state changes.

### Create Task Flow

Files:

- `lib/screens/home/view/dashboard_screen.dart`
- `lib/screens/home/widget/task_dialog_widget.dart`

Flow:

1. User clicks the floating action button.
2. `showTaskDialog(...)` opens a dialog.
3. The user enters title, optional description, and priority.
4. `_saveTask()` creates a `Task` object.
5. The dialog calls `dashboardController.addTask`.
6. The controller adds the task and persists the full list.

### Edit Task Flow

Files:

- `lib/screens/home/widget/task_all.dart`
- `lib/screens/home/widget/complete_task_widget.dart`
- `lib/screens/home/widget/incomplete_task_widget.dart`
- `lib/screens/home/widget/task_dialog_widget.dart`

Flow:

1. User taps a task card.
2. The same dialog opens with existing task data.
3. Saving calls `dashboardController.updateTask`.
4. The controller replaces the matching task by ID and persists changes.

### Complete / Incomplete Flow

Files:

- `lib/screens/home/widget/task_collection_view.dart`
- `lib/screens/home/widget/task_card_widgets.dart`
- `lib/screens/home/controller/dashboard_controller.dart`

Flow:

1. User toggles the checkbox on a task card.
2. `toggleChecked(Task task)` flips `isChecked`.
3. The observable list refreshes.
4. The controller persists the updated list.
5. The task automatically moves between `Complete` and `Incomplete` tabs because those tabs are filtered views.

### Archive Flow

Files:

- `lib/screens/home/widget/task_card_widgets.dart`
- `lib/screens/home/controller/dashboard_controller.dart`
- `lib/screens/home/view/archive_screen.dart`

Flow:

1. User presses the archive/remove icon on a task card.
2. `toggleArchive(Task task)` flips `isArchived`.
3. Archived tasks disappear from active tabs.
4. They become visible in the archive screen.

Archive screen actions:

- Restore: `unarchiveTask(task)` sets `isArchived = false`
- Delete permanently: `deleteFromArchive(task)` removes the task from the list

### Navigation Flow

File: `lib/screens/home/widget/drawer_widget.dart`

Navigation is simple:

- Home stays on the dashboard
- Archive navigates with `Get.to(() => ArchiveScreen())`

## Screen and Widget Responsibilities

### `lib/screens/home/view/dashboard_screen.dart`

- Main page shell
- Handles drawer vs sidebar layout
- Hosts tabs and floating action button
- Applies width constraints and responsive padding
- Shows loading overlay through `.appLoading(...)`

### `lib/screens/home/widget/task_collection_view.dart`

- Shared renderer for task lists
- Switches between `ListView` and `GridView` based on screen width
- Wraps each task in an `InkWell` so cards are tappable

### `lib/screens/home/widget/task_card_widgets.dart`

- Visual card for each task
- Displays checkbox, title, description, priority badge, status badge, and archive action

### `lib/screens/home/widget/task_dialog_widget.dart`

- Form UI for both create and update
- Reuses the same dialog for both actions
- Preserves existing `id`, `isChecked`, and `isArchived` when editing

### `lib/screens/home/view/archive_screen.dart`

- Shows only archived tasks
- Reuses the same collection view as the main dashboard
- Uses a custom trailing action for restore

## How the Code Works Together

High-level data flow:

1. App starts and initializes local preferences.
2. `DashboardController` loads persisted tasks in `onInit()`.
3. Screens get the controller with `Get.find<DashboardController>()`.
4. Widgets use `Obx(...)` to react to observable state changes.
5. User actions call controller methods.
6. Controller updates `tasks`.
7. Controller persists the full task list.
8. Reactive widgets rebuild with the latest filtered lists.

This project follows a single-controller pattern for the entire app workflow.

## Responsiveness on Web and Larger Screens

Main file: `lib/utils/responsive.dart`

### Breakpoints

- Mobile: width `< 700`
- Tablet: width `>= 700` and `< 1100`
- Desktop: width `>= 1100`
- Sidebar becomes embedded at width `>= 1000`

### What Changes by Screen Size

#### Navigation

File: `lib/screens/home/view/dashboard_screen.dart`

- Below `1000px`: uses `Scaffold.drawer`
- At or above `1000px`: shows `MyDrawer(embedded: true)` as a permanent left sidebar

#### Floating Action Button Position

File: `lib/screens/home/view/dashboard_screen.dart`

- Smaller screens: `FloatingActionButtonLocation.centerFloat`
- Larger screens with sidebar: `FloatingActionButtonLocation.endFloat`

#### Page Width and Padding

Files:

- `lib/utils/responsive.dart`
- `lib/screens/home/view/dashboard_screen.dart`

Padding rules:

- Mobile: `EdgeInsets.symmetric(horizontal: 16, vertical: 16)`
- Tablet: `EdgeInsets.symmetric(horizontal: 24, vertical: 20)`
- Desktop: `EdgeInsets.symmetric(horizontal: 32, vertical: 24)`

The dashboard content is also wrapped in `ConstrainedBox(maxWidth: 1180)`, which stops the UI from stretching too wide on desktop web.

#### Tabs

File: `lib/screens/home/view/dashboard_screen.dart`

- On mobile, tabs are scrollable with `isScrollable: true`
- On mobile, tab alignment is `TabAlignment.start`
- On larger widths, tabs fill the available row

#### Task List Layout

File: `lib/screens/home/widget/task_collection_view.dart`

The task renderer changes automatically:

- 1 column: `ListView.separated`
- 2 columns: `GridView.builder`
- 3 columns: `GridView.builder`

Column count comes from `AppDimensions.taskGridCount`:

- Mobile: 1
- Tablet: 2
- Desktop: 3

Grid card height is also adjusted:

- Desktop: `mainAxisExtent: 186`
- Tablet: `mainAxisExtent: 194`

#### Dialog Behavior

File: `lib/screens/home/widget/task_dialog_widget.dart`

- The task dialog uses `ConstrainedBox(maxWidth: 560)` so it stays readable on web and tablet
- `SingleChildScrollView` plus `MediaQuery.viewInsetsOf(context).bottom` prevents the keyboard from covering the form on smaller screens

## How Hover Works

There is no custom hover system in this project.

That means:

- No `MouseRegion`
- No manual hover state variables
- No custom `onHover` logic

Instead, hover behavior on web/desktop comes from Flutter Material widgets.

### Where Hover Feedback Comes From

#### Task cards

File: `lib/screens/home/widget/task_collection_view.dart`

Each task tile is wrapped in `InkWell`, so desktop/web gets built-in Material pointer feedback when hovering and tapping.

#### Drawer navigation items

File: `lib/screens/home/widget/drawer_widget.dart`

The `navigationMenu(...)` helper also uses `InkWell`, so sidebar items get standard hover and press feedback.

#### Buttons and controls

Files:

- `lib/screens/home/widget/task_card_widgets.dart`
- `lib/screens/home/widget/task_dialog_widget.dart`

Widgets such as these provide built-in interactive states on web/desktop:

- `IconButton`
- `Checkbox`
- `ChoiceChip`
- `OutlinedButton`
- `FilledButton`

So hover is implemented implicitly through Material components, not through custom pointer handling.

## Loading Behavior

File: `lib/extensions/ext_on_widget.dart`

The dashboard applies `.appLoading(isLoading: dashboardController.isLoading.value)`.

When loading is true:

- the current screen stays visible underneath
- a semi-opaque white layer is added on top
- `AppLoader()` is centered above the content

This is mainly used around task fetch and update operations.

## Important Files

- `lib/main.dart`: app bootstrap and dependency registration
- `lib/screens/home/controller/dashboard_controller.dart`: core state and business logic
- `lib/model/task.dart`: task model and serialization
- `lib/services/local_storage_service.dart`: task persistence implementation
- `lib/services/preference.dart`: preferences wrapper initialization and typed storage
- `lib/screens/home/view/dashboard_screen.dart`: main shell and workflow entry point
- `lib/screens/home/widget/task_dialog_widget.dart`: create/update task form
- `lib/screens/home/widget/task_collection_view.dart`: shared responsive list/grid renderer
- `lib/screens/home/widget/task_card_widgets.dart`: task card UI
- `lib/screens/home/view/archive_screen.dart`: archive lifecycle UI
- `lib/utils/responsive.dart`: all screen width rules

## Current Project Characteristics

- Local-first app, no backend
- Single main controller for app state
- Reactive UI through GetX observables
- Shared task renderer reused across tabs and archive
- Responsive layout based on width breakpoints, not separate web-only code
- Hover behavior relies on built-in Material widget states

## Suggested Documentation Entry Point

If someone is new to the project, the best reading order is:

1. `lib/main.dart`
2. `lib/screens/home/controller/dashboard_controller.dart`
3. `lib/screens/home/view/dashboard_screen.dart`
4. `lib/screens/home/widget/task_dialog_widget.dart`
5. `lib/screens/home/widget/task_collection_view.dart`
6. `lib/screens/home/view/archive_screen.dart`
7. `lib/services/local_storage_service.dart`
8. `lib/model/task.dart`
