class Task < ApplicationRecord
  belongs_to :user

  # Enum for status
  enum status: {
    pending: "pending",
    in_progress: "in_progress",
    completed: "completed"
  }

  # Validations
  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }

  # Set default status
  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= :pending
  end
end
