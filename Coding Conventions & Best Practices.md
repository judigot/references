# Dos
- Object Parameter instead of individual arguments for readability

  Don't:
  ```typescript
  function calculateRectangleArea(length: number, width: number): number {
    return length * width;
  }
  
  // Unclear usage; values lack context and purpose
  const area = calculateRectangleArea(5, 10);
  ```
  
  Do:
  ```typescript
  function calculateRectangleArea({ length, width }: { length: number, width: number }): number {
      return length * width;
  }

  // Clear usage; values provide context and purpose
  const area2 = calculateRectangleArea({ length: 5, width: 10 });
  ```

- Self-documenting code: dot notation to reference object values
- Guard clauses or early returns
- Null guards
- IFFEs (Immediately Invoked Function Expression)
- Heredoc, EOF, multi-line strings
- Ternary operators
- Logical operators:

  Nullish coalescing operator (?? or ||): execute "first" if true. Else, fallback to "second"
  ```js
  
  console.log("first" || "second");
  
  ```

  Execute "second" if left argument is true
  ```js
  
  console.log("first" && "second");
  
  ```
  
  Chaining: assign the first true to the variable
  ```js
  
  const x = false || false || "last condition";
  console.log(x); // Will output "last condition"
  
  ```
  
  
- Method chaining or builder pattern
  
  Class:
  ```typescript
  class Calculator {
    private result: number;

    constructor(initialValue: number) {
      this.result = initialValue;
    }

    add(value: number): Calculator {
      this.result += value;
      return this;
    }
    subtract(value: number): Calculator {
      this.result -= value;
      return this;
    }
    multiply(value: number): Calculator {
      this.result *= value;
      return this;
    }
    divide(value: number): Calculator {
      this.result /= value;
      return this;
    }
    getResult(): number {
      return this.result;
    }
  }

  const initialValue = 10;
  console.log(
    new Calculator(initialValue)
      .add(5)
      .multiply(2)
      .subtract(10)
      .divide(5)
      .getResult()
  );

  ```

  Function:
  ```typescript
  const calculator = (initialValue: number) => {
    let result = initialValue;
    
    const builder = {
      add: (value: number) => {
        result += value;
        return builder;
      },
      subtract: (value: number) => {
        result -= value;
        return builder;
      },
      multiply: (value: number) => {
        result *= value;
        return builder;
      },
      divide: (value: number) => {
        result /= value;
        return builder;
      },
      getResult: () => result,
    };
    return builder;
  };

  const initialValue = 10;
  console.log(
    calculator(initialValue).add(5).multiply(2).subtract(10).divide(5).getResult()
  );
  ```
  
  ```typescript
  const modifyString = (initialValue: string) => {
    let result: string = initialValue;

    const builder = {
      get: () => result,
      capitalize: () => {
        result = result.toUpperCase();
        return builder;
      },
      append: (str: string) => {
        result += str;
        return builder;
      },
    };
    return builder;
  };
  console.log(
    modifyString("Hello")
      .capitalize()
      .append(", world")
      .capitalize()
      .append("!")
      .capitalize()
      .get()
  );
  ```

- State logic: see React's useReducer
- Async/await
  
# Don'ts
- Nested ternary
- Global namespace pollution
- Callback hell - use async/await
- If/else hell: avoid nested if/else statements. Keep the code linear