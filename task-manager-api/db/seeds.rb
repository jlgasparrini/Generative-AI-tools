# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding database..."

# Clear existing data
Task.destroy_all
User.destroy_all

# Create test user with known credentials
user = User.create!(
  email: "test@example.com",
  password: "password123",
  password_confirmation: "password123"
)

puts "Created user: #{user.email}"
puts "API Token: #{user.api_token}"

# Create sample tasks
tasks_data = [
  {
    title: "Complete project documentation",
    description: "Write comprehensive documentation for the Task Management API",
    status: "in_progress",
    due_date: Date.today + 7.days
  },
  {
    title: "Review pull requests",
    description: "Review and merge pending pull requests from team members",
    status: "pending",
    due_date: Date.today + 3.days
  },
  {
    title: "Deploy to production",
    description: "Deploy the latest version to production environment",
    status: "pending",
    due_date: Date.today + 14.days
  },
  {
    title: "Fix authentication bug",
    description: "Investigate and fix the reported authentication issue",
    status: "completed",
    due_date: Date.today - 2.days
  },
  {
    title: "Update dependencies",
    description: "Update all gem dependencies to latest stable versions",
    status: "pending",
    due_date: Date.today + 5.days
  }
]

tasks_data.each do |task_data|
  task = user.tasks.create!(task_data)
  puts "Created task: #{task.title} (#{task.status})"
end

puts "\nSeeding completed!"
puts "=" * 50
puts "Test User Credentials:"
puts "Email: #{user.email}"
puts "Password: password123"
puts "API Token: #{user.api_token}"
puts "=" * 50
