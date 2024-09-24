import ballerina/file;
import ballerina/http;
import ballerina/sql;
import ballerinax/h2.driver as _;
import ballerinax/java.jdbc;

string dbPath = check file:getAbsolutePath("database");
string jdbcUrl = string `jdbc:h2:${dbPath}/POSTS`;


table<Post> key(id) postsTable = table [
    {id: 1, description: "Exploring Ballerina Language", tags: "ballerina, programming, language", category: "Technology", userId: 1},
    {id: 2, description: "Introduction to Microservices", tags: "microservices, architecture, introduction", category: "Software Engineering", userId: 2}
];

function initDatabase(sql:Client dbClient) returns error? {
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS POSTS (ID INT AUTO_INCREMENT PRIMARY KEY, USER_ID INT, DESCRIPTION VARCHAR(255), TAGS VARCHAR(255), CATEGORY VARCHAR(255))`);
}

service /social\-media on new http:Listener(9090) {

    sql:Client dbClient;
    SentimentClient sentimentClient;

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

    resource function post posts(NewPost newPost) returns http:Created|http:BadRequest|error {
        Sentiment sentiment = check self.sentimentClient->/api/sentiment.post({text: newPost.description});
        if sentiment.label != "pos" {
            return http:BAD_REQUEST;
        }

        _ = check self.dbClient->execute(`INSERT INTO POSTS (USER_ID, DESCRIPTION, TAGS, CATEGORY) VALUES (${newPost.userId}, ${newPost.description}, ${newPost.tags}, ${newPost.category})`);
        return http:CREATED;
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
