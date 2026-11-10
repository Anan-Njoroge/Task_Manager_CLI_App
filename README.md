Project 1: Elixir CLI Task Tracker
==================================

Welcome to **Project 1** of the 15-project Elixir Mastery Curriculum! This project establishes the foundational building blocks of functional programming, immutable data structures, pattern matching, structural sharing, and interactive command-line interface design using Elixir.

1\. Project Overview & Architecture
-----------------------------------

The **Elixir CLI Task Tracker** is a pure-functional command-line application built from scratch using Elixir, the `Mix` build tool, and `IEx` (Interactive Elixir).

The application adheres to a strict **Separation of Concerns**, cleanly dividing the codebase into two distinct architectural layers:

- **The Core Business Logic (`TaskManager`)**: Located in `lib/task_manager.ex`. This module functions as the core engine---managing structs, data transformations, list operations, and state transitions without any knowledge of terminals, user input, or IO streams.

- **The Interface Layer (`TaskManager.CLI`)**: Located in `lib/task_manager/cli.ex`. This module handles command-line interaction (`IO.gets` / `IO.puts`), parses user input safely via case statements, and uses tail recursion to maintain application state across an interactive loop.

2\. Core Functional Concepts Addressed
--------------------------------------

Transitioning from object-oriented or imperative paradigms to Elixir requires mastering several core functional concepts implemented in this project:

- **Immutability & Data Transformations**: In Elixir, data cannot be mutated in place. Every state update returns a brand-new copy of the data structure, ensuring thread safety, predictability, and eliminating hidden side effects.

- **Structural Sharing**: To prevent massive memory overhead when transforming large lists, Elixir reuses pointers to unchanged elements. When a list is modified, only the changed element is duplicated; all unchanged elements are safely referenced in memory, yielding optimal $O(1)$ and $O(N)$ efficiency.

- **Tail Recursion**: Because Elixir lacks traditional mutable loops (like `while` or `for`), long-running processes such as the interactive CLI menu are sustained using **tail-optimized recursion**. The function calls itself with the newly updated state, passing the baton forward efficiently without growing the call stack.

- **Process-Based Garbage Collection & Reachability**: The BEAM virtual machine isolates garbage collection per lightweight process. Unchanged or abandoned data structures are cleaned up based on **reachability** (zero active pointers remaining) rather than global stop-the-world pauses.

3\. Data Structures & Structs
-----------------------------

Tasks are modeled using a custom Elixir `struct` inside the `TaskManager` module, offering compile-time safety and strict field enforcement.

Elixir

```
defmodule TaskManager do
  defstruct [:id, :title, status: :pending]

  # Business logic implementations...
end

```

- **Required Fields (`:id`, `:title`)**: Declared without default values inside the struct definition, forcing the caller to supply unique identifiers and titles when instantiating tasks.

- **Default Values (`status: :pending`)**: Declared using keyword list syntax (`status: :pending`), automatically assigning the `:pending` state unless explicitly overridden.

4\. API Reference & Functions Included
--------------------------------------

### Core Business Logic (`TaskManager`)

- **`add_task(tasks, title)`**

  - **Signature**:  `def add_task(tasks, title)`

  - **Description**: Computes a unique incremental ID based on list length, instantiates a new `%TaskManager{}` struct, and prepends it using the high-performance cons operator `[new_task | tasks]` ($O(1)$ complexity).

- **`list_by_status(tasks, target_status)`**

  - **Signature**:  `def list_by_status(tasks, target_status)`

  - **Description**: Filters the task list using `Enum.filter/2` combined with pattern matching directly in the anonymous function clauses to isolate tasks matching the target status (`:pending` or `:completed`).

- **`complete_task(tasks, target_id)`**

  - **Signature**:  `def complete_task(tasks, target_id)`

  - **Description**: Iterates through the list using `Enum.map/2`, targets the specific task using the **pin operator (`^target_id`)**, and updates its status using Elixir's struct update syntax (`%{task | status: :completed}`).

- **`update_task(tasks, target_id, new_title)`**

  - **Signature**:  `def update_task(tasks, target_id, new_title)`

  - **Description**: Safely modifies the title of a specific task matching the pinned ID while preserving its unique identifier and current completion status.

- **`delete_task(tasks, target_id)`**

  - **Signature**:  `def delete_task(tasks, target_id)`

  - **Description**: Rejects and removes a task from the list by ID using `Enum.reject/2` and the pin operator to match the target.

### Interactive CLI (`TaskManager.CLI`)

- **`start(tasks \\ [])`**

  - **Signature**:  `def start(tasks \\ [])`

  - **Description**: Entry point for the interactive terminal application. Prints the welcome banner and invokes the recursive loop with the initial task state.

5\. Usage & Testing Examples
----------------------------

### Testing Core CRUD Functions in IEx

Boot up your interactive Elixir shell and compile the project:

Bash

```
iex.bat -S mix

```

Execute core operations directly in the shell:

Elixir

```
# 1. Initialize an empty task list
iex> tasks = []

# 2. Add tasks
iex> tasks = TaskManager.add_task(tasks, "Learn Elixir Immutability")
iex> tasks = TaskManager.add_task(tasks, "Master Structural Sharing")

# 3. List pending tasks
iex> TaskManager.list_by_status(tasks, :pending)

# 4. Mark a task as completed (ID 1)
iex> tasks = TaskManager.complete_task(tasks, 1)

# 5. Update a task title (ID 2)
iex> tasks = TaskManager.update_task(tasks, 2, "Master Structural Sharing & Pointer Reuse")

# 6. Delete a task (ID 1)
iex> tasks = TaskManager.delete_task(tasks, 1)

```

### Launching the Interactive CLI Menu

To launch the full interactive terminal application:

Elixir

```
iex> TaskManager.CLI.start()

```

Terminal Output Menu Example:

Plaintext

```
==============================
   ✨ ELIXIR TASK TRACKER ✨
==============================

What would you like to do?
1. Add a task
2. List all tasks
3. Complete a task
4. Update a task
5. Delete a task
6. Exit

Enter choice (1-6):
```
