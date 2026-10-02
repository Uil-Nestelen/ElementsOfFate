
# Elements of Fate — Element & Combat Framework

> **Purpose:** This is the design reference for elemental spells, interactions, residue, statuses, combat timing, and the systems that implement them.
>
> **Status:** Rules in this document are the current design unless explicitly marked **TBD / Open Decision**.
>
> **Design principle:** Elemental interactions are intentionally capable of creating chaos. Chain reactions are allowed and can create powerful opportunities or backfire on the player.

---

# 1. Core Concepts

## 1.1 Terminology

| Term | Meaning |
|---|---|
| **Element** | Fire, Water, Frost, etc. |
| **Spell** | A castable ability using an element and a spell shape. |
| **Spell Shape** | The geometric/function type of a spell: Bolt, AOE, Wall, Trap, etc. |
| **Residue** | A temporary elemental state attached to a battlefield tile. A tile can contain at most one residue element at a time. |
| **Status Effect** | An effect attached to an entity, such as Burn, Poison, Chill, or Frozen. |
| **Elemental Resolution** | Determining what happens when a newly applied element meets existing elemental residue. |
| **Enhancement** | A successful elemental combination that produces a named elemental interaction. |
| **Nullification** | A pair of elements that cancel each other. Existing residue is removed and the new spell leaves no residue. |
| **Replacement / No Interaction** | The elements have no special interaction. The new element replaces the old residue. |
| **Reaction** | The execution of an elemental enhancement. |
| **Elemental Object** | A persistent battlefield object created by an elemental spell, such as a Wall, Trap, Golem, or special terrain. |
| **Combatant** | An entity participating in combat: player, enemy, or autonomous combat entity such as a Golem. |

## 1.2 The three possible elemental resolutions

Whenever a new elemental spell affects a tile that already contains elemental residue, exactly one happens:

1. **Enhancement**
   - The two elements trigger a named elemental interaction.
   - After the interaction resolves, the newly cast element normally becomes the residue.

2. **Nullification**
   - The two elements cancel.
   - Existing residue is removed.
   - The new spell does not leave residue on that tile.
   - The tile becomes neutral.

3. **Replacement / No Interaction**
   - No special reaction occurs.
   - Existing residue is replaced by the newly cast element.

A tile cannot contain multiple normal elemental residues simultaneously.

---

# 2. Spell Shapes

Not every element can use every shape. The allowed shapes and elemental behaviour are defined in the individual element sections.

## Bolt

- Targets one square.
- Affects one tile for residue purposes.
- Damage/status behaviour depends on the element.

## AOE

- Projectile lands in a 4×4 area.
- Normally affects all 16 squares.
- Entities in the area receive the spell's elemental effect.
- Affected squares receive the spell's residue unless elemental resolution changes that outcome.
- Residue normally lasts until round end.

## Trap

- Places an elemental trap on a selected tile.
- Current temporary cast range: 3 squares.
- Normally activates when another entity enters the trap.
- Can also be activated by an elemental interaction.
- Remains as an elemental object during its lifespan.
- Its tile carries the trap's element while the trap exists.

## Wall

- Creates an 8×1 wall.
- Horizontal or vertical only.
- Default lifespan: 5 turns.
- Cannot be placed directly on an enemy.
- May connect to other walls.
- Overlapping a wall refreshes the replaced sections' 5-turn timer.
- A Physical wall blocks movement.
- A Physical wall blocks normal spells/projectiles that cannot penetrate it.
- Non-Physical walls can be walked through but may apply their elemental effect on contact.
- Wall tiles retain their elemental identity for the wall's lifespan.
- Special removal rules apply; not every spell can remove every wall.

## Self

- Applies the element to the caster.
- Effect depends on the element.
- **Self uses the normal elemental-residue rules.**
- If the caster stands on residue, casting Self can trigger an elemental resolution on that tile.
- Example: Fire residue + Water Self → Water's normal healing occurs, Fire + Water nullifies, Fire residue disappears, and no Water residue remains.

This is intentional and creates positioning risk/reward.

## Star

- Projectile lands at a target point.
- Creates a star made from + and ×.
- Length: 5 squares including the centre.
- Total area: 17 squares.
- Affected squares can interact with residue until round end unless otherwise specified.

## Laser

- Requires sacrificing 3 MP to cast.
- Fires horizontally or vertically.
- Cannot be cast diagonally.
- Normally pierces enemies.
- Has the Pierce property.
- Can pass through penetrable obstacles.
- Destroyable obstacles can be destroyed.

## Cone

- Approximately 90 degrees.
- Reach: 4 squares.
- Occupies a 4×4 area with the caster in one corner.
- Caster's square is excluded.
- Normally affects 15 squares.
- Affected squares can interact with residue until round end unless otherwise specified.

## Aura

- Imbues the caster with elemental magic.
- Reach: 4 squares around the user.
- Affected squares can interact with residue until round end unless otherwise specified.
- Aura does not receive the persistent-object exception used by Walls, Traps, and Golems.
- If the caster stands on residue, normal elemental rules apply.

## Golem

- Creates an autonomous elemental golem.
- Only one golem per caster is allowed for now.
- Chooses its target when summoned and does not change targets afterwards.
- Moves toward and attacks its target.
- If two targets are equally distant:
  1. Choose the lowest-HP target.
  2. If HP is also equal, choose randomly using the battle/run RNG.
- Has 3 MP.
- Difficult terrain can affect its movement.
- Cannot move through other combatants.
- Is a Physical entity and occupies its tile.
- Has no normal HP.
- Disappears after 3 attacks, or earlier when destroyed by an applicable elemental interaction.
- Creates residue from its element on tiles it moves across or interacts with while acting.
- If it neither moves nor attacks during its turn, it creates no new residue.
- Can interact with other elements.

### Golem timing — Open Decision

The document contains two conflicting statements:

- The golem begins moving/attacking immediately when summoned.
- The golem acts at the start of its summoner's turn.

This must be unified before final implementation.

---

# 3. Element System

## Layer 1

- Fire
- Earth
- Water
- Air

## Layer 2

- Void
- Decay
- Frost
- Electro

## Layer 3

- Light
- Dark
- Aether
- Nether

---

# 4. Element Definitions

## 4.1 Fire

### Identity
Damage over time.

### Status
**Burn**
- Indirect damage.
- At round end, an entity takes damage equal to Burn stacks.
- Burn stacks then decrease by 1/3.

### Shape behaviour

- **Bolt:** 3 Burn.
- **AOE:** 1 Burn.
- **Trap:** 6 Burn.
- **Wall:** Fire Wall, 8×1.
  - Contact applies 1 Burn.
  - Walking through applies Burn.
  - Ending a turn in it applies Burn.
  - Starting the next turn while still in contact can apply Burn again.

## 4.2 Earth

### Identity
Physicality, obstacles, blunt force.

### Characteristics

- Spell shapes that physically create something gain the Physical property.
- Physical creations become battlefield obstacles.
- Physical walls block movement and normal projectile paths.
- Earth damage is normally direct Bludgeon damage.

### Shape behaviour

- **Self:** Encases the user in rock, makes them immune to Bludgeon damage, and sets remaining MP to 0 until the start of their next turn.
- **Trap:** 6 damage.
- **Wall:** Physical stone wall, 8×1; spells and entities cannot pass through it.
- **Golem:** Stone Golem.

## 4.3 Water

### Identity
Versatility and adaptability.

Water can specialise into damage, healing, physical effects, and other functions.

### Shape behaviour

- **Bolt:** 3 damage.
- **Self:** Restores 8 HP.
- **AOE:** Large water bubble launched at the target area.
- **Laser:** High-pressure water laser.

## 4.4 Air

### Identity
Displacement and extending other elemental effects through interactions.

### Shape behaviour

- **Bolt:** 1 Bludgeon damage.
- **Self:** Grants 2 additional MP for the current turn.
- **Cone:** Pushes affected entities; collision can deal 3 Bludgeon damage.
- **Aura:** 15% chance for a projectile aimed at the user to bounce back toward the caster.

## 4.5 Void

### Identity
Single-target manipulation and combination.

### Characteristics

- Normally only single-target spells.
- No normal multi-target spell shapes.
- Intended to be weaker alone and powerful in combinations.

### Shape behaviour

- **Bolt:** 3 Psychic damage.
- **Self:** Incoming spells must pass a hit check; a failed spell passes through the user and lands behind them.
- **Trap:** Can eat the next spell travelling over it, or pull an enemy entering its 3×3 zone and reduce its MP by 2.
- **Golem:** Void Golem dealing 2 Bludgeon damage on attack.

## 4.6 Decay

### Identity
Slow, persistent, difficult-to-remove poisoning.

Aether is the primary elemental counter to Decay poison.

### Shape behaviour

- **Golem:** 1 Poison on attack.
- **AOE:** 3 Poison.
- **Trap:** 6 Poison when triggered.
- **Star:** 3 Poison.

## 4.7 Frost

### Identity
Area control and resource disruption.

Frost focuses on MP/AP manipulation and Chill/Frozen.

### Shape behaviour

- **Golem:** 1 Chill on attack.
- **AOE:** 1 Bludgeon damage + 1 Chill.
- **Bolt:** 2 Bludgeon damage + 3 Chill.
- **Star:** 1 Bludgeon damage + 1 Chill.

## 4.8 Electro

### Identity
Shock accumulation and Overload.

### Shape behaviour

- **Aura:** Entities entering gain 2 Shock; they gain 2 more when they end or start their turn in it.
- **Laser:** 5 Shock and can pierce obstacles.
- **Trap:** 6 damage + 10 Shock.
- **Cone:** 3 damage + 5 Shock.

## 4.9 Light

### Identity
Piercing, purification, precision, and cleansing.

### Shape behaviour

- **Laser:** Piercing beam. Pierces enemies and physical obstacles and destroys obstacles it hits, including sections of non-physical walls such as Fire Wall.
- **Star:** Radiating piercing beams.
- **Aura:** Removes negative status effects from the user at the start of their turn.
- **Cone:** Pierces enemies but stops at sufficiently strong obstacles.

## 4.10 Dark

### Identity
Debuffs, concealment, and weakening.

### Shape behaviour

- **Self:** Attacks against the user have a chance to miss until the start of the user's next turn.
- **AOE:** Darkness that reduces enemy vision/range.
- **Wall:** Applies Weakening to enemies passing through.
- **Cone:** Psychic damage + Weakening.

## 4.11 Aether

### Identity
Purity, restoration, and magical manipulation.

### Shape behaviour

- **Self:** Restores HP and removes one negative status and Decay Poison.
- **Golem:** Follows the user and periodically heals nearby allies.
- **Wall:** Purifies/empowers projectiles passing through and removes hostile statuses attempting to cross it.
- **Laser:** Piercing Psychic damage and removes one positive buff from enemies.

## 4.12 Nether

### Identity
Destruction, life/soul manipulation, and synergy with afflicted targets.

### Shape behaviour

- **Aura:** Drains HP from enemies entering or ending their turn inside and heals the user.
- **Wall:** Passing through costs 1 AP.
- **Laser:** Psychic damage; stronger against statused enemies.
- **Cone:** Psychic damage and consumes one existing elemental status on each affected enemy for additional damage.

---

# 5. Elemental Interactions

## 5.1 Enhancement table

| Element 1 | Element 2 | Result | Effect |
|---|---|---|---|
| Fire | Earth | **Magma** | 6 Burn and -1 MP for the current turn. |
| Fire | Air | **Fire Tornado** | Spreads the original Fire effect into a surrounding 3×3 area using the original Burn amount. |
| Fire | Void | **Implosion** | Pulls entities in a 5×5 area toward the reaction point and deals 4 damage. Entities cannot occupy the same tile. |
| Fire | Decay | **Corrosive Burn** | Compare Burn and Poison, take the higher value, add 3, then set both statuses to that value. Example: 3 Burn/2 Poison → 6 Burn/6 Poison. |
| Fire | Electro | **Electrical Overload** | Adds 3 Overload. Overload discharges at round end in a 3×3 area. |
| Earth | Fire | **Magma** | Same as Fire + Earth. |
| Earth | Water | **Mud Puddle** | Reduces MP by 2, rounded up. Frost applied afterwards can freeze the mud shut and prevent movement. |
| Earth | Decay | **Tarpit** | Next Fire hit before round end applies double Burn. Electro instead ignites for 6 Burn; this is not doubled. |
| Earth | Void | **Earthquake** | 4 Bludgeon damage. Nearby Physical walls multiply damage by 3 per wall; walls are destroyed. |
| Earth | Frost | **Frost Quake** | 2 Stabbing damage. |
| Water | Earth | **Mud Puddle** | Same as Earth + Water. |
| Water | Air | **Cyclone** | At the end of the affected entity's turn, it is displaced 2 squares in a random direction. |
| Water | Frost | **PermaFrost** | Creates frozen terrain for 2 rounds. Standing entities lose 1 MP; entering costs additional movement. |
| Water | Decay | **Blightwater** | Contaminates a square for 2 rounds. Entering or ending a turn there gives 2 Poison. Can spread one tile per round through connected Water residue. |
| Water | Electro | **Conductive Surge** | Electricity travels through connected Water residue. Example damage chain: 4 → 3 → 2 → 1. |
| Air | Water | **Cyclone** | Same as Water + Air. |
| Air | Fire | **Fire Tornado** | Same as Fire + Air. |
| Air | Electro | **Lightning Storm** | At round end, 5 lightning strikes hit random squares in the affected area. Entities in the area have a 20% chance per strike to be hit. Each strike applies 3 Overload. |
| Air | Frost | **Blizzard** | Lasts 2 rounds. Anyone starting their turn inside receives 2 Frost stacks and loses 1 MP. |
| Air | Void | **Gravity Vortex** | Displaces the target 3 squares toward the nearest obstacle/structure. Collision damage depends on how many squares were needed: 1 = 6 Bludgeon, 2 = 3, 3 = 1. |
| Void | Fire | **Implosion** | Same as Fire + Void. |
| Void | Earth | **Earthquake** | Same as Earth + Void. |
| Void | Air | **Gravity Vortex** | Same as Air + Void. |
| Void | Electro | **Arcane Blackout** | Everyone cannot cast spells for 2 rounds. The current round counts as the first. |
| Void | Decay | **Miasma** | Affected square is uninhabitable for 2 rounds. Starting or ending a turn there applies 3 Poison. |
| Void | Dark | **Umbral Abyss** | Target loses visibility of enemies for the remainder of the round. |
| Decay | Earth | **Tarpit** | Same as Earth + Decay. |
| Decay | Water | **Blightwater** | Same as Water + Decay. |
| Decay | Fire | **Corrosive Burn** | Same as Fire + Decay. |
| Decay | Void | **Miasma** | Same as Void + Decay. |
| Decay | Frost | **Necrofrost** | Entities killed while affected leave a frozen corpse. Breaking it releases ice shards in a 5×5 area that deal 5 Piercing damage. |
| Decay | Nether | **Corpse Explosion** | Deals 5 direct non-type-specific damage. If this kills the target, nearby entities in a 4×4 area take 4 Bludgeon damage. |
| Frost | Water | **PermaFrost** | Same as Water + Frost. |
| Frost | Air | **Blizzard** | Same as Air + Frost. |
| Frost | Earth | **Frost Quake** | Same as Earth + Frost. |
| Frost | Electro | **Flash Freeze** | Remaining MP becomes 0. If the target moved at least 2 squares before being hit, it also takes 2 Bludgeon damage. |
| Frost | Decay | **Necrofrost** | Same as Decay + Frost. |
| Frost | Light | **Refraction** | 10 damage. Cannot be negated and pierces armour and terrain, including Physical walls. |
| Electro | Air | **Lightning Storm** | Same as Air + Electro. |
| Electro | Water | **Conductive Surge** | Same as Water + Electro. |
| Electro | Fire | **Electrical Overload** | Same as Fire + Electro. |
| Electro | Frost | **Flash Freeze** | Same as Frost + Electro. |
| Electro | Void | **Arcane Blackout** | Same as Void + Electro. |
| Electro | Aether | **Lightning Tether** | Links two entities. Whenever one takes damage, the other receives 20% of that damage as Electrical damage. Lasts 2 rounds. |
| Light | Dark | **Umbral Twilight** | Target remembers the last known positions of entities; movement after the effect is not noticed. |
| Light | Frost | **Refraction** | Same as Frost + Light. |
| Dark | Light | **Umbral Twilight** | Same interaction; current design specifies a 1-round duration. |
| Dark | Void | **Umbral Abyss** | Same as Void + Dark. |
| Aether | Nether | **Paradox** | Stores the last elemental effect applied to the square and repeats it at round end. |
| Aether | Electro | **Lightning Tether** | Same as Electro + Aether. |
| Nether | Aether | **Paradox** | Same as Aether + Nether. |
| Nether | Decay | **Corpse Explosion** | Same as Decay + Nether. |

---

# 6. Nullification

When a pair is nullifying:

- The spell's ordinary direct/status effects still resolve.
- Existing residue is removed.
- The new spell leaves no residue on the affected tile.
- The tile becomes neutral.

| Element 1 | Element 2 |
|---|---|
| Fire | Water |
| Fire | Frost |
| Water | Fire |
| Water | Void |
| Earth | Air |
| Earth | Electro |
| Air | Earth |
| Air | Decay |
| Void | Frost |
| Void | Water |
| Decay | Air |
| Decay | Electro |
| Frost | Fire |
| Frost | Void |
| Electro | Earth |
| Electro | Decay |

---

# 7. No Interaction / Replacement

Every pair not present in the Enhancement or Nullification tables is non-interactive.

When this happens:

1. The spell's ordinary effects resolve.
2. Old residue is replaced.
3. The new element becomes the tile's residue.

Example:

Fire residue + Dark spell
→ Dark does not react with Fire.
→ Fire residue becomes Dark residue.

---

# 8. Elemental Residue

## 8.1 Basic rule

Whenever a spell affects a battlefield tile, that tile normally receives the spell's elemental residue.

Examples:

- Fire Bolt → 1 Fire residue tile.
- Fire AOE → 16 Fire residue tiles.

Residue normally disappears at round end.

## 8.2 Purpose

Residue exists primarily so later elemental spells can interact with the battlefield.

The core process is:

Existing residue + newly applied element
→ Elemental Resolution
→ Enhancement / Nullification / Replacement

## 8.3 Persistent exceptions

### Wall

- Wall element remains attached to the wall for its lifespan.
- Wall tiles continue to carry its elemental identity.
- The wall is treated as an elemental object rather than ordinary one-round residue.

### Trap

- Trap tile carries its element for the trap's lifespan.
- The trap remains until triggered, destroyed, or otherwise removed.

### Golem

- Golem applies its element to tiles it moves across or interacts with during its turn.
- If it does not move or attack, it creates no new residue.

### Self and Aura

Self and Aura follow normal residue rules and do not receive the persistent-object exception.

---

# 9. Spell Resolution

## 9.1 Current formal sequence

1. Caster selects a spell.
2. Check whether the caster is allowed to cast it.
3. Check required resources, including AP and special MP costs.
4. Select target/location.
5. Cast the spell.
6. Pay the spell's AP cost.
7. Determine affected tiles/entities.
8. Apply the spell's immediate effects:
   - Damage.
   - Statuses.
   - Movement/displacement.
   - Shape-specific behaviour.
9. Check existing elemental residue on each affected tile.
10. Resolve the elemental relationship.
11. Execute enhancements.
12. Queue effects created by those enhancements.
13. Write the resulting residue according to Enhancement, Nullification, or Replacement.
14. Resolve queued chain effects after the original spell and its direct elemental resolutions finish.
15. Return control to the caster if they can continue acting.

## 9.2 Example: Fire AOE → Decay AOE

### Fire AOE

- Pay 1 AP.
- Determine 16 tiles.
- Apply Fire's normal effects.
- No residue exists.
- Write Fire residue to all 16 tiles.

### Decay AOE

- Pay 1 AP.
- Determine 16 tiles.
- Apply 3 Poison.
- Check all 16 tiles.
- Fire residue exists.
- Fire + Decay = Corrosive Burn.
- Resolve Corrosive Burn wherever applicable.
- Replace affected Fire residue with Decay residue.

The interaction is evaluated for all affected tiles, even if some tiles contain no entity to receive the resulting effect.

---

# 10. Chain Reactions

## 10.1 Chain reactions are intentional

Elemental interactions can initiate additional elemental interactions.

This is a core part of the intended game identity.

A chain can be:

Spell → Residue → Interaction → New effect → New tiles → Interaction → New effect → ...

Chains can be extremely powerful or can backfire.

## 10.2 Chain timing

A chain reaction does not interrupt the middle of the original spell's basic resolution.

Order:

Original spell
→ original spell effects
→ original residue resolutions
→ original interaction results
→ queue chain effects
→ resolve queued chain effects
→ resolve further reactions they create

## 10.3 Multiple interactions in one turn

A combatant can trigger multiple elemental interactions during one turn.

Example:

- AP 1: Fire spell.
- AP 2: Decay spell → Corrosive Burn.
- AP 3: Electro spell → Electrical Overload.

Walls, Self spells, Traps, Golems, and other elemental objects can also participate where their rules permit.

---

# 11. Round and Turn Timing

## 11.1 Round definition

A round consists of:

1. Player turn.
2. Enemy 1 turn.
3. Enemy 2 turn.
4. Additional enemy turns as needed.
5. Round-end resolution.
6. Next round.

A round ends once the player and all enemies have completed their turns.

## 11.2 Turn structure

### Start of turn
- Start-of-turn effects.
- Relevant persistent-object effects.
- Other effects explicitly defined as starting at the beginning of the turn.

### Actions
- Movement.
- Spell casting.
- Other available actions.

### End of turn
- End-of-turn effects.
- Effects explicitly defined to trigger when the entity ends its turn.

## 11.3 Canonical round-end order

1. Burn damage.
2. Poison damage.
3. Overload discharge.
4. Shock removal.
5. Chill decay.
6. Residue removal.
7. Resource refresh.
8. Increment round counter.
9. Start next round.

---

# 12. AP and MP

## AP — Action Points

- Default maximum: 3 AP.
- Determines how many spells/actions an entity can perform.
- Normal spell cost: 1 AP unless specified otherwise.
- Cannot fall below 0.
- Effects may increase/decrease AP.
- Temporary/permanent modifications must specify duration.
- Refreshed to maximum at round end.

## MP — Movement Points

- Default maximum: 3 MP.
- Determines normal movement.
- Cannot fall below 0.
- Effects may increase/decrease MP.
- Temporary/permanent modifications must specify duration.
- Refreshed to maximum at round end.

### Magical displacement

Involuntary magical displacement does not consume MP.

This intentionally allows elemental interactions to move entities beyond their normal movement capacity.

---

# 13. Status Effects

## Burn

- Damage equal to Burn stacks at round end.
- Burn stacks then decrease by 1/3.

## Poison

- Round-end damage equal to half Poison stacks, rounded down.

## Chill

- Stacks up to 10.
- Whenever an application causes Chill to reach 10, the target immediately becomes Frozen.
- This check happens whenever Chill is applied, regardless of whose turn it is.
- On reaching 10:
  - Chill is removed.
  - Target becomes Frozen.
- If the target does not become Frozen, 4 Chill stacks are removed at the relevant end-of-turn cleanup.

## Frozen

- Entity cannot move during its turn.

## Shock

- Accumulates toward 20.
- At 20, entity gains 1 Overload.
- Shock is completely removed at round end.

## Overload

- Stores electrical energy.
- At round end, discharges in a 3×3 area.
- Damage depends on Overload stacks.

## Weakening

- Reduces damage dealt to 2/3 of normal.
- Does not reduce status-type effects.
- Applies to damage portions of spells and elemental interactions.

## Blindness / Visibility

Behaviour depends on the source.

Examples:
- Making enemies invisible.
- Making the player invisible.
- Making the affected entity remember the last known position of another entity.

## MP Reduction

Reduces movement capacity. Default maximum is 3 unless changed by relics or other upgrades.

## AP Reduction

Reduces action capacity. Default maximum is 3 unless changed by relics or other upgrades.

---

# 14. Damage Types

## Direct

Damage received immediately when a spell/effect interacts with its target.

## Indirect

Damage delayed until a defined timing point, such as end of turn or end of round.

## Psychic

Damage that affects the mind.

Current intended property:
- Not blocked by nullification.
- Not blocked by defensive Self spell variants intended to protect against physical damage.

## Bludgeon

Physical blunt-force damage.

Typical sources:
- Earth magic.
- Collision with Physical terrain.
- Collision with Physical entities/objects.

## Stabbing

Physical sharp damage.

Typical sources:
- Ice shards.
- Sharp terrain effects.

## Pierce

The physical counterpart to Psychic.

Piercing effects trade some raw damage potential for penetration and can:
- Penetrate certain defensive Self shapes.
- Penetrate Physical walls/obstacles.
- Interact with terrain that ordinary physical attacks cannot pass through.

---

# 15. Movement and Displacement

## 15.1 Displacement

Displacement is involuntary magical movement and does not consume MP.

## 15.2 Collision rules

### Another entity

Takes Bludgeon collision damage.

Exact collision damage: **TBD**.

### Physical wall

Takes Bludgeon collision damage.

### Non-Physical wall

The entity can phase into/through it according to that wall's rules and receives the wall's effect as if it entered/contacted it normally.

Example: Fire Wall → Burn.

### Battlefield edge

The battlefield is currently intended to be surrounded by Physical walls.

### Impassable tile

Treat as an object with the Physical property.

### Multiple obstacles

No current mechanic requires a formal rule for simultaneous collision with multiple obstacles.

### Newly created wall

Treat the same as an existing wall.

---

# 16. End-of-Round Death Resolution

Current rule:

1. Entity receives a lethal effect.
2. Entity dies.
3. Death effects resolve.
4. Already queued effects continue resolving.
5. Entity is removed when appropriate.

Effects already present on an entity continue to resolve even if that entity is already dead.

This should be implemented as a deliberate queued-resolution system rather than relying only on object existence.

---

# 17. Deterministic Combat Randomness

All combat randomness must originate from the deterministic battle/run RNG.

Do not use arbitrary global random calls for combat mechanics.

This applies to:
- Random Golem target selection when targets are tied.
- Cyclone displacement direction.
- Lightning Storm strike locations.
- Lightning Storm hit chances.
- Void/self hit checks.
- Future combat randomness.

Goal:

Same run seed + same player decisions + same combat state = same combat result.

---

# 18. Persistent Elemental Objects

Persistent objects should be handled as their own system rather than ordinary one-round residue.

Relevant objects include:
- Walls.
- Traps.
- Golems.
- Frozen corpses.
- Special terrain created by interactions.

## Object interaction principle

An elemental object can be directly targeted by a spell where its rules allow it.

Examples:
- A Golem can be removed by directly hitting it with an appropriate spell.
- A Trap can be triggered or otherwise interacted with according to its rules.
- Walls can be destroyed by specific effects such as Light Laser or Earthquake where applicable.

---

# 19. Combat System Architecture

The elemental design should not be placed entirely inside BattleManager or TurnManager.

The intended architecture is:

    BattleManager
    ├── TurnManager
    ├── Action / Spell System
    ├── ElementSystem
    ├── StatusSystem
    ├── Battlefield / Grid
    ├── Combatants
    └── Battle / Run RNG

## BattleManager

Coordinates the battle as a whole:
- Battle state.
- System coordination.
- Battle start/end.
- High-level phase control.

It should not contain every elemental rule.

## TurnManager

Responsible for:
- Whose turn it is.
- Turn transitions.
- Round transitions.
- Start/end turn notifications.
- Start/end round notifications.

It should not implement Burn, Poison, elemental interactions, spell geometry, etc.

## Action / Spell System

Responsible for:
- Validating actions.
- Paying AP/MP costs.
- Determining affected tiles.
- Executing spell behaviour.
- Sending resulting effects into the appropriate systems.

## ElementSystem

Responsible for:
- Elemental residue.
- Enhancement lookup.
- Nullification lookup.
- Replacement lookup.
- Elemental resolution.
- Interaction execution.
- Chain-reaction queuing.

## StatusSystem

Responsible for:
- Applying/removing statuses.
- Status thresholds.
- Start/end turn status effects.
- Round-end status effects.
- Death-related status resolution.

## Battlefield / Grid

Responsible for:
- Tile occupancy.
- Terrain.
- Obstacles.
- Physical properties.
- Spatial queries.
- Movement/pathing support.

## Combatants

Responsible for:
- HP.
- AP/MP state.
- Position.
- Personal buffs/debuffs.
- Available spells.
- Turn-specific state.

## RNG

Responsible for deterministic combat randomness.

---

# 20. Recommended High-Level Combat Flow

    BattleManager
        ↓
    TurnManager starts turn
        ↓
    Start-of-turn effects
        ↓
    Combatant acts
        ↓
    Action / Spell System
        ↓
    Validate action
        ↓
    Pay resources
        ↓
    Determine affected tiles/entities
        ↓
    Apply immediate spell effects
        ↓
    ElementSystem checks residue
        ↓
    Elemental Resolution
        ├── Enhancement
        ├── Nullification
        └── Replacement
        ↓
    Queue chain reactions
        ↓
    Resolve queued chain reactions
        ↓
    Return control to combatant
        ↓
    End turn
        ↓
    Next combatant
        ↓
    Round end
        ↓
    Status round-end resolution
        ↓
    Burn
        ↓
    Poison
        ↓
    Overload
        ↓
    Shock cleanup
        ↓
    Chill cleanup
        ↓
    Residue cleanup
        ↓
    Resource refresh
        ↓
    Next round

---

# 21. Elemental Resolution Algorithm

    New elemental effect reaches tile
                ↓
        Does tile have residue?
           /             \
         No               Yes
         ↓                 ↓
    Write new        Compare old + new
    residue                ↓
                 ┌─────────┼─────────┐
                 ↓         ↓         ↓
            Enhancement Nullification Replacement
                 ↓         ↓         ↓
               React    Clear tile   Replace old
                 ↓         ↓         ↓
            New effects Neutral     New residue
                 ↓
          Queue chain effects

---

# 22. Element Acquisition and Shrines

## Starting elements

The starting wizard provides one Layer 1 element:
- Fire
- Earth
- Water
- Air

## Upgrading elements

Shrines offer three choices.

The left-most option attempts to provide an upgrade.

An upgrade can:
- Advance an element to the next layer.
- Provide a perk.

Example:

Fire → Void → Dark

Taking a perk on an element locks that element from further elemental advancement.

## Duplicate elements

Duplicate elements are not allowed.

If an element is already owned elsewhere, the Shrine cannot provide that same element as another elemental upgrade.

The Shrine attempts to provide at least one valid upgrade. Other options are randomised.

If all three spell slots are already infused with elements, Shrine offerings are restricted to those existing elements.

## Perks

Perks modify elemental behaviour rather than simply increasing base damage.

A perk can:
- Modify a status.
- Change spell behaviour.
- Add/change an interaction.
- Change an elemental characteristic.
- Create a new tactical use.

Example concept:

A Frost perk could make Frozen targets take damage in addition to being unable to move.

The detailed perk catalogue still needs to be designed.

---

# 23. Open Decisions / Explicit TBDs

These are intentionally separated from established rules so unfinished ideas do not become accidental implementation requirements.

## Combat / elemental rules

- Exact interaction behaviour for every persistent object in every edge case.
- Exact collision damage when displacement hits an entity/object.
- Exact handling when multiple obstacles could theoretically be collided with simultaneously.
- More detailed defence rules for Psychic and Pierce.
- Exact implementation of some interaction-generated terrain/effects.
- Full formalisation of queued chain-reaction data structures.
- Exact Golem initial-action timing: immediately on summon vs start of summoner's next turn.

## Balance / content

- Implosion pull positioning details.
- Lightning Storm detailed strike selection/repeated-hit behaviour.
- Conductive Surge damage falloff beyond the current example.
- Future perk values and catalogue.
- Shrine/perk catalogue.
- Encounter/boss balancing.
- Event encounter design.

---

# 24. Historical Notes

The original brainstorming process contained questions such as:
- Does every pair of elements need an explicit result?
- Can a tile contain multiple elemental residue?
- Exactly when does an interaction trigger?
- Can interactions chain?
- How do AP/MP refresh?
- How do damage types interact with defenses?

Decisions have now been made for most of these and converted into explicit rules above.

Older brainstorming wording should not be treated as a second source of truth. If an older note conflicts with this document, this document takes priority unless the newer design is explicitly changed again.

---

# 25. Encounter Types Reference

This section is retained for completeness but is separate from the elemental combat rules.

## Combat

Normal battle encounter. Winning provides money for Shops. If player HP reaches 0, the run ends.

## Elite

Stronger combat encounter with greater rewards. Current intended difficulty target: approximately 1.5×–2× normal combat.

## Shrine

Allows elemental progression and perks. Spell shapes cannot be swapped during the run; preparation happens before the run.

## Shop

Allows spending money on Relics and health.

## Event

TBD.

## Rest

Restores approximately 25% of maximum HP.

## Mystery

The encounter type is hidden until entered.

Current intended outcomes:
- Shrine
- Shop
- Rest
- Treasure
- Combat
- Elite
- Trap

The intended distribution is slightly more positive than negative.

## Treasure

Provides Relics.

## Trap

Currently only encountered through Mystery. Deals 7.5% of maximum HP.

## Boss

Final encounter of a floor. Current intended difficulty: approximately 3×–4× normal combat.

Boss elemental design depends on the player's starting class/element.

Difficulty intent:
- **Easy:** Boss uses elemental spells that are countered by the player's build.
- **Normal:** Boss receives random spells plus relics/boosters.
- **Hard:** Boss receives spells designed to counter the player's build plus relics.

---

# 26. Implementation Principle

Implement the elemental system from the rules in this document rather than translating the brainstorming history directly into code.

The most important boundaries are:

1. **TurnManager controls time.**
2. **Action/Spell System controls actions and spell execution.**
3. **ElementSystem controls elemental resolution and chain reactions.**
4. **StatusSystem controls statuses and their timing.**
5. **Battlefield/Grid controls spatial state.**
6. **Combatants own personal combat state.**
7. **Battle/Run RNG controls combat randomness.**
8. **BattleManager coordinates the systems instead of containing all their rules.**

The intended result is a combat system where complex elemental interactions can grow without turning BattleManager or TurnManager into giant, unmaintainable classes.
