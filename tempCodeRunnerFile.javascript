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
const firstMales = people.find((person) => person.gender === "male");
console.log(firstMales);