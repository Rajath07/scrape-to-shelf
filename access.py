from lxml import etree

# Load the XML and XSLT files
xml_file = 'books_data.xml'
xslt_file = 'books.xsl'

xml = etree.parse(xml_file)
xslt = etree.parse(xslt_file)

# Apply the XSLT transformation
transform = etree.XSLT(xslt)
result = transform(xml)

# Save the result to an HTML file
with open('books.html', 'wb') as f:
    f.write(etree.tostring(result, pretty_print=True, method="html"))