# ShopWise - Flutter Technical Assessment

A Flutter product listing and favorites application built using the public
[DummyJSON API](https://dummyjson.com/).

The project demonstrates Flutter UI development, Riverpod state management,
GetX controllers, REST API integration, clean architecture, asynchronous state
management, pagination, search, category filtering, favorites synchronization,
error handling, performance optimization, and automated testing.

---

## Features

### Product Listing

- Display product image
- Product title
- Price
- Rating
- Category
- Favorite button
- Search products
- Filter products by category
- Pagination / load more
- Pull-to-refresh
- Loading state
- Error state
- Empty state
- Retry on API failure

### Product Details

- Product images
- Title
- Description
- Price
- Discount percentage
- Rating
- Stock
- Brand
- Category
- Add/remove from favorites
- Fetch product details using the product ID

### Favorites

- View favorite products
- Add/remove favorites from the product list
- Add/remove favorites from product details
- Favorite state remains synchronized across listing, details, and favorites
- Favorites are maintained locally in memory

---

## API

The application uses the public DummyJSON API.

Base URL:

https://dummyjson.com/

Main endpoints used by the application:

- `GET /products`
- `GET /products/search?q={query}`
- `GET /products/{id}`
- `GET /products/categories`
- `GET /products/category/{category}`
- `GET /products?limit={limit}&skip={skip}`

No backend was created for this assessment.

---

## Project Setup

### Requirements

Make sure Flutter and Dart are installed on your machine.

### Install dependencies

Clone the repository and navigate to the project directory:

```bash
git clone https://github.com/SamanWaqarAhmed/shopify_flutter_assessment.git
cd shopify_flutter_assessment