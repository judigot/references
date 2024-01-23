/*
These will not invoke the function on render:
✔️ onClick={functionName}
✔️ onClick={ () => { functionName("value"); } }

//==========TIMER==========//
let timerRef = React.useRef<NodeJS.Timeout>();
React.useEffect(() => {
  clearTimeout(timerRef.current as NodeJS.Timeout);
  timerRef.current = setTimeout(function () {
    // Reset state
    setMessage(``);
  }, 2000);
});
//==========TIMER==========//

This will invoke the function on render:
❌ onClick={functionName("value")}
*/

// Destructure useref; destructure ref; destructure react useref; destructure react ref
const {
  current: { value: message },
} = messageRef;

// Runs only once after the component initially renders
useEffect(() => {
  // Code
}, []);

// Runs on every state change or render
useEffect(() => {
  // Code
});

useEffect(() => {
  // Prevent running on initial render
  if (number !== initialStateValue) {
    console.log("This console log runs after changing number state.");
  }
}, [number]);

// Think of it as a "state listener"
// Runs ONCE after initial rendering
// and after every state or prop change
useEffect(() => {
  // Code
}, [prop, state]);

Iterate data:
// Iterate an object; iterate an array of objects; iterate array of objects
    {data?.map(({id, firstName}, i) => (
      <div key={id}>{row}</div>
    ))}

// Iterate an object; iterate object; iterate an object literal; iterate object literal
  const animalsKeys = {
    CAT: "CAT",
    DOG: "DOG",
  } as const;

  const animals = {
    [animalsKeys.CAT]: "Felis catus",
    [animalsKeys.DOG]: "Canis lupus familiaris",
  } as const;

  // TSX
  {Object.entries(animals).map(([animalEng, animalLatin]: [string, string], i: number) => (
    <option key={animalEng}>{animalLatin}</option>	
  ))}

  // Raw
  Object.entries(animals).forEach(([animalEng, animalLatin]: [string, string], i: number) => (
    <option key={animalEng}>{animalLatin}</option>	
  ))

// Iterate a number of times
// Loop 5 times
    {[...Array(5)].map(({id, firstName}, i) => (
      <div key={id}>{row}</div>
    ))}

// Iterate an array
    {["value 1", "value 2", "value 3"].map(({id, firstName}, i) => (
      <div key={id}>{row}</div>
    ))}

// Iterate an array of object using a function
// Usage: <>{GradesItems}</>
    const Items = Data.map(({id, firstName}, i) => (
      <div key={id}>{firstName}</div>
    ));