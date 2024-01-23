Laravel:

https://laracasts.com/series/laravel-from-scratch-2018/

Install dependencies (package.json)
Blank project steps:
Apply custom settings
Create migrations
Create models
Create controller (RESTful)
Setup routes

==============
PRODUCTION:
1. Cache config files
2. Store api keys, credentials, etc. in the .env file
==============

•••••••••••••••••••••••••••••••••••••••••••
Learn:
•Convert DB structure to migration
•Use query builder than eloquent:
https://fideloper.com/laravel-raw-queries

Service provider:
register() method loads first before the boot() method
When adding a service, go to app>config>services.php and input the necessary detail referencing the .env file (config files work like dbinfo.json)

•••••••••••••••••••••••••••••••••••••••••••
•Custom Settings
Add following code to AppServiceProvider.php (/app/Providers/AppServiceProvider.php)
===============================
use Illuminate\Support\Facades\Schema;
function boot()
{
    Schema::defaultStringLength(191);
}
===============================

•Commands
Start the project:
	php artisan serve

CONTROLLER COMMANDS:
*__construct is the first thing that runs in a class when called

•Create Controller/Class:
	php artisan make:controller sampleController
•Create Controller/Class with existing functions:
	php artisan make:controller SampleController -r
•Create Controller with existing functions and Model:
	php artisan make:controller SampleModelController -r -m SampleModel

MIGRATION COMMANDS:
•Define database tables from PHP classes (setup the database details in .env file first):
	php artisan migrate
•Create "migrations" table:
	php artisan migrate:install
•Rollback last migration:
	php artisan migrate:rollback
•Redefine database tables:
	php artisan migrate:fresh
•Create table:
	php artisan make:migration create_sample_table
•Update table:
	php artisan make:migration create_sample_table

MODEL COMMANDS:
•Create model:
	php artisan make:model Tablename
•Create one-to-make relationship
	php artisan make:model Order -m -f

SERVICE PROVIDER COMMANDS:
•Create provider
	php artisan make:provider SampleProvider
•Cache config files (for production)
	php artisan config:cache
•Remove cached config files
	php artisan config:clear

MIDDLEWARE COMMANDS:
•Create middleware (after creating, instantiate it in the Kernel.php, add conditions in the handle() function)
	php artisan make:middleware MiddlewareName

*2 types of middleware:
	•Global = runs on every request/page
	•Route = optional on every request/page (e.g: authentication)

AUTHENTICATION
*can be applied on the controller (constructor) or routes (web.php)
•Create login and registration system
	php artisan make:auth

LARAVEL TELESCOPE
•Require telescope
	composer require laravel/telescope --dev
•Install telescope
	php artisan telescope:install
	php artisan migrate

DEPENDENCIES
•Install dependencies
	npm install
•Compile assets (css, javascript)
	npm run dev
	npm run production
•Auto-compile assets when changed
	npm run watch

=================================================

•Routing
Router = routes>web.php
Views/Pages = (resources>views)
•Controller
•Migrations
•Models
•CSRF Protection token
•Routing Conventions
•Validation
•Service Provider (Runs on every page load)
•Authentication
•Laravel Telescope
•Events (Custom) to separate extra logic from the main purpose (CRUD)
•Notifications
•Webpack
•Collections