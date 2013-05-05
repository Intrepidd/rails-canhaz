[A port of this gem working on mongoid](https://github.com/intrepidd/mongoid-canhaz) is now avaible.

# Rails-Canhaz for Rails 4.0.0.beta1 !

This gem is a simple activerecord extention that allows any application using activerecord to manage permissions based roles.

## Installation (Prerelease gem !)

Standard gem installation :

```
gem install rails-canhaz -v 2.0.0.pre
```

Or in your Gemfile if you use bundler

```ruby
gem 'rails-canhaz', '2.0.0.pre'
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

Or you can run this command to automatically create one:

```
rails g can_haz:install
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

article.subjects_with_permission(User, :read) # Will return all the users hat are able to read this article

#You can also remove permissions

user.cannot!(:read, article)

# Version 1.0.0 introduces global permissions :

user.can?(:haz_cheezburgers) # false

user.can!(:haz_cheezburgers)

user.can?(:haz_cheezburgers) # true

```

## Changelog
* 1.0.0 (hurray !):
  * Removing can and cannot deprecated functions (renamed to can! and cannot!)
  * Adding global permissions for subjects
* 0.4.1 :
  * Adding a rails migration generator thanks to [Awea](http://github.com/Awea)
* 0.4.0 :
  * Aliasing can to can! and deprecating can
  * Aliasing cannot to cannot! and deprecating cannot
* 0.3.0 :
  * Removing rights from the database before destroying a subject or object model
