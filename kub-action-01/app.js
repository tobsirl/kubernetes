const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.send(`
    <h1>Hello from this NodeJS app!!!</h1>
    <h2>Version 1.0.0</h2>
    <p>It's running on Kubernetes!</p>
    <p>Try sending a request to /error and see what happens</p>
  `);
});

app.get("/error", (req, res) => {
  process.exit(1);
});

app.listen(8080);
