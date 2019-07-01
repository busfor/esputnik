# Esputnik

Обертка над API маркетинговой системы eSputnik. Поддерживает минимальный необходимый объем функциональности:
  - подписка новых пользователей
  - обновление данных пользователей
  - отправка событий

Пример 

```
client = Esputnik::Client.new(login: 'email@busfor.com', password: 'password', logger: Logger.new(STDOUT))

client.simple_contact_subscribe(email: 'test123@example.com', phone: '+79160001122', additional_data: [{id: 98748, value: 'м'}])

client.simple_contact_update(id: 564407320, additional_data: [{id: 98748, value: 'ж'}])
```

Здесь email и phone - каналы, а такие данные как имя, фамилия и адрес пропущены.
id=98748 - id дополнительного поля Gender, настроенного для конкретного аккаунта eSputnik.

```
client.event(event_type_key: 'test', key_value: 'test@example.com', params: {foo: 'bar')
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/esputnik.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
