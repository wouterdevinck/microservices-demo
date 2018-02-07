# Task API service

A microservice exposing a simple REST API to Create, Read, Update & Delete (CRUD) tasks. Stores these tasks in MongoDB. Requires a ```DB_URL``` environment variable to know which database to use.

## REST API

#### GET /api/v1/tasks
*Get all tasks* [Try in browser](https://tasks-gr01.k8s.me/api/v1/tasks)

Returns:
```json
[
  {
    "_id": "5a7908acf2ffdc00110df980",
    "done": true,
    "description": "Task 1"
  },
  {
    "_id": "5a7908b0f2ffdc00110df981",
    "done": false,
    "description": "Task 2"
  }
]
```

#### GET /api/v1/tasks/{id}
*Get a specific task by id*

Returns:
```json
{
  "_id": "5a7908acf2ffdc00110df980",
  "done": true,
  "description": "Task 1"
},
```

#### PUT /api/v1/tasks
*Create a new task*

Accepts:
```json
{
  "done": false,
  "description": "Task 1"
}
```
Returns:
```json
{
  "_id": "5a7908acf2ffdc00110df980",
  "done": false,
  "description": "Task 1"
}
```

#### POST /api/v1/tasks/{id}
*Update a specific task*

Accepts:
```json
{
  "done": false,
  "description": "Task 1"
}
```

#### DELETE  /api/v1/tasks/{id}
*Delete a task by id*