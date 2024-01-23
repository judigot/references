<?php
// Rename object keys; rename keys
function renameKeys($object, $newKeys)
{
    foreach ($newKeys as $key => $value) {

        // Get position of the target key
        $position = array_search($key, array_keys($object));

        // Get original value
        $positionValue = $object[$key];

        $newObject = [$value => $positionValue];

        // Remove key and its value
        unset($object[$key]);

        // Merge different parts of the array (head, renamed element, tail)
        $object = array_merge(
            array_merge(
                array_slice($object, 0, $position, true),
                $newObject
            ),
            array_slice($object, $position, count($object), true)
        );
    }

    return $object;

    /**************
     * SAMPLE USE *
     **************/
    /*
    $array = [
        "key1" => "value1",
        "key3" => "value2",
        "key4" => "value3",
    ];
    $result = renameKeys($array, [
        "key3" => "three",
    ]);
     */
}

// Get PC Serial Number (for generating license key):
$serial = shell_exec('wmic DISKDRIVE GET SerialNumber 2>&1');
echo $serial;

// Delete all files in a directory
array_map("unlink", glob(__DIR__ . "\FolderName\*"));
// Delete all files including subfolders
array_map("unlink", array_filter((array)glob(__DIR__ . "\FolderName\*")));

//  Add leading zeros:
$num = 5;
echo str_pad($num, 2, "0", STR_PAD_LEFT);

//     Validate email:
$email = "john.doe@@example.com";
if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo ("$email is a valid email address");
} else {
    echo ("$email is not a valid email address");
}

//  Get absolute project path:
$projectRoot = str_replace($_SERVER['DOCUMENT_ROOT'], "", str_replace(chr(92), "/", getcwd())) . "/";

//     Serialize database result:
md5(serialize($Result));

// Get timestamp/Current date/Get current date:
echo date("g:i:s A"); // 5:30 PM
echo date("Y-m-d H:i:s A");    // 24-hour format
echo date("Y-m-d H:i:s", time());
echo date("F j, Y");        //December 14, 2019

//   Insert MySQL date and time/get date and time/get timezone:
echo date_default_timezone_get();
echo "<br>";
echo date("Y-m-d");
echo "<br>";
echo date("G-i-s");
$time = strtoupper(date("h:i:s a"));
if ($time[0] == "0") {
    $time = substr($time, 1);
}
echo $time;

//  Get Column Names from MySQL Table:
$ColumnNames = array_keys($Result[0]);
print_r($ColumnNames);

//  Get Enum Values from MySQL Table:
$Result = $Database::Read($Connection, "SHOW COLUMNS FROM `attendees` WHERE FIELD='eventFee'");
$EventFeeFields = explode("','", preg_replace("/(enum|set)\('(.+?)'\)/", "\\2", $Result[0][array_keys($Result[0])[1]]));

//   Display Array:
echo "<pre>" . print_r($array, true) . "</pre>";