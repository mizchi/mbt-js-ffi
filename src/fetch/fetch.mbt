///| Raw JavaScript Fetch API wrapper
extern "js" fn js_fetch(url : String, init : @js.Value) -> @js.Promise =
  #| (url, init) => {
  #|   console.log("fetching", url, init);
  #|   return fetch(url, init)
  #| }

///|
extern "js" fn js_fetch_with_request(request : @js.Value) -> @js.Promise = "fetch"

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
  let init = build_request_init(http_method~, headers~, body~)
  Response(js_fetch(url, init).wait!())
}

///|
pub fn fetch_with_request(request : Request) -> Response!Error + Async {
  let js_value = @js.Value::cast_from(request)
  Response(js_fetch_with_request(js_value).wait!())
}
