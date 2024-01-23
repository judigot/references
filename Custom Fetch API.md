# Custom Fetch API

## Custom Fetch
```typescript
// customFetch.ts

type DataBody = BodyInit;

const ROOT_URL: string = 'http://localhost:3000/api/v1';

export interface FetchOptions extends RequestInit {
  timeout?: number;
  body?: DataBody;
}

export type RequestInterceptor = (
  url: string,
  options: FetchOptions,
) => FetchOptions;
export type ResponseInterceptor = (response: Response) => Response;

const defaultOptions: FetchOptions = {
  method: 'GET',
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json, text/plain, */*',
  },
};

const requestInterceptors: RequestInterceptor[] = [];
const responseInterceptors: ResponseInterceptor[] = [];

export const addRequestInterceptor = (
  interceptor: RequestInterceptor,
): void => {
  requestInterceptors.push(interceptor);
};

export const addResponseInterceptor = (
  interceptor: ResponseInterceptor,
): void => {
  responseInterceptors.push(interceptor);
};

const applyRequestInterceptors = (
  url: string,
  options: FetchOptions,
): FetchOptions =>
  requestInterceptors.reduce(
    (acc, interceptor) => interceptor(url, acc),
    options,
  );

const applyResponseInterceptors = (response: Response): Response =>
  responseInterceptors.reduce((acc, interceptor) => interceptor(acc), response);

const determineContentType = (body: DataBody): string => {
  if (body instanceof FormData) {
    return 'multipart/form-data';
  }
  if (typeof body === 'object') {
    return 'application/json';
  }
  return 'text/plain';
};

const customFetchInternal = async <T>(
  url: string,
  options: FetchOptions = {},
): Promise<T> => {
  if (!url || typeof url !== 'string') {
    throw new Error('URL must be a valid string');
  }

  const mergedOptions: FetchOptions = { ...defaultOptions, ...options };

  const finalOptions: FetchOptions = applyRequestInterceptors(
    url,
    mergedOptions,
  );

  // Ensure headers object exists
  if (!finalOptions.headers) {
    finalOptions.headers = {};
  }

  // Now TypeScript knows headers is an object, so we can safely add properties
  if (
    finalOptions.body !== undefined &&
    !(finalOptions.headers as Record<string, string>)['Content-Type']
  ) {
    (finalOptions.headers as Record<string, string>)['Content-Type'] =
      determineContentType(finalOptions.body);
  }

  const controller = new AbortController();
  const id = setTimeout(() => controller.abort(), finalOptions.timeout ?? 5000);
  finalOptions.signal = controller.signal;

  try {
    let response: Response = await fetch(`${ROOT_URL}${url}`, finalOptions);
    clearTimeout(id);

    if (!response.ok) {
      throw new Error(
        `There was an HTTP Error with a status code ${response.status}.`,
      );
    }

    response = applyResponseInterceptors(response);
    return await (response.json() as Promise<T>);
  } catch (error) {
    console.error(
      'Error:',
      error instanceof Error ? error.message : String(error),
    );
    throw error;
  }
};

export const customFetch = {
  get: async <T>(params: {
    url: string;
    options?: FetchOptions;
  }): Promise<T> => {
    const { url, options } = params;
    return customFetchInternal<T>(url, { ...options, method: 'GET' });
  },
  post: async <T>(params: {
    url: string;
    body: DataBody;
    options?: FetchOptions;
  }): Promise<T> => {
    const { url, body, options } = params;
    return customFetchInternal<T>(url, { ...options, method: 'POST', body });
  },
};
```

## Usage Example

```typescript
// useFetchAPI.ts

import { customFetch } from "./customFetch";

// Example usage of the get method
const readData = async () => {
  try {
    const userData = await customFetch.get({
      url: `http://localhost:3000/api/v1/languages`,
    });
    console.log(userData);
  } catch (error) {
    console.error('Error fetching user data:', error);
  }
};

// Example usage of the post method
const createData = async (userData: {name: string; email: string}) => {
  try {
    const response = await customFetch.post<{success: boolean}>({
      url: `https://api.example.com/users`,
      body: JSON.stringify(userData),
    });
    console.log(response);
  } catch (error) {
    console.error('Error creating user:', error);
  }
};

// Call the functions as needed
readData()
  .catch((error) => {
    if (typeof error === `string`) throw Error(`There was an error: error`);
    if (error instanceof Error)
      throw Error(`There was an error: ${error.message}`);
  })
  .finally(() => {});

createData({name: 'Jane Doe', email: 'jane@example.com'})
  .then(() => {})
  .catch((error) => {
    if (typeof error === `string`) throw Error(`There was an error: error`);
    if (error instanceof Error)
      throw Error(`There was an error: ${error.message}`);
  })
  .finally(() => {});
```