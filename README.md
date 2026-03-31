# Wesnoth Roguelite

A roguelite campaign add-on for [Battle for Wesnoth](https://www.wesnoth.org/).

Fight through procedurally generated floors. When you die, choose an upgrade and try again. Each run is different. How far can you go?

## How It Works

- Each floor has a **randomly generated map** (Lua map generator)
- On death, your hero's `last_breath` is intercepted — no campaign restart
- You see your **run stats**, pick a **permanent perk**, and loop back for a new run
- Perks accumulate across runs: more HP, more gold, more income
- Enemy difficulty scales with floor number

## Installation

Copy or symlink this folder to your Wesnoth `userdata/data/add-ons/Wesnoth_Roguelite/` directory.

## License

GPL v2.0 — see [LICENSE](LICENSE).
