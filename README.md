# ActiveAdmin Select2

Incorporate [Select2](http://ivaynberg.github.io/select2/) into your [ActiveAdmin](http://activeadmin.info/) apps.

Supports both ActiveAdmin 0.x (use with Rails 3.x) and 1.0+ (use with Rails 4.x).

## Installation

Add `activeadmin`, `jquery-rails` and `select2-rails` to your Gemfile:

```ruby
gem 'activeadmin'
gem 'jquery-rails'
gem 'select2-rails'
```

And add `activeadmin-select2` to your Gemfile:

```ruby
gem 'activeadmin-select2', github: 'mfairburn/activeadmin-select2'
```

Add the activeadmin-select2 calls to the active_admin stylesheets and javascripts with:

```active_admin.css.scss
@import "active_admin/select2/base";
```

```active_admin.js
//= require active_admin/select2
```


## Usage

### Filters

Standard `as: :select` filters will automagically be converted to Select2 filters.

If you want a multi-select combo-box then use:

```ruby
ActiveAdmin.register Products do

  filter :fruits, as: :select2_multiple, collection: [:apples, :bananas, :oranges]

end
```

### Select Lists

To use a Select2 style list simply change from `:select` to `:select2` or `:select2_multiple`

```ruby
ActiveAdmin.register Products do

  form do |f|
    f.input :fruit, as: :select2
  end

  form do |f|
    f.inputs "Product" do
      f.has_many :fruits, allow_destroy: true, new_record: "Add Fruit" do |e|
        e.input :fruit, as: :select2_multiple
      end
    end
  end

end
```

### Ajax support

It's strongly recommended to load data dynamically if you have more than just a handful of options.

To use Select2 with [remote data sets](http://ivaynberg.github.io/select2/#ajax), use `:select2_ajax`.

```ruby
ActiveAdmin.register App do

  form do |f|

    # for belongs_to association
    f.input :user_id, as: :select2_ajax, label: 'Owner', select2: {
      # endpoint that responds with {data: [{id: 1, text: 'Name'}]}
      url: search_admin_users_path,

      # initial id
      value: (f.object.owner ? f.object.owner.id : nil),

      # initial value
      init: (f.object.owner ? { id: f.object.owner.id, text: f.object.owner.email } : nil),
    }


    # for has_many association
    f.input :user_ids, as: :select2_ajax, label: 'Users', select2: {
      url: search_admin_users_path,

      value: (f.object.users.map(&:id).join(',')),

      init: (f.object.users.map { |user| {id: user.id, text: user.email} }),

      multiple: true
    }
  end

end
```

To make this work you need to have an endpoint that receives user input in `params[:term]` and responds with

```json
{
  "data": [
    {"id": 1, "text": "Martin Freeman"},
    {"id": 412, "text": "Joe Pesci"}
  ]
}
```

E.g.

```ruby
ActiveAdmin.register User do

  # Note: automatically aliased as search_admin_users
  collection_action :search do
    users = User
      .where(['email like ?', "#{params[:term]}%"])
      .select('id as id, email as text')
    render json: { data: users }
  end

end
```

### Filters using ajax

You can (and should) use remote data sets also for filters.

```ruby
ActiveAdmin.register App do

  # for single option (note that you may use this for filtering has_many associations, too)
  filter :user_id, label: 'Owner', as: :select2_ajax, select2: {
    # endpoint
    url: '/admin/users/search',
    
    # proc that converts id to result
    object_for: ->(id) do
      (user = User.find(id)) ? { id: id, text: user.email } : nil
    end
  }


  # for multiple options (i.e. filter that matches any of the selected options)
  # TODO

end
```


## Acknowledgements


## Copyright

Copyright (c) 2014 Mark Fairburn, Praxitar Ltd
See the file LICENSE.txt for details.
