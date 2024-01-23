# Database Must-Haves
- Insert date and time in UTC. This means, whenever you have a user that inserts or updates a datetime value in the database, convert it to UTC and store the UTC value in the database column. Your data will be consistent. Then in the client's side, convert the UTC to the client's timezone.

# Database Schema Template

Convert this PostgreSQL schema to another database (e.g. MySQL):
- Run this template on a PostgreSQL database
- Introspect using prisma/sequelize to generate a schema file or models
- Change the database client in your .env file e.g. MySQL
- Push the generated prisma/sequelize schema to the target database

```sql
CREATE TYPE "user_types" AS ENUM ('administrator', 'standard');
CREATE TABLE "user" (
    "user_id" BIGSERIAL NOT NULL,
    "email" VARCHAR(255) UNIQUE NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "user_type" user_types DEFAULT 'standard',
    PRIMARY KEY ("user_id")
);
CREATE TABLE "product" (
    "product_id" BIGSERIAL NOT NULL,
    "sku" VARCHAR(255) UNIQUE NOT NULL,
    "product_name" VARCHAR(255) NOT NULL,
    "cost" NUMERIC,
    "price" NUMERIC,
    PRIMARY KEY ("product_id")
);
CREATE TABLE "customer" (
    "customer_id" BIGSERIAL NOT NULL,
    "customer_name" VARCHAR(255) UNIQUE NOT NULL,
    PRIMARY KEY ("customer_id")
);
CREATE TABLE "order" (
    "order_id" BIGSERIAL NOT NULL,
    "customer_id" BIGINT NOT NULL,
    "order_date" TIMESTAMPTZ NOT NULL,
    PRIMARY KEY ("order_id"),
    CONSTRAINT "FK_order.customer_id" FOREIGN KEY ("customer_id") REFERENCES "customer"("customer_id")
);
CREATE TABLE "order_product" (
    "id" BIGSERIAL NOT NULL,
    "order_id" BIGINT NOT NULL,
    "product_id" BIGINT NOT NULL,
    PRIMARY KEY ("id"),
    CONSTRAINT "FK_order_product.order_id" FOREIGN KEY ("order_id") REFERENCES "order"("order_id"),
    CONSTRAINT "FK_order_product.product_id" FOREIGN KEY ("product_id") REFERENCES "product"("product_id")
);
```

# SQL Datatypes

1. **BIGSERIAL (BIGINT AUTO_INCREMENT in MySQL)**
    - **Examples**: `order_number`, `invoice_id`, `customer_id`, `ticket_id`, `reservation_id`
    - **Context**: Ideal for auto-incrementing primary keys in large tables, ensuring unique identifiers for each record.

2. **BIGINT (Same in MySQL)**
    - **Examples**: `foreign_order_id`, `foreign_product_id`, `foreign_customer_id`, `external_reference_id`, `linked_transaction_id`
    - **Context**: Suitable for referencing BIGSERIAL or BIGINT AUTO_INCREMENT primary keys from other tables, especially in large databases.

3. **UUID (Same in MySQL)**
    - **Examples**: `system_process_id`, `global_user_identifier`, `unique_payment_reference`, `distributed_transaction_id`, `cross_service_session_id`
    - **Context**: Ideal for globally unique identifiers, particularly in distributed systems or where collision avoidance is critical.

4. **VARCHAR(32) (Same in MySQL)**
    - **Examples**: `api_token`, `device_uuid`, `reference_code`, `short_url_key`, `activation_code`
    - **Context**: Used for storing fixed-size, unique strings like UUIDs, API keys, and other short identifiers.

5. **TEXT (Same in MySQL)**
    - **Examples**: `blog_post_content`, `customer_feedback`, `email_body`, `long_description`, `detailed_instructions`
    - **Context**: Ideal for fields requiring large or variable-length text data, such as descriptions, articles, or user-generated content.

6. **DECIMAL or NUMERIC (DECIMAL in MySQL)**
    - **Examples**: `product_price`, `monthly_salary`, `tax_amount`, `exchange_rate`, `mortgage_rate`
    - **Context**: Perfect for precise numerical values, especially in financial data, to avoid rounding errors and maintain accuracy.
    - **SQL**: `CREATE TABLE transactions ( amount DECIMAL(15, 2) );`

7. **FLOAT / DOUBLE (Same in MySQL)**
    - **Examples**: `gps_latitude`, `gps_longitude`, `temperature_reading`, `scientific_measurement`, `stock_price`
    - **Context**: Suitable for storing approximate floating-point numbers, with FLOAT for single precision and DOUBLE for double precision, used where exact precision is less critical.

8. **TIMESTAMP (Same in MySQL)**
    - **Examples**: `last_login_time`, `record_creation_date`, `email_sent_time`, `download_timestamp`, `subscription_start`
    - **Context**: Useful for tracking dates and times of various events or record changes, without time zone details.

9. **TIMESTAMPTZ (DATETIME in MySQL)**
    - **Examples**: `flight_departure_time`, `international_event_date`, `appointment_scheduled_at`, `global_webinar_start`, `multi_timezone_meeting`
    - **Context**: Essential for applications dealing with multiple time zones, as it includes time zone information for accuracy in scheduling and event management.

10. **BOOLEAN (TINYINT(1) in MySQL)**
    - **Examples**: `is_active_flag`, `email_verified_status`, `two_factor_authentication_enabled`, `newsletter_subscription_status`, `new_user_indicator`
    - **Context**: Commonly used in MySQL as a boolean type to represent small integers or boolean values like flags and statuses.

11. **TIMESTAMPTZ(6) (DATETIME(6) in MySQL)**
    - **Examples**: `high_precision_event_time`, `transaction_completed_at`, `system_log_timestamp`, `sensor_data_recorded_at`, `audit_trail_created_time`
    - **Context**: Ideal for storing dates and times with fractional seconds, useful in high-precision time recording applications like logging systems.

12. **ENUM (Same in MySQL)**
    - **Examples**: `order_status ('new', 'processing', 'shipped', 'delivered', 'cancelled')`, `account_type ('free', 'premium', 'enterprise', 'admin', 'guest')`, `ticket_priority ('low', 'medium', 'high', 'urgent', 'critical')`, `user_status ('active', 'inactive', 'suspended', 'deleted', 'pending')`, `product_category ('electronics', 'clothing', 'grocery', 'furniture', 'books')`
    - **Context**: Useful for fields with a limited and known set of values, ensuring data integrity and simplifying queries and analysis.

13. **JSONB (No direct equivalent in MySQL)**
    - **Examples**: `user_preferences_settings`, `e-commerce_product_attributes`, `log_event_details`, `metadata_for_assets`, `dynamic_form_responses`
    - **Context**: Chosen for its efficiency in storing and querying JSON data, particularly in applications requiring complex data structures and fast access.

14. **ARRAY (No direct equivalent in MySQL)**
    - **Examples**: `product_tags`, `contact_phone_numbers`, `email_recipients`, `survey_responses`, `skillset_keywords`
    - **Context**: Useful for storing multiple values in a single column, simplifying schema design and queries for data naturally fitting an array format, like tags or contacts.

15. **CHAR(n) (Same in MySQL)**
    - **Examples**: `country_iso_code ('US', 'CA', 'UK')`, `currency_iso_code ('USD', 'EUR', 'GBP')`, `state_abbreviation ('CA', 'TX', 'NY')`, `vehicle_license_plate`, `stock_exchange_symbol`
    - **Context**: Best suited for storing fixed-length character data, ensuring data consistency and efficiency for short, standard-format strings.