import app1.dao;
# Returns the string `Hello` with the input string name.
#
# + name - name as a string
# + return - "Hello, " with the input string name
public function hello(string name) returns string {
    dao:ResponseDO[]|error tests = dao:selectRolesByApp("org1234", "app1234","",0,0);
    if tests is error {
        return "Hello, World Error!";
    }
    if !(name is "") {
        return "Hello, " + name;
    }
    return "Hello, World!";
}
