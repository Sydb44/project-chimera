# Project Chimera: Developer Context

**Version: 1.0**
**Last Updated:** July 23, 2025

This document is the single source of truth for all developers and AI agents working on Project Chimera. All work must adhere to the standards defined herein.

---

## 1. Core Vision & Guiding Principles

[cite_start]The goal of Project Chimera is not simply to create a game, but to "simulate a universe"[cite: 3]. [cite_start]Our development is guided by a core philosophy of **"System Over Content"**[cite: 3].

- **Explained Fantasy:** All non-realistic technology (e.g., nanobots, FTL travel) must be justified by a consistent, in-universe logic that provides clear avenues for gameplay, interaction, and systemic failure.
- [cite_start]**Story Generator:** We are building a "story generator," not a traditional game with a linear plot[cite: 16]. [cite_start]The most compelling narratives are those that emerge organically from the collision of complex systems[cite: 17].
- [cite_start]**The Two Sandboxes:** The architecture is built on two deeply connected sandboxes: the **Micro Sandbox** of the player's ship and the **Macro Sandbox** of the universe[cite: 6, 29]. [cite_start]The seamless flow of causality between these two is the project's central design challenge[cite: 30, 31].

---

## 2. Core Architectural Pillars

The architecture of Project Chimera is built upon the following four pillars, which stem from our core "Explained Fantasy" philosophy:

* **Nanofarm Technology:** A unified system for programmable nanobots used for construction, repair, and specialized tasks. This forms a core resource and crafting loop for both the player and their ship.
* **Logical Arcade Flight:** An intuitive, "atmospheric" flight model that is directly and logically governed by the state of the ship's internal systems. System failures must have a natural and predictable impact on flight performance.
* **Navigable Dangers (Astrogation):** An FTL travel system based on a plausible in-universe phenomenon that makes course-plotting a strategic decision with tangible risks and rewards.
* **Systemic Zero-G:** On-board character gameplay that treats zero-gravity not just as a movement mode, but as a systemic state with emergent consequences for repair, combat, and interaction.

---

## 3. Technical Stack

- **Game Engine:** Godot (3D Rendering Pipeline)
- **Programming Language:** GDScript
- **Version Control:** Git
- **Repository:** GitHub (`Sydb44/project-chimera`)

---

## 4. Development Workflow

- **Branching Strategy:**
  - `main`: This branch is for stable, production-ready code only. It is protected.
  - `develop`: This is the primary integration branch. It should always be stable and runnable. It is our default branch.
  - **Feature Branches:** All work must be done on a feature branch created from `develop`.
- **Branch Naming:** Branches must be prefixed according to their purpose:
  - `feat/`: For new features (e.g., `feat/power-grid-logic`).
  - `fix/`: For bug fixes (e.g., `fix/power-calculation-error`).
  - `docs/`: For documentation changes (e.g., `docs/update-context-file`).
  - `chore/`: For maintenance tasks (e.g., `chore/update-godot-version`).
- **Commits:** All commit messages **must** follow the **Conventional Commits** specification.
  - **Format:** `<type>(<scope>): <subject>`
  - **Example:** `feat(power): implement power grid simulation logic`
- **Pull Requests (PRs):** All code must be merged into `develop` via a Pull Request. The Project Lead is responsible for reviewing and merging all PRs.

---

## 5. Coding Standards (GDScript)

- **Formatting:** All code formatting is enforced by the `.editorconfig` file in the root of the repository. It must be respected.
- **Naming Conventions:**
  - **Classes/Nodes:** `PascalCase` (e.g., `PowerGrid`, `ShipComponent`).
  - **Functions & Variables:** `snake_case` (e.g., `update_grid_state`, `current_power`).
  - **Signals:** `snake_case` (e.g., `component_failed`).
  - **Constants:** `ALL_CAPS_SNAKE_CASE` (e.g., `MAX_POWER_OUTPUT`).

---

## 6. Document Governance

This is a living document. As our project evolves, this file will be updated. All changes to this document must be made via a Pull Request on a `docs/` branch and approved by the Project Lead.
