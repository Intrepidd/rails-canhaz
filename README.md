# Rails-Canhaz

This gem is a simple activerecord extention that allows any application using activerecord to manage permissions based roles.

## Installation

Standard gem installation :

```
gem install rails-canhaz
```

Or in your Gemfile if you use bundler

```ruby
gem 'rails-canhaz'
```

## How to use it ?

The rails-canhaz gem defines two static functions for ActiveRecord models which allow them to act as a subject or an object.

A subject has roles on objects.

Here is an example

```ruby
class User < ActiveRecord::Base
  acts_as_canhaz_subject
end

class Article < ActiveRecord::Base
  acts_as_canhaz_object
end
```

Now our models are marked as canhaz subjects and objects, we have access to some handy functions :


```ruby
user = User.find(42)
article = Article.find(1337)

user.can?(:read, article) # Can the user read this article? false for now

user.can(:read, article) # Ok, so the user can read this article

user.can?(:read, article) # Will be true

user.objects_with_permission(Article, :read) # Will return all the articles w/ read permissions for this user
```

More coming soon ...
