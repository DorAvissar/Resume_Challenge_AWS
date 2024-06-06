import json
import requests
import pytest

# Directly use the Lambda function URL
LAMBDA_URL = "https://xvmccarhiq436w4wxo7lri7fai0zaoqq.lambda-url.eu-central-1.on.aws/"

@pytest.fixture
def lambda_url():
    return LAMBDA_URL

def test_lambda_function(lambda_url):
    event = {"key": "value"}

    # Send a POST request to the Lambda function
    response = requests.post(lambda_url, data=json.dumps(event))

    # Check if the request was successful (status code 200)
    assert response.status_code == 200

    try:
        result = response.json()
        if isinstance(result, int):
            result = {"views": result}
        assert "views" in result
        assert isinstance(result["views"], int)

    except json.JSONDecodeError:
        # Handle the case where the response is not a valid JSON
        pytest.fail("Response is not a valid JSON")

if __name__ == "__main__":
    pytest.main()
