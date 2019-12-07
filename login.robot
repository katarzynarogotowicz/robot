*** Settings ***
Library  ../quick_start_guide/QuickStartGuide/lib/LoginLibrary.py  # wykorzytwana obecnie w teście
# Library  - to jest bibliteka do Pytona - jeśli importuję tę bibliotekę podaję samą nazwę
# Resource   - to jest biblioteka Robotowa - do tworzenia samodzielnie bez Test Cases - jeśli importuję tę bibliotekę podaję dokładną ścieżkę
# If we want certain keywords to be executed before or after each test, use the `Test Setup` and `Test Teardown`:
#Suite Setup       Clear Login Database
#Test Teardown     Clear Login Database

*** Variables ***
${USERNAME}               janedoe
${PASSWORD}               J4n3D0e
${NEW PASSWORD}           e0D3n4J
${DATABASE FILE}          ${TEMPDIR}  ${/}robotframework-quickstart-db.txt
${PWD INVALID LENGTH}     Password must be 7-12 characters long
${PWD INVALID CONTENT}    Password must be a combination of lowercase and uppercase letters and numbers

*** Test Cases ***
User can create an account and log in
        [Documentation]  Test written in KDD style (Keyword-Driven Development)
        Create Valid User                       fred             P4ssw0rd
        Attempt to Login with Credentials       fred             P4ssw0rd
        Status Should Be                        Logged In

User cannot log in with bad password
        [Documentation]  Test written in KDD style
        Create Valid User                       betty            P4ssw0rd
        Attempt to Login with Credentials       betty            wrong
        Status Should Be                        Access Denied

User can change password
        [Documentation]  Test written in BDD style (Behavior-Driven Development)
        When she changes her password
        Then she can log in with the new password
        And she cannot use the old password anymore

Invalid password
        [Documentation]  Test written in DDD style (Date-Driven Development)
        [Template]    Creating user with invalid password should fail
        abCD5            ${PWD INVALID LENGTH}
        abCD567890123    ${PWD INVALID LENGTH}
        123DEFG          ${PWD INVALID CONTENT}
        abcd56789        ${PWD INVALID CONTENT}
        AbCdEfGh         ${PWD INVALID CONTENT}
        abCD56+          ${PWD INVALID CONTENT}

User status is stored in database
        [Documentation]  ***Test when variables can be used in most places in the test data (lock Keywords ***)
        [Tags]                     variables    database
        Create Valid User          ${USERNAME}    ${PASSWORD}
        Database Should Contain    ${USERNAME}    ${PASSWORD}    Inactive
        Login                      ${USERNAME}    ${PASSWORD}
        Database Should Contain    ${USERNAME}    ${PASSWORD}    Active

*** Keywords ***
Clear login database
        Remove file    ${DATABASE FILE}

Create valid user
        [Arguments]         ${username}    ${password}
        Create user         ${username}    ${password}
        Status should be    SUCCESS

Creating user with invalid password should fail
        [Arguments]         ${password}    ${error}
        Create user         example        ${password}
        Status should be    Creating user failed: ${error}

Login
        [Arguments]         ${username}    ${password}
        Attempt to login with credentials    ${username}    ${password}
        Status should be    Logged In

    # Keywords below used by higher level tests. Notice how given/when/then/and
    # prefixes can be dropped. And this is a comment.

A user has a valid account
        Create valid user    ${USERNAME}    ${PASSWORD}

She changes her password
        Change password      ${USERNAME}    ${PASSWORD}    ${NEW PASSWORD}
        Status should be     SUCCESS

She can log in with the new password
        Login    ${USERNAME}    ${NEW PASSWORD}

She cannot use the old password anymore
        Attempt to login with credentials    ${USERNAME}    ${PASSWORD}
        Status should be                     Access Denied

Database Should Contain
        [Documentation]  ***Test when variables can be used in most places in the test data***
        [Arguments]         ${username}    ${password}    ${status}
        ${database} =       Get File    ${DATABASE FILE}
        Should Contain      ${database}    ${username}\t${password}\t${status}\n