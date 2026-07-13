# DMX Lights

This repository contains DMX light fixture definitions and configuration files for cheap budget DJ lights and a personal at-home lighting setup, specifically targeted for QLC+ v5.

All fixture definitions are written using the [Open Fixture Library (OFL)](https://github.com/OpenLightingProject/open-fixture-library) format for mathematical correctness of DMX boundaries, and then exported to QLC+ v5 compatible XML format (`.qxf`).

---

## Supported Fixtures & Manuals

The following fixtures are currently defined, with links to their manufacturer manuals, OFL definitions, and exported QLC+ v5 profiles:

### 1. Plus Bee Beam Moving Head Light (Armor Plug Bee Beam)

![Plus Bee Beam Moving Head Light](manuals/Armor%20Plug%20Bee%20Beam%20Manual.png)

* **DMX Modes:** 24 or 32 channels
* **Manufacturer Manual:** [Armor Plug Bee Beam Manual.md](manuals/Armor%20Plug%20Bee%20Beam%20Manual.md) (PDF version: [Armor Plug Bee Beam Manual.pdf](manuals/Armor%20Plug%20Bee%20Beam%20Manual.pdf))
* **OFL JSON Definition:** [plus-bee-beam-moving-head.json](tools/ofl/fixtures/alex/plus-bee-beam-moving-head.json)
* **QLC+ v5 Fixture Profile:** [Alex-Plus-Bee-Beam-Moving-Head-Light.qxf](qlc/fixtures/Alex-Plus-Bee-Beam-Moving-Head-Light.qxf)

### 2. LED Mini Moving Light

![LED Mini Moving Light](manuals/LED%20Mini%20Moving%20Light.png)

* **DMX Modes:** 26 channels
* **Manufacturer Manual:** [LED Mini Moving Light.md](manuals/LED%20Mini%20Moving%20Light.md) (PDF version: [LED Mini Moving Light.pdf](manuals/LED%20Mini%20Moving%20Light.pdf))
* **OFL JSON Definition:** [led-mini-moving-light.json](tools/ofl/fixtures/alex/led-mini-moving-light.json)
* **QLC+ v5 Fixture Profile:** [Alex-LED-Mini-Moving-Light.qxf](qlc/fixtures/Alex-LED-Mini-Moving-Light.qxf)

### 3. RGBW Spot Light
* **DMX Modes:** 6 channels
* **Manufacturer Manual:** [RGBW Spot Light Manual.md](manuals/RGBW%20Spot%20Light%20Manual.md)
* **OFL JSON Definition:** [rgbw-spot-light.json](tools/ofl/fixtures/alex/rgbw-spot-light.json)
* **QLC+ v5 Fixture Profile:** [Alex-RGBW-Spot-Light.qxf](qlc/fixtures/Alex-RGBW-Spot-Light.qxf)

### 4. UKing 18 RGBW Wall Washers

![UKing 18 RGBW Wall Washers](manuals/UKing%2018%20RGBW%20Wall%20Washers.png)

* **DMX Modes:** 5, 14, 33, or 37 channels
* **Manufacturer Manual:** [UKing Wall Washers Manual 18 RGBW.md](manuals/UKing%20Wall%20Washers%20Manual%2018%20RGBW.md) (PDF version: [UKing 18 RGBW Wall Washers Manual.pdf](manuals/UKing%2018%20RGBW%20Wall%20Washers%20Manual.pdf))
* **OFL JSON Definition:** [18-rgbw-wall-washers.json](tools/ofl/fixtures/alex/18-rgbw-wall-washers.json)
* **QLC+ v5 Fixture Profile:** [Alex-18-RGBW-Wall-Washers.qxf](qlc/fixtures/Alex-18-RGBW-Wall-Washers.qxf)

---

## QLC+ v5 Setup & Integration

To load these fixture definitions into QLC+ v5 on macOS, copy the exported `.qxf` files to the QLC+ user fixtures directory:

```bash
mkdir -p ~/Library/Application\ Support/QLC+/Fixtures/
cp qlc/fixtures/*.qxf ~/Library/Application\ Support/QLC+/Fixtures/
```

After copying, restart QLC+ v5 and the fixtures will appear under the manufacturer **Alex**.

---

## MIDI Controller: M-Vave SMC Mixer Setup

The at-home setup uses an **M-Vave SMC Mixer** as a physical MIDI controller.

### The Pitch Wheel Quirk
The M-Vave SMC Mixer sends Pitch Wheel messages for its faders, but **sends each fader on a different MIDI channel** (e.g., Fader 1 on Channel 1, Fader 2 on Channel 2, and so on).

To receive all faders correctly, QLC+ v5 must listen to MIDI Channels 1-16 (OMNI mode).

### Setting OMNI Mode on macOS
The QLC+ v5 UI for MIDI configuration does not permit selecting the OMNI range (`1-16`) due to a bug. To force this configuration, ensure QLC+ v5 is **completely closed** and run the following commands in the macOS terminal:

```bash
defaults write org.qlcplus.Q\ Light\ Controller\ Plus midiplugin.Input.SINCO.midichannel -int 16
defaults write org.qlcplus.Q\ Light\ Controller\ Plus midiplugin.Output.SINCO.midichannel -int 16
```
*(Setting the value to `16` writes the internal `MAX_MIDI_CHANNELS` enum, which forces OMNI mode).*

### Pitch Wheel Channel Offset
The official QLC+ v5 documentation states that Pitch Wheel messages map to channel offset `514`. However, QLC+ v5 source code maps them to channel offset `513`. 

If you are manually mapping Pitch Wheel faders in a custom profile, use the OMNI mode offset formula:

```text
Offset = 513 + (4096 * (midi_channel - 1))
```

* Fader 1 (Ch 1): `513`
* Fader 2 (Ch 2): `513 + 4096 = 4609`
* Fader 3 (Ch 3): `513 + (4096 * 2) = 8705`

The built-in **M-Wave SMC Mixer** input profile in QLC+ v5 maps these offsets correctly.

---

## Workflow: OFL JSON to QLC+ v5

The repository includes a vendored subset of the Open Fixture Library in `tools/ofl/` to ensure mathematical correctness of DMX boundaries.

### 1. Writing definitions
Create or edit OFL JSON files in:
`tools/ofl/fixtures/<manufacturer>/<fixture>.json`

### 2. Validating definitions
Run the validation script to verify schema conformity and DMX boundary correctness:
```bash
cd tools/ofl
node tests/fixtures-valid.js -a
```
### 3. Exporting to QLC+ v5

Export the validated definition into a QLC+ v5 compatible XML file (`.qxf`):
```bash
cd tools/ofl
node cli/export-fixture.js -p qlcplus_4.12.2 <manufacturer>/<fixture> -o ../../qlc/
```

### 4. Physical Testing & Iteration
Budget manufacturer manuals frequently contain omissions, errors, or typos. **Never edit the exported `.qxf` file directly.** Instead, follow this physical verification loop:
1. Update the original `.json` in `tools/ofl/fixtures/`.
2. Validate and re-export to `.qxf`.
3. Copy to `~/Library/Application Support/QLC+/Fixtures/`.
4. Restart QLC+ v5 and test using the "Simple Desk" or virtual sliders to observe the physical light behavior.

---

## QLC+ v5 3D Viewer Shapes Gotcha
QLC+ v5 uses the **first** category listed in the OFL JSON `categories` array to determine the 3D model shape. 
- Listing `"Color Changer"` first renders a single round PAR can.
- For physical bars or matrix panels, list structural categories like `"Pixel Bar"` or `"Matrix"` first in the `categories` array.
