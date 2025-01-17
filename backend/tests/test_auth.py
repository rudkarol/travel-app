from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


# def test_verify_code():
#     r = client.post(
#         "/auth/verify/",
#         json={"email": "user@example.com", "code": ""}
#     )
#     assert r.status_code == 200


# def test_verify_code_bad_code():
#     r = client.post(
#         "/auth/verify/",
#         json={"email": "user@example.com", "code": "fakecode"}
#     )
#     assert r.status_code == 401
#     assert r.json() == {"detail": "Invalid or expired verification code"}
#
#
# def test_verify_code_bad_email_format():
#     r = client.post(
#         "/auth/verify/",
#         json={"email": "userexample.com", "code": "fakecode"}
#     )
#     assert r.status_code == 422
