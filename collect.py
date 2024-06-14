import requests
from lxml import html
from pymongo import MongoClient

# URL of the website
base_url = "https://books.toscrape.com/catalogue/page-{}.html"
book_base_url = "https://books.toscrape.com/catalogue/"

# MongoDB connection setup (replace <username>, <password>, and <dbname> with your actual credentials and database name)
connection_string = "mongodb+srv://arrowphoto1815827rajath:KFNpqgil4qSgwVyL@nodeexpressprojects.f9im4fg.mongodb.net/books_database?retryWrites=true&w=majority&appName=NodeExpressProjects"
client = MongoClient(connection_string)
db = client['books_database']  # Database name
collection = db['books_collection']  # Collection name

# Function to scrape book details from a single book page
def scrape_book_details(book_url):
    response = requests.get(book_url)
    tree = html.fromstring(response.content)
    
    title = tree.xpath('//div[contains(@class, "product_main")]/h1/text()')[0]
    price = tree.xpath('//p[@class="price_color"]/text()')[0]
    availability = tree.xpath('//p[@class="instock availability"]/text()')[1].strip()
    
    # Handle missing description
    try:
        description = tree.xpath('//div[@id="product_description"]/following-sibling::p/text()')[0]
    except IndexError:
        description = ""
    
    upc = tree.xpath('//th[text()="UPC"]/following-sibling::td/text()')[0]
    product_type = tree.xpath('//th[text()="Product Type"]/following-sibling::td/text()')[0]
    price_excl_tax = tree.xpath('//th[text()="Price (excl. tax)"]/following-sibling::td/text()')[0]
    price_incl_tax = tree.xpath('//th[text()="Price (incl. tax)"]/following-sibling::td/text()')[0]
    tax = tree.xpath('//th[text()="Tax"]/following-sibling::td/text()')[0]
    number_of_reviews = tree.xpath('//th[text()="Number of reviews"]/following-sibling::td/text()')[0]
    
    # Extract category from breadcrumb navigation
    category = tree.xpath('//ul[@class="breadcrumb"]/li[3]/a/text()')[0]
    
    # Extract star rating
    star_rating_class = tree.xpath('//p[contains(@class, "star-rating")]/@class')[0]
    star_rating = star_rating_class.split()[-1]

    book_info = {
        'title': title,
        'price': price,
        'availability': availability,
        'description': description,
        'upc': upc,
        'product_type': product_type,
        'price_excl_tax': price_excl_tax,
        'price_incl_tax': price_incl_tax,
        'tax': tax,
        'number_of_reviews': number_of_reviews,
        'category': category,
        'star_rating': star_rating
    }

    return book_info

# Function to scrape book details from a single page
def scrape_page(page_url):
    response = requests.get(page_url)
    tree = html.fromstring(response.content)

    # XPath to extract book links
    book_links = tree.xpath('//article[@class="product_pod"]/h3/a/@href')
    book_list = []

    for link in book_links:
        book_url = book_base_url + link
        book_info = scrape_book_details(book_url)
        book_list.append(book_info)

    return book_list

# Function to scrape all pages
def scrape_all_pages():
    all_books = []
    page_number = 1

    while True:
        page_url = base_url.format(page_number)
        print(f"Scraping page: {page_number}")
        books = scrape_page(page_url)

        if not books:
            break

        all_books.extend(books)
        page_number += 1

    return all_books

# Scrape all books and store in MongoDB
def main():
    all_books = scrape_all_pages()

    if all_books:
        collection.insert_many(all_books)
        print(f"Scraped data inserted into MongoDB collection 'books_collection' in database 'books_database'")

if __name__ == "__main__":
    main()
