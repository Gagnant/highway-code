Highway Code

## Description

App is using MIU API directly whenever possible to reduce overhead and costs for supporting firestore and firebase functions. Cloud codebase is not included (!) in this repository.

## Run

1. Clone from git repository
2. Navigate to root directory
3. Run "./scripts/run.sh"

## Overview

Project is using Carthage as external DM to manage Firebase dependencies, so make sure you have Carthage installed (https://github.com/Carthage/Carthage). All other dependencies are resolved by SPM.

Warning: GCP is configured to work only with "com.gagnant.highway-code" app identifier.

## TODOs

- [ ] Add support for [App Clips](https://developer.apple.com/app-clips/).
- [ ] Add app widget.
- [ ] Use dependency injection library. [Needle](https://github.com/uber/needle) seems to be the best candidate for now because it is compile-time safe.
- [ ] Add the ability to manipulate queue/thread where `Resource` logic is being executed to improve performance.
- [ ] Stop using literals for images and strings and proceed with more safe option. [R.swift](https://github.com/mac-cain13/R.swift) or similar codegen tool should be used for this.
- [ ] Start to persist data (solution must be compliant with `Resource`s concept).
- [ ] Support local notification.
- [ ] Design UI for location services permission tracking bar for `Cameras` screen (logic is already in place).
- [ ] Discover (!) and support missing fine states.
- [ ] MIU API returns broken video stream sometimes so workaround should be discovered.
- [ ] Add unit and integration tests.
- [ ] ~Start using [XcodeGen](https://github.com/yonaskolb/XcodeGen) to decrese merge conflicts amount in case of project scaling.~


## Help

Use ./scripts/clean.sh to reset all untracked git files.
