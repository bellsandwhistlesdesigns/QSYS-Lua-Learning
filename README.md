# Q-SYS Lua Learning

This new repository documents my learning journey with Lua programming and AV control system development, with a focus on Q-SYS-style control logic and device driver architecture.

---

## Structure

### Basics
Fundamental Lua concepts and small exercises, including:
- Variables and data types
- Tables and data structures
- Functions
- Control flow (if/loops)
- Event-driven patterns

### Projects

#### AV Control System
A simulated AV control system designed to practice:
- Lua tables for state management
- Function-based control logic
- Event-driven programming concepts
- System state modeling

---

## System Architecture

```mermaid
flowchart TD

%% =========================
%% PHYSICAL INPUT LAYER
%% =========================
BP[Button Panel<br/>Physical Inputs]

%% =========================
%% EVENT SYSTEM
%% =========================
EB[Event Bus<br/>Router]

%% =========================
%% EVENT HANDLERS
%% =========================
EH[Event Handlers<br/>Toggle / Volume / Scene]

%% =========================
%% SCENE ENGINE
%% =========================
SE[Scene Engine<br/>Data-Driven Scenes]

%% =========================
%% DEVICE LAYER
%% =========================
DL[Device Layer<br/>State Mutations]

%% =========================
%% ROOM SYSTEM
%% =========================
R[Room Objects<br/>State Tables]

%% =========================
%% UI LAYER
%% =========================
UI[UI System<br/>Dashboard + Event Render]

%% =========================
%% SYSTEM CORE
%% =========================
SYS[System Core<br/>Rooms Registry]

BP --> EB
EB --> EH
EB --> SE

EH --> DL
SE --> DL

DL --> R

R --> UI
R --> EB

SYS --> R
```

```mermaid
sequenceDiagram

participant BP as ButtonPanel
participant EB as EventBus
participant EH as EventHandler
participant SE as SceneEngine
participant DL as Device Layer
participant R as Room State
participant UI as Dashboard

BP->>EB: Press("PresentationButton")
EB->>SE: RunScene(Presentation)
SE->>DL: Set projectorOn = true
SE->>DL: Set lightsOn = false
DL->>R: Update state
R->>UI: Push state update
UI->>BP: Render new status

```


#### TCP Socket Projector Driver
A simulated projector driver focused on control system architecture:
- Driver structure and design patterns
- Command parsing and formatting
- Device feedback handling
- State tracking via tables
- Concepts of TCP-based communication

Planned enhancements:
- Q-SYS `TcpSocket.New()` integration concepts
- Event handlers and callbacks
- Polling mechanisms
- Auto-reconnect logic
- Production-style driver architecture

---

##  Learning Goals

- Build real-world AV control logic using Lua
- Understand driver architecture patterns
- Model device state reliably
- Transition from scripts → structured control systems

---

##  License & Usage

© 2026 Douglas Moth – Bells & Whistles Designs. All rights reserved.

This repository is provided for portfolio and evaluation purposes only.

No permission is granted to use, copy, modify, or distribute this code
without explicit written consent from the author.