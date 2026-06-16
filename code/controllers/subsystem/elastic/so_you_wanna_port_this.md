# What is this?
This is a subsystem dedicated to sending data to [elasticsearch](https://www.elastic.co/elasticsearch), more specifically sending data to multiple indices inside your elastic cluster.
## Why?
Because if you want to collect lots of data with lots of fields its better to split things into multiple indices, it also allows you to setup different times for sending data see heartbeat vs round_data.
## How?
This is entirely self contained except the category defines as I assume you want to do those yourself, so just drop this folder into your codebase. After that you will want to create an API key see the curl request below (my homies hate the kibana dashboard)

1 thing to note is rouge_round_id will almost certainly need to be replaced with round_id in round_id compiled data sections.
```
curl -X POST "https://{YOUR_BACKEND}:9200/_security/api_key" \
  -H "Content-Type: application/json" \
  -u "elastic:your-password" \
  -d '{
    "name": "{INDICE_NAME}-metrics",
    "role_descriptors": {
      "{INDICE_NAME}_writer": {
        "cluster": ["monitor"],
        "index": [
          {
            "names": ["{INDICE_NAME}*"],
            "privileges": ["create_index", "index", "auto_configure"]
          }
        ]
      }
    }
  }'
```
this will create you an api key thats wildcarded to your indice + anything which is ideal, each cat can be stuff like: CODEBASE_heartbeat

You will use the encoded output from the above command as your metric key.
For the Endpoint urls that depends on your structure but it will always be:
https://{YOUR_BACKEND}:9200/{INDICE}/_doc
assuming you have default ports setup.

While you can have multiple shards pointing to 1 endpoint I highly recommend against as the entire reason you are doing shards is to contain the data to that shard.

## That's cool but how do I use this data?
The easiest way is to use something like [grafana](https://grafana.com/), you can add each of the endpoints as a source and build dashboards from it, quite useful and alot faster then blackbox was.

# Things to Note
- By default all the shards are set to not report data if no new data is added, this means you will want to bridge nulls on your dashboards or have it send regardless (I recommend just bridging in most cases)
- Crafting and Enchanting shards probably shouldn't be replicated by you since this creates alot of fields but genuinely lazy and like this.
