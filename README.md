![WOTapp](https://github.com/user-attachments/assets/d5cf5646-b0bd-4932-9756-837bff7641e9)

# Reading Codex

Reading Codex is an iOS companion app for the Wheel of Time book series.

This app is not yet public on the App Store (due to costs), however IPA file is available (see [Releases](https://github.com/ckfranz/reading-codex/releases)).

## Motivation

- The Wheel of Time series comprises of **15 books** with **2,787 named characters**, making it one of the most expansive fictional universes
- The series features **148 characters** with a point-of-view scene
- Keeping track of every character, location, and event **without getting spoiled** is challenging without a reference tool.

## Overview

Reading Codex allows users to track their progress, refresh with chapter recaps, read character bios and explore the world with an interactive map.

## Features

- **Character Database:** Detailed profiles for major and minor characters, filterable by book.
- **Chapter Recaps:** Quickly revisit the key events of any chapter.
- **Book Summaries:** Comprehensive overviews of each book to refresh your memory.
- **Map Viewer:** Interactive maps to explore the world and follow the journey.
- **Spoiler Free:** Character profiles can be explored by book to avoid spoilers.
- **Elegant & Intuitive UI:** Native iOS feel, with intuitive gestures and a dynamic light/dark mode.

<p align="center">
  <img src="https://github.com/user-attachments/assets/f5c3e15e-6d23-4d22-be78-fa87798c2f62" />
</p>

## Technologies Used

- **iOS Development:** Built using **Swift** and **SwiftUI**.
  - Features JSON parsing, custom routing and native components for a seamless experience for iPhone users
  - Utilizes local storage, optimized for rapid loading
- **Web Scraping:** Leveraged **Python** with **BeautifulSoup** to scrape and process data from online wikis

## Screenshots

### Book & Chapter Recaps

<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; justify-items: center; align-items: center;">
  <img src="https://github.com/user-attachments/assets/dc20e553-2ec2-4cea-bd47-a6daf4921744" alt="Screenshot 8" style="width: 30%; height: auto;">
  <img src="https://github.com/user-attachments/assets/86acc95f-e069-4dca-85c4-a4e7f2afde54" alt="Screenshot 5" style="width: 30%; height: auto;">
  <img src="https://github.com/user-attachments/assets/3be7cc38-c99a-4490-9de2-a30bb36d58d6" alt="Screenshot 6" style="width: 30%; height: auto;">
</div>

### Character Search

<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; justify-items: center; align-items: center;">
  <img src="https://github.com/user-attachments/assets/2ac94157-74ff-483c-97be-330e2f0f71fe" alt="Screenshot 10" style="width: 30%; height: auto;">
  <img src="https://github.com/user-attachments/assets/b30bf837-1eb5-43f0-a1bd-09cae1fab6e4" alt="Screenshot 2" style="width: 30%; height: auto;">
  
  <img src="https://github.com/user-attachments/assets/f89545e3-42ba-4d03-83d0-8c872b6199d4" alt="Screenshot 2" style="width: 30%; height: auto;">
</div>

### Interactive Map

<div align="center">
  <img src="https://github.com/user-attachments/assets/35e74628-4544-4651-8224-55724b76c009" alt="Screenshot 7" style="width: 60%; height: auto;">
</div>

### Attributions

- Book authors: [Robert Jordan](https://en.wikipedia.org/wiki/Robert_Jordan) and [Brandon Sanderson](https://brandonsanderson.com/)
- Chapter Summaries: [TarValon.Net](https://library.tarvalon.net/index.php?title=Tar_Valon_Library_Index_-_The_Wheel_of_Time)
- Character data: [Karl Hammond's WoT Compendium](https://hammondkd.github.io/WoT-compendium/)
- Book Cover art: Created by Darrel K. Sweet and Michael Whelan
- Chapter icons: https://jcsalomon.github.io/wot-chapter-icons/
  - This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/)
