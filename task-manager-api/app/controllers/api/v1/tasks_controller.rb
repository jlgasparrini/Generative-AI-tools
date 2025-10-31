class Api::V1::TasksController < Api::V1::BaseController
  before_action :set_task, only: [:show, :update, :destroy]

  # GET /api/v1/tasks
  def index
    tasks = current_user.tasks
    render json: { tasks: TaskSerializer.serialize_collection(tasks) }, status: :ok
  end

  # GET /api/v1/tasks/:id
  def show
    render json: { task: TaskSerializer.serialize(@task) }, status: :ok
  end

  # POST /api/v1/tasks
  def create
    task = current_user.tasks.build(task_params)

    if task.save
      render json: { task: TaskSerializer.serialize(task) }, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/tasks/:id
  def update
    if @task.update(task_params)
      render json: { task: TaskSerializer.serialize(@task) }, status: :ok
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/tasks/:id
  def destroy
    @task.destroy
    head :no_content
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end
