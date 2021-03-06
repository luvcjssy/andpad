### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby 2.7.1
- Rails 6.0.3

##### 1. Check out the repository

```bash
git@github.com:luvcjssy/andpad.git
```

##### 2. Go to project directory

```bash
cd <path_to_project>
```

##### 3. Install gem
```bash
bundle install
```

##### 4. Create database.yml file

Edit the database configuration as required.

```bash
config/database.yml
```

##### 5. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rake db:create
bundle exec rake db:migrate
```

##### 6. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```

And now you can visit the site with the URL http://localhost:3000

### APIs doc

Authors APIs

- GET: {endpoint}/api/v1/authors

- GET: {endpoint}/api/v1/authors/:id

- POST: {endpoint}/api/v1/authors

```ruby
{
  "name": "Author name",
  "bio": "Author bio"
}
```

- PUT: {endpoint}/api/v1/authors/:id

```ruby
{
  "name": "Author name",
  "bio": "Author bio"
}
```

- DELETE: {endpoint}/api/v1/authors/:id

Books APIs

- GET: {endpoint}/api/v1/books?author_name=demo

- GET: {endpoint}/api/v1/books/:id

- POST: {endpoint}/api/v1/books

```ruby
{
  "title": "Book title",
  "description": "Book desc",
  "price": 10,
  "author_id": 1
}
```

- PUT: {endpoint}/api/v1/books/:id

```ruby
{
  "title": "Book title",
  "description": "Book desc",
  "price": 10,
  "author_id": 1
}
```

- DELETE: {endpoint}/api/v1/books/:id