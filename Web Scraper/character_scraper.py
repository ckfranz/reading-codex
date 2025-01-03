from bs4 import BeautifulSoup
import re
import requests
import json


destination = 'Web Scraper/data/test/characters_cleaned.json'

base_url = 'https://hammondkd.github.io/WoT-compendium/'

summaries_page = requests.get(base_url)
character_soup = BeautifulSoup(summaries_page.text, 'html.parser')

long_summaries = character_soup.find_all('table')[0]
character_book_links_data = long_summaries.find_all('a')

character_summary_links = [base_url + link['href'] for link in character_book_links_data]

page = requests.get(character_summary_links[1])
soup = BeautifulSoup(page.text, 'html.parser')

# Initialize the list to hold structured data
characters = []

# Helper function to create a character link
def create_character_link(name):
    character_id = re.sub(r"[\s']", "-", name).replace("’", "-")
    return f"[{name}](#{character_id})"

# Extract all character names and their IDs for reference
all_characters = {a.get_text(strip=True).replace("The ", ""): a['id'] for a in soup.find_all('a', class_='name', id=True)}

print(len(all_characters))

# Loop through each <li> element containing character data
for li in soup.find_all('li'):
    # Extract the character's ID
    a_tag = li.find('a', class_='name')
    # print(a_tag)
    if not a_tag:
        continue

    char_name = a_tag.get_text(strip=True)
    char_name = char_name.replace("The ", "")
    char_id = char_name.replace("’", "-").replace(" ", "-")


    # Extract chapter information
    chapter = li.find_previous('h3', class_='chapter')
    chapter_name = chapter.get_text(strip=True) if chapter else "Prelude"
    chapter_name = chapter_name.replace("  ", " ")

    # Extract the information text
    info_text = li.get_text(separator=" ").strip()
    info_text = re.sub(r"\s+", " ", info_text)  # Normalize whitespace
    
    # Extract and remove page number (e.g., "p. ix (x)" or "p. 11")
    page_match = re.search(r"p\. [^—]+", info_text)
    page_info = page_match.group(0) if page_match else None
    info_text = re.sub(r"p\. [^—]+—", "", info_text)
    info_text = info_text.replace(char_name + " , ", "")

    # Remove the initial character name and page reference
    # info_text = re.sub(rf"^{re.escape(char_name)}\s*,?\s*p\.\s*\d+—", "", info_text).strip()
    # print(char_name)
    info_text = info_text.replace(f"{char_name},", "").strip()


    # Remove "See also" and any trailing extra content
    info_text = re.sub(r"See also.*$", "", info_text).strip()

    # Replace character names in the description with links
    for name, ref_id in all_characters.items():
        if name == char_name:
            continue
        linked_name = create_character_link(name)
        # print(linked_name)
        info_text = re.sub(rf"\b{name}\b", linked_name, info_text)
        
    info_text = info_text.replace(") ,", "),")
    info_text = info_text.replace(" ’", "'")
    info_text = info_text.replace(") .", ").")
    # Add structured data to the list
    characters.append({
        "id": char_id,
        "name": char_name,
        "chapter": chapter_name,
        "page": page_info,
        "info": info_text
    })

# Write the structured data to a JSON file
with open(destination, "w", encoding="utf-8") as json_file:
    json.dump(characters, json_file, indent=2, ensure_ascii=False)

print(f"Data saved to '{destination}'!")