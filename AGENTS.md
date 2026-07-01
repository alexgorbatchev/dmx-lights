# DMX Lights

This project is dedicated to creating DMX light fixture definitions for DJ lights based on manufacturer manuals.

## Setup
- All source materials and manufacturer documentation are located in the `manuals/` directory.
- We target QLC+ v5 for our fixture definitions.
- All QLC-related files and outputs must be kept strictly within the `qlc/` directory.
- We use the Open Fixture Library (OFL) format/repo (https://github.com/OpenLightingProject/open-fixture-library) as a reference and potential tool for creating and managing these definitions.

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

## Conventions
- Proactively update this `AGENTS.md` file to automatically capture any new project details, context, or rules provided by the user.
- Rely on the original markdown and PDF manuals in the `manuals/` directory for fixture DMX channel mappings and descriptions.
- Ensure all DMX definitions perfectly match the 0-255 value ranges and channel orders specified in the manuals.
- Name fixture definition files consistently with the manual names (e.g., `LED Mini Moving Light`).

## Gotchas
- Manufacturer manuals sometimes contain typos or confusing macro channel descriptions; carefully check the value ranges (e.g., 0-10 vs 11-255).
- Some lights have multiple DMX channel modes (e.g., 14-channel vs 37-channel mode). Make sure to account for all available modes when creating definitions.

## Boundaries
- Always: double-check DMX channel numbers and value ranges against the source `manuals/*.md` documentation.
- Ask first: before guessing or inferring missing information that is not explicitly defined in the manual.
- Never: modify the source manuals in `manuals/` unless explicitly requested to correct errors or improve formatting.
