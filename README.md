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

You then need to create a single table in order to make this gem to work

Here is the schema of this table, if you're using ruby on rails, you should create a migration :

```ruby
create_table :can_haz_permissions do |t|
  t.integer :csubject_id
  t.string :csubject_type

  t.integer :cobject_id
  t.string :cobject_type

  t.string :permission_name
end

add_index :can_haz_permissions, :csubject_id, :name => 'subject_id_ix'
add_index :can_haz_permissions, :cobject_id, :name => 'object_id_ix'
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

user.can!(:read, article) # Ok, so the user can read this article
user.can!(:edit, article) # He can edit it as well

user.can?(:read, article) # Will be true

user.objects_with_permission(Article, :read) # Will return all the articles w/ read permissions for this user

artice.subjects_with_permission(User, :read) # Will return all the users hat are able to read this article

#You can also remove permissions

user.cannot(:read, article)

```

More coming soon ...
