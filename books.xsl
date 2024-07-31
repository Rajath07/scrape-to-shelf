<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/">
        <html>
        <head>
            <title>BOOKS LIST</title>

            <script>
                function toggleDescription(id) {
                    var desc = document.getElementById(id);
                    if (desc.style.display === "none") {
                        desc.style.display = "block";
                    } else {
                        desc.style.display = "none";
                    }
                }

                function toggleDescription1(id) {
                    var desc1 = document.getElementById(id);
                    if (desc1.style.display === "none") {
                        desc1.style.display = "block";
                    } else {
                        desc1.style.display = "none";
                    }
                }

                function toggleDescription2(id) {
                    var desc2 = document.getElementById(id);
                    if (desc2.style.display === "none") {
                        desc2.style.display = "block";
                    } else {
                        desc2.style.display = "none";
                    }
                }
            </script>

            <style>

                body{
                background-image: url("img_3.png");
                background-size: cover;
                }

                tr{
                background-color: #FDF5E6;
                }

                th {
                background: linear-gradient(#777, #444);
                background-color: #BC8F8F;
                color: white;
                font-family: 'Courier New', monospace;
                font-weight: bold;
                font-size: 25px;
                }


                button {
                background-color: #02F4F4F; /* Green */
                  border: none;
                  color: white;
                  padding: 6px 270px;
                  text-align: center;
                  text-decoration: none;
                  display: inline-block;
                  font-size: 16px;
                  margin: 4px 2px;
                  transition-duration: 0.4s;
                  cursor: pointer;
                }

                button {
                  background-color: white;
                  color: black;
                  border: 2px solid #2F4F4F;
                }

                button:hover {
                  background-color: #2F4F4F;
                  color: white;
                }

            </style>
        </head>
        <body>

            <!--Table showing Top 5 expensive books (Query 1) -->
            <h1 style="text-align: center;">TOP 5 EXPENSIVE BOOKS</h1>
            <table border="1" style="width:100%">
                <tr style="height:50px">
                    <th style="width:22%">Title</th>
                    <th style="width:10%">Price</th>
                    <th style="width:18%">Availability</th>
                    <th style="width:50%">Description</th>
                </tr>
                <xsl:for-each select="BooksData/TopExpensiveBooks/Book">
                    <tr style="height:50px">
                        <td style="font-family: Copperplate, Papyrus, fantasy; font-size: 16px; font-weight: bold;">
                           <xsl:value-of select="title"/></td>
                        <td style="text-align: center; vertical-align: middle; font-family: Georgia, serif; font-weight: bold;">
                            <!-- Add the currency symbol before the price -->
                             <xsl:text>£</xsl:text>
                            <xsl:value-of select="price"/></td>
                        <td style="text-align: center; vertical-align: middle; font-family: Garamond, serif; font-weight: bold; font-size: 20px;">
                            <xsl:value-of select="availability"/></td>
                        <td style="font-family: Copperplate, Papyrus, fantasy;">
                            <button onclick="toggleDescription('desc{position()}')" style="text-align: center; vertical-align: middle; font-family: Copperplate, Papyrus, fantasy; font-weight: bold;">Click me</button>
                            <div id="desc{position()}" style="display:none;">
                                <xsl:value-of select="description"/>
                            </div>
                        </td>

                    </tr>
                </xsl:for-each>
            </table>

            <!--Table showing number of books available in each category (Query 2) -->
             <h1 style="text-align: center;">CATEGORY COUNT</h1>
            <table border="1" style="width:100%">
                <tr style="height:50px">
                    <th style="width:50%">Category</th>
                    <th style="width:50%">Count</th>
                </tr>
                <xsl:for-each select="BooksData/CategoryCounts/Category[not(_id = 'Default')]">
                    <tr style="height:50px">
                       <td style="font-family: Copperplate, Papyrus, fantasy; font-size: 16px; font-weight: bold;">
                           <xsl:value-of select="_id"/>
                       </td>
                        <td style="text-align: center; vertical-align: middle; font-family: Georgia, serif; font-weight: bold;">
                            <xsl:value-of select="count"/>
                        </td>

                    </tr>
                </xsl:for-each>
            </table>

            <!--Table showing average price of books for each star rating (Query 3) -->
            <h1 style="text-align: center;">AVERAGE PRICE BY STAR RATING</h1>
            <table border="1" style="width:100%">
                <tr style="height:50px">
                    <th style="width:50%">STAR</th>
                    <th style="width:50%">PRICE</th>
                </tr>
                <xsl:for-each select="BooksData/AveragePriceByStarRating/StarRating">
                    <tr style="height:50px">
                       <td style="font-family: Copperplate, Papyrus, fantasy; font-size: 16px; font-weight: bold;"><xsl:value-of select="_id"/></td>
                        <td style="text-align: center; vertical-align: middle; font-family: Georgia, serif; font-weight: bold;">
                        <!-- Add the currency symbol before the price -->
                        <xsl:text>£</xsl:text>
                        <xsl:value-of select="format-number(average_price, '#.00')"/></td>

                    </tr>
                </xsl:for-each>
            </table>


            <!--Table showing top 5 books with the lowest price (Query 4) -->
             <h1 style="text-align: center;">LOWEST PRICE BOOKS</h1>
            <table border="1" style="width:100%">
                <tr style="height:50px">
                    <th style="width:22%">Title</th>
                    <th style="width:10%">Price</th>
                    <th style="width:18%">Availability</th>
                    <th style="width:50%">Description</th>
                </tr>
                <xsl:for-each select="BooksData/LowestPriceBooks/Book">
                    <tr style="height:50px">
                       <td style="font-family: Copperplate, Papyrus, fantasy; font-size: 16px; font-weight: bold;"><xsl:value-of select="title"/></td>
                        <td style="text-align: center; vertical-align: middle; font-family: Georgia, serif; font-weight: bold;">
                        <!-- Add the currency symbol before the price -->
                        <xsl:text>£</xsl:text><xsl:value-of select="price"/></td>
                        <td style="text-align: center; vertical-align: middle; font-family: Garamond, serif; font-weight: bold; font-size: 20px;"><xsl:value-of select="availability"/></td>
                        <td style="font-family: Copperplate, Papyrus, fantasy;">
                            <button onclick="toggleDescription1('desc1{position()}')" style="text-align: center; vertical-align: middle; font-family: Copperplate, Papyrus, fantasy; font-weight: bold;">Click me</button>
                            <div id="desc1{position()}" style="display:none;">
                                <xsl:value-of select="description"/>
                            </div>
                        </td>

                    </tr>
                </xsl:for-each>
            </table>

            <!--Table showing the number of books in different price ranges (Query 5) -->
            <h1 style="text-align: center;">PRICE RANGES</h1>
            <table border="1" style="width:100%">
                <tr style="height:50px">
                    <th style="width:50%">Price Range</th>
                    <th style="width:50%">Count</th>
                </tr>
                <xsl:for-each select="BooksData/PriceRanges/Range">
                    <tr style="height:50px">
                       <td style="font-family: Copperplate, Papyrus, fantasy; font-size: 16px; font-weight: bold;">
                       <!-- Add the currency symbol before the price -->
                        <xsl:text>£</xsl:text>
                        <xsl:value-of select="range"/></td>
                        <td style="text-align: center; vertical-align: middle; font-family: Georgia, serif; font-weight: bold;"><xsl:value-of select="count"/></td>

                    </tr>
                </xsl:for-each>
            </table>

            <!--Table showing books with a 5-star rating (Query 6) -->
            <h1 style="text-align: center;">5 STAR BOOKS</h1>
            <table border="1" style="width:100%">
                <tr style="height:50px">
                    <th style="width:22%">Title</th>
                    <th style="width:10%">Price</th>
                    <th style="width:18%">Availability</th>
                    <th style="width:50%">Description</th>
                </tr>
                <xsl:for-each select="BooksData/FiveStarBooks/Book">
                    <tr style="height:50px">
                       <td style="font-family: Copperplate, Papyrus, fantasy; font-size: 16px; font-weight: bold;"><xsl:value-of select="title"/></td>
                        <td style="text-align: center; vertical-align: middle; font-family: Georgia, serif; font-weight: bold;">
                        <!-- Add the currency symbol before the price -->
                        <xsl:text>£</xsl:text>
                        <xsl:value-of select="price"/></td>
                        <td style="text-align: center; vertical-align: middle; font-family: Garamond, serif; font-weight: bold; font-size: 20px;"><xsl:value-of select="availability"/></td>
                        <td style="font-family: Copperplate, Papyrus, fantasy;">
                            <button onclick="toggleDescription2('desc2{position()}')" style="text-align: center; vertical-align: middle; font-family: Copperplate, Papyrus, fantasy; font-weight: bold;">Click me</button>
                            <div id="desc2{position()}" style="display:none;">
                                <xsl:value-of select="description"/>
                            </div>
                        </td>

                    </tr>
                </xsl:for-each>
            </table>
        </body>
        </html>
    </xsl:template>
</xsl:stylesheet>