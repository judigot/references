<!--

Scaffold database:
*Go to mysql command line in docker

    cd docker-entrypoint-initdb.d
    mysql -u root -p < md-master.sql
    mysql -u root -p md < massdepot_xcart_data.sql
    mysql -u root -p md < massdepot_xcart_extrafielddata.sql
    mysql -u root -p massdepot < md-structure.sql

index > home > auth > preauth > init

Create a different branch from development

    git checkout -b feature/ticket#593-retail-shop-module

*Copy htaccess from hifi and comment these lines

    RewriteCond %{HTTP_HOST} !^(www|test-hifi-devel)\.hifisoundconnection\.com
    RewriteRule ^(.*)$ https://www.hifisoundconnection.com/ [R=301,L]

* Upload Database
* Setup a valid admin account in customers table:

    Set the following values:
        username = *username
        password = *create a password using text_crypt (e.g. text_crypt("samplepassword"))
        autolock = 'Y'
        suspend_date = *anything larger than 0
        
    Set the following values in $sql_tbl["config"] table:
    *access globally through $config[{category}]
    
        name, value, category
        
        fb_access_token, {value}, {category}
        fb_account_id, {value}, {category}
        fb_app_id, {value}, {category}
        fb_appp_secret, {value}, {category}
        fb_catalog_id, {value}, {category}
        
    Set the following values in $sql_tbl["market_places"] table:
        
        marketplaceid
        title = Wish
        orderby = 1200
        special_payment_status = N
        fee = 0.080
        payment_fee = 0.000
        marketplace_type = wish
        marketplace_group = wish
        postfix = 
        status = 1
        api_store_status = 0
        last_store_check = 0
        
    Set the following values in $sql_tbl["payment_methods"] table:
    
        paymentid = 
        payment_method = Facebook Marketplace
        payment_details = 
        payment_template =
        ppayment_script =
        protocol =
        orderby =
        active =
        is_cod =
        af_check =
        processor_file =
        surcharge =
        surcharge_type =
        
        

* Duplicate config.php. Rename the duplicate to config.local.php
* Config.local.php

        *place the code below at the bottom-most part

    //====================LOCAL====================//

    define('SKIN_DIR', 'massdepot');

    $xcart_http_host = "md.local";
    $xcart_https_host = "md.local";
    $xcart_web_dir = "";

    $sql_host = 'db_mysql';
    $sql_db = 'xcart';
    $sql_user = 'root';
    $sql_password = 'red123_';

    $redis_host = "myredis";
    $memcache_host = "mymem";
    $blowfish_key = "Bl0wf1shBl0wf1shBl0wf1shBl0wf1sh";

    //====================LOCAL====================//

* Create a folder named "massdepot7" inside var/templates_c

* Inside init.php, change Memcache and Redis hosts to match docker containers

    Before:
    $is_redis_exists = $redis->connect('localhost', 6379);
    $memcache->connect('localhost', 11211);

    After:
    $is_redis_exists = $redis->connect($redis_host, 6379);
    $memcache->connect($memcache_host, 11211);

* Edit .conf files accordingly

 -->
