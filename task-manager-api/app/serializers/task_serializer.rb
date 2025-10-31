class TaskSerializer
  def self.serialize(task)
    {
      id: task.id,
      user_id: task.user_id,
      title: task.title,
      description: task.description,
      status: task.status,
      due_date: task.due_date,
      created_at: task.created_at,
      updated_at: task.updated_at
    }
  end

  def self.serialize_collection(tasks)
    tasks.map { |task| serialize(task) }
  end
end
