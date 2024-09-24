import ballerina/http;
import ballerina/log;
import ballerina/openapi;

@openapi:ServiceInfo {
    title: "Sentiment Analysis Service",
    version: "1.0.0",
    description: "This service provides sentiment analysis for text data."
}
service /text\-processing on new http:Listener(9000) {

    public function init() {
        log:printInfo("Sentiment analysis service started");
    }

    @openapi:ResourceInfo {
        summary: "Get sentiment analysis for a given text",
        operationId: "getSentiment"
    }
    resource function post api/sentiment(Content content) returns Sentiment {
        return {
            probability: {
                neg: 0.30135019761690551,
                neutral: 0.27119050546800266,
                pos: 0.69864980238309449
            },
            label: POS
        };
    }
}

type Probability record {
    @openapi:Example {value: 0.30135019761690551}
    decimal neg;
    @openapi:Example {value: 0.27119050546800266}
    decimal neutral;
    @openapi:Example {value: 0.69864980238309449}
    decimal pos;
};

@openapi:Example {value: "pos"}
enum SentimentLabel {
    NEG = "neg",
    NEUTRAL = "neutral",
    POS = "pos"
};

type Sentiment record {
    Probability probability;
    SentimentLabel label;
};

type Content record {
    @openapi:Example {value: "This is a positive message"}
    string text;
};
