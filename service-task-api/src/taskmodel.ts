import { Document, Schema, model } from "mongoose"

interface TaskModel extends Document {
  done: Boolean
  description: String
}

function omitPrivate(doc, obj) {
  delete obj.__v;
  return obj;
}

let options = {
  toJSON: {
      transform: omitPrivate
  }
};

let taskSchema = new Schema({
  done: Boolean,
  description: String
}, options);

export var Task = model<TaskModel>("Task", taskSchema)