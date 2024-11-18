from datetime import datetime, timezone
from functools import lru_cache


class Database:
    def __init__(self):
        self.fake_users_db = {
            "johndoe": {
                "username": "johndoe",
                "full_name": "John Doe",
                "email": "johndoe@example.com",
                "disabled": False,
            }
        }

        self.code_db = {}

    def save_code(self, username: str, code: str, expiry: datetime):
        self.code_db[username] = {
            "code": code,
            "expiry": expiry
        }

    def verify_code(self, username: str, code_to_verify: str):
        try:
            if self.code_db[username]["code"] == code_to_verify:
                if datetime.now(timezone.utc) < self.code_db[username]["expiry"]:
                    return True
        except KeyError:
            pass

        return False

@lru_cache
def get_database():
    return Database()