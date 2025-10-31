# Task Management API - Project Plan

## Project Overview

A RESTful API built with Ruby on Rails for managing tasks. The system provides complete CRUD operations for tasks, with each task associated to a user and containing title, description, status, and due date attributes.

## Technical Stack

- **Framework**: Ruby on Rails (API mode)
- **Database**: PostgreSQL
- **Authentication**: JWT or similar token-based authentication
- **API Standard**: RESTful JSON API

## Data Model

### User
- `id` (Primary Key)
- `email` (String, unique)
- `password` (String)
- `created_at` (Datetime)
- `updated_at` (Datetime)

### Task
- `id` (Primary Key)
- `user_id` (Foreign Key)
- `title` (String, required)
- `description` (Text)
- `status` (String/Enum: pending, in_progress, completed)
- `due_date` (Date)
- `created_at` (Datetime)
- `updated_at` (Datetime)

---

## User Stories

### Epic 1: User Management

#### US-001: User Registration
**As a** new user
**I want to** register for an account
**So that** I can create and manage my tasks

**Acceptance Criteria:**
- [ ] API endpoint `POST /api/v1/users` accepts email, password, and name
- [ ] Password is securely hashed before storage
- [ ] Email validation ensures valid format
- [ ] Email uniqueness is enforced
- [ ] Successful registration returns user object (excluding password) and 201 status
- [ ] Duplicate email returns 422 status with error message
- [ ] Invalid data returns 400 status with validation errors

---

#### US-002: User Authentication
**As a** registered user
**I want to** log in with my credentials
**So that** I can access my tasks securely

**Acceptance Criteria:**
- [ ] API endpoint `POST /api/v1/auth/login` accepts email and password
- [ ] Valid credentials return authentication token and 200 status
- [ ] Invalid credentials return 401 status with error message
- [ ] Token includes user identification and expiration
- [ ] Response includes user data (excluding password)

---

### Epic 2: Task CRUD Operations

#### US-003: Create Task
**As a** authenticated user
**I want to** create a new task
**So that** I can track things I need to do

**Acceptance Criteria:**
- [ ] API endpoint `POST /api/v1/tasks` requires authentication
- [ ] Request accepts title (required), description, status, and due_date
- [ ] Task is automatically associated with authenticated user
- [ ] Default status is "pending" if not provided
- [ ] Successful creation returns task object and 201 status
- [ ] Missing required fields return 400 status with validation errors
- [ ] Unauthenticated request returns 401 status
- [ ] Invalid status value returns 422 status with error message

---

#### US-004: View All Tasks
**As a** authenticated user
**I want to** view a list of all my tasks
**So that** I can see what I need to work on

**Acceptance Criteria:**
- [ ] API endpoint `GET /api/v1/tasks` requires authentication
- [ ] Returns only tasks belonging to authenticated user
- [ ] Response includes all task attributes (id, title, description, status, due_date, created_at, updated_at)
- [ ] Returns 200 status with array of tasks
- [ ] Empty list returns 200 status with empty array
- [ ] Unauthenticated request returns 401 status
- [ ] Support pagination with query parameters (page, per_page)

---

#### US-005: View Single Task
**As a** authenticated user
**I want to** view details of a specific task
**So that** I can see all information about that task

**Acceptance Criteria:**
- [ ] API endpoint `GET /api/v1/tasks/:id` requires authentication
- [ ] Returns task details for specified ID
- [ ] User can only view their own tasks
- [ ] Successful request returns task object and 200 status
- [ ] Non-existent task returns 404 status
- [ ] Attempting to view another user's task returns 403 status
- [ ] Unauthenticated request returns 401 status

---

#### US-006: Update Task
**As a** authenticated user
**I want to** update an existing task
**So that** I can modify task details or change its status

**Acceptance Criteria:**
- [ ] API endpoint `PUT/PATCH /api/v1/tasks/:id` requires authentication
- [ ] Accepts partial updates (any combination of title, description, status, due_date)
- [ ] User can only update their own tasks
- [ ] Successful update returns updated task object and 200 status
- [ ] Invalid data returns 422 status with validation errors
- [ ] Non-existent task returns 404 status
- [ ] Attempting to update another user's task returns 403 status
- [ ] Unauthenticated request returns 401 status
- [ ] Empty request body returns 400 status

---

#### US-007: Delete Task
**As a** authenticated user
**I want to** delete a task
**So that** I can remove tasks I no longer need

**Acceptance Criteria:**
- [ ] API endpoint `DELETE /api/v1/tasks/:id` requires authentication
- [ ] User can only delete their own tasks
- [ ] Successful deletion returns 204 status with no content
- [ ] Non-existent task returns 404 status
- [ ] Attempting to delete another user's task returns 403 status
- [ ] Unauthenticated request returns 401 status
- [ ] Deleted task is permanently removed from database

---

## Implementation Steps (Windsurf)

> The following steps are ordered. Each step should be executed before moving to the next one.

1. **Create Rails API project**
   - [x] Run `rails new task-manager-api --api --database=postgresql`
   - [x] Configure database in `config/database.yml`
   - [x] Run `rails db:create`

2. **Add core gems (if not present)**
   - [x] Add `gem "jwt"` (or `devise-jwt` if using Devise)
   - [x] Add `gem "rack-cors"`
   - [x] Run `bundle install`

3. **Generate User model**
   - [x] `rails g model User email:string:uniq password_digest:string api_token:string:uniq`
   - [x] Add `has_secure_password` to `app/models/user.rb`
   - [x] Add validations for email uniqueness
   - [x] Run `rails db:migrate`

4. **Generate Task model**
   - [x] `rails g model Task user:references title:string description:text status:string due_date:date`
   - [x] Add enum or validation for `status` (pending, in_progress, completed)
   - [x] Add validation for `title` presence
   - [x] Run `rails db:migrate`

5. **Namespace API**
   - [x] Create `app/controllers/api/v1/base_controller.rb`
   - [x] Set it to inherit from `ActionController::API`

6. **Add authentication concern**
   - [x] Create `app/controllers/concerns/authenticable.rb`
   - [x] Implement Bearer token lookup (`Authorization: Bearer <token>`)
   - [x] On failure return `401` JSON error
   - [x] Include in `Api::V1::BaseController`

7. **Generate controllers**
   - [x] `rails g controller api/v1/users --no-helper --no-assets`
   - [x] `rails g controller api/v1/auth --no-helper --no-assets`
   - [x] `rails g controller api/v1/tasks --no-helper --no-assets`

8. **Implement endpoints**
   - [x] `POST /api/v1/users` (sign up) → creates user
   - [x] `POST /api/v1/auth/login` → returns token
   - [x] `GET /api/v1/tasks` → current_user tasks
   - [x] `GET /api/v1/tasks/:id` → current_user task
   - [x] `POST /api/v1/tasks` → create task for current_user
   - [x] `PATCH /api/v1/tasks/:id` → update current_user task
   - [x] `DELETE /api/v1/tasks/:id` → delete current_user task

9. **Routes**
   - [x] Update `config/routes.rb`:
     ```ruby
     Rails.application.routes.draw do
       namespace :api do
         namespace :v1 do
           resources :users, only: [:create]
           post 'auth/login', to: 'auth#login'
           resources :tasks
         end
       end
     end
     ```

10. **Serializers / JSON shape**
    - [x] Create `app/serializers/task_serializer.rb`
    - [x] Use serializer in `index`, `show`, `create`, `update`

11. **Error handling**
    - [x] Add `rescue_from ActiveRecord::RecordNotFound` in `Api::V1::BaseController`
    - [x] Return `{ error: "Not Found" }`, status 404

12. **Seed data (for testing)**
    - [x] Create 1 user with known `api_token`
    - [x] Create 3–5 tasks for that user

## Success Criteria

The project will be considered complete when:
- All user stories are implemented and acceptance criteria met
- Authentication and authorization work correctly
- CRUD operations function as expected
- Error handling is comprehensive and user-friendly
