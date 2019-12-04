*** Settings ***
Library  ../quick_start_guide/QuickStartGuide/lib/LoginLibrary.py

*** Variables ***

*** Test Cases ***
User can create an account and log in
        [Documentation]  Test written in KDD style
        Create Valid User                       fred             P4ssw0rd
        Attempt to Login with Credentials       fred             P4ssw0rd
        Status Should Be                        Logged In

User cannot log in with bad password
        [Documentation]  Test written in KDD style
        Create Valid User                       betty            P4ssw0rd
        Attempt to Login with Credentials       betty            wrong
        Status Should Be                        Access Denied

User can change password
        [Documentation]  Test written in BDD style
        Given a user has a valid account
        When she changes her password
        Then she can log in with the new password
        And she cannot use the old password anymore

*** Keywords ***
Clear login database
        Remove file    ${DATABASE FILE}

Create valid user
        [Arguments]    ${username}    ${password}
        Create user    ${username}    ${password}
        Status should be    SUCCESS

Creating user with invalid password should fail
        [Arguments]    ${password}    ${error}
        Create user    example    ${password}
        Status should be    Creating user failed: ${error}

Login
        [Arguments]    ${username}    ${password}
        Attempt to login with credentials    ${username}    ${password}
        Status should be    Logged In

    # Keywords below used by higher level tests. Notice how given/when/then/and
    # prefixes can be dropped. And this is a comment.

A user has a valid account
        Create valid user    ${USERNAME}    ${PASSWORD}

She changes her password
        Change password    ${USERNAME}    ${PASSWORD}    ${NEW PASSWORD}
        Status should be    SUCCESS

She can log in with the new password
        Login    ${USERNAME}    ${NEW PASSWORD}

She cannot use the old password anymore
        Attempt to login with credentials    ${USERNAME}    ${PASSWORD}
        Status should be    Access Denied
