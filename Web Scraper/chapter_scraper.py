from bs4 import BeautifulSoup
import requests
import json

destination = 'Web Scraper/data/test/chapter_summaries.json'

base_url = 'https://library.tarvalon.net'
chapter_summaries_url = 'https://library.tarvalon.net/index.php?title=Chapter_Summaries'

# get all book links
book_chapter_summaries_page = requests.get(chapter_summaries_url)
chapter_summary_books_soup = BeautifulSoup(book_chapter_summaries_page.text, 'html.parser')

chapter_summaries_books = chapter_summary_books_soup.find_all('ul')[0]
book_chapter_summary_links_data = chapter_summaries_books.find_all('a')
book_chapter_summary_links = [base_url + link['href'] for link in book_chapter_summary_links_data]


icon_mapping = {
    "Lans Helmet": "Lans_helmet-icon",
    "Wheel and Serpent": "Wheel-icon",
    "Fish": "Fish-icon",
    "Flame of Tar Valon": "Flame-icon",
    "Rising Sun": "Cairhien-icon",
    "Six-Pointed Star": "Star-icon",
    "AS Test Icon": "Star-icon",
    "Mice": "Mice-icon",
    "Wooden Triangle": "Triangle-icon",
    "Powered by MediaWiki": "",
    "Two Ravens": "Ravens-icon",
    "Dragon's Fang": "Fang-icon",
    "Harp": "Harp-icon",
    "Leafless Tree": "Deadtree-icon",
    "Heron-Marked Sword Square": "Hilt-icon",
    "Staff": "Staff-icon",
    "Sunburst": "Cotl-icon",
    "Trefoil Leaf": "Leaves-icon",
    "Trolloc": "Trolloc-icon",
    "Wolf": "Wolf-icon",
    "Ruby Dagger": "Dagger-icon",
    "Horn of Valere": "Valere-icon",
    "Portal Stone": "Portal-icon",
    "Malden": "Malden-icon",
    "Aes Sedai Symbol": "Aessedai-icon",
    "Spear and Shield": "Aiel-icon",
    "Dragon": "Dragon-icon",
    "Sword and Anchor": "Anchor-icon",
    "Two Gulls": "Gulls-icon",
    "Dice": "Dice-icon",
    "Dream Ter'angreal": "Telaran-icon",
    "Serpent": "Snake-icon",
    "Bull": "Bull-icon",
    "Tree": "Tree-icon",
    "The Great Tree": "Tree-icon",
    "Crescent Moon and Stars": "Lanfear-icon",
    "Blighted Tree": "Blight-icon",
    "Waves": "Waves-icon",
    "Stag": "Stag-icon",
    "Stag's Head": "Stag-icon",
    "Horse": "Horse-icon",
    "Females": "Faces-icon",
    "Silhouettes": "Faces-icon",
    "Falcon": "Falcon-icon",
    "Far Madding": "Handandsword-icon",
    "Hilt": "Hilt-icon",
    "Lion": "Andoran-icon",
    "Cairhien": "Cairhien-icon",
    "Seanchan Helmet": "Seanchan-icon",
    "Dragonoriginal": "Dragonoriginal-icon",
    "Finn": "Finn-icon",
    "Cotl": "Cotl-icon",
    "Ter'angreal Ornaments": "Ornaments-icon",
    "Three Leaves": "Leaf-icon",
    "S'redit": "Sredit-icon",
    "A'dam": "A'dam-icon",
    "Aelfinn and Eelfinn": "Finn-icon",
    "Frayed Pattern": "Web-icon",
    "Age Lace": "Web-icon",
    "Blacksmith's Puzzle": "Malden-icon",
    "Puzzle": "Malden-icon",
}

final_data = []

print("Computing chapters to scrape...")

# get chapter total count
total_count = 0
for book_url in book_chapter_summary_links:
    chapter_summaries_page = requests.get(book_url) # book one
    chapter_summary_soup = BeautifulSoup(chapter_summaries_page.text, 'html.parser')

    chapter_summaries = chapter_summary_soup.find('div', class_='mw-content-ltr')
    chapter_summary_links_data = chapter_summaries.find_all('a')
    
    total_count += len(chapter_summary_links_data)

print(f"Scraping {total_count} book summaries...")

concurrent_count = 0

for book_url in book_chapter_summary_links:
    # get page for current book
    chapter_summaries_page = requests.get(book_url) # book one
    chapter_summary_soup = BeautifulSoup(chapter_summaries_page.text, 'html.parser')
    
    title = chapter_summary_soup.find_all('h1')[0]
    title = title.text[:title.text.rfind(": ")]

    # book structure
    book_data = {
        "title": title,
        "content": []
    }

    chapter_summaries = chapter_summary_soup.find('div', class_='mw-content-ltr')
    chapter_summary_links_data = chapter_summaries.select('ul li a')
    chapter_summary_links = [base_url + link['href'] for link in chapter_summary_links_data]
    
    for link in chapter_summary_links:
        # fetch page
        page = requests.get(link)
        soup = BeautifulSoup(page.text, 'html.parser')

        # extract relevant information
        chapter_title = soup.find("h1", class_="firstHeading").text.strip()
        author_element = soup.find("i")
        author_name = author_element.text.replace("Author: ", "").strip() if author_element else "Unknown Author"
        icon_element = soup.find("img", alt=True)
        icon_name = icon_element["alt"].replace(".png", "").strip() if icon_element else "Unknown-icon"
        icon_name = icon_name.replace(' Chapter Icon', '')
        icon_name = icon_mapping[icon_name]
        
        chapter_name = soup.find("font", size="4").text.strip() if soup.find("font", size="4") else chapter_title
        
        outline_element = soup.find("span", id="Outline")
        if outline_element:
            outline_paragraph = outline_element.find_next("p")
            if outline_paragraph:
                outline = outline_paragraph.text.strip()
            else:
                outline = ""
        else:
            outline = ""

        # Extract summary
        # account for spelling mistake (The Dragon Reborn: Chapter 29)
        summary_block = soup.find("span", id="Summary") or soup.find("span", id="Sumary")
        if summary_block:
            summary_section = summary_block.find_next("p")
        else:
            summary_section = None
            
        summary_list = []
        current_pov = None
        current_setting = None
        current_summary = []

        while summary_section and summary_section.name != "h2":
            # extract raw HTML to preserve inline tags like <a>
            raw_html = str(summary_section)

            # convert raw HTML to plain text while preserving spaces
            text = summary_section.get_text("", strip=False)

            # normalize whitespace and trim unnecessary newlines or spaces
            text = " ".join(text.split())
            
            if "Point of View" in text:
                # save current POV and summary
                if current_pov or current_summary:
                    summary_list.append({
                        "pov_character": current_pov or "General",
                        "setting": current_setting or "Unknown",
                        "pov_summary": "\n".join(current_summary).strip()
                    })

                # start new POV character
                current_pov = text.split("'")[0].strip()
                current_setting = None  # Reset the setting for the new POV
                current_summary = []

            elif "Setting:" in text:
                # extract setting description
                current_setting = text.replace("Setting:", "").strip()

            elif not ("Characters:" in text or "Setting:" in text):
                if text:
                    current_summary.append(text)

            summary_section = summary_section.find_next_sibling()

        if current_pov or current_summary:
            summary_list.append({
                "pov_character": current_pov or "General",
                "setting": current_setting or "Unknown",
                "pov_summary": "\n".join(current_summary).strip()
            })

        # structure data
        filtered_summary = {
            "Summary": summary_list,
            "Outline": outline,
        }

        book_data["content"].append({
            "chapter": chapter_title.split(":")[-1].strip(),
            "name": chapter_name,
            "author": author_name,
            "icon": icon_name,
            "summary": filtered_summary
        })
        
        concurrent_count += 1
        print(f"{concurrent_count}/{total_count}, {title}, Chapter {chapter_title.split(":")[-1].strip()}: {link}...")
        
    final_data.append(book_data)

with open(destination, 'w') as json_file:
    json.dump(final_data, json_file, indent=4)

print(f"Data saved to '{destination}'!")
