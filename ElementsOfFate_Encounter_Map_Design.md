# ElementsOfFate — Encounter Map Design

## 1. Overview

The encounter map is the structure through which the player progresses through a floor in **ElementsOfFate**.

The map is a **layered directed graph**, rather than a traditional tree. Players move forward through a sequence of encounter levels, while paths can split and later merge again.

The player can see the complete map of the current run/floor from the beginning, allowing them to plan their route.

---

## 2. Floor Structure

A run consists of **5 floors**.

Each floor contains:

- **10 normal encounter levels**
- **1 boss level**

Therefore, the player completes **10 encounters before reaching the floor boss**.

The structure is:

```text
Level 1
   ↓
Level 2
   ↓
Level 3
   ↓
...
   ↓
Level 10
   ↓
Level 11 — Floor Boss
```

Each of levels 1–10 contains **2 or 3 encounter nodes**, chosen randomly.

The boss is a single node that all valid routes on that floor eventually lead to.

---

## 3. Encounter Types

There are currently **7 encounter types**:

1. **Combat**
   - Normal battle encounter.
   - This should generally have the highest generation weight.

2. **Elite Combat**
   - More difficult battle encounter.
   - On Floor 1, elite encounters cannot appear during the first 3 encounter levels.
   - On later floors, elites may appear from the beginning of the floor.

3. **Element / Spell Shrine**
   - A special interaction related to the game's elemental/spell systems.

4. **Shop**
   - Allows the player to purchase available goods/upgrades.

5. **Event**
   - A special event with an outcome determined by the event.

6. **Rest / Heal**
   - Allows the player to recover/heal.

7. **Mystery**
   - The map shows the node as unknown (for example, `???`).
   - The actual encounter type is hidden until the player enters it.
   - The hidden encounter is randomly selected from the available encounter types.

Encounter weights will be configurable and centralized so they can easily be adjusted during balancing and playtesting.

---

## 4. Map Visibility

The player can see the **entire generated map** from the beginning.

This allows the player to plan a route based on:

- Encounter types
- Branches
- Merges
- Future encounters
- The eventual boss

Mystery nodes are the exception: their existence is visible, but their actual encounter type is hidden until entered.

---

## 5. Layered Graph Structure

The map is not a conventional tree.

It is a **directed acyclic graph (DAG) organized into levels**.

For example:

```text
Level 1             Level 2             Level 3

    A ─────────────── B ─────────────── D
     \─────────────── C ─────────────── D

    E ─────────────── F ─────────────── G
```

Paths may:

- Split into multiple routes.
- Merge back together.
- Continue forward through the map.
- Eventually converge on the same boss.

The player can never move backwards.

---

## 6. Nodes Per Level

Each normal encounter level contains either:

- **2 nodes**, or
- **3 nodes**

The number is randomized independently for each level.

For example:

```text
Level 1:  A  B
Level 2:  A  B  C
Level 3:  A  B
Level 4:  A  B  C
```

This means that the shape of the map can vary considerably between runs.

---

## 7. Connections

Connections follow strict structural rules.

### Forward only

A node may only connect to nodes on the **immediately following level**.

Connections may never skip levels.

Valid:

```text
Level 1 → Level 2
Level 2 → Level 3
Level 3 → Level 4
```

Invalid:

```text
Level 1 → Level 3
```

The player can never travel backwards.

---

## 8. Incoming Connection Rule

Every node must have **at least one incoming connection from the previous level**.

This prevents genuinely unreachable/orphaned nodes.

For example, this is valid:

```text
Level 1             Level 2

   A ───────────────→ B
    \───────────────→ C

   D ───────────────→ E
```

Every Level 2 node has at least one possible route into it.

This is invalid:

```text
Level 1             Level 2

   A ───────────────→ B
    \───────────────→ C

   D

                       E
```

Node `E` is invalid because no node on Level 1 connects to it.

### Important distinction

A node being **structurally reachable** is different from being reachable from the player's **current position**.

For example:

```text
Level 1             Level 2

   A ───────────────→ B
    \───────────────→ C

   D ───────────────→ E
```

If the player chooses `A`, then `E` is no longer accessible to them.

That is intentional.

The player chose the `A` branch and therefore cannot access the nodes that required choosing `D`.

This is valid map behavior.

The rule is therefore:

> Every node must have a valid incoming connection, but not every node needs to be reachable from every possible player choice.

---

## 9. Outgoing Connection Rule

Every normal encounter node must have **at least one outgoing connection** to the next level.

This prevents dead ends before the player reaches the boss.

The only exception is the final normal encounter level, where nodes connect toward the floor boss.

The floor boss itself is the final destination.

---

## 10. Branching

Branches are an important part of the map.

A node can connect to multiple nodes on the next level.

For example:

```text
Level 1             Level 2

   A ───────────────→ B
    ├───────────────→ C
    └───────────────→ D
```

This gives the player multiple future choices.

The number of outgoing connections should remain controlled so the map does not become completely interconnected.

The current design allows a node to connect to **up to 2 or 3 nodes**, depending on the generated layout and connection rules.

---

## 11. Merging Paths

Branches can reconnect later.

For example:

```text
Level 1             Level 2             Level 3

   A ───────────────→ B ───────────────→ D
    \───────────────→ C ───────────────→ D
```

Both possible routes eventually lead to the same node.

There should be approximately **1–2 meaningful merges per floor**.

Merging prevents the map from becoming a collection of completely isolated routes and allows interesting strategic decisions where different paths eventually reconnect.

---

## 12. Boss Convergence

All paths on a floor eventually converge on the same boss.

The final structure is therefore:

```text
                 ┌── Route A ──┐
                 │             │
Start → branches ├── Route B ──┼──→ FLOOR BOSS
                 │             │
                 └── Route C ──┘
```

The player fights the boss of the current floor after completing the 10 normal encounter levels.

There is only one boss node per floor.

---

## 13. Encounter Generation Weights

Encounter types use **weighted random generation**.

Normal Combat should have the highest weight initially.

Example configuration:

```text
Combat       = 40
Elite        = 10
Shrine       = 10
Shop         = 10
Event        = 10
Rest         = 10
Mystery      = 10
```

These values are **illustrative only and are not final balancing values**.

The actual values will be determined through testing and balancing.

The important design requirement is:

> Encounter weights must be centralized and easy to modify.

Generation rules such as elite restrictions should also be centralized rather than scattered throughout the generator.

---

## 14. Elite Generation Rules

### Floor 1

Elite encounters cannot appear on:

```text
Level 1
Level 2
Level 3
```

They can begin appearing from:

```text
Level 4+
```

### Later floors

There is no equivalent early-level restriction.

This means a later floor can potentially begin with:

```text
Level 1

Combat
Elite
Shrine
```

This is intended to allow later floors to challenge the build earlier.

---

## 15. Mystery Encounters

Mystery encounters have two pieces of information:

```text
Visible type:
    MYSTERY

Hidden type:
    One of the normal encounter types
```

For example:

```text
Map display:

    ???

Internally:

    MYSTERY
       ↓
    Hidden type = SHOP
```

When the player enters the node:

```text
???
 ↓
Reveal
 ↓
SHOP
```

The map should therefore retain the hidden encounter information while only revealing the appropriate information to the player.

---

## 16. Seeded Runs

Each complete run has **one master seed**.

The master seed determines the complete five-floor run:

```text
                    MASTER SEED
                         │
       ┌─────────────────┼─────────────────┐
       ↓                 ↓                 ↓
    Floor 1           Floor 2           Floor 3
       │                 │                 │
       └───────────────┬─┴─────────────────┘
                       │
                  Floor 4
                       │
                  Floor 5
```

The important rule is:

> **One seed produces one complete, reproducible five-floor run.**

The same seed should generate the same:

- Floor layouts
- Node counts
- Connections
- Encounter types
- Mystery hidden types
- Other map-generation randomness

This is intended to support potential future features such as player-vs-player runs using the same seed.

---

## 17. Generation vs Loading

Although the complete run is generated from the master seed, the game does not need to instantiate all floors as active gameplay objects.

Conceptually:

```text
Master Seed
    ↓
Generate complete run data
    ↓
┌────────┬────────┬────────┬────────┬────────┐
│ Floor 1│ Floor 2│ Floor 3│ Floor 4│ Floor 5│
│  Data  │  Data  │  Data  │  Data  │  Data  │
└────────┴────────┴────────┴────────┴────────┘
    ↓
Load/instantiate only the current floor
```

This preserves deterministic generation while avoiding unnecessary active gameplay objects.

---

## 18. Recommended Architecture

The encounter-map system should separate **data**, **generation**, **rules**, and **presentation**.

Recommended structure:

```text
Scripts/
└── EncounterMap/
    ├── EncounterMap.gd
    ├── EncounterNode.gd
    ├── EncounterGenerator.gd
    ├── EncounterRules.gd
    ├── EncounterType.gd
    └── EncounterMapUI.gd
```

### EncounterType.gd

Defines the available encounter types:

```text
COMBAT
ELITE
SHRINE
SHOP
EVENT
REST
MYSTERY
BOSS
```

### EncounterNode.gd

Represents an individual map node.

It should contain information such as:

- Level
- Encounter type
- Hidden encounter type, if applicable
- Connections to other nodes
- Whether it has been visited
- Whether it has been completed

### EncounterMap.gd

Owns the generated map/floor data.

It can contain:

- Floor number
- Seed information
- Nodes
- Current node
- Progress information

### EncounterRules.gd

Contains configurable generation rules:

- Nodes per level
- Encounter weights
- Elite restrictions
- Maximum outgoing connections
- Merge limits
- Other balancing rules

### EncounterGenerator.gd

Responsible for generating the graph using:

- Master seed
- Floor information
- Encounter rules

It should produce valid encounter-map data rather than directly controlling the UI.

### EncounterMapUI.gd

Responsible only for displaying the generated map.

The generator should not need to know whether a node is represented by:

- A circle
- An icon
- A line
- An animation
- A future custom UI element

---

## 19. Core Design Principles

The encounter-map system should follow these principles:

1. **The player always moves forward.**
2. **The player can see the whole map and plan ahead.**
3. **Each normal level contains 2–3 nodes.**
4. **Paths can split.**
5. **Paths can merge.**
6. **No connection can skip a level.**
7. **Every node must have a valid incoming connection.**
8. **A node can become inaccessible because of an earlier player choice.**
9. **Every non-boss node must eventually lead forward toward the boss.**
10. **All routes on a floor eventually converge on one boss.**
11. **Encounter types are weighted and centrally configurable.**
12. **Mystery encounters hide their actual type until entered.**
13. **The complete five-floor run is determined by one master seed.**
14. **The map data and map presentation should remain separate.**

---

## 20. Example Conceptual Floor

A simplified example:

```text
                    FLOOR BOSS
                        ▲
                   ┌────┴────┐
                   │         │
               Level 10   Level 10
                 Node       Node
                   ▲         ▲
                ┌──┴──┐   ┌──┴──┐
                │     │   │     │
             Level 9 ... ... Level 9
                ▲
             branches
                ▲
             Level 1
             /      \
          Start A   Start B
```

The exact layout is randomized.

A player might choose:

```text
Start A
   ↓
Combat
   ↓
Shop
   ↓
Event
   ↓
Elite
   ↓
...
   ↓
Boss
```

while another player using the same generated map might choose a completely different valid route.

---

## 21. Current Specification Status

The following decisions are considered established for the current implementation plan:

| System | Decision |
|---|---|
| Floors per run | 5 |
| Normal encounter levels per floor | 10 |
| Boss level | 11 |
| Nodes per normal level | Randomly 2–3 |
| Encounter types | Combat, Elite, Shrine, Shop, Event, Rest, Mystery |
| Player movement | Forward only |
| Level skipping | Not allowed |
| Branching | Allowed |
| Merging | Allowed |
| Approximate merges | 1–2 per floor |
| Incoming connections | Every node needs at least one |
| Outgoing connections | Every normal node needs at least one |
| Boss convergence | All routes eventually reach one boss |
| Map visibility | Entire map visible |
| Mystery visibility | Actual type hidden |
| Encounter generation | Weighted random |
| Weights | Centralized/configurable |
| Floor 1 elite restriction | No elites on first 3 levels |
| Later-floor elite restriction | None |
| Run seed | One master seed |
| Seed scope | Complete 5-floor run |
| Active floor loading | Only current floor needs to be instantiated |
| Map architecture | Data, generation, rules, and UI separated |

---

## 22. Next Design Task

Before implementing the encounter-map generator, the next step should be to define the **exact graph-generation algorithm**.

We should work through several concrete examples of:

- 2-node levels
- 3-node levels
- Branches
- Merges
- Different node counts between consecutive levels
- The transition into the boss
- How the generator guarantees there are no orphaned nodes
- How the generator guarantees there are no dead ends

Once those rules are defined, the `EncounterGenerator` can be implemented incrementally and tested independently from the visual map UI.
