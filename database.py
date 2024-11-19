from datetime import datetime, timezone
from functools import lru_cache


class Database:
    def __init__(self):
        self.fake_users_db = {
            "johndoe@example.com": {
                "email": "johndoe@example.com",
                "name": "johndoe"
            }
        }

        self.code_db = {}

    def save_code(self, email: str, code: str, expiry: datetime):
        self.code_db[email] = {
            "code": code,
            "expiry": expiry
        }

    def verify_code(self, email: str, code_to_verify: str):
        if email in self.code_db:
            if self.code_db[email]["code"] == code_to_verify:
                if datetime.now(timezone.utc) < self.code_db[email]["expiry"]:
                    return True

@lru_cache
def get_database():
    return Database()
