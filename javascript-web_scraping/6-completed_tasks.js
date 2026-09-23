#!/usr/bin/node
const request = require('request');

request(process.argv[2], (err, response, body) => {
  if (err) {
    console.log(err);
  } else {
    const todos = JSON.parse(body);
    const completed = {};
    for (const todo of todos) {
      if (todo.completed) {
        if (!completed[todo.userId]) {
          completed[todo.userId] = 0;
        }
        completed[todo.userId]++;
      }
    }
    console.log(completed);
  }
});
