# Roguelike Game Concept — Mechanics

> Working document for the current game concept.  
> This document intentionally focuses on the **core mechanics and structure** that have been brainstormed so far. Detailed element mechanics, spell upgrades, enemies, and balance will be designed later.

---

## 1. Core Concept

The game is a **single-player roguelike** with an additional **PvP/competitive mode** planned as a separate game mode.

The main goal is to give players a large amount of freedom to create different builds during each run.

The intended design philosophy is:

> **The class gives the player a starting direction, but does not determine the final build.**

Players should be able to make meaningful choices throughout a run and end up with builds that can play very differently from one another.

---

## 2. Classes

At the beginning of a run, the player selects a starting class.

Examples:

- Pyromancer
- Hemomancer
- Cryomancer
- Other classes to be designed later

A class currently provides only:

1. **A starting element on one of the player's three spells**
2. **A class passive**

The class should give the player an initial direction without locking them into a specific build.

### Example: Pyromancer

The player starts with:

- Spell 1: Fire + selected spell shape
- Spell 2: No element yet
- Spell 3: No element yet

The other two spells can receive an element during the run.

The exact class passives will be designed later.

---

## 3. Spells

The player has **three spells** available during a run.

The intention is to keep the number of spells small so that each spell is important to the player's build.

### Spell Construction

A spell is primarily defined by:

**Element + Spell Shape**

Examples of spell shapes:

- Bolt
- AoE
- Trap
- Wall
- Shield
- Other shapes to be designed later

The element determines the spell's mechanical identity, while the shape determines how the spell behaves spatially or tactically.

For example:

- Fire + Bolt
- Ice + AoE
- Blood + Trap

These combinations should create different tools without requiring a completely separate spell for every combination.

---

## 4. Spell Shape Unlocks

Spell shapes are unlocked outside of the individual run, primarily through **achievements/progression**.

Once unlocked, the player can select their three spell shapes **before starting a run**.

The player is free to choose any combination of unlocked shapes.

Examples:

- 3 × AoE
- 1 × Bolt + 1 × AoE + 1 × Trap
- 1 × Shield + 1 × Bolt + 1 × Wall

This means the player can prepare a general playstyle before entering a run, while the elements acquired during the run determine how that playstyle develops.

The exact unlock system and achievement requirements will be designed later.

---

## 5. Elements

Elements are a major part of the build system.

An element should not simply represent a different damage colour/type. Each element should have its own **mechanical identity** and encourage a different style of play.

Current examples:

- **Fire** — Burn / damage over time
- **Ice** — Slow / eventual Freeze-style control
- **Blood** — Healing and HP manipulation

These are only examples of the intended design direction. The complete element list and their detailed mechanics will be designed later.

### Important Design Principle

> **Elements should change how the player plays, not simply what damage type the player deals.**

Each element should ideally provide something mechanically distinctive that other elements do not naturally provide.

---

## 6. Element Acquisition

The player can acquire elements during a run.

One planned method is through **element shrines** on the map.

A spell without an element can be assigned an element at a suitable shrine.

Example:

> Pyromancer starts with Firebolt, while the other two spells are initially unaligned.  
> The player reaches a shrine and chooses Ice for their AoE spell.

The exact shrine system and available choices will be designed later.

---

## 7. Element-Based Spell Upgrades

Shrines can also be used to develop spells that already have an element.

If a player already has a Fire spell and encounters a Fire shrine, they can choose Fire again to further develop that spell.

The intention is that repeated investment into an element should **change or evolve the behaviour of the spell**, rather than simply providing generic numerical increases.

Example concept:

> Fire spell → Fire shrine → an upgrade that causes Burn to decay differently.

This is only an example. The actual upgrade effects and upgrade trees will be designed later.

The desired result is that two players can start with the same spell but evolve it into substantially different versions during their runs.

---

## 8. Relics

Relics are the main additional item system currently planned.

Relics provide **passive effects** and can influence the player's build.

There are currently no active-use items planned.

The purpose of relics is to create additional build possibilities and interactions between the player's spells and other mechanics.

Examples of possible relic effects will be designed later.

### Design Philosophy

Relics should help create emergent builds rather than simply provide flat stat increases whenever possible.

---

## 9. Combat System

The game is intended to use **turn-based, moment-to-moment tactical combat**.

The current concept is based around a grid.

The player takes a turn, performs actions, and then the enemy takes its turn.

### Action Points

The game is expected to use **Action Points (AP)** for combat actions such as casting spells.

The exact number of AP per turn has **not been decided yet**.

Questions such as:

- How many AP the player receives
- How much different spells cost
- Whether powerful spells can cost multiple AP
- What happens to unused AP

will be designed later.

### Movement Points

Movement is separate from Action Points.

The current idea is:

> **3 Movement Points (MP) per turn**

A movement point allows the player to move approximately one grid square.

This creates a distinction between:

- **MP** — positioning
- **AP** — combat actions

The exact movement rules can be adjusted during development.

---

## 10. Grid-Based Arenas

Combat takes place in a predetermined arena using a grid.

The exact dimensions of the grid are not fixed.

For example, the arena does not necessarily have to be a simple 8×8 grid.

Some grid squares can be inaccessible because of:

- Rocks
- Obstacles
- Environmental structures
- Other terrain

This means different encounters can have different layouts.

The intention is for positioning to become another layer of skill and decision-making on top of the player's build decisions.

### Visual Presentation

The initial implementation can use a simple grid and basic backgrounds.

Later, once the core game is working, the arena/background can change based on the enemy or encounter.

The visual environment should not be the priority during the initial development stage.

---

## 11. Enemy Turns

The exact enemy behaviour has not been designed yet.

Possible systems such as:

- Telegraphing enemy attacks
- Predictable enemy intentions
- Random behaviour
- Reactions/counterattacks
- Enemy abilities

will be designed after the core player mechanics are established.

For now, the priority is building the basic combat framework.

---

## 12. Unused Actions

The game has not yet decided what happens when the player does not use all available AP.

Possible future ideas include:

- Losing unused AP
- Saving AP
- Converting unused AP into defense
- Having relics interact with unused AP
- Generating another resource from unused AP

This system is intentionally left undecided for now.

---

## 13. Run Structure

A run is divided into multiple floors.

Each floor contains a **branching path/tree** of encounters.

The player chooses which path to take as they progress.

A simplified example:

```text
             START
               |
       +-------+-------+
       |       |       |
     Combat  Shrine   Event
       |       |       |
     Elite   Combat   Shop
       |       |       |
       +-------+-------+
               |
              BOSS
               |
            NEXT FLOOR
```

The exact node types and tree generation are still open for development.

### Possible Encounter Types

Currently considered:

- Combat
- Elite combat
- Element/Spell Shrine
- Shop
- Events
- Boss

The exact number and rules for each type will be designed later.

---

## 14. Floor Structure

The current concept is:

> **Branching tree → Boss → New floor → New branching tree**

A standard run may eventually contain approximately **5 floors**, with a boss at the end of each floor.

This is not finalized.

---

## 15. Run Completion

Two possible modes are currently considered.

### Standard Run

A finite run consisting of multiple floors, potentially:

> **5 floors + a boss at the end of each floor**

The exact number is not final.

### Endless Mode

An endless mode could allow players to continue fighting for as long as possible.

This could be used for:

- Leaderboards
- High-score chasing
- Build experimentation
- Competitive challenges

The exact endless-mode rules are not yet designed.

---

## 16. Multiplayer / PvP

Multiplayer is currently considered an **additional game mode**, rather than the foundation of the game.

The single-player roguelike should be designed and made fun first.

One possible competitive mode that has been discussed is a **same-seed race**.

### Same-Seed Concept

Two players receive the same run conditions:

- Same map/seed
- Same encounters
- Same potential rewards
- Same general progression opportunities

However, each player makes their own decisions.

The players then compete to see who can progress furthest or complete the run fastest.

This would test:

> **Who can build and play more effectively using the same resources?**

This idea is currently only a concept and should be revisited after the single-player game is established.

### Element Combination System

Directly combining different elements together was discussed as a possible future mechanic.

For now:

> **Element combinations are intentionally NOT part of the core design.**

The idea is being kept as a possible future addition if the game eventually needs more depth.

---

## 17. Current Core Gameplay Loop

The current concept can be summarized as:

```text
Choose Class
     ↓
Choose 3 Spell Shapes
     ↓
Start Run
     ↓
Choose a Path
     ↓
Combat / Shrine / Shop / Event / Elite
     ↓
Acquire Elements / Upgrade Spells / Obtain Relics
     ↓
Develop Build
     ↓
Fight Boss
     ↓
Move to Next Floor
     ↓
Repeat
     ↓
Final Boss / Endless Mode
```

---

## 18. Current Design Philosophy

The most important goals established so far are:

### Build Variety

The game should support a very large number of viable builds.

The goal is not to manually create hundreds of predefined builds, but to create systems that naturally produce many combinations.

### Player Choice

The player should make meaningful decisions throughout the run.

Choices should influence both:

- Immediate combat effectiveness
- Long-term build direction

### Class Freedom

A class should provide a starting identity without locking the player into a specific build.

### Mechanical Elements

Elements should have unique gameplay identities.

They should change how the player approaches combat.

### Spell Identity

The player's three spells should be important and distinct.

A spell should be capable of evolving during a run rather than remaining static.

### Tactical Combat

The combination of:

- Action Points
- Movement Points
- Grid positioning
- Spell shapes
- Enemy positioning
- Terrain

should create meaningful tactical decisions.

### Emergent Builds

The best builds should ideally emerge from the player's choices rather than being selected directly from a menu.

---

# 19. Systems Intentionally Left for Later

The following systems have **not been fully designed yet** and should not block initial development:

- Complete element list
- Detailed element mechanics
- Element status effects
- Element-specific shrine upgrades
- Spell upgrade trees
- Complete spell-shape list
- Exact AP amount
- AP costs
- Unused AP behaviour
- Enemy AI
- Enemy types
- Boss mechanics
- Relic catalogue
- Relic balance
- Events
- Shops
- Exact map generation
- Exact floor count
- Final boss
- Endless-mode rules
- PvP rules
- Story/lore
- Visual presentation

These can be designed progressively after the basic gameplay framework is functioning.

---

# 20. Recommended Initial Development Focus

The first playable prototype should **not** attempt to implement the entire roguelike.

The first goal should be a simple combat sandbox.

### Prototype 1

Implement:

1. Grid
2. Player
3. Player movement
4. Movement Points
5. Basic turn system
6. Action Points
7. One basic spell
8. Spell targeting
9. One basic enemy
10. Enemy turn
11. Basic damage/HP
12. Turn transition

Once this is fun and functional, begin adding:

```text
Grid
 ↓
Movement
 ↓
Actions
 ↓
Spells
 ↓
Spell Shapes
 ↓
Elements
 ↓
Spell Upgrades
 ↓
Relics
 ↓
Encounters
 ↓
Branching Map
 ↓
Bosses
 ↓
Full Runs
 ↓
Multiplayer
```

This keeps the project manageable while allowing the underlying systems to grow into the larger roguelike concept.
