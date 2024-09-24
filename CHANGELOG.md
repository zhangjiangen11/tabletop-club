# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

#### Assets

- A look-up cache has been implemented into the AssetDB, which should lead to
  increased performance when searching for specific assets.
- A new 'tagging' system has been added for the internal `user://` directory,
  which is more robust against missing files.
- Can now use the `?` wildcard in section names of `config.cfg` files, which
  will match one and only one character.
- Added a deprecation warning when attempting to use the old `VALUE: ROTATION`
  format for the `face_values` property.
- Added a warning when the number of entries in the `face_values` property does
  not match the number of faces on the die.
- Can now use the normal vector of a die face when setting its value, instead of
  the X and Z rotation needed to make the face point upwards.
- Both 'Picnic Bench' and 'Table' are now textured.
- Objects now have a black outline when they are unselected, and a grey outline
  when they are locked in place.

#### Commands

- Added the `/say` command, which sends a public message to all players in the
  current room. This is the same behaviour as entering a normal message in the
  chat window.

#### Controls

- Added new bindings for rotating the camera up, down, left, and right. By
  default these are bound to the arrow keys.
- Bindings can now be removed by holding the Escape key while they are being
  set.
- "Mouse Wheel Up" and "Mouse Wheel Down" are now shown as editable bindings for
  "Zoom In / Lift Down" and "Zoom Out / Lift Up" respectively.
- Added the "Start Message" binding (bound to the Enter key by default), which
  will bring the chat window in focus to allow the player to start typing a
  message, as long as there are no other UI elements currently in focus.
- Added the "Start Command" binding (bound to the forward slash key by default),
  which will bring the chat window in focus and automatically insert a forward
  slash character so the player can start typing in a command.
- The binding for selecting and grabbing objects is now editable.

#### Graphics

- Added the Fast Approximate Anti-Aliasing (FXAA) algorithm, which is now the
  default for players launching the game for the first time.
- Added sliders that can change the brightness, contrast, and saturation of the
  rendered scene in the options menu, under the "Video" section.
- Added quality presets for advanced graphics settings in the options menu: Low,
  Medium, High, Very High, and Ultra. The default for new players is Medium.
- Added a toggle for showing advanced graphics settings in the options menu.

#### Multiplayer

- Can now host multiplayer lobbies in "Direct Connection" mode, which allows
  clients to join using the host's IP address instead of a room code, removing
  the need to connect to the master server. (#225)
- Can now cancel attempts to host or join a multiplayer lobby.

#### Options

- When reading the system's language, if it is a variant of a language that is
  already supported by the game, the game will use the supported language
  instead of reverting to English. For example, if the system is set to Austrian
  German (`de_AT`), the game will use German (`de`) instead of English.
- Sliders in the options menu now display their values.
- In the options menu, a preview has been added showing what the player's name
  and colour will look like on the player list in the top-right corner.
- A warning is now shown when attempting to set an invalid player name in the
  options menu.
- Added a slider that can change the scale of the user interface in the options
  menu, under the "Video" section. (#290)
- Added a new dialog for when the player is about to leave the options menu with
  new settings that have not been applied.
- A countdown has been added to the dialog that appears when video settings have
  been changed, which will revert the changes automatically if it runs out.

#### Project

- Added unit tests for various in-game systems using Gut v7.4.3 (#153)
- Added a fallback directory in `user://` in the event that the player's
  Documents folder could not be opened.
- Optimised the look-up algorithm for certain node structures, which should lead
  to better performance when there are many dynamic objects in play.
- Enabled HiDPI on Windows, which stops the UI appearing blurry on displays with
  a high resolution in a small form factor.
- Added a new command-line argument `--preload`, which when given a path to a
  save file, will immediately load the file's save state upon launching the
  game. Example usage on Linux:
  `./TabletopClub.x86_64 --preload ~/Documents/TabletopClub/saves/quicksave.tc`
- The game is now available for ARM platforms (`arm32`, `arm64`) on Linux.

#### UI

- Added a fade-in effect for the main menu when the game first loads.
- Added full controller support. (#100)
- Added graphs to the debug screen showing both the frame delta, and the physics
  frame delta, over time.
- When typing a message in the chat window, the up and down arrow keys will now
  display the player's message history from that session.
- When clicking on a blank space while in-game, the game will automatically
  release the focus from any UI elements that have it at the time.
- Added more information about the connection process to the multiplayer window.
- When entering a room code, up and down arrow buttons have been added to cycle
  through the alphabet, in addition to using the keyboard to type the code in.
- Added a checkbox to the multiplayer window that hides the room code before
  entering the game.
- When sending messages through the chat window, special tags can now be used
  that will be substituted. For example, `<player 1>` will be replaced with the
  name of the host.
- Added a button next to the room code that copies it to the clipboard.
- The host of a multiplayer lobby is not indicated with an icon in the player
  list.
- The debug screen now shows more information about the state of the player
  controller.
- Added a "Loading..." panel when the client is receiving a new state from the
  host in multiplayer.
- When selecting assets, assets are now organised into folders.
- When selecting assets, the layout and scale in which assets are displayed can
  now be changed.
- Added a "Redo" button to the in-game UI.

### Changed

#### Assets

- The AssetDB now stores entries as resources instead of JSON-like dictionaries,
  which allows for increased type safety and internal data validation.
- The way temporary entries in the AssetDB (that is, entries that are provided
  by a multiplayer host) are stored in memory has been optimised.
- The `*` wildcard can now be used in the middle of section names in
  `config.cfg` files, rather than just at the beginning and end.
- Custom assets are now imported after the main menu has loaded, instead of
  before. This should lead to faster and more consistent loading times,
  regardless of the number of custom assets.
- The 'TabletopClub' asset pack that comes bundled with the game is now
  pre-imported inside the `.pck` file instead of in its own directory. The pack
  no longer has to be imported every launch.
- All textures within the 'TabletopClub' asset pack are now bundled in a
  compressed format, leading to less video memory usage.
- The collision shapes of the following objects have been simplified:
  'Chess Board', 'Bishop', 'King', 'Knight', 'Pawn', 'Picnic Bench', 'Pot',
  'Purse', 'Queen', 'Radio', 'Rook', 'Table'.
- The centre-of-mass of the following objects have been adjusted: 'Purse',
  'Gramophone', 'Radio'.
- The outline of selected objects is now always white, regardless of the
  player's favourite colour.

#### Controls

- Up to two keyboard and mouse bindings can be set per action now, instead of
  just one.
- Keyboard and controller bindings are now only stored if they are changed from
  their default values. This means that if the default value changes in a future
  version of the game, and you have not explicitly set a binding for a specific
  action, that action's binding will change to the new default.
- When changing a binding, instead of a dialog pop-up being shown, the binding's
  text simply changes to indicate it is waiting for a button press.

#### Graphics

- Restarting is no longer required to see the effects of changing the "Shadow
  Detail" level.

#### Multiplayer

- Updated the Godot WebRTC library from v0.5 to v1.0.5.
- Optimised the number of connections established between peers when using
  WebRTC.
- Lobbies will now continue if the connection to the master server is lost, but
  players will not be able to join the lobby anymore.
- If the connection to the host is lost, clients will now continue the session
  in singleplayer mode, instead of being kicked back to the main menu.

#### Options

- The "Effects Volume" option is now called "Object Volume" to better reflect
  its function.
- The "Multiplayer" tab in the options menu has been renamed to "Player".
- Hints for properties in the options menu are now shown in a dedicated label
  rather than in tooltips.
- Slightly adjusted the hints for properties in the options menu.
- The "Chat Font Size" option is now called "Chat Window Font Size", and has
  been moved to the "General" tab from the "Multiplayer" tab.
- "Skybox Radiance Detail" has been renamed to "Skybox Lighting Detail" in the
  options menu.
- The "Key Bindings" tab in the options menu has been removed in favour of a
  separate menu under the "Controls" tab.

#### Project

- Updated the Godot Engine from 3.4.5-stable to 3.6-stable.
- Updated the custom module to be more flexible in how files are imported.
- Replaced the physics frame interpolation patch with the engine-provided
  implementation.
- Changed the project's directory structure in order to comply with Godot
  conventions.
- System errors and warnings are no longer shown twice in the logs.

#### Tools

- Optimised the performance of the paint and erase tools.
- The appearance of hidden areas is now animated.

#### UI

- Changed the default window size from 1024x600 to 1920x1080.
- The importing process is now shown as an independent panel in the main menu
  instead of within the loading screen.
- Increased the font size of text on the loading screen.
- The main menu music will now fade out gradually when entering the game,
  instead of ending abruptly.
- Updated the layout of the main menu and the options menu.
- The 'Park' skybox is now the only default skybox, meaning that there is no
  longer a chance for the 'Park Winter' skybox to appear in the main menu.
- The game room is now loaded alongside the main menu, removing the need for a
  loading screen when entering singleplayer or multiplayer.
- The in-game menu screen now uses the same layout as the main menu.
- The appearance of the player list has been significantly improved.
- The colour pickers used throughout the UI have been replaced with colour
  sliders, which can be switched between two modes: HSV and RGB.
- Renamed the "Contributors" section in the credits to "Code Contributors".
- Increased the font size of the text in the debug screen.
- Optimised certain operations on the chat log.
- Improved the appearance of the chat window.
- The chat window is now also shown in the main menu, as well as in-game.
- The chat window will now become transparent when the mouse is being used
  somewhere else in the game.
- Improved the dialog that appears when attempting to run the game with a build
  of Godot that does not include the custom module.
- The game will now remember the last room code that was entered after the
  client successfully joins a multiplayer lobby.
- When attempting to host or join a multiplayer lobby, the attempt is now done
  in the main menu instead of in-game.
- Updated error messages related to the multiplayer network. In some cases,
  errors are now followed up with advice on how to solve the issue.
- The text of the "Hide Room Code" button has been replaced with an icon.
- In the objects menu, objects are now represented with static thumbnails
  instead of rotating 3D previews, which should fix a number of crashes. (#268)
- When selecting assets, the tooltip for each asset now only displays the
  description of the asset, instead of a full summary.
- When selecting assets, a scroll bar is now used instead of pages when
  displaying lots of assets at once.
- The "Tokens" object type has been renamed to "Tiles / Tokens".
- Improved the in-game UI.
- Moved the "Load Game" and "Save Game" buttons from the in-game menu to the top
  of the in-game UI.
- Moved the "Clear Table" and "Flip Table" buttons from the top of the in-game
  UI to the room menu, as well as the table's context menu.
- Moved the rotation amount button from the top of the in-game UI to the cursor
  tool's settings.
- When selecting an object in the objects menu, you can now choose where the
  object spawns, instead of the object being placed at a "spawn point".

### Fixed

#### Assets

- Objects inside of stacks will now retain their custom colour after reloading
  a previous save.
- An object's centre-of-mass will no longer change when the object is scaled.
- Fixed an issue where if the 'Red Cup' container had a custom scale applied to
  it, the applied scale would change when loading a previous save state.
- Fixed objects with box collision shapes dancing on the table before eventually
  settling down. (#50)

#### Multiplayer

- Fixed the game client not detecting when the connection to the master server
  has been lost silently.
- Fixed the game client not detecting when the connection to another client has
  been lost silently.
- Fixed the game client not detecting when a connection to the host, or to a
  client joining the room, was not able to be established.
- Fixed the client not being able to send data packets larger than 64 KiB.

#### Project

- Fixed a crash when attempting to run the game on macOS with a system using the
  `arm64` architecture.

#### UI

- Fixed some labels not being added to the translation template file, which was
  preventing them from being able to be translated by contributors.

### Removed

#### Assets

- Removed the `--base-asset-dir` command-line argument, as it is no longer
  required.
- The Downloads, Desktop, and installation folders are no longer scanned for
  asset packs.
- Removed the `--export-asset-db` command-line argument.
- The following properties are no longer used in configuration files: `default`,
  `main_menu`.

#### UI

- The randomly selected pieces that were falling in the background of the main
  menu have been removed.
- The "Video Adapter" and "Physics Objects" values have been removed from the
  debug screen, as they currently do not work correctly in the engine.
- The "Send" button has been removed from the chat window.
- The import log has been removed from the main menu, as the chat window (which
  displays errors and warnings generated by assets) is now shown in the main
  menu.
- When selecting assets, the "Pack" and "Type" dropdowns have been removed now
  that folders have been implemented.

[unreleased]: https://github.com/drwhut/tabletop-club/compare/HEAD...HEAD
