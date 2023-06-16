import ballerina/io;
import ballerina/test;
import ballerinax/java.jdbc;

@test:Mock {
    moduleName: "app1.dao",
    functionName: "getClient"
}
function getDBMockClient() returns jdbc:Client|error {
    return new ("");
}

// Before Suite Function

@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("I'm the before suite function!");
}

// Test function

@test:Config {}
function testFunction() {
    string name = "John";
    string welcomeMsg = hello(name);
    test:assertEquals("Hello, John", welcomeMsg);
}

// Negative Test function

@test:Config {}
function negativeTestFunction() {
    string name = "";
    string welcomeMsg = hello(name);
    test:assertEquals("Hello, World!", welcomeMsg);
}

// After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("I'm the after suite function!");
}
