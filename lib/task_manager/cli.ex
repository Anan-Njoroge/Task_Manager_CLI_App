defmodule TaskManager.CLI do
  alias TaskManager

  @doc """
  Starts the interactive task tracker loop. It continuously prompts the user for input until they choose to exit. It uses tail recursion to maintain state (the list of tasks) across iterations.
  """
  def start(tasks \\ []) do
    IO.puts("\n==============================")
    IO.puts("   ✨ ELIXIR TASK TRACKER ✨   ")
    IO.puts("==============================")

    # The loop function is called with the current list of tasks, allowing it to maintain state across user interactions
    loop(tasks)
  end

  # The recursive loop that keeps the CLI running until the user decides to exit.
  defp loop(tasks) do
    IO.puts("\nWhat would you like to do?")
    IO.puts("1. Add a task")
    IO.puts("2. List all tasks")
    IO.puts("3. Complete a task")
    IO.puts("4. Update a task")
    IO.puts("5. Delete a task")
    IO.puts("6. Exit")

    # Prompt the user for their choice and trim any whitespace.
    choice = IO.gets("\nEnter choice (1-6): ") |> String.trim()
    #
    handle_choice(choice, tasks)
  end

  # Choice 1: Add a new task.
  defp handle_choice("1", tasks) do
    title = IO.gets("Enter task title: ") |> String.trim()
    new_tasks = TaskManager.add_task(tasks, title)
    IO.puts("✨ Task added successfully!")
    loop(new_tasks)
  end

  # Choice 2: List all tasks.
  defp handle_choice("2", tasks) do
    IO.puts("\n--- Your Task List ---")

    if Enum.empty?(tasks) do
      IO.puts("No tasks found.")
    else
      # Print each task with its ID, status icon, title, and status text.
      Enum.each(tasks, fn task ->
        status_icon = if task.status == :completed, do: "✅", else: "⏳"
        IO.puts("[ID: #{task.id}] #{status_icon} #{task.title} (#{task.status})")
      end)
    end

    loop(tasks)
  end

  # Choice 3: Complete a task by ID.
  defp handle_choice("3", tasks) do
    id_str = IO.gets("Enter task ID to complete: ") |> String.trim()

    case Integer.parse(id_str) do
      {id, ""} ->
        new_tasks = TaskManager.complete_task(tasks, id)
        IO.puts("✅ Task #{id} marked as completed!")
        loop(new_tasks)
      _ ->
        IO.puts("❌ Invalid ID. Please enter a valid number.")
        loop(tasks)
    end
  end

  # Choice 4: Update a task's title by ID.
  defp handle_choice("4", tasks) do
    id_str = IO.gets("Enter task ID to update: ") |> String.trim()

    case Integer.parse(id_str) do
      {id, ""} ->
        new_title = IO.gets("Enter new title: ") |> String.trim()
        new_tasks = TaskManager.update_task_title(tasks, id, new_title)
        IO.puts("✏️ Task #{id} updated!")
        loop(new_tasks)

      _ ->
        IO.puts("❌ Invalid ID.")
        loop(tasks)
    end
  end

  # Choice 5: Delete a task by ID.
  defp handle_choice("5", tasks) do
    id_str = IO.gets("Enter task ID to delete: ") |> String.trim()

    case Integer.parse(id_str) do
      {id, ""} ->
        new_tasks = TaskManager.delete_task(tasks, id)
        IO.puts("🗑️ Task #{id} deleted!")
        loop(new_tasks)

      _ ->
        IO.puts("❌ Invalid ID.")
        loop(tasks)
    end
  end

  # Choice 6: Exit the app
  defp handle_choice("6", _tasks) do
    IO.puts("\nGoodbye! Keep building awesome things.")
  end

  # Handle invalid choices.
  defp handle_choice(_, tasks) do
    IO.puts("❌ Invalid choice. Please choose a number between 1 and 6.")
    loop(tasks)
  end
end
