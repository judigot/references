// Types:
// Array of objects: rows: [{ [key: string]: string }]

// Form handling; get form data; get form entries; get form values;
onSubmit={(e) => {
  e.preventDefault();
  const formValues = new FormData(e.currentTarget);
  const data = Object.fromEntries(formValues.entries());
  console.log(JSON.stringify(data));
}}

//==========FILTER OBJECTS; FILTER DATA; SEARCH OBJECTS; SEARCH DATA==========//
const people = [
  {
    name: "John Doe",
    gender: "male",
  },
  {
    name: "Jane Doe",
    gender: "female",
  },
];
const males = people.filter((person) => person.gender === "male");
console.log(males)
//==========FILTER OBJECTS; FILTER DATA; SEARCH OBJECTS; SEARCH DATA==========//

// Capitalize first letter of a string
const string = "hello";
const capitalizedFirstLetter = string.alias.charAt(0).toUpperCase() + string.slice(1);

// Get vowel count; get consonant count
const string = "Test";
const vowelsCount = string.match(/[aeiou]/gi)!.length;
const consonantsCount = string.length - vowelsCount;
console.log(vowelsCount);
console.log(consonantsCount);

// Search array for matches; Filter array for matches
const array = ["Cat", "Dog"]; // Haystack
const query = "cat"; // Needle
const matches: string[] = [];

if (query) {
  for (let i = 0, arrayLength = array.length; i < arrayLength; i++) {
    const element = array[i];
    if (element.toUpperCase().match(query.toUpperCase())) {
      matches.push(element);
    }
  }
  console.log(matches);
} else {
  console.log(matches);
}

const promise = (parameter) => {
  return new Promise((resolve, reject) => {
    if (true) {
      resolve({ message: "Success", data: parameter });
    } else {
      reject(new Error(parameter));
    }
  });
};

const anotherPromise = (parameter) => {
  return new Promise((resolve, reject) => {
    if (false) {
      resolve({ message: "Success", data: parameter });
    } else {
      reject(new Error(parameter));
    }
  });
};

// Promise.all for resolving multiple promises
Promise.all([promise("param1"), anotherPromise("param2")]).then((result) => {
  console.log(result[0]); // promise()
  console.log(result[1]); // anotherPromise()
});

// Filter table rows; filter rows; row filter; search table; search rows; search table rows
function filterRows() {
  const searchQuery: string = query.current.value.toUpperCase();

  const rows = document.querySelector("#myTable")!.getElementsByTagName("tr");

  for (let i = 0, arrayLength = rows.length; i < arrayLength; i++) {
    const rowContent = rows[i].textContent || rows[i].innerText;
    if (rowContent.toUpperCase().includes(searchQuery)) {
      rows[i].style.display = "";
    } else {
      rows[i].style.display = "none";
    }
  }
}

//==========SORT OBJECTS; SORT ARRAY OF OBJECTS==========//
const sort = (orderBy: string) => {
  const sortedObject = [
    { id: 4, age: 5, score: 15 },
    { id: 2, age: 5, score: 35 },
    { id: 4, age: 3, score: 45 },
    { id: 1, age: 3, score: 56 },
    { id: 4, age: 9, score: 65 },
    { id: 3, age: 4, score: 23 },
    { id: 4, age: 9, score: 23 },
  ];

  const sortByID = "id"; // 1st priority
  const sortByAge = "age"; // 2nd priority
  const sortByScore = "score"; // 3rd priority

  // const sortByRank = {
  //   key: "id",
  //   orderBy: "asc",
  // };
  // sortedObject.sort((a: any, b: any) => {
  //   return (
  //     (sortByRank.orderBy === "asc" ? 1 : -1) * // Negate result for descending
  //     (a[sortByRank.key] - b[sortByRank.key])
  //   );
  // });

  sortedObject.sort((a: any, b: any) => {
    return (
      (orderBy === "asc" ? 1 : -1) * // Negate result for descending
      (a[sortByID] - b[sortByID] || // Main priority
        a[sortByAge] - b[sortByAge] || // Use another category if the former category values are equal
        a[sortByScore] - b[sortByScore]) // Use another category if the former category values are equal
    );
  });

  return sortedObject;
};
console.log(JSON.stringify(sort("asc"), null, 4));
//==========SORT OBJECTS; SORT ARRAY OF OBJECTS==========//

Format object:
JSON.stringify({ message: "Hello, World!" }, null, 2);

//==========ADD CLASS TO AN ELEMENT==========//
element.classList.add("hidden");

// Usage
Array.prototype.forEach.call(
  document.querySelectorAll(".someClass"),
  function (element, i) {
    element.classList.add("hidden");
  }
);
//==========ADD CLASS TO AN ELEMENT==========//

//==========REMOVE CLASS FROM AN ELEMENT==========//
element.classList.remove("hidden");

// Usage
Array.prototype.forEach.call(
  document.querySelectorAll(".someClass"),
  function (element, i) {
    element.classList.remove("hidden");
  }
);
//==========REMOVE CLASS FROM AN ELEMENT==========//

// Clone object; clone array
const array = [1, 2, 3];
const object = { message: "💩" };
const arrayClone = structuredClone(array);
const objectClone = structuredClone(object);

// Check if value exists in an array; check if value exists in array
if (["string", "number"].includes(typeof value)) {
  console.log(true);
}

//==========TYPE CHECKER==========//
// Datatypes; check datatypes; datatype checker; data types; check what type; check type; typeof

const object = { x: 1 };
const array = [0, 1, 2, 3];
const date = new Date();
const int = 14.0;
const float = 14.14;

const value = float;

// PostgreSQL Prisma
// import { Decimal } from "@prisma/client/runtime/library";
// if (value instanceof Decimal) {
//   rows[key] = parseFloat(value as unknown as string);
//   console.log("Numeric");
// }

// Integer
if (Number(value) === value && value % 1 === 0) {
  console.log("Integer");
}

// Float
if (Number(value) === value && value % 1 !== 0) {
  console.log("Float");
}

// Date/Datetime
if (
  new Date(value) instanceof Date &&
  new Date(value).constructor.name === "Date" &&
  Object.prototype.toString.call(new Date(value)) === "[object Date]" &&
  !isNaN(new Date(value)) &&
  new Date(value).getDate()
) {
  console.log("Date");
}

// Array
if (
  value instanceof Array &&
  Array.isArray(value) &&
  value.constructor.name === "Array"
) {
  console.log("Array");
}

// Object
if (
  value instanceof Object &&
  !Array.isArray(value) &&
  value.constructor.name === "Object"
) {
  console.log("Object");
}
//==========TYPE CHECKER==========//


// Async/await; async await
(async () => {
  try {
    const data: object = await getData();
    return data;
  } catch (error: unknown) {
    if (typeof error === "string") {
      throw new Error(error);
    }
    if (error instanceof Error) {
      throw new Error(error.message);
    }
  }
})();

const asyncFunction = async () => {
  try {
    if (true) {
      const a = await firstPromise();
      const b = await secondPromise(a);
      const c = await thirdPromise(b);
      return c;
    } else {
      throw new Error("Error 1");
    }
    if (false) {
      throw new Error("Error 2");
    }
  } catch (error) {
    return error;
  }
};

//====================CONVERT LOCAL DATETIME TO UTC====================//
const localDatetime = new Date();
const timezoneDifference = Math.abs(localDatetime.getTimezoneOffset()) / 60;
const UTCDatetime = new Date(new Date().setUTCHours(timezoneDifference));
console.log(UTCDatetime);
//====================CONVERT LOCAL DATETIME TO UTC====================//

//====================CONVERT UTC TO LOCAL DATETIME====================//
const UTCDatetime = "2023-02-20 17:07:00";
const localDatetime = new Date(`${UTCDatetime} UTC`);
console.log(localDatetime);
//====================CONVERT UTC TO LOCAL DATETIME====================//

//====================DOWNLOAD FILE====================//
// Download file in javascript (client side):
const fileName = "User Data";
const fileExtension = "csv";

const rows = [
  ["id", "firstName", "lastName"],
  ["1", "Jude", "Igot"],
];

let fileContent = `data:text/${fileExtension};charset=utf-8,`;

switch (fileExtension) {
  case "csv":
    fileContent += rows
      .map((array) =>
        array
          .map((value) => {
            // Escape , and "
            return (value.includes(`"`) || value.includes(`,`)) ? `"${value.replace(/"/g, `""`)}"` : value;
          })
          .join(",")
      )
      .join("\n");
    break;
  default:
    break;
}

const encodedURI = encodeURI(fileContent);
const link = document.createElement("a");
link.setAttribute("href", encodedURI);
link.setAttribute("download", `${fileName}.${fileExtension}`);
document.body.appendChild(link);
link.click();
link.remove();
//====================DOWNLOAD FILE====================//

function recursion(param: number): number {
  // Base Case
  if (param === 10) {
    return param;
  }

  // Recursive Case
  return recursion(param + 1);
}
console.log(recursion(1));

// Get second to the last value of array; Get array element starting from the last element
const array = [1, 2, 3, 4, 5];
console.log(array.at(-2)); // Will output 4

//==========TIMER==========//
// Timer instantiation should be at the top or global level
let timer: NodeJS.Timeout | undefined = undefined;

clearTimeout(timer);
timer = setTimeout(function () {
  // Execute action
}, 1000);
//==========TIMER==========//


//==========ITERATE DATA; ITERATE OBJECT; EXTRACT OBJECT; EXTRACT COLUMN NAMES & EXTRACT ROW VALUES==========//
const columnNames = Object.keys(array[0]);
const rowValues = array.map(row => Object.values(row));

console.log(columnNames);
console.log(rowValues);
//==========ITERATE DATA; ITERATE OBJECT; EXTRACT OBJECT; EXTRACT COLUMN NAMES & EXTRACT ROW VALUES==========//

// Get cookie value
const cookieValue = document.cookie
  .split("; ")
  .find((row) => row.startsWith("cookieName="))
  ?.split("=")[1];

// Check if a query is saved in document cookies
if (cookieValue) {
  console.log(cookieValue);
}

// Set cookie
document.cookie = "cookieName=Cookie Value"

// Select all elements
const allElements = document.getElementsByTagName("*");
for (var i = 0; i < allElements.length; i++) {
  allElements[i].style.color = "green";
}

// Convert array to string (comma-separated):
console.log(array1 + `,` + array2);

// Combine arrays; combine two arrays; combine 2 arrays; merge two arrays;
const mergedArrays = array1.concat(array2);

// Combine arrays; combine two arrays; combine 2 arrays; merge two arrays;
// Manual
const a1 = ["one", "two"];
const a2 = ["three", "four", "five"];
for (let i = 0, initialArray1Length = a1.length; i < a2.length; i++) {
  a1[a1.length - (a1.length - initialArray1Length) + i] = a2[i];
}
console.log(a1);

// Append object to another object:
const object1 = {};
const object2 = {};
for (let i = 0; i < object2.length; i++) {
  object1[object1.length + (i + 1)] = object2[i];
}

// AJAX

const url = new URL("https://example.com");
url.searchParams.append("animals", encodeURIComponent("cat"));
url.searchParams.append("animals", encodeURIComponent("dog"));
url.searchParams.append("person", "John Doe");
console.log(url.searchParams.getAll("animals"));
console.log(url.searchParams.get(decodeURIComponent("person")));
console.log(url);

/*
Output:
[ 'cat', 'dog' ]
John Doe
*/

export const ajax = async (): Promise<object | object[] | undefined> => {
  let data: object | object[] | undefined = undefined;
  try {
    const response = await fetch('https://example.com', {
      // *GET, POST, PATCH, PUT, DELETE
      method: 'GET',
      headers: {
        Accept: 'application/json, text/plain, */*', // Same as axios
        'Content-Type': 'application/json',
      },
      // For POST, PATCH, and PUT requests
      // body: JSON.stringify(formData),
    });
    if (response?.ok) {
      data = response.json();
    } else {
      throw new Error(`HTTP Error`);
    }
  } catch (error: unknown) {
    if (typeof error === `string`) {
      throw new Error(`There was an error: ${error}`);
    }
    if (error instanceof Error) {
      throw new Error(`There was an error: ${error.message}`);
    }
    if (error instanceof SyntaxError) {
      // Unexpected token < in JSON
      throw new Error(`Syntax Error`);
    }
  } finally {
    // Ensure cleanup, even if an exception occurred
  }

  // Success
  if (data) {
    return data;
  }
};

fetch(	
  `https://url.com/api/users`,	

  // prettier-ignore	
  // `https://url.com/api/users`                // GET	
  // `https://url.com/api/users/${resource}`    // GET	

  // `https://url.com/api/users`                // POST	

  // `https://url.com/api/users/${resource}`    // PATCH, PUT, DELETE	
  // `https://url.com/api/users/${resource}`    // PUT	
  // `https://url.com/api/users/${resource}`    // DELETE	
  {	
  // *GET, POST, PATCH, PUT, DELETE	
  method: "GET",	
  headers: {	
    Accept: "application/json",	
    "Content-Type": "application/json",	
  },	
  // For POST, PATCH, and PUT requests	
  // body: JSON.stringify(formData),	
})	
.then((response) => response.json())	
.then((result) => {	
  // Success	
})	
.catch((error) => {	
  // Failure	
  throw new Error(error);	
});

axios
.post("/login", {
  username: username,
  password: password,
})
.then((res) => {
  if (res.status == 200 && res.statusText === "OK") {
    // Success
    const data: { [key: string]: boolean } = res.data;
  }
})
.catch((error) => {
  // Fail
  throw new Error(error);
})
.finally(() => {
  // Finally
});

//========================================//
// Extract paths from tsconfig.json and convert to aliases
import tsconfig from "./tsconfig.json";
const paths: any = tsconfig.compilerOptions.paths;
let aliases: any = {};
for (let i = 0; i < Object.keys(paths).length; i++) {
  const key = Object.keys(paths)[i];

  // Remove / and * from the string
  const alias = key.replace(/\/\*/g, "");
  
  // Webpack.config.js
  const pathToFolder = paths[key][0].replace(/\*/g, "");
  aliases[alias] = path.resolve(__dirname, `${entryFolder}/${pathToFolder}/`);
  
  // Babel.config.js
  // const pathToFolder = paths[key][0].replace(/\*/g, "").slice(0, -1);
  // aliases[alias] = `./src/${pathToFolder}/`;
}

// Add aliases in resolve property in webpack build or in babel config plugins property
const build = {
  resolve: {
    alias: aliases, // Path aliases are extracted from tsconfig.json
  },
};
//========================================//
//========================================//
const string1 = "bad";
const string2 = "badassness";
const string4 = "123badass456";
const string3 = "abc";
const string5 = "ssadab";
const string6 = "bababababadbabasdzx";

//  Without predefined method tests
console.log(withoutPredefinedMethod(string1, string1)); // true
console.log(withoutPredefinedMethod(string1, string2)); // true
console.log(withoutPredefinedMethod(string1, string3)); // false
console.log(withoutPredefinedMethod(string1, string4)); // true
console.log(withoutPredefinedMethod(string1, string5)); // false
console.log(withoutPredefinedMethod(string1, string6)); // true

function withoutPredefinedMethod(needle, haystack) {
  let matchedChars = needle[0] + "";
  for (let i = 0; i < haystack.length; i++) {
    if (needle[0] === haystack[i]) {
      for (let j = 1; j < needle.length; j++) {
        if (needle[j] === haystack[i + j]) {
          matchedChars += haystack[i + j];
        } else {
          matchedChars = needle[0] + "";
          break;
        }
      }
      if (needle === matchedChars) {
        return true;
      }
    }
  }
  return false;
}

//========================================//

// Question #1: 3 + 3 = 6 minutes
// Question #2: 10 + 33 = 33 minutes
// Question #3: 30 + 15 + 18 + 8 + 40 = (111 min) 1 hour and 51 minutes
// Question #4: 15 + 35 + 5 = 55 minutes
// Question #5: 35 minutes
// Total = (240 min) 4 hours

console.log("Question #1: Reverse String\n");
const reverseString = (string) => {
  return string.split(" ").reverse().join(" ");
};

console.log(reverseString("This is Valhalla"));
console.log("\n"); //========================================//

console.log("Question #2: Get Highest and Lowest Numbers\n");
const getHighestAndLowest = (numbers) => {
  let lowest = numbers[0];
  let highest = numbers[0];
  for (let i = 0; i < numbers.length; i++) {
    const currentNum = numbers[i];
    if (currentNum < lowest) {
      lowest = currentNum;
    }
    if (currentNum > highest) {
      highest = currentNum;
    }
  }
  return {
    highest: highest,
    lowest: lowest,
  };
};
const result = getHighestAndLowest([34, 7, 23, 32, 5, 62, -1]);
console.log(`Highest: ${result.highest}\nLowest: ${result.lowest}`);
console.log("\n");
//========================================//

console.log("Question #3: Sort Array of Numbers\n");
const sortArray = (numbers) => {
  for (let i = 0; i < numbers.length; i++) {
    const currentElement = numbers[i];
    const nextElement = numbers[i + 1];
    if (currentElement > nextElement) {
      numbers[i] = nextElement;
      numbers[i + 1] = currentElement;
      sortArray(numbers);
    }
  }
  return numbers;
};
const sortedArray = sortArray([34, 7, 23, 32, 5, 62]);
console.log(sortedArray);
console.log("\n");
//========================================//

console.log("Question #4: Get First Recurring Character\n");
function getFirstRecurringCharacter(string) {
  const stringChars = [];
  for (let i = 0; i < string.length; i++) {
    const char = string[i];
    stringChars.push(char);
  }
  var set = new Set();
  return stringChars.find((v) => set.has(v) || !set.add(v)) || null;
}
console.log(getFirstRecurringCharacter("ABCA"));
console.log(getFirstRecurringCharacter("CABDBA"));
console.log(getFirstRecurringCharacter("CBAD"));
console.log("\n");
//========================================//

console.log("Question #5: Find Addends That Equal To 8\n");
const isEqualToEight = (numbers) => {
  if (numbers.length !== 0) {
    for (let i = 0; i < numbers.length; i++) {
      const num = numbers[0];
      const nextNum = numbers[i + 1];
      if (nextNum !== undefined) {
        if (num + nextNum == 8) {
          return true;
        }
      }
    }
    numbers.shift();
    return isEqualToEight(numbers);
  }
  return false;
};
console.log(isEqualToEight([1, 2, 3, 4]));
console.log(isEqualToEight([4, 2, 4, 1]));
console.log(isEqualToEight([7, 2, 4, 6, 7]));


//====================FIND A WORD IN A STRING====================//
const string1 = "bad";
const string2 = "badassness";
const string4 = "123badass456";
const string3 = "abc";
const string5 = "ssadab";
const string6 = "bababababadbabasdzx";

//  Without predefined method tests
console.log(withoutPredefinedMethod(string1, string1)); // true
console.log(withoutPredefinedMethod(string1, string2)); // true
console.log(withoutPredefinedMethod(string1, string3)); // false
console.log(withoutPredefinedMethod(string1, string4)); // true
console.log(withoutPredefinedMethod(string1, string5)); // false
console.log(withoutPredefinedMethod(string1, string6)); // true

function withoutPredefinedMethod(needle, haystack) {
  let matchedChars = needle[0] + "";
  for (let i = 0; i < haystack.length; i++) {
    if (needle[0] === haystack[i]) {
      for (let j = 1; j < needle.length; j++) {
        if (needle[j] === haystack[i + j]) {
          matchedChars += haystack[i + j];
        } else {
          matchedChars = needle[0] + "";
          break;
        }
      }
      if (needle === matchedChars) {
        return true;
      }
    }
  }
  return false;
}

//====================FIND A WORD IN A STRING====================//

// Get element using attribute
document.querySelectorAll(`input[name=paymentid]`)[0].value

// Bookmarklet - run javascript on a page
javascript: alert("Hello, World!");

javascript: (function () {
  alert("Hello, World!");
})();

javascript: (function () {
  var name = prompt("Please enter your name", "John Doe");
  if (name) {
    alert(name);
  }
})();

// Prompt; javascript text input; javascript input
var name = prompt("Please enter your name", "John Doe");
if (name) {
  alert(name);
}

//====================FORWARD TRAVERSAL====================//

const parentDiv = document.querySelectorAll(`div[class=container]`)[0];

// Get the children element using the parent element; get children element using parent element; select the children element using the parent element; select children element using parent element
const child = parentDiv.querySelector("a"); // Select anchor child <a></a>

const grandparent = document.querySelector(".grandparent");

const parents = Array.from(grandparent.children); // Stores elements into an array; with this, you don't need a loop

const parentOne = parents[0];

const children = parentOne.children;

// Children skipping (grandparent to grandchildren)

const grandChildOne = grandparent.querySelector(".child");

const grandChildren = grandparent.querySelectorAll(".child");

// Form; get elements by type; get form input elements; ; get form input names; get input names
const formNode = document.querySelectorAll("form");
const inputs = formNode?.querySelectorAll("input");
const inputIDs: string[] = [];
if (inputs?.length) {
  for (let i = 0, arrayLength = inputs.length; i < arrayLength; i += 1) {
    const input = inputs[i];
    const id = input.getAttribute("id");
    if (typeof id === "string") {
      inputIDs.push(id);
    }
  }
}

//====================BACKWARD TRAVERSAL====================//

const grandChildOne = grandparent.querySelector("#childOne");

const parent = grandChildOne.parentElement;

// Parent skipping (grandchildren to grandparent)

const grandParent = grandChildOne.closest(".grandparent");

//====================SIDE-BY-SIDE TRAVERSAL====================//

const childOne = document.querySelector("#childeOne");

const childTwo = childOne.nextElementSibling;

const childOne = childTwo.previousElementSibling;

// Select element by a specific attribute value
var element = document.querySelector(
  `[class="fome6x0j tkqzz1yd aodizinl fjf4s8hc f7vcsfb0"]`
);

// Get keydowns:
document.addEventListener("keydown", function (e) {
    alert(e.key);
});

// Document onload:
document.addEventListener("DOMContentLoaded", function (e) {
    alert("Hello, world!");
});

window.onload = function () {
    alert("Hello, world!");
};
window.onload = () => {
    alert("Hello, world!");
};

// Multiple elements in a single event listener:
['element1', 'element2'].forEach(function (element) {
    document.querySelector(`#${element}`).addEventListener("click", function () {
        alert("Hello, world!");
    });
});

// Multiple event listeners in a single element:
['keyup', 'change', 'paste'].forEach(function (event) {
    document.querySelector(`#element`).addEventListener(event, functionName, false);
});

// Event listener:
document.querySelector("#id").addEventListener("click", functionName);
document.querySelector("#id").addEventListener("click", function (e) {
    alert("Hello, world!");
});

// Loop each element:
Array.prototype.forEach.call(document.querySelectorAll("tbody tr"), function (element, i) {
});

Array.prototype.forEach.call(document.querySelectorAll(".class-name"), function (element, i) {
    alert(element.getAttribute("value"));
});

// Get Element by XPath:
function getElementByXPath(path) {
    return document.evaluate(path, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
}
const element = getElementByXPath(`//html[1]/body[1]/div[1]`);
element.remove();

// Add commas to numbers:
string = string.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

// Confirmation box:
if (confirm("Are you sure you want to delete this?")) {
    alert("Deleted.");
} else {
    alert("Cancelled.");
}

// Parse / Parse / Run javascript string:
eval("alert('Hello, world!')");

// JSON HTML attribute:
dataJson = '[{"integer":1,"string":"value","nullSample":null},{"integer":1,"string":"value","object":{"options":["option1","option2"]}}]'

// Reload current page:
window.location.reload();

// HTTP redirect to a page:
window.location.replace("home.php");

// Replace string:
string.replace(/blue/g, "red");

// Replace URL:
window.history.replaceState({}, "", "urlString");

// Add page changes to history / back button:
window.history.replaceState({}, "", "urlString");

// Play audio:
// ------------------------------------------------------------------------------------
custom_playAudio("sound.wav");

function custom_playAudio(source) {
    var sound = new Audio(source).play();
    if (sound !== undefined) {
        sound.then(_ => {
        }).catch(error => {
        });
    }
}
// ------------------------------------------------------------------------------------

// Simulate link click event:
window.location.href = "home.php";

// Filter HTML / special characters:
var rawValue = $("#oldOptions").find("input").eq(i).val();
var regex = /<|>|"|'|&/gi;
//var regex = /&lt;|&gt;|&quot;|&#039;|&amp;/gi;
var newValue = rawValue.replace(regex, function (char) {
    var specialCharacters = {
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#039;",
        "&": "&amp;",
        "&lt;": "<",
        "&gt;": ">",
        "&quot;": "\"",
        "&#039;": "'",
        "&amp;": "&"
    };
    return specialCharacters[char];
});
alert(newValue);

jQuery Conditions:

Detect Filled/Not Empty Input:
if ($("#element").replace(/\s/g, '').length !== 0) {
}

Filter Space/Detect Blank Input:
if (!$("#element").val().replace(/\s/g, '').length) {
}

Detect Focusout:
if ($("#element").is(":focus") === false) {
}

// Remove part of a string:
"Hello, world!".replace(", world", ""); // Result is "Hello!"

// Animation Functions:
// easings.net
$("element").hide("drop", { direction: "up" }, 100, function () {
});

// Set IDs for children elements:
$("#editTextFieldFields").find("[id]").each(function () {
    if (this.id.match(".*\\d.*")) {
        if (this.id.replace(/\D/g, '') !== gfm_editField) {
            this.id = this.id.slice(0, -1);
            this.id = this.id + gfm_editField;
        }
    } else {
        this.id = this.id + gfm_editField;
    }
});

// Document onload:
$(function () {
});

// Detect input element changes:
$(document).on("input", "input", function (e) {
});

// Custom events:
$(document).on("customEvent", function () {
});
$(document).trigger("customEvent");
// --------
$(document).on("customEvent", {
    name: "Jude"
}, function (e, var1, var2) {
    alert(e.data.name + " " + var1 + " " + var2);
});
$(document).trigger("customEvent", ["Francis", "Igot"]);

// Generate random value from array:
var color = ["red", "green", "blue"];
alert(color[Math.floor(Math.random() * color.length)]);
var position = ["left", "right"][Math.floor(Math.random() * ["left", "right"].length)]

// Notify.js:
$.notify("Notify.js", {
    position: "top center",
    className: "success"
});

// Toggle animation:
// See jQuery toggle effects
$("#element").toggle("drop", {
    direction: "right"
}, 1000);

// Check element visibility:
!$("#element").is(":visible") ? $("#element").show(100) : $("#element").hide(100);
if ($("#element").is(":visible")) {
}

// Select specific attribute from all children elements:
$("#parent").find("[id]").each(function () {
    alert(this.id);
});

// Check if array contains value:
// returns the index of the matched value in the array. 
// returns "-1" if no matches found
["1", "2", "3"].indexOf("2"); // returns "1" since "2" is in [1]

// Check if a string contains any number:
if ("abcde1".match(".*\\d.*")) {
}

// Count immediate child elements:
$("#parent >").length
// Specific Element:
$("#parent > div").length

// Find parent element:
$(this).parents().find("[data-sample]").attr("data-value")

// Target Closest / Parent Element:
$(this).closest("div").remove();

// Target child element:
$("#parent").children("div").attr("class");

// Detect if element is not focused:
if ($(".edit-box, .edit-fee").is(":focus") === false) {
}

// Mouse click:
$(document).on("click", "#element", function (e) {
});

// Whole page mouse click:
$(document).on("click", function (e) {
});

// Exclude an element from an event:
$(document).on("click", "#element1:not(#element2)", function (e) {
});

// Keyboard: (Use keyup when checking for field values; see mcci registration add attendee)

// Keyboard combinations:
$(document).on("keydown", function (e) {
    var key = { a: 65, b: 66, c: 67, d: 68, e: 69, f: 70, g: 71, h: 72, i: 73, j: 74, k: 75, l: 76, m: 77, n: 78, o: 79, p: 80, q: 81, r: 82, s: 83, t: 84, u: 85, v: 86, w: 87, x: 88, y: 89, z: 90 };
    if (e.ctrlKey && e.shiftKey && e.altKey && e.keyCode === key.z) {
        e.preventDefault();
        alert("Ctrl + Shift + Alt + Z");
    }
});

$(document).on("keydown", "#element", function (e) {
    // Enter key
    if (e.keyCode === 13) {
    }
});

// Disable Context Menu / Right Click:
$(document).on("contextmenu", function (e) {
    return false;
});

// Get Get variable:
alert(location.href.substr(location.href.lastIndexOf('/') + 1));

// Focus on an Element / Field:
$("#element").focus();

// Load a Page on an Element:
$("#target").load("url.php");

// Target Current Element / Get Element Attribute:
$(this).attr("class");

// Add Attributes to an Element:
$("#element").attr("placeholder", "some place holder");

// Show Modal:
$("#myModal").modal("show");
$("#myModal").modal({ backdrop: 'static' });

// Hide Modal:
$("#myModal").modal("hide");

// CSS
$("#element").css({ "color": "red" });

// Set Interval:
setInterval(function () {
}, 1000);

// Set timeout:
setTimeout(function () {
}, 1000);

// Ajax:
$.ajax({
    url: "url.php",
    type: "POST",
    dataType: "json",
    data: {
        read: "getData",
        data: {
            email: "example@gmail.com",
            password: "123"
        }
    }
}).done(function (result) {
    // Parse AJAX database result:
    var data = JSON.parse(result);
}).fail(function (error) {
});


// Date format; Time format
const date = new Date(dataUpdatedAt);

const dayOfTheWeek = date.getDay();
const year = date.getFullYear();
const day = date.getDate();
const month = date.toLocaleString("default", {
  month: "long",
});

const time = new Date(dataUpdatedAt).toLocaleString("en-US", {
  // year: "numeric",
  // month: "numeric",
  // day: "numeric",
  hour: "numeric",
  minute: "numeric",
  second: "numeric",
  hour12: true,
});

console.log(`${month} ${day}, ${year} at ${time}`);