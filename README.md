# Moonbit Fetch

Use `fetch` by moonbit (--target js)

WIP (not published yet)

```json
{
  "is-main": true,
  "import": ["rami3l/js-ffi/js", "mizchi/js-ffi/fetch"]
}
```

```mbt
///|
fnalias @fetch.fetch
fnalias @fetch.fetch_with_request

typealias @fetch.Request

struct ResponseType {
  userId : Int
  id : Int
  title : String
  body : String
} derive(@json.FromJson, Show)

async fn run() -> Unit!Error + Async {
  let url = "https://jsonplaceholder.typicode.com/posts/1"
  let res = fetch!(url, http_method="GET", headers={
    "Accept": "application/json",
    "Content-Type": "application/json",
  })
  let response_json : ResponseType = res.json!().cast()
  println("data: \{response_json}")

  // Post test
  let request = Request::new(
    "https://jsonplaceholder.typicode.com/posts",
    http_method="POST",
    headers={ "Accept": "application/json", "Content-Type": "application/json" },
    body=Some({
      "userId": 1,
      "id": 1,
      "title": "foo",
      "body": "bar",
      "xxx": { "a": 1, "b": 2, "c": 3 },
    }),
  )
  let res = fetch_with_request!(request.clone())
  let body = res.json!()
  let str_body = body.to_json_string!().substring(start=0, end=20)
  println("data: \{str_body}")
}

///|
fn main {
  @js.spawn_detach(async fn() { run!() })
}
```
