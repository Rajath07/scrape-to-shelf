from pymongo import MongoClient
import xml.etree.ElementTree as ET
import xmlschema

# MongoDB connection setup
connection_string = "mongodb+srv://arrowphoto1815827rajath:KFNpqgil4qSgwVyL@nodeexpressprojects.f9im4fg.mongodb.net/books_database?retryWrites=true&w=majority&appName=NodeExpressProjects"
client = MongoClient(connection_string)
db = client['books_database']  # Database name
collection = db['books_collection']  # Collection name

# Function to run queries and generate XML
def run_queries_and_generate_xml():
    # Query 1: Find the top 5 most expensive books
    top_expensive_books = list(collection.find().sort("price", -1).limit(5))

    # Query 2: Count the number of books available in each category
    category_counts = list(collection.aggregate([
        {"$group": {"_id": "$category", "count": {"$sum": 1}}},
        {"$sort": {"count": -1}}
    ]))

    # Query 3: Find the average price of books for each star rating
    average_price_star_rating = list(collection.aggregate([
        {"$group": {"_id": "$star_rating", "average_price": {"$avg": "$price"}}},
        {"$sort": {"_id": 1}}
    ]))

    # Query 4: Find the top 5 books with the lowest price
    lowest_price_books = list(collection.find().sort("price", 1).limit(5))

    # Query 5: Count the number of books in different price ranges
    price_ranges = [
        {"range": "<10", "min": 0, "max": 10},
        {"range": "10-20", "min": 10, "max": 20},
        {"range": "20-50", "min": 20, "max": 50},
        {"range": ">50", "min": 50, "max": float('inf')}
    ]

    price_range_counts = []
    for pr in price_ranges:
        if pr["max"] == float('inf'):
            count = collection.count_documents({"price": {"$gt": pr["min"]}})
        else:
            count = collection.count_documents({"price": {"$gte": pr["min"], "$lt": pr["max"]}})
        price_range_counts.append({"range": pr["range"], "count": count})

    # Query 6: Find books with a 5-star rating
    five_star_books = list(collection.find({"star_rating": "Five"}))

    # Generate XML
    generate_xml(top_expensive_books, category_counts, average_price_star_rating, lowest_price_books, price_range_counts, five_star_books)

# Function to generate XML and validate against XSD
def generate_xml(top_expensive_books, category_counts, average_price_star_rating, lowest_price_books, price_range_counts, five_star_books):
    xml_root = ET.Element("BooksData")

    # Add top expensive books
    top_expensive_books_elem = ET.SubElement(xml_root, "TopExpensiveBooks")
    for book in top_expensive_books:
        book_elem = dict_to_xml("Book", book)
        top_expensive_books_elem.append(book_elem)

    # Add category counts
    category_counts_elem = ET.SubElement(xml_root, "CategoryCounts")
    for category in category_counts:
        category_elem = dict_to_xml("Category", category)
        category_counts_elem.append(category_elem)

    # Add average price by star rating
    average_price_star_rating_elem = ET.SubElement(xml_root, "AveragePriceByStarRating")
    for rating in average_price_star_rating:
        rating_elem = dict_to_xml("StarRating", rating)
        average_price_star_rating_elem.append(rating_elem)

    # Add lowest price books
    lowest_price_books_elem = ET.SubElement(xml_root, "LowestPriceBooks")
    for book in lowest_price_books:
        book_elem = dict_to_xml("Book", book)
        lowest_price_books_elem.append(book_elem)

    # Add price ranges
    price_ranges_elem = ET.SubElement(xml_root, "PriceRanges")
    for pr in price_range_counts:
        pr_elem = dict_to_xml("Range", pr)
        price_ranges_elem.append(pr_elem)

    # Add five-star books
    five_star_books_elem = ET.SubElement(xml_root, "FiveStarBooks")
    for book in five_star_books:
        book_elem = dict_to_xml("Book", book)
        five_star_books_elem.append(book_elem)

    # Save XML
    xml_tree = ET.ElementTree(xml_root)
    xml_tree.write("books_data.xml")
    print("books_data.xml generated")

    # Validate against XSD
    validate_xml("books_data.xml", "books_data.xsd")

# Convert dictionary to XML element
def dict_to_xml(tag, d):
    elem = ET.Element(tag)
    for key, val in d.items():
        child = ET.Element(key)
        child.text = str(val)
        elem.append(child)
    return elem

# Function to validate XML against XSD
def validate_xml(xml_filename, xsd_filename):
    xsd = xmlschema.XMLSchema(xsd_filename)
    if xsd.is_valid(xml_filename):
        print(f"{xml_filename} is valid against {xsd_filename}")
    else:
        print(f"{xml_filename} is invalid against {xsd_filename}")

if __name__ == "__main__":
    run_queries_and_generate_xml()
