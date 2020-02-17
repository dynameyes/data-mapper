# data-mapper

Data mapper for lua

## Contents

[API](#api)
+ [Entity](#entity)
+ [Field](#field)
+ [Relation](#relation)

[Dependencies](#dependencies)

[Usage](#usage)

## Dependencies

 - [Pgmoon](https://github.com/leafo/pgmoon "Pgmoon github")
 - [LuaSQL](https://keplerproject.github.io/luasql/index.html "LuaSQL home page")
 
## API

### Entity

Entity - use for description table in database. For example

	local db = require("data-mapper.db"):new{
			config = {
				driver = "postgres",
				host = "localhost",
				port = "5432",
				user = "test",
				password = "testpw",
				database = "test"
			}
		}
    local entity = require('data-mapper.entity')

	local testtype = entity:new{
		table = 'testtype',
		pk = 'sid',
		db = db,
		fields = {
			sid = {
				type = 'string'
			},
			name = {
				type = 'string'
			}
		}
	}

	local test = entity:new{
		table = 'test',
		pk = 'id',
		db = db,
		fields = {
			id = {
				type = 'number'
            },
			sid_testtype = {
                    alias ='testtype',
                    type = 'string',
                    foreign_key = true,
                    table = testtype
            },
            name = {
				type = 'string'
			},
			dt = {
				type = 'string'
            },
            balance = {
				type = 'number'
            }
        }
    }

    local test_on = entity:new {
        table = 'test_on',
        pk = 'id',
        db = db,
        fields = {
            id = {
                type = 'number'
            },
            test_id = {
                alias = "test_id",
                type = 'number',
                foreign_key = true,
                table = test
            }
        }
    }

In entity you can define properties:

 - **schema** - table schema. If not defined used *public*
 - **table** - table name 
 - **pk** - table primary key. If not defined used *id*
 - **prefix** - used table prefix. If not defined used first char from *schema* and *table* for example
    *public.test* get prefix **pt**  
 - **db** - used database 
 - **fields** - defined fields in table
 
 Entity provide those methods:
 
  - [**add**](#add) - insert new record in table and return create record
  - [**update**](#update) - update record in table
  - [**delete**](#delete) - delete record in table
  - [**get_by_pk**](#get_by_pk) - get records from table by primary key value
  - [**get_by_field**](#get_by_field) - get records from table by field value 
  - [**get**](#get) - get records from table by fields parameters

#### add 
For add new record:

	test = test:add({id=1,testtype = 'test1', name='test', dt='1970-01-01'})
	print(inspect(test))
	
	{
        dt = "1970-01-01",
        id = 1,
        name = "test",
        testtype = "test1"
	}

#### update
For update record:

	test = test:update({dt='2018-01-01', name='update-test'}, {id=1})
	print(inspect(test))
	
	{
        dt = "2018-01-01",
        id = 1,
        name = "update-test",
        testtype = "test1"
	}

#### delete 
For delete record:

	test:delete{id=1}
	
### get_by_pk

	test = test:get_by_pk(1)
	print(inspect(test))
	
	{
		dt = "2018-01-01",
        id = 1,
        name = "update-test",
        testtype = "test1"
    }

### get_by_field

	test = test:get_by_field('name', 'update-test')
	print(inspect(test))
	{
		dt = "2018-01-01",
        id = 1,
        name = "update-test",
        testtype = "test1"
    }

### get

Simple usage:

	test = test:get{ id=1, name= "update-test"}
	print(inspect(test))
	{
		dt = "2018-01-01",
        id = 1,
        name = "update-test",
        testtype = "test1"
    }
Simple usage with 'OR':
	test:get({ id=1, name= 'Test2'}, "or")

Advanced usage:
    ilike:
	test = test:get{ name = {value = "update", op = 'ilike' }}
	print(inspect(test))
	{
		dt = "2018-01-01",
        id = 1,
        name = "update-test",
        testtype = "test1"
	}
	in:
 	test = test:get({id = {value = {1,3}, op = "IN"}})

### get_calc

Get SUM, COUNT, AVG:
    test = test:get_calc({count={field = "id", op = "COUNT"},total_balance = {field="balance", op = "SUM"},avg_balance = {field="balance", op = "AVG"}})
    test = test:get_calc({count={field = "id", op = "COUNT"}}, { id=1, name= 'Test2'}, "or") - example  with conditions

### join
    single join:
    test =  test:select():join('testtype'):mapper() - can use alias or table name

    one to many:
    test = test:select():join(test_on, { type = 'many' }):mapper()

Now supported operation:
 * ilike
 * =,<,>,<=,>=
 
This operation also supported in update filter


  