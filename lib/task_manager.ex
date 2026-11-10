defmodule TaskManager do
  @moduledoc """
  Documentation for `TaskManager`.
  """

  # Define a clean struct for our tasks
  defstruct [:id, :title, status: :pending]

  @doc """
  Adds a new task to an existing list of tasks.
  Uses Elixir's list prepend operator ([ | ]) for high performance.
  """

  def add_task(tasks, title) do
    # Generate a simple incremental ID based on list length + 1
    new_id = length(tasks) + 1

    new_task = %TaskManager{id: new_id, title: title, status: :pending}

    # Prepend the new task to the front of the list
    [new_task | tasks]
  end

  @doc """
  Filters the task list by a given status (e.g., :pending or :completed).
  Uses Elixir's Enum.filter/2 combined with pattern matching for clarity and performance.
  """
  def list_by_status(tasks, target_status) do
    Enum.filter(tasks, fn %TaskManager{status: status} ->
    status == target_status
    end)
  end

  @doc """
  Finds a task by its ID and updates its status to :completed.
  Uses Enum.map/2 to traverse the list and pattern matching to identify the task, struct update syntax, and the Pin operator (^).
  """
  def complete_task(tasks, target_id) do
    Enum.map(tasks, fn
      # Match the task whose ID matches our target_id
      %TaskManager{id: ^target_id} = task ->
        # Update the status to :completed using struct update syntax
        %{task | status: :completed}

        # For all other tasks, leave them unchanged.
        task ->
          task
      end
      )
  end

  @doc """
  Finds a task by its ID and updates its title.
  """
 def update_task_title(tasks, target_id, new_title) do
  Enum.map(tasks, fn
    # Match the target task using the pin operator (^)
    %TaskManager{id: ^target_id} = task ->
      %{task | title: new_title}

      # Leave all other tasks untouched
      task ->
        task
    end
    )
 end

 @doc """
 Deletes a task from the list by its ID.
 Uses Enum.reject and the pin operator (^) to filter out the task with the specified ID.
 """
 def delete_task(tasks, target_id) do
  Enum.reject(tasks, fn
    %TaskManager{id: ^target_id} -> true
    # Keep all other tasks in the list
    _ -> false
    end)
 end
end
