import ballerina/http;

table<Post> key(id) postsTable = table [
    {id: 1, description: "Exploring Ballerina Language", tags: "ballerina, programming, language", category: "Technology", userId: 1},
    {id: 2, description: "Introduction to Microservices", tags: "microservices, architecture, introduction", category: "Software Engineering", userId: 2}
];

SentimentClient sentimentClient = check new;

service /api on new http:Listener(9090) {

    resource function get posts(string? category) returns Post[] {
        if category is () {
            return postsTable.toArray();
        }
        return postsTable.filter(post => post.category == category).toArray();
    }

    resource function get posts/[int id]() returns Post|http:NotFound {
        return postsTable.hasKey(id) ? postsTable.get(id) : http:NOT_FOUND;
    }

    resource function post posts(NewPost newPost) returns PostCreated|http:BadRequest|error {
        Sentiment sentiment = check sentimentClient->/api/sentiment.post({text: newPost.description});
        if sentiment.label != "pos" {
            return http:BAD_REQUEST;
        }

        int id = postsTable.nextKey();
        Post post = {
            id,
            ...newPost
        };
        postsTable.add(post);
        return <PostCreated>{body: post};
    }

    resource function delete posts/[int id]() returns http:NoContent {
        _ = postsTable.removeIfHasKey(id);
        return http:NO_CONTENT;
    }

    resource function get posts/[int id]/meta() returns PostWithMeta|http:NotFound {
        if !postsTable.hasKey(id) {
            return http:NOT_FOUND;
        }
        Post post = postsTable.get(id);
        return transformPost(post);
    }
}
