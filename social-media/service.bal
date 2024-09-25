import ballerina/file;
import ballerina/http;
import ballerina/sql;
import ballerinax/h2.driver as _;
import ballerinax/java.jdbc;

string dbPath = check file:getAbsolutePath("databases");
string jdbcUrl = string `jdbc:h2:${dbPath}/SOCIAL_MEDIA`;

function initDatabase(sql:Client dbClient) returns error? {
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS POSTS (ID INT AUTO_INCREMENT PRIMARY KEY, USER_ID INT, DESCRIPTION VARCHAR(255), TAGS VARCHAR(255), CATEGORY VARCHAR(255))`);
}

service /api on new http:Listener(9090) {

    final sql:Client dbClient;
    final SentimentClient sentimentClient;

    function init() returns error? {
        self.dbClient = check new jdbc:Client(jdbcUrl);
        self.sentimentClient = check new;
        check initDatabase(self.dbClient);
    }

    resource function get posts(string? category) returns Post[]|error {
        sql:ParameterizedQuery query = category is string ?
            `SELECT * FROM POSTS WHERE CATEGORY = ${category}` : `SELECT * FROM POSTS`;
        stream<Post, sql:Error?> postStream = self.dbClient->query(query);
        return from Post post in postStream
            select post;
    }

    resource function get posts/[int id]() returns Post|http:NotFound {
        Post|error post = self.dbClient->queryRow(`SELECT * FROM POSTS WHERE ID = ${id}`);
        return post is Post ? post : http:NOT_FOUND;
    }

    resource function post posts(NewPost newPost) returns PostCreated|http:BadRequest|error {
        Sentiment sentiment = check self.sentimentClient->/api/sentiment.post({text: newPost.description});
        if sentiment.label != "pos" {
            return http:BAD_REQUEST;
        }

        sql:ExecutionResult result = check self.dbClient->execute(`INSERT INTO POSTS (USER_ID, DESCRIPTION, TAGS, CATEGORY) VALUES (${newPost.userId}, ${newPost.description}, ${newPost.tags}, ${newPost.category})`);
        string|int? id = result.lastInsertId;
        return id is int ? <PostCreated>{body: {id, ...newPost}} : error("Error occurred while retriving the post id");
    }

    resource function delete posts/[int id]() returns http:NoContent|error {
        _ = check self.dbClient->execute(`DELETE FROM POSTS WHERE ID = ${id}`);
        return http:NO_CONTENT;
    }

    resource function get posts/[int id]/meta() returns PostWithMeta|http:NotFound {
        Post|error post = self.dbClient->queryRow(`SELECT * FROM POSTS WHERE ID = ${id}`);
        return post is Post ? transformPost(post) : http:NOT_FOUND;
    }
}
