const express = require('express')
const path = require('path');
const fs = require('fs');

const app = express()
const port = 8080

function serialiseFile(name, content) {
  const escapedName = name.replace(".lua", "");
  let escapedContent = content.replace(/"/g, "\\\"");
  escapedContent = escapedContent.replace(/\n/g, "\\n");
  return `${escapedName} = "${escapedContent}"`;
}

function serialiseFolder(folder) {
  const directoryPath = path.join(__dirname, folder);
  const fileNames = fs.readdirSync(directoryPath);
  const serialisedFiles = fileNames.map(fileName => serialiseFile(fileName, fs.readFileSync(path.join(directoryPath, fileName), {encoding: "utf-8"})));
  return serialisedFiles.join(",\n");
}

function getResponse() {
  return `
    {
      top = {
        ${serialiseFolder("programs/top")},
        ${serialiseFolder("programs/all")}
      },
      middle = {
        ${serialiseFolder("programs/middle")},
        ${serialiseFolder("programs/all")}
      },
      bottom = {
        ${serialiseFolder("programs/bottom")},
        ${serialiseFolder("programs/all")}
      },
      controller = {
        ${serialiseFolder("programs/controller")}
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