# Rails Engine Lite
>

![ruby-image]

A RESTful rails API to allow a client to query merchant and item data. Mock data is stored in a Postgresql database. Includes search functions by name and price parameters. Created in a five day sprint.

Reach out to me on [Linkedin](https://www.linkedin.com/in/gavin-carew-6476748a/) or  [Github](https://github.com/gjcarew) 

## Table of contents

- [Database setup](#database-setup)
- [Endpoints](#endpoints)
- [Query parameters](#query-params)

## <a name="database-setup"></a>Database Setup

Fork and clone the project, then install the required gems with `bundle`. 

```sh
bundle install
```

Reset and seed the database: 

```sh
rake db:{drop,create,migrate,seed}
```

Run a schema dump:

```sh
rails db:schema:dump
```
Start a rails server, and you're ready to query 
```sh
rails s
```

## <a name="endpoints"></a>Endpoints

These endpoints are available:

- `GET    /api/v1/merchants`
  - Get all merchants
- `GET    /api/v1/merchants/:id`
  - Get a single merchant by ID
- `GET    /api/v1/merchants/:merchant_id/items`
  - Get a merchant's items
- `GET    /api/v1/merchants/find?<QUERY_PARAMS>`
  - Search for a single merchant. Query details are below.
- `GET    /api/v1/merchants/find_all?<QUERY_PARAMS>`
  - Search for all merchants matching a query
- `GET    /api/v1/items`
  - Get all items
- `POST   /api/v1/items`
  - Create an item
- `GET    /api/v1/items/:id`
  - Get a single item
- `PATCH  /api/v1/items/:id`
  - Update an item's attributes
- `DELETE    /api/v1/items/:id`
  - Deletes an item and related invoices if it was the only item on the invoice          
- `GET    /api/v1/items/:item_id/merchant`
  - Gets an item's merchant
- `GET    /api/v1/items/find?<QUERY_PARAMS>`
  - Search for a single item. Query details are below.
- `GET    /api/v1/items/find_all?<QUERY_PARAMS>`
  - Search for all items matching a query

## <a name="query-params"></a>Query parameters
### Query by name
The `name` query parameter is case-insensitive and supports partial matching. When querying for a single result and there are multiple matches, the first result of the query sorted alphabetically will be returned. Merchants can _only_ be queried by name. 
### Example

```json
Query: localhost:3000/api/v1/merchants/find?name=ILL
Response: 
{
  "data": [
    {
      "id": "3",
      "type": "merchant",
      "attributes": {
        "name": "Willms and Sons"
        }
    },
    {
      "id": "5",
      "type": "merchant",
      "attributes": {
        "name": "Williamson Group"
        }
    },
    {
      "id": "6",
      "type": "merchant",
      "attributes": {
        "name": "Williamson Group"
        }
    },
    {
      "id": "13",
      "type": "merchant",
      "attributes": {
        "name": "Tillman Group"
        }
    },
    {
      "id": "28",
      "type": "merchant",
      "attributes": {
        "name": "Schiller, Barrows and Parker"
        }
    }
  ]
}
```
### Query by price
Only items can be queried by price. They can be queried by `min_price` and `max_price`. Items can either be queried by name or price, but not both. A query can include only a `min_price`, only a `max_price`, or both. When querying for a single result and there are multiple matches, the first result of the query sorted alphabetically will be returned.
### Example
```json
Query: localhost:3000/api/v1/items/find_all?min_price=50&max_price=50.25
Response: 
{
  "data": [
    {
      "id": "587",
      "type": "item",
      "attributes": {
        "name": "Item Animi In",
        "description": "Eum necessitatibus eos aliquid consequuntur. Occaecati ut quia et. Vel molestiae eum beatae ut nostrum. Beatae rem cumque autem.",
        "unit_price": 50.03,
        "merchant_id": 29
      }
    },
    {
      "id": "2282",
      "type": "item",
      "attributes": {
        "name": "Item Eos Amet",
        "description": "Cum architecto necessitatibus assumenda alias. Magnam consequatur et iusto nihil dignissimos temporibus amet. Occaecati rerum dolorem pariatur omnis et quasi.",
        "unit_price": 50.19,
        "merchant_id": 94
      }
    },
    {
      "id": "75",
      "type": "item",
      "attributes": {
        "name": "Shiny Itemy Item",
        "description": "It does a lot of things real good",
        "unit_price": 50.11,
        "merchant_id": 43
      }
    }
  ]
}


```



<!-- Markdown link & img dfn's -->
[ruby-image]: https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white

