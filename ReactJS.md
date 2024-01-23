React.js:

Front end topics:
Component
Component nesting
States
Props

use cases:
access children states (quickform form maker when clicking submit)

steps:
high level overview
core principles

What i did:
read latest book
watched tutorials
watched talk on react:
	understand the abstractions of a framework/library
Watched conferences on react


react learning curve:
core principles:
	declarative programming
		imperative - driving on your own; telling car how to drive
		declarative - riding a taxi; driver does the imperative work
	composition
		create components and make them work together
		component heirarchy
	data flow
		parent to child - unidirectional data flow; top to bottom

_____
functional components - component inside a component; modular components
props - pass in arguments to a react components

Functional. Components 

- Props 
- Events 

- onClick
- onBIur 
- onChange 

- Hooks 
- useState 


useMemo - cache unchanged values to avoid unnecessary rerenders; useful when running a slow function
	- returns value from the function
	
useCallback = same as useMemo, but returns the callback/function instead of a return value
	- returns the callback (the whole function)
	
*see difference between useMemo and useCallback (https://youtu.be/_AyFP5s69N4?t=285)
	
useEffect - asynchronous; "state listener"
useLayoutEffect - synchronous version of the useEffect
useRef - used to get the value from input fields
useReducer - used when changing multiple states between multiple actions/conditions (e.g.: default, succes, error)
	- useful for login systems (https://youtu.be/o-nCM1857AQ)
	- grouping actions together for cleaner code
	- inspired by redux
useContext - global data/state listener; manage state globally
	- solves the props drilling problem: when you have to pass down props from parents to children

-----------
React best practices:
Component lifecycle
dynamic component insertion

Difference between main react library and react-dom
the main react library only takes care of the diffing. It doesn't know that youre generating HTML
react is compatible with any DOM insertion tool (https://youtu.be/i793Qm6kv3U?t=1455)
the element insertion to the DOM is handled by react DOM

use custom hooks to fetch data

always add a unique key (id) to elements (e.g. lists, comments, etc.)
use uuid to generate unique random keys

components must be functional components (class components is old)

props/proponents - data that can be used by the componen (e.g. names)

Hot module replacement:
if (module.hot) {
	module.hot.accept();
}

function vs arrow functions, optional return statement

super(props) - to ensure that the React. Component 's constructor() function gets called
			 - put in every constructor
			 - When having a constructor in your ES6 class component, it is mandatory to call super();

constructor - initial state of the component

use function useState to avoid constructors

named exports vs default exports

const [stateGetter, stateSetter] = React.useState(state);			 
use stateSetter when changing state
setState has a callback function

useEffect - a component can have multiple useEffects for isolation
		  - runs after the initial render
		  - runs after every update
		  - runs on every state change???
		  - subscribe and unsubscribe (return a function inside useEffect to unsubscribe/cleanup listeners)
		  - "state listener"; runs when you want to execute code after a state changes

		  
https://www.youtube.com/watch?v=dpw9EHDh2bM&ab_channel=ReactConf
		  
custom hooks - should start with the word "use"	(e.g. useWindowWidth) for convention
			 - declare custom hooks below the component
			 
Lazy loading
Concurrent mode
Defer

Avoid:
Wrapper hell

Don'ts:
Don't modify a state variable directly. Create a copy before modifying it, then use that copy to set the new state

Iterate data in a component:
render() {
return (
<div className="App">
{list.map(function(item) {
return <div>{item.title}</div>;
})}
</div>
);
}

Syntax:
event listeners must be inline
JSX
const - immutable; cannot be changed
let - normal variable; can be changed; alternative to var
using
Use const whenever you can
conditional rendering
css should be camel case