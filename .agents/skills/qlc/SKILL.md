# QLC+ (v5)

This skill provides domain knowledge, gotchas, and workflows for working with QLC+ v5, OFL (Open Fixture Library), and MIDI configurations, especially on macOS.

## Key Paths (macOS)
- **Fixtures:** `~/Library/Application Support/QLC+/Fixtures/`
- **Input Profiles:** `~/Library/Application Support/QLC+/InputProfiles/`

## Known Quirks & Bugs

### MIDI OMNI Mode Configuration Bug (macOS)
The QLC+ v5 UI for MIDI configuration is bugged and does not allow selecting the OMNI range (`1-16`) via the dropdown/spinner. To force OMNI mode, QLC+ must be completely closed, and you must use the terminal to patch the `.plist` file:

```bash
defaults write org.qlcplus.Q\ Light\ Controller\ Plus midiplugin.Input.SINCO.midichannel -int 16
defaults write org.qlcplus.Q\ Light\ Controller\ Plus midiplugin.Output.SINCO.midichannel -int 16
```
*(Note: Replace `SINCO` with the exact device name string if using a different controller. Setting the value to `16` corresponds to the internal `MAX_MIDI_CHANNELS` constant, which triggers OMNI mode).*

### Pitch Wheel Channel Offset Documentation Error
The official QLC+ documentation incorrectly states that Pitch Wheel messages map to channel offset `514`. Inspecting the source code reveals the actual base offset is `513`. 
- **Formula for OMNI mode mapping:** `513 + (4096 * (midi_channel - 1))`
- **Example:** Fader 2 sending Pitch Wheel on MIDI Channel 2 translates to `513 + (4096 * 1) = 4609`. Do not base math on 514.

## Hardware specifics: M-Vave SMC Mixer
- **The Quirk:** Sends Pitch Wheel messages for its faders, but *each fader is on a different MIDI channel* (Fader 1 on Ch 1, Fader 2 on Ch 2, etc.).
- **Requirement:** Must use OMNI mode (see bug above).
- **Profile:** Use the built-in "M-Wave SMC Mixer" input profile, which correctly implements the `513` base Pitch Wheel offsets.

## OFL (Open Fixture Library) Workflow
When creating new fixture definitions:
1. **Author:** Create OFL JSON files in `tools/ofl/fixtures/<manufacturer>/<fixture>.json`.
2. **Validate:** `node tests/fixtures-valid.js -a` (run from `tools/ofl/`)
3. **Export:** `node cli/export-fixture.js -p qlcplus_4.12.2 <manufacturer>/<fixture> -o ../../qlc/` (run from `tools/ofl/`)
4. **Deploy:** Automatically copy `.qxf` exports to `~/Library/Application Support/QLC+/Fixtures/` and `.qxi` to `~/Library/Application Support/QLC+/InputProfiles/`. 
5. **Verify:** Restart QLC+ and physically verify channel bindings using the Simple Desk or virtual sliders.
