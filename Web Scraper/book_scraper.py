from bs4 import BeautifulSoup
import requests
import json

destination = 'Web Scraper/data/test/book_summaries.json'

base_url = 'https://library.tarvalon.net'

book_summaries_url = 'https://library.tarvalon.net/index.php?title=Book_Summaries'

summaries_page = requests.get(book_summaries_url)
book_summary_soup = BeautifulSoup(summaries_page.text, 'html.parser')

long_summaries = book_summary_soup.find_all('ul')[0]
full_summary_links_data = long_summaries.find_all('a')

book_summary_links = [base_url + link['href'] for link in full_summary_links_data]

def scrape_summary(soup):
    # extract title
    title_tag = soup.find('h1', class_='firstHeading')
    title = title_tag.text.strip()
    title = title.replace(': Plot Summary', '')
    
    # extract main content div
    content_div = soup.find('div', class_='mw-content-ltr')

    # remove the last 3 <p> tags (irrelevant footer)
    all_paragraphs = content_div.find_all('p')
    for p in all_paragraphs[-3:]:
        p.extract()
        
    # Remove nested <div> elements (irrelevant info boxed
    for nested_div in content_div.find_all('div'):
        nested_div.extract()
        
    # Extract author
    author_tag = content_div.find('i')
    if author_tag:
        author = author_tag.text.strip().replace('Author: ', '')
        author_tag.extract()
    else:
        author = "Unknown"

    summaries = []
    current_section = None

    for tag in content_div.find_all(['p', 'b', 'h2']):
        if tag.name == 'p' and not tag.get_text(strip=True):
            continue

        # if tag is a <p> and contains a <b>, treat <b> as section header
        if tag.name == 'p' and tag.find('b'):
            current_section = tag.find('b').get_text(strip=True)
            if not any(s["section"] == current_section for s in summaries):
                summaries.append({"section": current_section, "content": ""})
        # start a new section if encounter a header
        elif tag.name in ['b', 'h2'] and tag.get_text(strip=True):
            current_section = tag.get_text(strip=True)
            if not any(s["section"] == current_section for s in summaries):
                summaries.append({"section": current_section, "content": ""})
        # add the paragraph to current section
        elif tag.name == 'p':
            if current_section:
                for s in summaries:
                    if s["section"] == current_section:
                        s["content"] += tag.get_text(strip=False)
                        break
            else:
                # if no section exists, start default section
                current_section = "Summary"
                if not any(s["section"] == current_section for s in summaries):
                    summaries.append({"section": current_section, "content": ""})
                summaries[-1]["content"] += tag.get_text(strip=False)

    return title, author, summaries

data = []

print(f"Scraping {len(book_summary_links)} book summaries...")
for idx, link in enumerate(book_summary_links, start=1):
    print(f"{idx}/{len(book_summary_links)}: {link}...")
    
    # fetch page
    page = requests.get(link)
    soup = BeautifulSoup(page.text, 'html.parser')

    # scrape summary
    title, author_name, summary = scrape_summary(soup)

    data.append({
        "title": title,
        "author": author_name,
        "summary": summary
    })

with open(destination, 'w') as json_file:
    json.dump(data, json_file, indent=4)
    
print(f"Data saved to '{destination}'!")