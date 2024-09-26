import ballerina/http;
import ballerina/sql;

public type Post record {|
    @sql:Column {name: "ID"}
    readonly int id;
    @sql:Column {name: "USER_ID"}
    int userId;
    @sql:Column {name: "DESCRIPTION"}
    string description;
    @sql:Column {name: "TAGS"}
    string tags;
    @sql:Column {name: "CATEGORY"}
    string category;
|};

public type NewPost record {|
    int userId;
    string description;
    string tags;
    string category;
|};

public type PostCreated record {|
    *http:Created;
    Post body;
|};

public type Meta record {|
    string[] tags;
    string category;
|};

public type PostWithMeta record {|
    int id;
    int userId;
    string description;
    Meta meta;
|};

function transformPost(Post post) returns PostWithMeta => {
    id: post.id,
    userId: post.userId,
    description: post.description,
    meta: {
        tags: re `,`.split(post.tags),
        category: post.category
    }
};
