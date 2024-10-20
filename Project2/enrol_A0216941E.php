<?php
# code to log errors
// error_reporting(E_ALL);
// ini_set('display_errors', 1);
// echo "'<script>console.log(\"$results_user_sql_insert\")</script>'";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $db_host = "localhost";
    $db_name = "university";
    $db_user = "adam";
    $db_pass = "university_adam_123";
    $conn = mysqli_connect($db_host, $db_user, $db_pass, $db_name);
    if (mysqli_connect_error()) {
        echo mysqli_connect_error();
        exit;
    }

    # create variables for the user inputs
    $user_input_ID = $_POST['ID'];
    $user_input_name = $_POST['name'];
    $user_input_dept_name = $_POST['dept_name'];
    $user_input_tot_cred = $_POST['tot_cred'];

    # MySQL logic check: check if user_input_ID already exists in database
    $check_duplicate_id_sql = "SELECT COUNT(ID) counts FROM student where ID = '$user_input_ID'";
    $results_check_duplicate_id_sql = mysqli_query($conn,$check_duplicate_id_sql);
    $count_check_duplicate_id_sql = mysqli_fetch_assoc($results_check_duplicate_id_sql);
    $count_check_duplicate_id_sql = $count_check_duplicate_id_sql['counts'];

    # if count=0, it means that there is no existing ID with the user_input_ID --> run the main logic
    # else --> return a warning message for user and do nothing so he can retry
    if ($count_check_duplicate_id_sql==0) {

        # Run sql insert in the database using the the user inputs
        $user_sql_insert = "INSERT INTO student (ID, name, dept_name, tot_cred) 
                            VALUES ('$user_input_ID','$user_input_name','$user_input_dept_name','$user_input_tot_cred')";
        $results_user_sql_insert = mysqli_query($conn, $user_sql_insert);
        
        # Return count of students in the user_input_dept_name if sql insert is successful
        if ($results_user_sql_insert) {
            $sql_retrieve = "SELECT COUNT(*) count_student FROM student WHERE dept_name='$user_input_dept_name'";
            $results_sql_retrieve = mysqli_query($conn, $sql_retrieve);
            $student_count = mysqli_fetch_assoc($results_sql_retrieve);
            $student_count = $student_count['count_student'];
            echo "There are now " . $student_count . " students in " . $user_input_dept_name . " Department";
        } else {
            echo "Error: " . mysqli_error($conn);
        }
    } else {
        echo "Error: input ID already exists in the database! Please use a new ID.";
    }
}
?>

<html>
<head>
    <title>Enrolment Page</title>
    <meta charset="utf-8">
</head>
<body>
    <header>
        <h1>Enrolment Page</h1>
    </header>
    <main>
       <h2>New student</h2>
        <form method="post">
            <div>
                <label for="ID">Student ID</label>
                <input name="ID" id="ID" placeholder="Enter Student ID">
            </div>
            <div>
                <label for="name">Student name</label>
                <input name="name" id="name" placeholder="Enter Student Name">
            </div>
            <div>
                <label for="dept_name">Deptment name</label>
                <input name="dept_name" id="dept_name" placeholder="Enter Department Name">
            </div>
            <div>
                <label for="tot_cred">Total credit</label>
                <input name="tot_cred" id="tot_cred" placeholder="Enter Total Credits">
            </div>
            <button>Add</button>
        </form>
    </main>
</body>
</html>