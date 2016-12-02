# symphony_qa

Symphony integration testing via ExUnit and Hound. The test cases will drive user actions via symphony_web using a front end driver

## Setup
Check out enbala/symphony project into '/home/enbala/' or you'll need to modify one script (detailed below) 

## Execution of test cases

Inside symphony_qa:

`mix deps.get`

`./test/support/chrome_driver &`

To run the test cases:

`bash test/support/dbsetup`

note1: dbsetup will kill all mix processes, reset the database, create the first admin

note2: you may need to edit dbsetup to specify where you have cloned symphony

`mix test hw_test.exs`

Everytime you run the test, you will need to run dbsetup first as it requires a clean environment.


