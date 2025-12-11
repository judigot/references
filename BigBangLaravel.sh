#!/bin/bash

DB_CONNECTION=pgsql
DB_HOST=https://localhost
DB_PORT=5432
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=123

# Global variables
main() {
    # php artisan migrate:reset && rm -rf * .* .git
    echo -e "\e[32mInitializing...\e[0m"

    download_laravel
    configure_env_for_postgresql
    generate_migrations

    create_repositories_folder
    create_base_controller
    create_base_repository
    create_base_interface

    enable_api
    register_api_routes
    configure_api_guard

    create_models
    create_auth_controller
    create_auth_routes

    migrate_and_seed

    # composer install
    # generate key: php artisan key:generate

    initializeGit
    echo -e "Big Bang successfully scaffolded."
}

initializeGit() {
    if command -v git >/dev/null 2>&1; then
        echo "Git is installed."

        cd "$PROJECT_DIRECTORY" || return
        git init && git add . && git commit -m "Initial commit" --quiet
    else
        echo "Git is not installed."
    fi
}

create_repositories_folder() {
    mkdir app/Repositories
}

create_base_controller() {
    # Create routes in routes/api.php
    cat >app/Http/Controllers/BaseController.php <<EOL
<?php
//{{ownerComment}}

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Routing\Controller;

abstract class BaseController extends Controller
{
    protected \$repository;

    public function index()
    {
        \$items = \$this->repository->getAll();
        return response()->json(\$items);
    }

    public function show(\$id)
    {
        \$item = \$this->repository->findById(\$id);
        if (\$item) {
            return response()->json(\$item);
        }
        return response()->json(['message' => 'Resource not found'], 404);
    }

    public function store(Request \$request)
    {
        \$item = \$this->repository->create(\$request->all());
        return response()->json(\$item, 201);
    }

    public function update(Request \$request, \$id)
    {
        \$updated = \$this->repository->update(\$id, \$request->all());
        if (\$updated) {
            return response()->json(['message' => 'Resource updated']);
        }
        return response()->json(['message' => 'Resource not found'], 404);
    }

    public function destroy(\$id)
    {
        \$deleted = \$this->repository->delete(\$id);
        if (\$deleted) {
            return response()->json(['message' => 'Resource deleted']);
        }
        return response()->json(['message' => 'Resource not found'], 404);
    }

    public function findByAttributes(Request \$request)
    {
        \$attributes = \$request->all();
        \$item = \$this->repository->findByAttributes(\$attributes);
        if (\$item) {
            return response()->json(\$item);
        }
        return response()->json(['message' => 'Resource not found'], 404);
    }

    public function paginate(Request \$request)
    {
        \$perPage = \$request->input('per_page', 15);
        \$items = \$this->repository->paginate(\$perPage);
        return response()->json(\$items);
    }

    public function search(Request \$request)
    {
        \$query = \$request->input('query');
        \$fields = \$request->input('fields', []);
        \$perPage = \$request->input('per_page', 15);
        \$results = \$this->repository->search(\$query, \$fields, \$perPage);
        return response()->json(\$results);
    }

    public function count(Request \$request)
    {
        \$criteria = \$request->all();
        \$count = \$this->repository->count(\$criteria);
        return response()->json(['count' => \$count]);
    }

    public function getWithRelations(Request \$request)
    {
        \$relations = \$request->input('relations', []);
        \$items = \$this->repository->getWithRelations(\$relations);
        return response()->json(\$items);
    }

    public function findOrFail(\$id)
    {
        \$item = \$this->repository->findOrFail(\$id);
        return response()->json(\$item);
    }

    public function updateOrCreate(Request \$request)
    {
        \$attributes = \$request->input('attributes', []);
        \$values = \$request->input('values', []);
        \$item = \$this->repository->updateOrCreate(\$attributes, \$values);
        return response()->json(\$item);
    }

    public function softDelete(\$id)
    {
        \$softDeleted = \$this->repository->softDelete(\$id);
        if (\$softDeleted) {
            return response()->json(['message' => 'Resource soft-deleted']);
        }
        return response()->json(['message' => 'Resource not found'], 404);
    }

    public function restore(\$id)
    {
        \$restored = \$this->repository->restore(\$id);
        if (\$restored) {
            return response()->json(['message' => 'Resource restored']);
        }
        return response()->json(['message' => 'Resource not found'], 404);
    }

    public function batchUpdate(Request \$request)
    {
        \$criteria = \$request->input('criteria', []);
        \$data = \$request->input('data', []);
        \$updated = \$this->repository->batchUpdate(\$criteria, \$data);
        return response()->json(['updated' => \$updated]);
    }

    public function exists(Request \$request)
    {
        \$criteria = \$request->all();
        \$exists = \$this->repository->exists(\$criteria);
        return response()->json(['exists' => \$exists]);
    }

    public function pluck(Request \$request)
    {
        \$column = \$request->input('column');
        \$key = \$request->input('key', null);
        \$values = \$this->repository->pluck(\$column, \$key);
        return response()->json(\$values);
    }

    public function firstOrCreate(Request \$request)
    {
        \$attributes = \$request->input('attributes', []);
        \$values = \$request->input('values', []);
        \$item = \$this->repository->firstOrCreate(\$attributes, \$values);
        return response()->json(\$item);
    }

    public function firstOrNew(Request \$request)
    {
        \$attributes = \$request->input('attributes', []);
        \$values = \$request->input('values', []);
        \$item = \$this->repository->firstOrNew(\$attributes, \$values);
        return response()->json(\$item);
    }

    public function chunk(Request \$request)
    {
        \$size = \$request->input('size', 100);
        \$callback = function (\$items) {
            return response()->json(\$items);
        };
        \$this->repository->chunk(\$size, \$callback);
    }

    public function each()
    {
        \$callback = function (\$item) {
            return response()->json(\$item);
        };
        \$this->repository->each(\$callback);
    }

    public function random(Request \$request)
    {
        \$count = \$request->input('count', 1);
        \$items = \$this->repository->random(\$count);
        return response()->json(\$items);
    }

    public function latest(Request \$request)
    {
        \$column = \$request->input('column', 'created_at');
        \$item = \$this->repository->latest(\$column);
        return response()->json(\$item);
    }

    public function oldest(Request \$request)
    {
        \$column = \$request->input('column', 'created_at');
        \$item = \$this->repository->oldest(\$column);
        return response()->json(\$item);
    }

    public function findMany(Request \$request)
    {
        \$ids = \$request->input('ids', []);
        \$items = \$this->repository->findMany(\$ids);
        return response()->json(\$items);
    }

    public function whereIn(Request \$request)
    {
        \$column = \$request->input('column');
        \$values = \$request->input('values', []);
        \$items = \$this->repository->whereIn(\$column, \$values);
        return response()->json(\$items);
    }

    public function whereNotIn(Request \$request)
    {
        \$column = \$request->input('column');
        \$values = \$request->input('values', []);
        \$items = \$this->repository->whereNotIn(\$column, \$values);
        return response()->json(\$items);
    }

    public function whereBetween(Request \$request)
    {
        \$column = \$request->input('column');
        \$range = \$request->input('range', []);
        \$items = \$this->repository->whereBetween(\$column, \$range);
        return response()->json(\$items);
    }

    public function withTrashed()
    {
        \$items = \$this->repository->withTrashed();
        return response()->json(\$items);
    }

    public function onlyTrashed()
    {
        \$items = \$this->repository->onlyTrashed();
        return response()->json(\$items);
    }

    public function withoutTrashed()
    {
        \$items = \$this->repository->withoutTrashed();
        return response()->json(\$items);
    }

    public function orderBy(Request \$request)
    {
        \$column = \$request->input('column');
        \$direction = \$request->input('direction', 'asc');
        \$items = \$this->repository->orderBy(\$column, \$direction);
        return response()->json(\$items);
    }

    public function groupBy(Request \$request)
    {
        \$column = \$request->input('column');
        \$items = \$this->repository->groupBy(\$column);
        return response()->json(\$items);
    }
}
EOL
}

create_base_repository() {
    cat >app/Repositories/BaseRepository.php <<EOL
<?php
//{{ownerComment}}

namespace App\Repositories;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Collection;
use App\Repositories\BaseInterface;

abstract class BaseRepository implements BaseInterface
{
    protected Model \$model;

    public function __construct(Model \$model)
    {
        \$this->model = \$model;
    }

    public function getAll(): Collection
    {
        return \$this->model->all();
    }

    public function findById(int \$id): ?Model
    {
        return \$this->model->find(\$id);
    }

    public function create(array \$data): Model
    {
        return \$this->model->create(\$data);
    }

    public function update(int \$id, array \$data): bool
    {
        \$record = \$this->model->find(\$id);
        return \$record ? \$record->update(\$data) : false;
    }

    public function delete(int \$id): bool
    {
        \$record = \$this->model->find(\$id);
        return \$record ? \$record->delete() : false;
    }

    public function findByAttributes(array \$attributes): ?Model
    {
        return \$this->model->where(\$attributes)->first();
    }

    public function paginate(int \$perPage = 15)
    {
        return \$this->model->paginate(\$perPage);
    }

    public function search(string \$query, array \$fields, int \$perPage = 15)
    {
        return \$this->model->where(function (\$q) use (\$query, \$fields) {
            foreach (\$fields as \$field) {
                \$q->orWhere(\$field, 'LIKE', "%\$query%");
            }
        })->paginate(\$perPage);
    }

    public function count(array \$criteria = []): int
    {
        return \$this->model->where(\$criteria)->count();
    }

    public function getWithRelations(array \$relations): Collection
    {
        return \$this->model->with(\$relations)->get();
    }

    public function findOrFail(int \$id): Model
    {
        return \$this->model->findOrFail(\$id);
    }

    public function updateOrCreate(array \$attributes, array \$values = []): Model
    {
        return \$this->model->updateOrCreate(\$attributes, \$values);
    }

    public function softDelete(int \$id): bool
    {
        \$record = \$this->model->find(\$id);
        return \$record ? \$record->delete() : false;
    }

    public function restore(int \$id): bool
    {
        \$record = \$this->model->onlyTrashed()->find(\$id);
        return \$record ? \$record->restore() : false;
    }

    public function batchUpdate(array \$criteria, array \$data): bool
    {
        return \$this->model->where(\$criteria)->update(\$data) > 0;
    }

    public function exists(array \$criteria): bool
    {
        return \$this->model->where(\$criteria)->exists();
    }

    public function pluck(string \$column, string \$key = null): Collection
    {
        return \$this->model->pluck(\$column, \$key);
    }

    public function firstOrCreate(array \$attributes, array \$values = []): Model
    {
        return \$this->model->firstOrCreate(\$attributes, \$values);
    }

    public function firstOrNew(array \$attributes, array \$values = []): Model
    {
        return \$this->model->firstOrNew(\$attributes, \$values);
    }

    public function chunk(int \$size, callable \$callback): bool
    {
        return \$this->model->chunk(\$size, \$callback);
    }

    public function each(callable \$callback): bool
    {
        return \$this->model->each(\$callback);
    }

    public function random(int \$count = 1): Collection
    {
        return \$this->model->inRandomOrder()->limit(\$count)->get();
    }

    public function latest(string \$column = 'created_at'): ?Model
    {
        return \$this->model->latest(\$column)->first();
    }

    public function oldest(string \$column = 'created_at'): ?Model
    {
        return \$this->model->oldest(\$column)->first();
    }

    public function findMany(array \$ids): Collection
    {
        return \$this->model->findMany(\$ids);
    }

    public function whereIn(string \$column, array \$values): Collection
    {
        return \$this->model->whereIn(\$column, \$values)->get();
    }

    public function whereNotIn(string \$column, array \$values): Collection
    {
        return \$this->model->whereNotIn(\$column, \$values)->get();
    }

    public function whereBetween(string \$column, array \$range): Collection
    {
        return \$this->model->whereBetween(\$column, \$range)->get();
    }

    public function withTrashed(): Collection
    {
        return \$this->model->withTrashed()->get();
    }

    public function onlyTrashed(): Collection
    {
        return \$this->model->onlyTrashed()->get();
    }

    public function withoutTrashed(): Collection
    {
        return \$this->model->withoutTrashed()->get();
    }

    public function orderBy(string \$column, string \$direction = 'asc'): Collection
    {
        return \$this->model->orderBy(\$column, \$direction)->get();
    }

    public function groupBy(string \$column): Collection
    {
        return \$this->model->groupBy(\$column)->get();
    }
}
EOL
}
create_base_interface() {
    cat >app/Repositories/BaseInterface.php <<EOL
<?php
//{{ownerComment}}

namespace App\Repositories;

use Illuminate\Support\Collection;
use Illuminate\Database\Eloquent\Model;

interface BaseInterface
{
    public function getAll(): Collection;
    public function findById(int \$id): ?Model;
    public function create(array \$data): Model;
    public function update(int \$id, array \$data): bool;
    public function delete(int \$id): bool;
    public function findByAttributes(array \$attributes): ?Model;
    public function paginate(int \$perPage = 15);
    public function search(string \$query, array \$fields, int \$perPage = 15);
    public function count(array \$criteria = []): int;
    public function getWithRelations(array \$relations): Collection;
    public function findOrFail(int \$id): Model;
    public function updateOrCreate(array \$attributes, array \$values = []): Model;
    public function softDelete(int \$id): bool;
    public function restore(int \$id): bool;
    public function batchUpdate(array \$criteria, array \$data): bool;
    public function exists(array \$criteria): bool;
    public function pluck(string \$column, string \$key = null): Collection;
    public function firstOrCreate(array \$attributes, array \$values = []): Model;
    public function firstOrNew(array \$attributes, array \$values = []): Model;
    public function chunk(int \$size, callable \$callback): bool;
    public function each(callable \$callback): bool;
    public function random(int \$count = 1): Collection;
    public function latest(string \$column = 'created_at'): ?Model;
    public function oldest(string \$column = 'created_at'): ?Model;
    public function findMany(array \$ids): Collection;
    public function whereIn(string \$column, array \$values): Collection;
    public function whereNotIn(string \$column, array \$values): Collection;
    public function whereBetween(string \$column, array \$range): Collection;
    public function withTrashed(): Collection;
    public function onlyTrashed(): Collection;
    public function withoutTrashed(): Collection;
    public function orderBy(string \$column, string \$direction = 'asc'): Collection;
    public function groupBy(string \$column): Collection;
}
EOL
}

create_auth_routes() {
    echo -e "Creating API routes for AuthController..."

    # Create routes in routes/api.php
    cat >routes/api.php <<EOL
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

// Public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Protected routes
Route::middleware('auth:api')->group(function () {
    Route::get('/user', [AuthController::class, 'user']);
    Route::post('/logout', [AuthController::class, 'logout']);
});
EOL

    echo -e "Auth routes added to routes/api.php successfully!"
}

configure_api_guard() {
    echo -e "Configuring API guard for Passport in config/auth.php..."

    AUTH_CONFIG="config/auth.php"

    # Check if 'guards' array exists in config/auth.php and 'api' guard is present
    if grep -q "'api' =>" "$AUTH_CONFIG"; then
        # Update the 'api' guard to use 'passport' as the driver
        sed -i "s/'driver' => '.*'/'driver' => 'passport'/" "$AUTH_CONFIG"
        echo -e "'api' guard updated to use Passport driver."
    else
        # Add the 'api' guard if it's missing
        sed -i "/'guards' => \[/a \ \ \ \     'api' => ['driver' => 'passport', 'provider' => 'users', 'hash' => false]," "$AUTH_CONFIG"
        echo -e "'api' guard added with Passport driver."
    fi
}

create_auth_controller() {
    echo -e "Creating AuthController..."

    # Create the AuthController
    cat >app/Http/Controllers/AuthController.php <<EOL
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Http\Controllers\BaseController;

class AuthController extends BaseController
{
    /**
     * Register a new user
     *
     * @param \Illuminate\Http\Request \$request
     * @return \Illuminate\Http\JsonResponse
     */
    public function register(Request \$request)
    {
        \$validatedData = \$request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
        ]);

        \$user = User::create([
            'name' => \$validatedData['name'],
            'email' => \$validatedData['email'],
            'password' => Hash::make(\$validatedData['password']),
        ]);

        \$token = \$user->createToken('authToken')->accessToken;

        return response()->json(['token' => \$token], 201);
    }

    /**
     * Login a user
     *
     * @param \Illuminate\Http\Request \$request
     * @return \Illuminate\Http\JsonResponse
     */
    public function login(Request \$request)
    {
        \$credentials = \$request->only('email', 'password');

        if (!Auth::attempt(\$credentials)) {
            \$user = User::where('email', \$credentials['email'])->first();

            if (!\$user) {
                return response()->json([
                    'status' => 404,
                    'message' => 'User not found',
                    'error_code' => 'USER_NOT_FOUND'
                ], 404);
            }

            return response()->json([
                'status' => 401,
                'message' => 'Invalid credentials',
                'error_code' => 'INVALID_CREDENTIALS'
            ], 401);
        }

        \$user = Auth::user();
        \$user->load('userTypes');

        \$token = \$user->createToken('Personal Access Token')->accessToken;
        return response()->json([
            'user' => \$user,
            'accessToken' => \$token,
        ], 200);
    }


    /**
     * Get the authenticated user details
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function user(Request \$request)
    {
        \$user = \$request->user();
        \$user->load('userTypes'); // Eager load user types

        // Return the authenticated user's information
        return response()->json(\$user);
    }


    /**
     * Logout the authenticated user
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function logout(Request \$request)
    {
        \$request->user()->token()->revoke();
        return response()->json(['message' => 'Logged out successfully']);
    }
}
EOL

    echo -e "AuthController created successfully!"
}

download_laravel() {
    echo -e "Downloading Laravel..."
    composer create-project --prefer-dist laravel/laravel .
    echo -e "Laravel has been downloaded!"
}

enable_api() {
    echo -e "Enabling API..."
    # php artisan install:api --passport
    echo -e "\n" | php artisan install:api --passport
    echo -e "API has been enabled!"
}

register_api_routes() {
    echo -e "Registering API routes in bootstrap/app.php..."
    
    APP_FILE="bootstrap/app.php"
    
    if [ ! -f "$APP_FILE" ]; then
        echo -e "Error: $APP_FILE not found!"
        return 1
    fi
    
    # Check if API routes are already registered
    if grep -q "api: __DIR__.'/../routes/api.php'" "$APP_FILE"; then
        echo -e "API routes already registered in $APP_FILE"
        return 0
    fi
    
    # Check if withRouting exists
    if ! grep -q "withRouting" "$APP_FILE"; then
        echo -e "Error: withRouting() not found in $APP_FILE"
        return 1
    fi
    
    # Add API route registration after web route
    # This uses sed to insert the line after the web: line
    sed -i "/web: __DIR__.'\/..\/routes\/web.php',/a \        api: __DIR__.'/../routes/api.php'," "$APP_FILE"
    
    echo -e "API routes registered successfully in $APP_FILE"
}

laravel_passport_setup() {
    echo -e "Setting up Laravel Passport..."

    # Step 1: Install Passport via Composer
    composer require laravel/passport

    # Step 2: Run the Passport installation command
    php artisan passport:install

    # Step 3: Publish Passport's assets (including migrations)
    php artisan vendor:publish --tag=passport-migrations

    # Step 4: Generate the AuthServiceProvider if not already present
    if [ ! -f "app/Providers/AuthServiceProvider.php" ]; then
        echo -e "AuthServiceProvider.php not found. Generating AuthServiceProvider..."

        cat >app/Providers/AuthServiceProvider.php <<EOL
<?php

namespace App\Providers;

use Laravel\Passport\Passport;
use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Gate;

class AuthServiceProvider extends ServiceProvider
{
    /**
     * The policy mappings for the application.
     *
     * @var array
     */
    protected \$policies = [
        // 'App\\Models\\Model' => 'App\\Policies\\ModelPolicy',
    ];

    /**
     * Register any authentication / authorization services.
     */
    public function boot()
    {
        \$this->registerPolicies();

        // Register Passport routes
        Passport::routes();
    }
}
EOL
        echo -e "AuthServiceProvider.php created and Passport routes added."
    fi

    # Step 5: Register AuthServiceProvider in config/app.php
    if ! grep -q "App\\\\Providers\\\\AuthServiceProvider::class" config/app.php; then
        sed -i "/App\\\\Providers\\\\AppServiceProvider::class,/a \ \ \ \ App\\\\Providers\\\\AuthServiceProvider::class," config/app.php
        echo -e "AuthServiceProvider added to config/app.php"
    else
        echo -e "AuthServiceProvider already registered in config/app.php"
    fi

    # Step 6: Add Passport to the 'api' guard in config/auth.php
    sed -i "s/'driver' => 'token'/'driver' => 'passport'/" config/auth.php

    # Step 7: Add HasApiTokens to User model if not already present
    USER_MODEL="app/Models/User.php"
    if [ -f "$USER_MODEL" ]; then
        if ! grep -q "HasApiTokens" "$USER_MODEL"; then
            sed -i "/use HasFactory,/a \ \ \ \ use Laravel\\\\Passport\\\\HasApiTokens;" "$USER_MODEL"
            sed -i "s/use HasFactory, Notifiable;/use HasApiTokens, HasFactory, Notifiable;/" "$USER_MODEL"
            echo -e "HasApiTokens trait added to User model."
        else
            echo -e "HasApiTokens trait already present in User model."
        fi
    else
        echo -e "User model not found. Please ensure the User model exists in app/Models/User.php."
    fi

    echo -e "Laravel Passport setup completed!"
}

# Step 1: Configure .env for PostgreSQL
configure_env_for_postgresql() {
    echo -e "Configuring .env for PostgreSQL..."

    clone .env.example .env

    # Update .env values for PostgreSQL
    sed -i "s/^DB_CONNECTION=[^ ]*/DB_CONNECTION=$DB_CONNECTION/" .env
    sed -i "s/^# DB_HOST=[^ ]*/DB_HOST=$DB_HOST/" .env
    sed -i "s/^# DB_PORT=[^ ]*/DB_PORT=$DB_PORT/" .env
    sed -i "s/^# DB_DATABASE=[^ ]*/DB_DATABASE=$DB_DATABASE/" .env
    sed -i "s/^# DB_USERNAME=[^ ]*/DB_USERNAME=$DB_USERNAME/" .env
    sed -i "s/^# DB_PASSWORD=[^ ]*/DB_PASSWORD=$DB_PASSWORD/" .env

    echo -e ".env configured for PostgreSQL."
}

# Step 2: Generate new migration files with fixed names
generate_migrations() {
    echo -e "Generating migration for user_types, user_user_type, and adding soft deletes..."

    # Create the user_types migration with fixed filename 0001_01_01_000003
    cat >database/migrations/0001_01_01_000003_create_user_types_table.php <<EOL
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('user_types', function (Blueprint \$table) {
            \$table->id();
            \$table->string('name')->unique(); // Role name like 'superadmin', 'admin', 'user'
            \$table->timestamps();
            \$table->softDeletes();  // Add soft deletes
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_types');
    }
};
EOL

    # Create the user_user_type pivot table migration with fixed filename 0001_01_01_000004
    cat >database/migrations/0001_01_01_000004_create_user_user_type_table.php <<EOL
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('user_user_type', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('user_id')->constrained()->onDelete('cascade');
            \$table->foreignId('user_type_id')->constrained()->onDelete('cascade');
            \$table->timestamps();
            \$table->softDeletes();  // Add soft deletes
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_user_type');
    }
};
EOL

    # Add soft deletes to users table (if not already existing)
    cat >database/migrations/0001_01_01_000005_add_soft_deletes_to_users.php <<EOL
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint \$table) {
            \$table->softDeletes();  // Adds the deleted_at column for soft deletes
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint \$table) {
            \$table->dropColumn('deleted_at');  // Remove the deleted_at column if needed
        });
    }
};
EOL

    echo -e "Migration files created successfully!"
}

# Step 3: Create UserType model and update User model with default comments
create_models() {
    echo -e "Creating UserType model and updating User model..."

    # Create UserType model
    cat >app/Models/UserType.php <<EOL
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class UserType extends Model
{
    use SoftDeletes;

    protected \$fillable = ['name'];

    /**
     * The users that belong to this user type.
     */
    public function users()
    {
        return \$this->belongsToMany(User::class, 'user_user_type', 'user_type_id', 'user_id')->withTimestamps();
    }
}
EOL

    # Update User model to include the relationship with user types and keep default comments
    cat >app/Models/User.php <<EOL
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Database\Eloquent\SoftDeletes;
use Laravel\Passport\HasApiTokens; // Used by laravel passport

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable, SoftDeletes;

    /** @use HasFactory<\\Database\\Factories\\UserFactory> */
    
    protected \$fillable = [
        'name',
        'email',
        'password',
    ];

    protected \$hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    /**
     * The user can have multiple user types (roles).
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function userTypes()
    {
        return \$this->belongsToMany(UserType::class, 'user_user_type', 'user_id', 'user_type_id')->withTimestamps();
    }
}
EOL

    echo -e "UserType model created and User model updated successfully with default comments!"
}

# Step 4: Run migrations and seed the database (including John Doe and Jane Doe)
migrate_and_seed() {
    echo -e "Running migrations and seeding data..."

    # Run migrations
    php artisan migrate

    # Seed initial user types and users (John Doe and Jane Doe)
    echo "Seeding user types and users..."
    cat >database/seeders/UserSeeder.php <<EOL
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\UserType;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        // Create user types
        \$superadmin = UserType::create(['name' => 'superadmin']);
        \$admin = UserType::create(['name' => 'admin']);
        \$user = UserType::create(['name' => 'user']);

        // Create John Smith (superadmin)
        \$john = User::create([
            'name' => 'John Smith',
            'email' => 'johnsmith@example.com',
            'password' => bcrypt('123')
        ]);
        \$john->userTypes()->attach(\$superadmin->id);

        // Create John Doe (admin)
        \$john = User::create([
            'name' => 'John Doe',
            'email' => 'johndoe@example.com',
            'password' => bcrypt('123')
        ]);
        \$john->userTypes()->attach(\$admin->id);

        // Create Jane Doe (user)
        \$jane = User::create([
            'name' => 'Jane Doe',
            'email' => 'janedoe@example.com',
            'password' => bcrypt('123')
        ]);
        \$jane->userTypes()->attach(\$user->id);
    }
}
EOL

    # Run the seeder
    php artisan db:seed --class=UserSeeder

    echo -e "Seeding complete!"
}

main
