# Fake-Redis Server

Just playing with some Redis commands :)

### Setup

Just bundle install it:

    $ bundle install

And run the specs:

    $ rspec


### Using

You can start the server calling the cli present in bin folder
    $ bin/cli

### Examples

    local> set a 10
    'OK'
    local> get a
    10
    local> begin
    TRANSACTION INITIATED
    local> get a
    10
    local> set a 20
    'OK'
    local> get a
    20
    local> commit
    SAVED
    local> exit
    BYE
