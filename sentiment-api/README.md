# Sentiment Analysis Service

This service provides sentiment analysis for text data. It is designed to analyze the sentiment of a given text and return whether the sentiment is positive, neutral, or negative along with the probabilities for each sentiment.

## API Documentation

### Base URL

```yaml
{server}:{port}/api
```

- Default server: `http://localhost`
- Default port: `9000`

### Endpoints

#### POST /sentiment

Get sentiment analysis for a given text.

- **Summary**: Get sentiment analysis for a given text
- **Operation ID**: getSentiment
- **Request Body**:
  - **Content**: `application/json`
  - **Schema**: `Content`
  - **Required**: true
- **Responses**:
  - **201 Created**:
    - **Description**: Created
    - **Content**: `application/json`
    - **Schema**: `Sentiment`
  - **400 BadRequest**:
    - **Description**: BadRequest
    - **Content**: `application/json`
    - **Schema**: `ErrorPayload`

### Components

#### Schemas

##### Content

- **Type**: object
- **Required**:
  - `text`
- **Properties**:
  - `text`:
    - **Type**: string
    - **Example**: "This is a positive message"

##### Probability

- **Type**: object
- **Required**:
  - `neg`
  - `neutral`
  - `pos`
- **Properties**:
  - `neg`:
    - **Type**: number
    - **Format**: double
    - **Example**: 0.30135019761690551
  - `neutral`:
    - **Type**: number
    - **Format**: double
    - **Example**: 0.27119050546800266
  - `pos`:
        - **Type**: number
        - **Format**: double
        - **Example**: 0.69864980238309449

##### Sentiment

- **Type**: object
- **Required**:
  - `label`
  - `probability`
- **Properties**:
  - `probability`:
    - **$ref**: `#/components/schemas/Probability`
  - `label`:
    - **$ref**: `#/components/schemas/SentimentLabel`

##### SentimentLabel

- **Type**: string
- **Example**: "pos"
- **Enum**:
  - `pos`
  - `neutral`
  - `neg`

## Example Request

```json
{
    "text": "This is a positive message"
}
```

## Example Response

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
