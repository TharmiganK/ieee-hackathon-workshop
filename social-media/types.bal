import ballerina/http;

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

public type PostCreated record {|
    *http:Created;
    Post body;
|};
