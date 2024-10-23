#!/bin/bash

# Global variables
main() {
    # rm -rf * .* .git
    # download_laravel

    # git init
    # git add .
    # git commit -m "Initial commit"

    # enable_api

    # git add .
    # git commit -m "feat: enable api"

    # configure_env_for_postgresql
    # generate_migrations
    # create_models
    # migrate_and_seed

    # git add .
    # git commit -m "feat: add user types"
    
    # laravel_passport_setup

    # git add .
    # git commit -m "feat: setup laravel passport"

    # create_auth_controller
    configure_api_guard
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
        sed -i "/'guards' => \[/a \ \ \ \ 'api' => ['driver' => 'passport', 'provider' => 'users', 'hash' => false]," "$AUTH_CONFIG"
        echo -e "'api' guard added with Passport driver."
    fi
}


create_auth_controller() {
    echo -e "Creating AuthController..."

    # Create the AuthController
    cat > app/Http/Controllers/AuthController.php <<EOL
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Laravel\Passport\HasApiTokens;

class AuthController extends Controller
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
        \$loginData = \$request->validate([
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        if (!Auth::attempt(\$loginData)) {
            return response()->json(['error' => 'Invalid credentials'], 401);
        }

        \$user = Auth::user();
        \$token = \$user->createToken('authToken')->accessToken;

        return response()->json(['token' => \$token, 'user' => \$user]);
    }

    /**
     * Get the authenticated user details
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function userDetails()
    {
        return response()->json(['user' => Auth::user()]);
    }

    /**
     * Logout the authenticated user
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function logout(Request \$request)
    {
        if (Auth::check()) {
            // Revoke the user's token
            \$request->user()->token()->revoke();

            return response()->json(['message' => 'Logged out successfully']);
        }

        return response()->json(['error' => 'User not logged in'], 401);
    }
}
EOL

    echo -e "AuthController created successfully!"
}

download_laravel() {
    echo -e "Downloading Laravel..."

    # Use Composer to create a new Laravel project
    composer create-project --prefer-dist laravel/laravel laravel

    echo -e "Laravel has been downloaded!"
}

enable_api() {
    echo -e "Enabling API..."

    # Assuming you are using Laravel 9.x or higher
    php artisan install:api

    echo -e "API has been enabled!"
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
        
        cat > app/Providers/AuthServiceProvider.php <<EOL
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

    # Update .env values for PostgreSQL
    sed -i 's/DB_CONNECTION=sqlite/DB_CONNECTION=pgsql/' .env
    sed -i 's/# DB_HOST=127.0.0.1/DB_HOST=127.0.0.1/' .env
    sed -i 's/# DB_PORT=3306/DB_PORT=5432/' .env
    sed -i 's/# DB_DATABASE=laravel/DB_DATABASE=laravel/' .env
    sed -i 's/# DB_USERNAME=root/DB_USERNAME=root/' .env
    sed -i 's/# DB_PASSWORD=/DB_PASSWORD=123/' .env

    echo -e ".env configured for PostgreSQL."
}

# Step 2: Generate new migration files with fixed names
generate_migrations() {
    echo -e "Generating migration for user_types, user_user_type, and adding soft deletes..."

    # Create the user_types migration with fixed filename 0001_01_01_000003
    cat > database/migrations/0001_01_01_000003_create_user_types_table.php <<EOL
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
    cat > database/migrations/0001_01_01_000004_create_user_user_type_table.php <<EOL
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
    cat > database/migrations/0001_01_01_000005_add_soft_deletes_to_users.php <<EOL
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
    cat > app/Models/UserType.php <<EOL
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;  // Import SoftDeletes

class UserType extends Model
{
    use SoftDeletes;  // Use the SoftDeletes trait

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
    cat > app/Models/User.php <<EOL
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Database\Eloquent\SoftDeletes;  // Import SoftDeletes

class User extends Authenticatable
{
    use HasFactory, Notifiable, SoftDeletes;  // Use the SoftDeletes trait

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
    cat >database/seeders/UserTypeSeeder.php <<EOL
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\UserType;

class UserTypeSeeder extends Seeder
{
    public function run(): void
    {
        // Create user types
        \$superadmin = UserType::create(['name' => 'superadmin']);
        \$admin = UserType::create(['name' => 'admin']);
        \$user = UserType::create(['name' => 'user']);

        // Create John Doe (superadmin)
        \$john = User::create([
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => bcrypt('123')
        ]);
        \$john->userTypes()->attach(\$superadmin->id);

        // Create Jane Doe (user)
        \$jane = User::create([
            'name' => 'Jane Doe',
            'email' => 'jane@example.com',
            'password' => bcrypt('123')
        ]);
        \$jane->userTypes()->attach(\$user->id);
    }
}
EOL

    # Add the seeder call to DatabaseSeeder.php
    sed -i "/call(UserSeeder::class);/a \ \ \ \ \$this->call(UserTypeSeeder::class);" database/seeders/DatabaseSeeder.php

    # Run the seeder
    php artisan db:seed --class=UserTypeSeeder

    echo -e "Seeding complete!"
}

main
