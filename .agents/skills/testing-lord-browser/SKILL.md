---
name: testing-lord-browser
description: Test SysML-LoRD browser-local WASM gameplay, natural rescue narration, and replay saves through Chrome.
---

# Setup

In the SysML-LoRD repository, use `make web` to build `build/web/`.
Serve it with `python3 -m http.server -d build/web 8080` and browse
`http://localhost:8080/`. This is a static WASM app, not the former OpenSysML
Go HTTP server. Use the supplied build only when it matches the checkout.
No package installation was needed in the established Go environment.

## Devin Secrets Needed

None. No authentication or backend is involved.

# Browser flows

- Clear only `localStorage["lord.save"]` on the test origin, or use Retire,
  before independent fresh-warrior scenarios. Saves persist across reloads.
- Derive current initial stats from `lord.sysml`, not older test reports.
- In town, F enters Forest. L creates an encounter; A advances one round
  rather than resolving the whole forest battle. Observe foe HP in the
  heading, warrior HP, rewards, counters and the returned forest menu.
- C in Forest attempts to catch a fairy once per day. A miss may leave HP1
  and disable C. R,N,F returns through town/new day and reopens Forest.
  Use a declared bounded retry budget; never inject inventory to claim a
  natural gameplay result.
- With a fairy, continue ordinary forest rounds until a lethal foe strike
  consumes it. Check the same round shows "aims a killing blow at you!"
  and "The fairy in your pocket flies free.", no foe miss, healed HP and
  removal of the fairy indicator. Child rescue is progression-gated and
  should be marked untested when not naturally reached.
- Town S opens Slaughter; A asks for the opening move (only Attack until a
  skill has uses and the rival outranks you) and resolves a rival attack.
  Confirm its outcome and subsequent responsive navigation. This does not demonstrate the
  model-internal unwoundable stand-off edge case.
- Town H enters the Healer's Hut without healing; H again heals and charges
  only when hurt and able to pay, and is dimmed otherwise.
- Forest T then G wagers: the outcome reads "The old man rolls the dice..."
  with a win or loss. Inn B: Seth Able's song is named and its effect told;
  B dims afterwards.
- Read-only `lord.view()` returns JSON text for complete state/menu
  comparisons. Compare it and the `lord.save` localStorage entry across a
  UI reload, as well as the visible Welcome back message.
- Query the complete browser console separately after evaluated scripts;
  script-return logs alone are not evidence of absence of app errors.

# Evidence

Record the actual browser and annotate meaningful state changes. Capture
the rescue round before another action dims or removes its log lines.
Label ordinary combat and persistence checks as regression when narration
is the feature under test. Report random branches that did not occur
without treating them as either passes or defects.
