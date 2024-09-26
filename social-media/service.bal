import ballerina/http;

table<Post> key(id) postsTable = table [
    {
        id: 1,
        userId: 1,
        description: "Exploring Ballerina Language",
        tags: "ballerina, programming, language",
        category: "Technology"
    },
    {
        id: 2,
        userId: 2,
        description: "Introduction to Microservices",
        tags: "microservices, architecture, introduction",
        category: "Software Engineering"
    }
];

service /api on new http:Listener(9090) {

    // category is an optional query parameter
    resource function get posts(string? category) returns Post[]|error {
        // Implement the logic to filter posts based on the category
        return postsTable.toArray();
    }
}
