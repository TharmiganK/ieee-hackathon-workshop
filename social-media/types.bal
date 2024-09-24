public type Post record {|
    readonly int id;
    int userId;
    string description;
    string tags;
    string category;
|};

public type NewPost record {|
    int userId;
    string description;
    string tags;
    string category;
|};

public type PostWithMeta record {|
    int id;
    int userId;
    string description;
    record {|
        string[] tags;
        string category;
    |} meta;
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
