import httpx
import xmltodict
from datetime import datetime

from schemas.risks import CountryItem
from dependencies import get_database

database = get_database()

async def fetch_data():
    url = "https://travel.state.gov/_res/rss/TAsTWs.xml#.html"

    async with httpx.AsyncClient() as client:
        r = await client.get(url)
        r.raise_for_status()
        return r.text

async def parse_xml_data_and_update_db(xml_content: str):
    parsed_dict = xmltodict.parse(xml_content)
    for item in parsed_dict["rss"]["channel"]["item"]:
        try:
            parts = item["title"].split(" - Level ")
            country = parts[0]
            level_parts = parts[1].split(": ")
            level = level_parts[0]
            pub_date = datetime.strptime(item["pubDate"], "%a, %d %b %Y")

            country_item = CountryItem(country=country, level=level, pub_date=pub_date, link=item["link"])
            await database.update_country_advisories(country_item)
        except (IndexError, KeyError):
            pass

async def update_risks():
    data = await fetch_data()
    await parse_xml_data_and_update_db(data)
