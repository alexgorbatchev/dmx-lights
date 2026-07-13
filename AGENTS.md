# DMX Lights

This project is dedicated to creating DMX light fixture definitions for DJ lights based on manufacturer manuals.

## Setup
- All source materials and manufacturer documentation are located in the `manuals/` directory.
- We target QLC+ v5 for our fixture definitions.
- All QLC-related files and outputs must be kept strictly within the `qlc/` directory.
- We use the Open Fixture Library (OFL) format/repo (https://github.com/OpenLightingProject/open-fixture-library) as a reference and potential tool for creating and managing these definitions.
- **MIDI Controller:** We use an M-Vave SMC Mixer. 
  - **The Quirk:** It sends Pitch Wheel messages for its faders, but *each fader is sent on a different MIDI channel* (Fader 1 on Ch 1, Fader 2 on Ch 2, etc.).
  - **QLC+ Setup:** QLC+ must be configured to listen to MIDI Channels `1-16` (OMNI mode) to receive all faders.
  - **How to set OMNI in QLC+ v5 (macOS):** The QLC+ v5 UI for MIDI configuration is bugged and does not allow selecting the OMNI range (`1-16`). You must force this configuration via the macOS terminal while QLC+ is **completely closed**:
    ```bash
    defaults write org.qlcplus.Q\ Light\ Controller\ Plus midiplugin.Input.SINCO.midichannel -int 16
    defaults write org.qlcplus.Q\ Light\ Controller\ Plus midiplugin.Output.SINCO.midichannel -int 16
    ```
    *(Note: Setting the value to `16` in the plist corresponds to the internal `MAX_MIDI_CHANNELS` enum, which triggers OMNI mode).*
  - **Profile:** Use the built-in "M-Wave SMC Mixer" input profile in QLC+ (which correctly maps the Pitch Wheel offsets).
  - **QLC+ Documentation Warning:** The official QLC+ documentation incorrectly states that Pitch Wheel messages are mapped to channel offset `514`. Inspecting the source code reveals the actual offset is `513`. If you ever need to manually map a Pitch Wheel fader in a custom profile, the formula for OMNI mode is `513 + (4096 * (midi_channel - 1))`. For example, Fader 2 on MIDI Channel 2 is `513 + 4096 = 4609`. Do not use `514`.

## Fixture Workflow (OFL JSON -> QLC+)
We use a vendored subset of the Open Fixture Library located in `tools/ofl/` to ensure mathematical correctness of DMX boundaries.
1. **Write:** Create OFL JSON files in `tools/ofl/fixtures/<manufacturer>/<fixture>.json`.
2. **Validate:** Run the validation script to ensure schema conformity and DMX boundary correctness:
   ```bash
   cd tools/ofl
   node tests/fixtures-valid.js -a
   ```
3. **Export:** Once valid, export the fixture to QLC+ XML (`.qxf`):
   ```bash
   cd tools/ofl
   node cli/export-fixture.js -p qlcplus_4.12.2 <manufacturer>/<fixture> -o ../../qlc/
   ```

## Verification and Iteration Loop
Because manufacturer manuals frequently contain lies, typos, or omitted details, static verification is not enough. You must physically verify the fixture.
1. **Load into QLC+:** On macOS, QLC+ loads user fixtures directly from `~/Library/Application Support/QLC+/Fixtures/` and input profiles from `~/Library/Application Support/QLC+/InputProfiles/`. **Agents MUST automatically copy `.qxf` files and `.qxi` files there after every export without waiting for a user prompt:**
   ```bash
   mkdir -p ~/Library/Application\ Support/QLC+/Fixtures/ ~/Library/Application\ Support/QLC+/InputProfiles/
   cp qlc/fixtures/*.qxf ~/Library/Application\ Support/QLC+/Fixtures/
   cp -f qlc/inputprofiles/*.qxi ~/Library/Application\ Support/QLC+/InputProfiles/ 2>/dev/null || true
   ```
   Restart QLC+, and they will automatically appear under the manufacturer "Alex" when you add a fixture.
2. **Physical Testing:** Use the "Simple Desk" or virtual sliders in QLC+ to manually sweep through the 0-255 ranges for each channel. Observe the physical light to ensure the manual's claims match reality (especially for macro channels, strobe speeds, and pan/tilt degrees).
3. **Iterate:** If the physical light behaves differently than the manual states, **NEVER** edit the exported `.qxf` file directly. Instead:
   - Update the original `.json` in `tools/ofl/fixtures/`.
   - Re-run the validation script.
   - Re-export the `.qxf`.
   - Reload the fixture in QLC+.

## Conventions
- Proactively update this `AGENTS.md` file to automatically capture any new project details, context, or rules provided by the user.
- Rely on the original markdown and PDF manuals in the `manuals/` directory for fixture DMX channel mappings and descriptions.
- Ensure all DMX definitions perfectly match the 0-255 value ranges and channel orders specified in the manuals.
- Name fixture definition files consistently with the manual names (e.g., `LED Mini Moving Light`).
- If physical fixture dimensions are not specified in the printed manual, check the user's prompt or ask the user for these dimensions (as `[width, height, depth]` in millimeters) and include them in the OFL JSON definition.

## Gotchas
- **QLC+ 3D Viewer Shapes:** QLC+ uses the *first* category listed in the OFL JSON `categories` array to determine the 3D model shape. If you define a linear bar but list `"Color Changer"` first, QLC+ will render a single round PAR can. Always list structural categories like `"Pixel Bar"` or `"Matrix"` first if you want the 3D viewer to render a physical bar.
- Manufacturer manuals sometimes contain typos or confusing macro channel descriptions; carefully check the value ranges (e.g., 0-10 vs 11-255).
- Some lights have multiple DMX channel modes (e.g., 14-channel vs 37-channel mode). Make sure to account for all available modes when creating definitions.

## Boundaries
- Always: double-check DMX channel numbers and value ranges against the source `manuals/*.md` documentation.
- Ask first: before guessing or inferring missing information that is not explicitly defined in the manual.
- Never: modify the source manuals in `manuals/` unless explicitly requested to correct errors or improve formatting.
