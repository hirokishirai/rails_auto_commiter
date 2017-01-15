# RailsAutoCommiter
RailsAutoCommiter provides an auto commiter for Ruby on Rails.
If you run `rails [generate,destroy] ...`, files Rails changed will be automatically commited by it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_auto_commiter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_auto_commiter

## Usage

Run the rails commands as always. The changed files are automatically committed.

```zsh
% rails generate model Post hoge
Running via Spring preloader in process 78876
Expected string default value for '--jbuilder'; got true (boolean)
      invoke  active_record
      create    db/migrate/20170115144306_create_posts.rb
      create    app/models/post.rb
      invoke    test_unit
      create      test/models/post_test.rb
      create      test/fixtures/posts.yml
[master 0a9773b] result of 'rails generate model Post title body:text'.
 4 files changed, 28 insertions(+)
 create mode 100644 app/models/post.rb
 create mode 100644 db/migrate/20170115144306_create_posts.rb
 create mode 100644 test/fixtures/posts.yml
 create mode 100644 test/models/post_test.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rails_auto_commiter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

RailsAutoCommiter is released under the [MIT License](http://www.opensource.org/licenses/MIT).
