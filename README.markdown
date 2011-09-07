# Moodle SIMS Script #

#### Done for school to take in some CSV and output SQL queries for adding users for multiple SIMS courses to one course. ####

See _test\_data.csv_ and _test\_data.xls_ for example input data, and _test\_output.sql_ for the corresponding output.

* * * *

The script takes the CSV filename as the first parameter, outputs to STDOUT
and should be called like the following:

    ruby moodle_sims.rb test_data.csv > test_output.sql

* * * *

Data should be formatted in two columns, the first containing the name of the
main, user-added moodle course and the second containing the name of the
auto-generated SIMS course. Rows containing a blank first column will use the
value of the first column in the row above.

**The first row is ignored, as it is assumed to contain column names.**

Example data is shown below:

    ------------------------------
    | Course ID | SIMS Course ID |
    | ----------|--------------- |
    |     70    |      421       |
    |           |      385       |
    |           |      943       |
    |           |      113       |
    |           |      439       |
    |           |      405       |
    |           |      504       |
    |           |      850       |
    |    124    |      381       |
    |           |      981       |
    |           |      388       |
    |           |      280       |
    |           |      472       |
    |    678    |      804       |
    ------------------------------