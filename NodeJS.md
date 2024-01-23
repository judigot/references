Node.js:

npm config set shell "C:\\judigot\\Programming\\Environment\\PortableGit\\bin\\bash.exe"

-----------------------------------------------
Project Scaffolding:

## Install NestJS
```
git clone https://github.com/nestjs/typescript-starter.git .
pnpm install
pnpm run start
```
## Fix Initial ESLint Errors
Add this to .eslintrc.js inside **rules**
```
"prettier/prettier": [
  "error",
  {
    "endOfLine": "auto"
  }
],
```

Vite (TypeScript):

	npm create vite@latest . -- --template react-ts
	
	pnpm create vite . --template react-ts
	
Next.js

	Install on current directory:
		npx create-next-app@latest . --use-pnpm --ts --tailwind --eslint --app --src-dir --import-alias @/*
	
	Install on current a different directory:
		npx create-next-app@latest bigbang --use-pnpm --ts --tailwind --eslint --app --src-dir --import-alias @/*

		What is your project named? bigbang
		Would you like to use TypeScript? Yes
		Would you like to use ESLint? Yes
		Would you like to use Tailwind CSS? Yes
		Would you like to use `src/` directory? Yes
		Would you like to use App Router? (recommended) Yes
		Would you like to customize the default import alias (@/*)? Yes
		What import alias would you like configured? @/*
	
	Update next.js installation:
		npm i next@latest react@latest react-dom@latest eslint-config-next@latest
	
	getServerSideProps:
		- use for authentication and conditional rendering
		- render data on request time
	
	getStaticProps:
		- for SEO
		- for static pages
		- generates static html and json files for caching
-----------------------------------------------

PurgeCSS (remove unused css)
https://www.youtube.com/watch?v=y3WQoON6Vfc
-----------------------------------------------
Commands:
•Show unused packages:
  npx depcheck

•Create package.json with wizard:
	npm init

•Create package.json without wizard:
	npm init -y

•Install all dependencies from package-lock.json:
	npm ci

•Install development/production dependencies in package-lock.json
	npm ci --only=development
	npm ci --only=production

•Install all dependencies from package.json:
	npm install

•Install all production ("dependencies") dependencies from package.json globally
	npm install --only=production

•Install all development ("devDependencies") dependencies from package.json globally
	npm install --only=development

•Install dependencies globally
        npm install -g
	
•Check package version; check dependency version
        npm view <package-name> version

•Delete all dependencies:
	npm uninstall *
-----------------------------------------------
-----------------------------------------------
Scripts:
*clear clears the console
*rom -r dist deletes the dist folder

"dev": "clear && rm -r dist && webpack --mode development",
"build": "clear && rm -r dist && webpack --mode production && tsc -p .",
"watch": "clear && rm -r dist && webpack --watch --mode development"
-----------------------------------------------
======================Global Dependepcies======================
======================Big Bang Dependepcies======================
npm install -D nodemon
npm install --save-prod express
npm install --save-prod dotenv
npm install --save-prod bcrypt
npm install --save-prod sequelize

npm install --save-prod typescript
npm install --save-prod ts-node

npm install --save-prod @types/node

npm install @types/bcrypt
npm install @types/express

npm install --save-prod ejs
npm install --save-prod ejs-loader
npm install --save-prod mysql2
======================Production Dependepcies======================
npm install --save-prod bootstrap
npm install --save-prod @popperjs/core
npm install --save-prod jquery
npm install --save-prod jquery-ui-dist

npm install --save-prod bootstrap-timepicker

npm install --save-prod jquery-contextmenu
npm install --save-prod datatables.net-dt

npm install --save-prod notifyjs
npm install --save-prod flipclock
npm install --save-prod @fortawesome/fontawesome-free
:: End
======================Development Dependepcies======================
npm install -D webpack
npm install -D webpack-cli

npm install -D @babel/core
npm install -D babel-loader
npm install -D @babel/preset-env

npm install -D node-sass
npm install -D sass-loader
npm install -D css-loader
npm install -D style-loader

npm install -D mini-css-extract-plugin

npm install -D purgecss-webpack-plugin
npm install -D file-loader

npm install -D clean-webpack-plugin

npm install -D html-webpack-plugin
npm install -D copy-webpack-plugin

npm install -D img-loader
:: End
	
# NVM Installation

1. Download nvm-noinstall.zip from the latest version here: https://github.com/coreybutler/nvm-windows/releases
2. Extract to a folder named "nvm" in C:\judigot\Programming\Environment\nvm
3. Run "install.cmd" that's inside the extracted "nvm" folder
4. Enter "C:\judigot\Programming\Environment\nvm" as the absolute path
5. Set the "path:" inside "settings.txt" to "C:/judigot/Programming/Environment/nodejs"