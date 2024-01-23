Architecture:
  Microservices:
    - separate backend (API) and frontent (client)
    - can have many clients (web, desktop, mobile)
    
Backend tests:
Rearrange any table's column order and see of app still works

Back-end:
  JSON schema validator (zod, ajv)
  WSL2 as linux environment. See WSL2 vs docker environment
  Single source of truth (SSOT) architecture, or single point of truth (SPOT) architecture
  Dependency injection
  Diffing algorithm: update only what's changed
  Serial processing; sequential processing
    - one process at a time to be processed
    - used when a process is dependent on another process's output (e.g. javascript's await, transactions)
  Parallel processing programming
  Bootstrapping (https://www.youtube.com/watch?v=hy0oieokjtQ)
    *runs on every request or page
    *service providers
    *register services
    *in laravel, use the boot() method
  Set up a server
    *accepts and parses json from front end
    *send json response to front end
  Load environment variables from .env file
  Create ERDs (Entity Relationship Diagram):
    - Lucidchart.com
  ORM
    *Raw query option with replacements/placeholder
    *Indexing for faster data retrieval
    *Database introspection: generate models from an existing database; convert or genereate models/migrations from existing database:
      - Sequelize-Auto
      - Prisma: npx prisma db push && npx prisma generate
    *Sync schema changes to the database; sync models/migrations settings to database structure:
      - Sequelize: Models.sequelize.sync();
      - Prisma: npx prisma db push && npx prisma generate
    *ACID, transactions, transaction rollback
    *auto increment
    *null
    *unique
    *define foreign key
    *constraints
    *migrations: stage schema changes; "database schema version control"
    *seeders
      *initial app data (app settings, admin users)
      *store app settings in the database
    *rename columns names without deleting data
    *change database structure without deleting data
  GraphQL:
    *combine different database queries (posgres & mongodb) in a single graphql query
      - https://www.youtube.com/watch?v=_trOqBZMJHQ
    *combine parent and junction table data in a single graphql query (e.g. order & order_products)
  Models
    *model must be singular, table name must be plural
    *must be connected to the database from the start
    *extends database wrapper to use CRUD functions
  Asynchronous functions
  Error handling
    *Try...throw...catch...finally block
  Connect to the database
  CRUD functions
    *prepared statements (replace ? with quoted/escaped values)
  Create a class that inherits database wrapper e.g. User class inherits CRUD methods/functions from Database class
  Routes
  REST API endpoints (GET, POST, DELETE, PUT, PATCH)
    *Handle CORS preflight requests (preflight sends OPTIONS request instead of POST)
      - switch (req.method) {
          case "POST":
            // Handle POST request
            break;
          default:
            // Handle OPTIONS (preflight) requests
            res.json({});
            break;
        }
    *Arrange API routes properly: declare dynamic routes at the top, static routes below (https://youtu.be/SccSCuHhOw0?t=1100)
    *API versioning (example.com/v1/users/posts)
    *allow only server's ip address or own domain to interact with the API. Restrict other websites, IP addresses, apps, etc.
    *use JWT (json web tokens) to protect endpoints and routes
    *return json response
    *return status (200)
  CORS
    Allow all sites (development):
      Access-Control-Allow-Origin "*"

    Allow only specific sites (production):
      Access-Control-Allow-Origin "https://www.example.com"
    
  Password hashing and checking
  Authentication
    *sessions
    *Auth0 for OAuth authentication
  Middleware
    *Global middleware: middleware to run during every HTTP request
    *Route middleware: middleware specific to certain routes e.g. Authentication middleware
    *chaining middlewares (one master middleware file and import other middlewares i.e. Laravel Kernel)
    *run code on every route visit
    *run code at the end of route visit
  Lambda functions (anonymous function)
  Closures
  Namespacing
  Caching
    *redis
    *memcached
  Decorators
  Method chaining
    $("example").toUpperCase().addQuotes().titleCase().fixSpelling()
    *must be readable and eloquent like laravel's
  Upload large CSV file to mysql and postgres (100k rows)

Front-end:
  Rendering:
    Render object literal
    Store <select/> value to state on change

  Reuse component logic; extract component logic into a reusable function (react custom hooks)
  Lifting up state vs redux
  React virtualized (react-virtualized): virtualized render; virtual rendering
  Optimistic updates
  Conditional rendering (avoid useEffect for checking authentication to prevent flashing the login page before the user page)
  Dynamic imports
  Inline assets load faster than downloaded ones
  Lighthouse (chrome) to optimize metrics (FCP && TTI)
  Toast messages
  Auth0 & OAuth
  Read URL slugs
  Page title controller middleware
  Debugger like laravel's dd(). var_dump() + die() combined
  Router:
    - get URL parameters (useSearchParams)
    - routes controller (react router)
    - dynamic titles
  CSRF/XSRF protection
  Render data as html to prevent running malicious scripts
  Templating
  SCSS
    *remove unused css
  Tree shaking
    *remove unused javascript
  State management
    *react useReducer
    Redux:
      use cases:
        passing value from unrelated components (another component is not a child/parent)
  AJAX:
    interceptor (request, response); see axios interceptor
  Login component (react, vue, angular)
  Lazy loading
  Load components/code on demand
  Bundling
    *code splitting

  Testing:
    - check if component renders based on prop value e.g. isLoggedIn
    - call functions inside components
    - get element's innerHTML and outerHTML
    - trigger events (click, keyboard keys)
    - access component/element attributes (id, class, data, etc.)
    - get element text content
    - access component state
    - get input element values (text, textarea, select, etc.)
    - gete form values
    - get children, sibling, grandparent count of components
    - get element type (div, span, h1, etc)
    - resolve promises
    
Git commit messages (Semantic Commit Messages):
Format:
  <feat, fix, refactor, etc.>[optional scope (api, etc.)]: <description>

  [optional body]

  [optional footer(s)]
  
Format:
  `<type>(<scope>): <subject>`

! = important
`<scope>` is optional

Examples:
  feat(api)!: send an email to the customer when a product is shipped

- `feat`: (new feature for the user, not a new feature for build script)
- `fix`: (bug fix for the user, not a fix to a build script)
- `docs`: (changes to the documentation)
- `style`: (formatting, missing semi colons, etc; no production code change)
- `refactor`: (refactoring production code, eg. renaming a variable)
- `test`: (adding missing tests, refactoring tests; no production code change)
- `chore`: (updating grunt tasks etc; no production code change)

Testing:
  Browser automation (google chrome recorder, selenium, puppeteer, cypress)
  Component testing
  Jest
  Mocha

Coding tools:
  Linter
  
## Framework
  Generate controller
  Generate helper for controller
  Import helper function into the controller
  Create a "get" REST API route/endpoint using the controller
  Change CORS policy in the backend to enable requests
  

## Snippets
  React:
    boilerplate
    useState
    useStateExpensive; useStateLazy
  
  General:
    stringVariable
    numberIntegerVariable
    numberFloatVariable
    booleanVariable
    objectVariable
    objectLiteralVariable; constant; objectConstant
    arrayOfStringsVariable
    arrayOfNumbersVariable
    arrayOfObjectsVariable
    class
    function
    ifStatement
    ifStatements
    ifElseStatement
    switchCase
    tryCatchFinallyBlock
    forLoop; loop
    whileLoop; loop
    fetch
    iterateArray
    iterateArrayAndReturnNewArray
    iterateObjects
    iterateObjectProperties
    compareStrings
    compareNumbers
    compareBooleans
    compareArrays
    compareObjects
    log
    logRed
    logYellow
    logGreen
    logArray; logObject
    logObjectProperty
    combineStrings; concatenateStrings; stringCombination
    stringer
    stringerInterpolation; templateLiteral
    debug
    lambda; anonymous function; lambda expression; arrow function body
    IIFE; self-invoking expression; self-calling expression; self-invoking function; self-calling function;
    findObjectIndex
    mutateObject
    existsInArray; valueExistsInArray;
    recursion
    getObjectKeys
    getObjectValues
    appendToArray
    prependToArray
    removeFirstElementInArray
    removeLastElementInArray
    getArrayLength
    getObjectLength
    appendToObject
    prependToObject
    arrayToCSV
    multilineString
    builderPattern; methodChaining
    import
    export
  
    TODOs:
    functionCall
    getType
    namespace
    negate
    ternary
    isEqualTo
    isGreaterThan
    isLessThan
    isGreaterOrEqualTo
    isLessOrEqualTo
    replaceString
    convertToString
    convertToNum

  Extras:
    exportDefault
    alert
    logToPage
    logAsTable
    server
    functionArrow
    interface
    type
    arrayValuesAsType
    objectKeysAsType
    objectKeysAsMappedType
    objectValuesAsType
    asyncLambda; async anonymous function; async lambda expression
    asyncIIFE; self-invoking expression; self-calling expression; self-invoking function; self-calling function;
    asyncFunction
    asyncAwaitTryCatch
    thenCatchFinally
    tryCatchFinallyBlock