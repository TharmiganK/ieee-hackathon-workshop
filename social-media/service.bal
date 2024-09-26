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

    resource function get posts(string? category) returns Post[]|error {
        return postsTable.toArray();
    }

    resource function get posts/[int id]() returns Post|http:NotFound {
        return postsTable.hasKey(id) ? postsTable.get(id) : http:NOT_FOUND;
    }

    resource function post posts(NewPost newPost) returns PostCreated|http:BadRequest|error {
        int id = postsTable.nextKey();
        Post post = {
            id,
            ...newPost
        };
        postsTable.add(post);

        return <PostCreated>{
            body: post
        };
    }

    // Implement the `DELETE api/posts/{id}` resource to delete a specific post by its `id`. 
    // The `id` is provided in the path. Return a `204 - No Content` status code response.
    
}
