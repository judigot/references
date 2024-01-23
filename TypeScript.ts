// Pick & Omit to select or remove attributes from object interface/types. Used for reusing interfaces/types

//==========FILTER DATA; FILTER OBJECT==========//
const StudentYears = {
    "1": 1,
    "2": 2,
    "3": 3,
    "4": 4,
    "5": 5,
    "6": 6,
  };
  
  const schools = {
    schoolA: "School A",
    schoolB: "School B",
    schoolC: "School C",
  } as const;
  
  const Genders = {
    MALE: "MALE",
    FEMALE: "FEMALE",
  } as const;
  
  type Person = {
    schoolType: "all" | (typeof schools)[keyof typeof schools];
    grade: "all" | (typeof StudentYears)[keyof typeof StudentYears];
    gender: "all" | (typeof Genders)[keyof typeof Genders];
  };
  
  const Data: Person[] = [
    { schoolType: schools.schoolA, grade: 1, gender: Genders.MALE },
    { schoolType: schools.schoolB, grade: 2, gender: Genders.FEMALE },
    { schoolType: schools.schoolC, grade: 1, gender: Genders.MALE },
  ];
  
  // User selections
  const schoolType: "all" | Person["schoolType"] = "all";
  const grade: "all" | Person["grade"] = "all";
  const gender: "all" | Person["gender"] = Genders.MALE;
  
  const filteredData = Data.filter(
    (row) =>
      (schoolType === "all" || row.schoolType === schoolType) &&
      (grade === "all" || row.grade === grade) &&
      (gender === "all" || row.gender === gender)
  );
  
  console.log(filteredData);
//==========FILTER DATA; FILTER OBJECT==========//

// Interface keys as type; interface key as type; interface properties as type; interface property as type; interface attributes as type; interface attribute as type
interface Data {
  namae: string;
}
// ...
console.log(row[key as keyof Data]);

//====================CREATE DYNAMIC OBJECT LITERALS====================//
const createObjectLiteral = <T extends string>(
  keys: T[]
): Readonly<Record<T, string>> =>
  Object.freeze(
    keys.reduce((obj, key) => ({ ...obj, [key]: key }), {} as Record<T, T>)
  );

type Page = keyof typeof Pages;
const Pages = createObjectLiteral(["FORM", "CONFIRMATION", "COMPLETED"]);
Pages.FORM = "NEW VALUE"; // This will LITERALLY throw an error
console.log(Pages);
//====================CREATE DYNAMIC OBJECT LITERALS====================//
//====================OBJECT LITERAL EXAMPLE====================//
export const GendersKeys = {
  MALE: "MALE",
  FEMALE: "FEMALE",
} as const;

// Use GenderKeys values for consistency
// Mapped types; object keys as type; object keys as keys; object key as key
export const Genders: { [K in keyof typeof GendersKeys]: string } = {
  [GendersKeys.MALE]: "男子",
  [GendersKeys.FEMALE]: "女子",
} as const;
//====================OBJECT LITERAL EXAMPLE====================//
//====================OBJECT LITERAL SHORTHAND====================//
const keys = ["FORM", "CONFIRMATION", "COMPLETED"] as const;
const Pages = Object.freeze(
  keys.reduce(
    (acc, key) => ({
      ...acc,
      [key]: key,
    }),
    {} as Record<(typeof keys)[number], string>,
  ),
);
Pages.FORM = "NEW VALUE"; // This will LITERALLY throw an error
console.log(Pages.FORM); // Access using dot notation
//====================OBJECT LITERAL SHORTHAND====================//

//====================CONSTANTS; ENUM ALTERNATIVE; OBJECT LITERALS====================//
// Object keys as type; object attributes as type
type Page = keyof typeof Pages;

// Object values as type; object value as type; value as type; use when keys and values differ
// type PageValues = (typeof Pages)[keyof typeof Pages];

const Pages = {
  FORM: "FORM",
  CONFIRMATION: "CONFIRMATION",
  COMPLETED: "COMPLETED",
} as const;

const currentPage: Page = Pages.FORM;

console.log(currentPage);
//====================CONSTANTS; ENUM ALTERNATIVE; OBJECT LITERALS====================//

// Object type parameter; Unknown keys
const functionName = (result: { [key: string]: string }[]) => {
  // Code
}

//====================DYNAMIC KEYS; DYNAMIC OBJECTS; ITERATE OBJECT; LOOP OBJECT====================//
const data = {
  first_name: "John",
  last_name: "Doe",
  birthday: new Date("January 1, 2000"),
};
for (let i = 0, arrayLength = Object.keys(data).length; i < arrayLength; i++) {
  const key = (Object.keys(data) as (keyof typeof data)[])[i];
  const value = data[key];

  console.log(value);
}
//====================DYNAMIC KEYS; DYNAMIC OBJECTS; ITERATE OBJECT; LOOP OBJECT====================//

//====================ASSIGN DYNAMIC KEYS; DYNAMIC OBJECTS====================//
/* Element implicitly has an 'any' type because expression of type 'string' can't be used to index type 'Datatype'.
No index signature with a parameter of type 'string' was found on type 'Datatype'. */

export interface Person {
  first_name: string;
  last_name: string;
  birthday: Date;
  // [key: string]: string | number | Date | undefined; // Uncomment to fix console.log error
  // [index: number]: string | number | Date | undefined; // For assigning dynamic indexes (number)
}

// Usage
const x: Record<string, string> = {
  first_name: "First Name",
  last_name: "Last Name",
  birthday: "Birthday",
};

const data: Person[] = [
  {
    first_name: "John",
    last_name: "Doe",
    birthday: new Date("January 1, 2000"),
  },
];

for (let i = 0, arrayLength = data.length; i < arrayLength; i++) {
  const key: string[] = Object.keys(x);
  const row = data[i];
  console.log(row[key[i]]); // Uncomment "[key: string]: string | number | Date;" in Person interface
}
//====================ASSIGN DYNAMIC KEYS; DYNAMIC OBJECTS====================//

// Omit type; reuse interface; remove interface property; omit interface property
interface SuperUser {
  userId: number;
  macAddress: string;
  username: string;
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  roles: ("Admin" | "Editor" | "Author")[];
}

interface NormalUser extends Omit<SuperUser, "roles" | "username" | "userId"> {}

const normalUser: NormalUser = {
  userId: 1,
  macAddress: "string",
  username: "string",
  email: "string",
  password: "string",
  firstName: "string",
  lastName: "string",
};