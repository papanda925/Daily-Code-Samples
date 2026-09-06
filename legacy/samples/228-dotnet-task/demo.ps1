$task=[Threading.Tasks.Task]::Run([Action]{Start-Sleep 2});"Task status=$($task.Status)";$task.Wait();"Task status=$($task.Status)"
