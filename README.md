# IEEE Hackathon Workshop 1 - Part 1 - Social Media Service in Ballerina

## Introduction

This workshop will guide you through the process of creating a Ballerina REST API that will allow
you to create, read, update, and delete social media posts. In the first part of the workshop, 
the data will be stored in in-memory tables.

The Social media REST service exposes the following resources:

| Resource                       | Description                                        |
|--------------------------------|----------------------------------------------------|
| `GET api/posts`                | Get all the posts                                  |
| `GET api/posts/{id}`           | Get the post specified by the id                   |
| `POST api/post`                | Create a new post                                  |
| `DELETE api/posts/{id}`        | Delete the post specified by the id                |
| `GET api/posts/{id}/meta`      | Get the post specified by the id with the metadata |

## Areas covered

- Ballerina HTTP service
- Ballerina HTTP resource
- HTTP methods
- Path and query parameters
- Status code responses
- Request payload binding
- Data mapper
- Ballerina HTTP client

## Prerequisites

- Install the latest version of Ballerina
- Set up VS code by installing the Ballerina extension

## Implementation

1. Create a new Ballerina project.

    ```bash
    $ bal new social-media
    ```

2. Create a Ballerina HTTP service with the basepath: "/api".

3. Define a Ballerina record to represent the post. An example JSON object representing a post is 
   as follows:

    ```json
    {
        "id": 1,
        "userId": 1,
        "description": "This is a post",
        "tags": "tag1, tag2",
        "category": "category1"
    }
    ```

4. Create an in-memory Ballerina table to store the posts. Use the `id` field as the key.

5. Populate the table with the following sample data:

    ```json
    {
        "id": 1,
        "userId": 1,
        "description": "This is a post",
        "tags": "tag1, tag2",
        "category": "category1"
    }
    ```

    ```json
    {
        "id": 2,
        "userId": 2,
        "description": "This is another post",
        "tags": "tag3, tag4",
        "category": "category2"
    }
    ```

6. Implement the `GET api/posts` resource to retrieve all the posts. The response should have an
   array of posts.

7. Extend the `GET api/posts` resource by adding an optional query parameter `category`. If the
   `category` query parameter is provided, the resource should return only the posts that match the
   specified category.

8. Implement the `GET api/posts/{id}` resource to retrieve a specific post by its `id`. The `id` is
   provided in the path. Return a `404 - Not Found` status code response if the post is not found.

9. Define a Ballerina record to represent the new post request payload. An example JSON object
   representing a new post is as follows:

    ```json
    {
        "userId": 1,
        "description": "This is a new post",
        "tags": "tag5, tag6",
        "category": "category3"
    }
    ```

10. Implement the `POST api/post` resource to create a new post. The new post data is provided in
    the request payload. Return a `201 - Created` status code response.

11. Implement the `DELETE api/posts/{id}` resource to delete a specific post by its `id`. The `id`
    is provided in the path. Return a `204 - No Content` status code response.

12. Define a Ballerina record to represent the post with metadata. An example JSON object
    representing the post metadata is as follows:

    ```json
    {
        "id": 1,
        "userId": 1,
        "description": "This is a post",
        "meta": {
            "tags": ["tag1", "tag2"],
            "category": "category1"
        }
    }
    ```

13. Define a data-mapper function to convert a post to a post with metadata. The tags should be
    converted to an array by splitting with the comma.

14. Implement the `GET api/posts/{id}/meta` resource to retrieve a specific post by its `id` with
    metadata. The `id` is provided in the path. Return a `404 - Not Found` status code response if
    the post is not found.

15. Define a Ballerina HTTP client to call the sentiment analysis service. The sentiment analysis
    service can be started by running the `sentiment-api` Ballerina project. The service will be
    stated in the following URL: `http://localhost:9090/text-processing`.

16. Define a Ballerina record to represent the sentiment analysis response. An example JSON object
    representing the sentiment analysis response is as follows:

    ```json
    {
        "label": "pos",
        "probability": {
            "neg": 0.30135019761690551,
            "neutral": 0.27119050546800266,
            "pos": 0.69864980238309449
        }
    }
    ```

17. Modify the `POST api/post` resource to validate the sentiment of the post by calling the
    sentiment analysis service. If the sentiment is negative, return a `400 - Bad Request` status
    code response.
