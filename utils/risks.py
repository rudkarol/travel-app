import httpx
import xmltodict

from models.risks import CountryItem


async def fetch_data():
    url = "travel.state.gov/_res/rss/TAsTWs.xml#.html"

    async with httpx.AsyncClient() as client:
        r = await client.get(url)
        r.raise_for_status()
        return r.text

def parse_xml_data(xml_content: str):
    result = []
    parsed_dict = xmltodict.parse(xml_content)

    for item in parsed_dict["rss"]["channel"]:
        result.append(CountryItem(**item))
    return result

async def update_risks():
    data = await fetch_data()
    parsed_items = parse_xml_data(data)
    print(parsed_items)