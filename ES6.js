// See: spread syntax, object mutation

// Destructuring nested objects; double destructuring; destructure nested objects
const { data: { username } }: any = await graphql({ schema: gql(schema), source: query, rootValue });
console.log(username);

//==========CHANGE VALUES MULTIPLE OBJECTS==========//
 interface Person {
  firstName: string;
  age?: number;
  active: boolean;
}
const data: Person[] = [
  {
    firstName: "John Doe",
    active: true,
  },
  {
    firstName: "Jane Doe",
    active: true,
  },
];
const editedRows = data.map((row: Person) => {
  delete row.age;
  row.active = false;
  return row;
});
//==========CHANGE VALUES MULTIPLE OBJECTS==========//

//==========CHANGE VALUES OF AN OBJECT==========//
// Version 1
const object = {
  firstName: "John Doe",
  active: true,
};
const newValues = {
  active: false,
};
const mutatedObject = { ...object, ...newValues };

// Version 2
const object = {
  firstName: "John Doe",
  active: true,
};
const mutatedObject = { ...object };
mutatedObject.active = false;

/* New value
{
  firstName: "John Doe",
  active: false,
}
*/
//==========CHANGE VALUES OF AN OBJECT==========//

// Destructure; destructuring; shorthand; shortcut; destructure object

// Access object values without initializing a variable
const { name } = {name: "John Doe"};
console.log(name);

// Renaming keys
const { name: fullName } = {name: "John Doe"};
console.log(fullName);


//=====FUNCTIONS=====//
// Functions - this syntax allows you to use functions before they are declared
functionName(); // Calling a function before its declaration
function functionName(){
  // Code here
}
//=====FUNCTIONS=====//

const functionName = () => {
  // Code here
};

const functionName = () => console.log("One-liner function");

//====================//
// Override object; combine object properties; object mutation; mutate object; add property to object; add attribute to object
// Change object property; modify object property; change object attribute; modify object attribute
const originalObject = {
  a: "1",
  b: "2",
  c: "3", // This property will be overridden by mutation's c: property
};
const mutation = {
  c: "new value",
  d: "4",
};
const mutatedObject = { ...originalObject, ...mutation };
console.log(mutatedObject);
//====================//

//==========MUTATE NESTED OBJECTS==========//
const originalObject = {
  a: "1",
  b: "2",
  c: {
    d: "3",
    e: "4",
  },
};
const mutation = {
  c: {
    ...originalObject.c,
    e: "new value",
  },
};
const mutatedObject = { ...originalObject, ...mutation };
console.log(mutatedObject);
//==========MUTATE NESTED OBJECTS==========//


// Extract keys from an object; Extract properties from an object
let { firstName: firstName, lastName: lastName } = person;

// Exclude keys from an object; Exclude properties from an object; filter an object; remove object property; remove object key; mutate object; exclude object key; exclude object property
let { removeThis, removeThisAsWell, ...newObject } = originalObject;