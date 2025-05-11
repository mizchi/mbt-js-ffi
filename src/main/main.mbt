///| Raw JavaScript Fetch API wrapper
extern "js" fn js_fetch(url : String, init : @js.Value) -> @js.Promise = "fetch"

///| JavaScript Fetch API wrapper
/// Usage:
/// ```
/// let res = fetch!(
///  "https://jsonplaceholder.typicode.com/posts/1",
///  http_method="GET",
///  headers={
///   "Accept": "application/json",
///   "Content-Type": "application/json",
///  }
///  body=Some({
///   "userId": 1,
///  })
/// )
/// ```
/// TODO: Abort Signal
pub fn fetch(
  url : String,
  http_method~ : String = "GET",
  body~ : Json? = None,
  headers~ : Map[String, String] = {}
) -> Response!Error + Async {
  let init = @js.Object::new()
  init["method"] = http_method
  if body is Some(v) {
    init["body"] = @json.stringify(v)
  }
  if not(headers.is_empty()) {
    init["headers"] = @js.Object::from_iter(headers.iter()).to_value()
  }
  Response(js_fetch(url, init.to_value()).wait!())
}

///| Fetch API Response
type Response @js.Value

///| response.json()
extern "js" fn Response::js_json(v : Response) -> @js.Promise =
  #| (v) => v.json()

///| response.text()
extern "js" fn Response::js_text(v : Response) -> @js.Promise =
  #| (v) => v.text()

///| response.status
extern "js" fn Response::js_status(v : Response) -> @js.Value =
  #| (v) => return v.status

///| response.status
extern "js" fn Response::js_ok(v : Response) -> @js.Value =
  #| (v) => return v.ok

///| response.status
extern "js" fn Response::js_body_used(v : Response) -> @js.Value =
  #| (v) => return v.bodyUsed

///| response.status
fn Response::status(v : Response) -> Int {
  v.js_status().cast()
}

///| response.bodyUsed
fn Response::body_used(v : Response) -> Bool {
  v.js_body_used().cast()
}

///| response.ok
fn Response::ok(v : Response) -> Bool {
  v.js_status().cast()
}

///| resposne.json()
fn Response::json(v : Response) -> @js.Value!Error + Async {
  v.js_json().wait!()
}

///| response.text()
fn Response::text(v : Response) -> String!Error + Async {
  v.js_text().wait!().cast()
}

///|
struct ResponseType {
  userId : Int
  id : Int
  title : String
  body : String
} derive(@json.FromJson, Show)

///|
async fn run() -> Unit!Error + Async {
  let url = "https://jsonplaceholder.typicode.com/posts/1"
  let res = fetch!(url, http_method="GET", headers={
    "Accept": "application/json",
    "Content-Type": "application/json",
  })
  let response_json : ResponseType = res.json!().cast()
  println("data: \{response_json}")

  // Post test
  let res = fetch!(
    "https://jsonplaceholder.typicode.com/posts",
    http_method="POST",
    headers={ "Accept": "application/json", "Content-Type": "application/json" },
    body=Some({ "userId": 1, "id": 1, "title": "foo", "body": "bar" }),
  )
  let body = res.json!()
  let str_body = body.to_json_string!().substring(start=0, end=20)
  println("data: \{str_body}")
}

///|
fn main {
  @js.spawn_detach(async fn() { run!() })
}
