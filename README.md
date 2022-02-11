# doube_navigator_bug

A reproducible project to demonstrate the double navigator bug.

- Navigator A
  - Press me button
  - Navigator B
    - Page 1
      - Solid green UiKitView
      - Push opaque route button
      - Push transparent route button
      - Page 2
        - Dismiss me button

Problem:

With two navigators, when we pop the Navigator A when the Page 2 is presented (and so the Navigator B), we expect the UiKitView is deallocated.
Unfortunately, this occurs only when the Page 2 is a transparent `PageRoute`, and not an opaque one.