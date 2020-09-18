const express = require('express')
const path = require('path');
const fs = require('fs');
var glob = require("glob")

const app = express()
const port = 8080

function serialiseFile(name, folder, content) {
  name = name.replace(".lua", "");
  name = name.replace(folder, "");
  name = name.replace(/\//g, "_")

  content = content.replace(/"/g, "\\\"");
  content = content.replace(/\n/g, "\\n");

  return `${name} = "${content}"`;
}

function serialiseFolder(folder) {
  const fileNames = glob.sync(`${folder}/**/*.lua`);
  const serialisedFiles = fileNames.map(fileName => serialiseFile(fileName, folder, fs.readFileSync(fileName, {encoding: "utf-8"})));
  return serialisedFiles.join(",\n");
}

function getResponse() {
  return `
    {
      connector = {
        ${serialiseFolder("turtles/connector/")},
        ${serialiseFolder("turtles/all/")}
      },
      top = {
        ${serialiseFolder("turtles/top/")},
        ${serialiseFolder("turtles/all/")}
      },
      middle = {
        ${serialiseFolder("turtles/middle/")},
        ${serialiseFolder("turtles/all/")}
      },
      bottom = {
        ${serialiseFolder("turtles/bottom/")},
        ${serialiseFolder("turtles/all/")}
      },
      controller = {
        ${serialiseFolder("controller/")}
      }
    }
  `;
}

app.get('/', (req, res) => {
  console.log("Request Receivend");
  const response = getResponse();
  console.log("Response Sent");
  res.send(response);
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
})