import ballerinax/java.jdbc;
import ballerina/sql;

// DB related configs
public configurable string dbHostName = "localhost";
public configurable string dbUserName = "authzdbuser";
public configurable string dbPassword = "regadmin";
public configurable string databaseName = "authz_service_db";
public configurable int dbPort = 5432;

jdbc:Client dbClient = check getClient();

final string url = string `jdbc:postgresql://${dbHostName}:${dbPort.toString()}/${databaseName}`;

function getClient() returns jdbc:Client|error =>
    new (url, dbUserName, dbPassword);

public type ResponseDO record {
    string name;
    string id?;
    int cursor_key?;
    string org_id?;
    string app_id?;
};

public function selectRolesByApp(string appId, string organizationId, string direction, int cursor, int 'limit) returns ResponseDO[]|error {

    sql:ParameterizedQuery query = selectRolesByAppQuery(appId, organizationId, direction, cursor, 'limit);
    stream<ResponseDO, sql:Error?> resultStream = dbClient->query(query);
    ResponseDO[]? roles = check from ResponseDO roleDO in resultStream
        select roleDO;
    return roles ?: [];
}

function selectRolesByAppQuery(string appId, string organizationId, string direction, int cursor, int 'limit) returns sql:ParameterizedQuery {
    sql:ParameterizedQuery query = `SELECT name, app_id, org_id, cursor_key FROM ROLE WHERE APP_ID = ${appId} AND ORG_ID = ${organizationId}`;
    match direction {
        "after" => {
            return sql:queryConcat(query, `AND CURSOR_KEY > ${cursor} ORDER BY CURSOR_KEY LIMIT ${'limit}`);
        }
        "before" => {
            return sql:queryConcat(query, `AND CURSOR_KEY < ${cursor} ORDER BY CURSOR_KEY DESC LIMIT ${'limit}`);
        }
    }
    return query;
}